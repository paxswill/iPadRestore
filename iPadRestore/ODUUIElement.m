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
		CFArrayRef attributeNames;
		CFArrayRef attributeValues;
		CFArrayRef actionNames;
		NSMutableArray *actionDescriptions = [[NSMutableArray alloc] init];
		AXError error;
		error = AXUIElementCopyActionNames(self.element, &actionNames);
		error = AXUIElementCopyAttributeNames(self.element, &attributeNames);
		error = AXUIElementCopyMultipleAttributeValues(self.element, attributeNames, kAXCopyMultipleAttributeOptionStopOnError, &attributeValues);
		for(int i = 0; i < [(NSArray *)actionNames count]; ++i){
			CFStringRef actionDescription;
			error = AXUIElementCopyActionDescription(self.element, (CFStringRef)[(NSArray *)actionNames objectAtIndex:i], &actionDescription);
			[actionDescriptions addObject:(NSString *)actionDescription];
		}
		//Make the dictionaries
		self.attributes = [NSDictionary dictionaryWithObjects:(NSArray *)attributeValues forKeys:(NSArray *)attributeNames];
		self.actions = [NSDictionary dictionaryWithObjects:(NSArray *)actionDescriptions forKeys:(NSArray *)actionNames];
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

@end
