//
//  ODUUIElement.m
//  iPadRestore
//
//  Created by Will Ross on 2/2/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import "ODUUIElement.h"
#import <objc/runtime.h>

@implementation ODUUIElement

@synthesize element;

static ODUUIElement *systemElement = nil;

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
	if(systemElement == nil){
		AXUIElementRef uiElement = AXUIElementCreateSystemWide();
		systemElement = [[ODUUIElement alloc] initWithUIElement:uiElement];
		CFRelease(uiElement);
	}
	return systemElement;
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
    [super dealloc];
}

-(NSString *)description{
	return [NSString stringWithFormat:@"Actions:\n%@\n\nAttributes:\n%@", self.actions, self.attributes];
}


//These methods provide dynamic (runtime) method resolution for the AXActions. It is heavy, but it works.
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
	//First check to see if it's a to-many attribute
	//BOOL foundAttribute = [self.toManyAttributes containsObject:NSStringFromSelector(aSelector)];
	NSClassDescription *classDesc = [NSClassDescription classDescriptionForClass:[self class]];
	BOOL foundAttribute = NO;
	//Here we check to see if the selector has an associtaed action for this element
	BOOL foundAction = NO;
	CFArrayRef actions;
	AXError error = AXUIElementCopyActionNames(self.element, &actions);
	for(int i = 0; i < CFArrayGetCount(actions); ++i){
		if(aSelector == NSSelectorFromString(CFArrayGetValueAtIndex(actions, i))){
			foundAction = YES;
			break;
		}
	}
	CFRelease(actions);
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
		if(error != kAXErrorCannotComplete){
			NSAssert(error == kAXErrorSuccess, @"Action failed!");
		}
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
