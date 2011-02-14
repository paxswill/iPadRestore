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
@synthesize toManyAttributes;

static NSString *axErrorDomain = @"AXError";

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWithUIElement:(AXUIElementRef)uiElement{
	if((self = [super init])){
		self.element = uiElement;
		self.toManyAttributes = [NSMutableSet set];
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
				//Mark the attribute as a 'to-many' attribute
				[self.toManyAttributes addObject:(NSString *)attribute];
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

+(NSError *)errorForAXError:(AXError)error{
	NSString *errorDescription = nil;
	switch(error){
		case kAXErrorFailure:
			errorDescription = @"A system error occurred, such as the failure to allocate an object.";
			break;
		case kAXErrorIllegalArgument:
			errorDescription = @"An illegal argument was passed to the function.";
			break;
		case kAXErrorInvalidUIElement:
			errorDescription = @"The AXUIElementRef passed to the function is invalid.";
			break;
		case kAXErrorInvalidUIElementObserver:
			errorDescription = @"The AXObserverRef passed to the function is not a valid observer.";
			break;
		case kAXErrorCannotComplete:
			errorDescription = @"The function cannot complete because messaging failed in some way or because the application with which the function is communicating is busy or unresponsive.";
			break;
		case kAXErrorAttributeUnsupported:
			errorDescription = @"The attribute is not supported by the AXUIElementRef.";
			break;
		case kAXErrorActionUnsupported:
			errorDescription = @"The action is not supported by the AXUIElementRef.";
			break;
		case kAXErrorNotificationUnsupported:
			errorDescription = @"The notification is not supported by the AXUIElementRef.";
			break;
		case kAXErrorNotImplemented:
			errorDescription = @"Indicates that the function or method is not implemented (this can be returned if a process does not support the accessibility API).";
			break;
		case kAXErrorNotificationAlreadyRegistered:
			errorDescription = @"This notification has already been registered for.";
			break;
		case kAXErrorNotificationNotRegistered:
			errorDescription = @"Indicates that a notification is not registered yet.";
			break;
		case kAXErrorAPIDisabled:
			errorDescription = @"The accessibility API is disabled (as when, for example, the user deselects \"Enable access for assistive devices\" in Universal Access Preferences).";
			break;
		case kAXErrorNoValue:
			errorDescription = @"The requested value or AXUIElementRef does not exist.";
			break;
		case kAXErrorParameterizedAttributeUnsupported:
			errorDescription = @"The parameterized attribute is not supported by the AXUIElementRef.";
			break;
		case kAXErrorNotEnoughPrecision:
		default:
			errorDescription = @"You must've really screwed up, this return value isn't documented";
		case kAXErrorSuccess:
			return nil;
	}
	return [NSError errorWithDomain:axErrorDomain 
							   code:error 
						   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedDescriptionKey, errorDescription, nil]];
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
	//First check to see if it's a to-many attribute
	BOOL foundAttribute = [self.toManyAttributes containsObject:NSStringFromSelector(aSelector)];
	//Here we check to see if the selector has an associtaed action for this element
	BOOL foundAction = NO;
	for(int i = 0; i < [[self.actions allKeys] count]; ++i){
		if(aSelector == NSSelectorFromString([[self.actions allKeys] objectAtIndex:i])){
			foundAction = YES;
			break;
		}
	}
	if(foundAction){
		//Just the two hidden variables, no arguments, void return type
		char *types = malloc(sizeof(char) * 3);
		types[0] = @encode(void)[0];
		types[1] = @encode(id)[0];
		types[2] = @encode(SEL)[0];
		NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:types];
		free(types);
		return signature;
	}else if(foundAttribute){
		char *types = malloc(sizeof(char) * 4);
		//Returning id, and no special arguments 
		types[0] = @encode(id)[0];
		types[1] = @encode(id)[0];
		types[2] = @encode(SEL)[0];
		types[3] = @encode(id)[0];
		NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:types];
		free(types);
		return signature;
	}else{
		return nil;
	}
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
	//Now to run this stuff
	SEL selector = [anInvocation selector];
	if([self.toManyAttributes containsObject:NSStringFromSelector(selector)]){
		// A to-many attribute. Modify the invocation
		[anInvocation setTarget:self];
		[anInvocation setSelector:@selector(arrayForAttribute:)];
		[anInvocation setArgument:NSStringFromSelector(selector) atIndex:2];
		
	}else{
		// An action
		NSString *action = NSStringFromSelector(selector);
		AXError error = AXUIElementPerformAction(self.element, (CFStringRef)action);
		NSAssert(error == kAXErrorSuccess, @"Action failed!");
	}
}

-(NSArray *)arrayForAttribute:(NSString *)attribute{
	CFIndex attributeCount;
	AXError error = AXUIElementGetAttributeValueCount(self.element, (CFStringRef)attribute, &attributeCount);
	CFArrayRef values;
	error = AXUIElementCopyAttributeValues(self.element, (CFStringRef)attribute, 0, attributeCount + 1, &values);
	NSMutableArray *attributeValues = [[NSMutableArray alloc] initWithCapacity:attributeCount];
	for(int i = 0; i < attributeCount; ++i){
		[attributeValues addObject:[[[ODUUIElement alloc] initWithUIElement:CFArrayGetValueAtIndex(values, i)] autorelease]];
	}
	return  attributeValues;
}




@end
