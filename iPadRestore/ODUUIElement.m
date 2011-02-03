//
//  ODUUIElement.m
//  iPadRestore
//
//  Created by Will Ross on 2/2/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import "ODUUIElement.h"


@implementation ODUUIElement

@synthesize element;
@synthesize attributes;
@synthesize actions;
@synthesize children;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWithUIElement:(AXUIElementRef)uiElement{
	if((self = [super init])){
		self.element = uiElement;
		//Fill the attributes and actions
		CFMutableArrayRef attributeNames;
		NSMutableArray *attributeValues = [[NSMutableArray alloc] init];
		CFArrayRef actionNames;
		NSMutableArray *actionDescriptions = [[NSMutableArray alloc] init];
		AXError error;
		error = AXUIElementCopyActionNames(self.element, &actionNames);
		error = AXUIElementCopyAttributeNames(self.element, &attributeNames);
		for(int i = 0; i < [(NSArray *)attributeNames count]; ++i){
			//Get the attribute name
			CFStringRef attribute = CFArrayGetValueAtIndex(attributeNames, i);			
			//How many values does the attribute have?
			CFIndex attributeCount;
			error = AXUIElementGetAttributeValueCount(self.element, attribute, &attributeCount);
			//Check to see if this attribute is valid for this element
			if(error == kAXErrorAttributeUnsupported){
				error = kAXErrorSuccess;
				CFArrayRemoveValueAtIndex(attributeNames, i);
				--i;
				continue;
			}
			//depending on how many values there are, put them in the value array
			if(attributeCount == 1){
				//Only one value, easy to manage
				CFTypeRef obj;
				error = AXUIElementCopyAttributeValue(self.element, attribute, &obj);
				[attributeValues addObject:(id)obj];
				CFRelease(obj);
			}else if(attributeCount > 1){
				//Many values, no so easy.
				CFArrayRef values;
				error = AXUIElementCopyAttributeValues(self.element, attribute, 0, attributeCount + 1, &values);
				[attributeValues addObject:(id)values];
				CFRelease(values);
			}else{
				NSLog(@"Attribute %@ has no value", attribute);
				CFArrayRemoveValueAtIndex(attributeNames, i);
				--i;
			}
		}
		for(int i = 0; i < [(NSArray *)actionNames count]; ++i){
			CFStringRef actionDescription;
			error = AXUIElementCopyActionDescription(self.element, (CFStringRef)[(NSArray *)actionNames objectAtIndex:i], &actionDescription);
			[actionDescriptions addObject:(NSString *)actionDescription];
		}
		//Make the dictionaries		
		self.attributes = [NSDictionary dictionaryWithObjects:(NSArray *)attributeValues forKeys:(NSArray *)attributeNames];
		self.actions = [NSDictionary dictionaryWithObjects:(NSArray *)actionDescriptions forKeys:(NSArray *)actionNames];
		//Clean up
		CFRelease(attributeNames);
		[attributeValues release];
		CFRelease(actionNames);
		[actionDescriptions release];
		//Setup the children
		children = nil;
	}
	return self;
}

+(ODUUIElement *)elementForApplicationBundle:(NSString *)bundleIdentifier{
	NSWorkspace *workspace = [[NSWorkspace sharedWorkspace] retain];
	//Check to see if the process is running
	int count = 0;
	NSRunningApplication *app = nil;
	while(app == nil && count < 2){
		NSArray *apps = [[NSRunningApplication runningApplicationsWithBundleIdentifier:bundleIdentifier] retain];
		if([apps count] != 0){
			//Application Found
			app = [apps lastObject];
			ODUUIElement *element = [ODUUIElement elementForProcessID:app.processIdentifier];
			//Cleanup
			[workspace release];
			[apps release];
			return element;
		}else{
			//Try launching the application
			NSString *bundlePath = [[workspace absolutePathForAppBundleWithIdentifier:bundleIdentifier] retain];
			if(bundlePath == nil){
				[workspace release];
				return nil;
			}
			if(![workspace launchApplication:bundlePath]){
				[bundlePath release]; 
				[workspace release];
				return  nil;
			}
			//Application launched! Loop through again to get the PID
		}
		[apps release];
	}
	return nil;
}

+(ODUUIElement *)elementForProcessID:(pid_t)pid{
	AXUIElementRef uiElement = AXUIElementCreateApplication(pid);
	ODUUIElement *element = [[ODUUIElement alloc] initWithUIElement:uiElement];
	CFRelease(uiElement);
	return [element autorelease];
}

+(ODUUIElement *)systemElement{
	AXUIElementRef uiElement = AXUIElementCreateSystemWide();
	ODUUIElement *element = [[ODUUIElement alloc] initWithUIElement:uiElement];
	CFRelease(uiElement);
	return [element autorelease];
}

- (void)dealloc {
    // Clean-up code here.
    self.element = NULL;
	self.attributes = nil;
	self.actions = nil;
    [super dealloc];
}

-(NSString *)description{
	return [NSString stringWithFormat:@"Actions:\n%@\n\nAttributes:\n%@", self.actions, self.attributes];
}

-(NSArray *)children{
	//Lazy load the children.
	if(children == nil){
		NSUInteger childCount = [[self.attributes valueForKey:(NSString *)kAXChildrenAttribute] count];
		NSMutableArray *tempChildren = [[NSMutableArray alloc] initWithCapacity:childCount];
		for(int i = 0; i < childCount; ++i){
			[tempChildren addObject:[[[ODUUIElement alloc] initWithUIElement:(AXUIElementRef)[[self.attributes valueForKey:(NSString *)kAXChildrenAttribute] objectAtIndex:i]] autorelease]];
		}
		children = tempChildren;
	}
	return children;
}

-(ODUUIElement *)getChildAtIndex:(NSUInteger)childIndex{
	return [self.children objectAtIndex:childIndex];
}

-(ODUUIElement *)getElementForAttribute:(NSString *)attributeName{
	if([[self.attributes allKeys] containsObject:attributeName]){
		return [[[ODUUIElement alloc] initWithUIElement:(AXUIElementRef)[self.attributes valueForKey:attributeName]] autorelease];
	}else{
		return nil;
	}
	
}

//These methods provide dynamic (runtime) method resolution for the AXActions. It is heavy, but it works.
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
	//Here we check to see if the selector has an associtaed action for this element
	BOOL foundSelector = NO;
	for(int i = 0; i < [[self.actions allKeys] count]; ++i){
		if(aSelector == NSSelectorFromString([[self.actions allKeys] objectAtIndex:i])){
			foundSelector = YES;
			break;
		}
	}
	if(foundSelector){
		//Just the two hidden variables, no arguments
		char *types = malloc(sizeof(char) * 3);
		types[0] = @encode(void)[0];
		types[1] = @encode(id)[0];
		types[2] = @encode(SEL)[0];
		NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:types];
		return signature;
	}else{
		return nil;
	}
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
	//Now to run this stuff
	SEL selector = [anInvocation selector];
	NSString *action = NSStringFromSelector(selector);
	AXError error = AXUIElementPerformAction(self.element, (CFStringRef)action);
	NSAssert(error == kAXErrorSuccess, @"Action failed!");
}




@end
