//
//  ODURestoreController.m
//  iPadRestore
//
//  Created by Will Ross on 1/31/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import "ODURestoreController.h"
#import "ODUiPad.h"

@implementation ODURestoreController

@synthesize rescan;
@synthesize restore;
@synthesize iPads;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Initialization code here.
		self.iPads = [NSMutableArray array];
		//Jut for giggles, lets test the iPads view
		ODUiPad *test1 = [[ODUiPad alloc] init];
		test1.serialNumber = @"foo";
		ODUiPad *test2 = [[ODUiPad alloc] init];
		test2.serialNumber = @"bar";
		[self.iPads addObject:test1];
		[self.iPads addObject:test2];
    }
    
    return self;
}

-(IBAction)rescan:(id)sender{
	//Get iTunes
	ODUUIElement *iTunesElement = [[ODUUIElement elementForApplicationBundle:@"com.apple.iTunes"] retain];
	//Get the main window
	ODUUIElement *mainWindow = [[iTunesElement getElementForAttribute:(NSString *)kAXMainWindowAttribute] retain];
	
	//Find the Sources Scroll area
	BOOL (^sourcesScrollAreaTest)(id obj, NSUInteger idx, BOOL *stop) = ^BOOL(id obj, NSUInteger idx, BOOL *stop){
		ODUUIElement *child = (ODUUIElement *)obj;
		BOOL isScroll = [(NSString *)[child.attributes valueForKey:(NSString *)kAXRoleAttribute] isEqualToString:(NSString *)kAXScrollAreaRole];
		BOOL isSources = [(NSString *)[child.attributes valueForKey:(NSString *)kAXDescription] isEqualToString:@"sources"];
		return isScroll && isSources;
	};
	NSUInteger sourcesScrollAreaIndex = [mainWindow.children indexOfObjectPassingTest:sourcesScrollAreaTest];
	ODUUIElement *sourcesScrollArea = [mainWindow getChildAtIndex:sourcesScrollAreaIndex];
	
	//Get the outline
	BOOL (^outlineTest)(id obj, NSUInteger idx, BOOL *stop) = ^BOOL(id obj, NSUInteger idx, BOOL *stop){
		ODUUIElement *child = (ODUUIElement *)obj;
		BOOL isOutline = [(NSString *)[child.attributes valueForKey:(NSString *)kAXRoleAttribute] isEqualToString:(NSString *)kAXOutlineRole];
		BOOL isSources = [(NSString *)[child.attributes valueForKey:(NSString *)kAXDescription] isEqualToString:@"sources"];
		return isOutline && isSources;
	};
	NSUInteger outlineIndex = [sourcesScrollArea.children indexOfObjectPassingTest:outlineTest];
	ODUUIElement *scrollOutline = [sourcesScrollArea getChildAtIndex:outlineIndex];
	NSLog(@"Scroll Outline:\n%@", scrollOutline);
	
	//Get the device
	BOOL (^deviceTest)(id obj, NSUInteger idx, BOOL *stop) = ^BOOL(id obj, NSUInteger idx, BOOL *stop){
		ODUUIElement *child = (ODUUIElement *)obj;
		NSLog(@"Current Child: %@", child);
		BOOL isRow = [(NSString *)[child.attributes valueForKey:(NSString *)kAXRoleAttribute] isEqualToString:(NSString *)kAXRowRole];
		BOOL isDevice = NO;
		if([child.children count] == 1){
			ODUUIElement *potentialDescription = [child.children objectAtIndex:0];
			if([(NSString *)[potentialDescription.attributes valueForKey:(NSString *)kAXRoleAttribute] isEqualToString:(NSString *)kAXStaticTextRole]){
				isDevice = [(NSString *)[potentialDescription.attributes valueForKey:(NSString *)kAXDescription] isEqualToString:(NSString *)@"device"];
			}else{
				isDevice = NO;
			}
		}else{
			isDevice = NO;
		}
		//BOOL isDevice = [(NSString *)[child.attributes valueForKey:(NSString *)kAXDescription] isEqualToString:@"device"];
		return isRow && isDevice;
	};
	NSUInteger deviceRow = [scrollOutline.children indexOfObjectPassingTest:deviceTest];
	ODUUIElement *deviceElement = [scrollOutline getChildAtIndex:deviceRow];
	NSLog(@"Device:\n%@", deviceElement);
	//Now click on the device row to select the iPad
	CGPoint iPadPoint;
	AXValueGetValue((AXValueRef)[deviceElement.attributes objectForKey:(NSString *)kAXPositionAttribute], kAXValueCGPointType, &iPadPoint);
	iPadPoint.x = iPadPoint.x + 20;
	iPadPoint.y = iPadPoint.y + 5;
	CGEventRef iPadClick = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, iPadPoint, kCGMouseButtonLeft);
	// Just before we click, raise iTunes to the front
	[mainWindow performSelector:@selector(AXRaise)];
	// Do it twice, once to make the application active, another to select
	CGEventPost(kCGHIDEventTap, iPadClick);
	CGEventPost(kCGHIDEventTap, iPadClick);
	
	//Now we have to backtrack to the window, and find the tab group
	BOOL (^tabGroupTest)(id obj, NSUInteger idx, BOOL *stop) = ^BOOL(id obj, NSUInteger idx, BOOL *stop){
		ODUUIElement *child = (ODUUIElement *)obj;
		BOOL isTabGroup = [(NSString *)[child.attributes valueForKey:(NSString *)kAXRoleAttribute] isEqualToString:(NSString *)kAXTabGroupRole];
		return isTabGroup;
	};
	NSUInteger tabGroupIndex = [mainWindow.children indexOfObjectPassingTest:tabGroupTest];
	ODUUIElement *tabGroup = [mainWindow getChildAtIndex:tabGroupIndex];
	NSLog(@"Tab Group:\n%@", tabGroup);
	
	//Make sure we're on the summary tab
	BOOL (^summaryTest)(id obj, NSUInteger idx, BOOL *stop) = ^BOOL(id obj, NSUInteger idx, BOOL *stop){
		ODUUIElement *child = (ODUUIElement *)obj;
		BOOL isRadioButton = [(NSString *)[child.attributes valueForKey:(NSString *)kAXRoleAttribute] isEqualToString:(NSString *)kAXRadioButtonRole];
		BOOL isSummary = [(NSString *)[child.attributes valueForKey:(NSString *)kAXTitleAttribute] isEqualToString:@"Summary"];
		return isRadioButton && isSummary;
	};
	NSUInteger summaryIndex = [tabGroup.children indexOfObjectPassingTest:summaryTest];
	ODUUIElement *summaryButton = [tabGroup getChildAtIndex:summaryIndex];
	NSLog(@"summaryButton: %@", summaryButton);
	[summaryButton performSelector:@selector(AXPress)];
	
	//Get the scroll area
	BOOL (^scrollAreaTest)(id obj, NSUInteger idx, BOOL *stop) = ^BOOL(id obj, NSUInteger idx, BOOL *stop){
		ODUUIElement *child = (ODUUIElement *)obj;
		BOOL isScrollArea = [(NSString *)[child.attributes valueForKey:(NSString *)kAXRoleAttribute] isEqualToString:(NSString *)kAXScrollAreaRole];
		return isScrollArea;
	};
	NSUInteger scrollAreaIndex = [tabGroup.children indexOfObjectPassingTest:scrollAreaTest];
	ODUUIElement *scrollArea = [tabGroup getChildAtIndex:scrollAreaIndex];
	NSLog(@"scrollArea: %@", summaryButton);
	
	//Click the restore button
	BOOL (^restoreButtonTest)(id obj, NSUInteger idx, BOOL *stop) = ^BOOL(id obj, NSUInteger idx, BOOL *stop){
		ODUUIElement *child = (ODUUIElement *)obj;
		BOOL isButton = [(NSString *)[child.attributes valueForKey:(NSString *)kAXRoleAttribute] isEqualToString:(NSString *)kAXButtonRole];
		BOOL isRestore = [(NSString *)[child.attributes valueForKey:(NSString *)kAXTitleAttribute] isEqualToString:@"Restore"];
		return isButton && isRestore;
	};
	NSUInteger restoreButtonIndex = [scrollArea.children indexOfObjectPassingTest:restoreButtonTest];
	ODUUIElement *restoreButton = [scrollArea getChildAtIndex:restoreButtonIndex];
	[restoreButton performSelector:@selector(AXPress)];
	
	//Get the alert window.
	//We need to reload the iTunes application element
	BOOL (^restoreDialogTest)(AXUIElementRef element) = ^BOOL(AXUIElementRef element){
		//Is it a window?
		CFStringRef roleType;
		CFTypeRef roleRef;
		AXError error = AXUIElementCopyAttributeValue(element, kAXRoleAttribute, &roleRef);
		roleType = (CFStringRef)roleRef;
		if(CFStringCompare(roleType, kAXWindowRole, 0)){
			//Move down the tree to see if it has the proper attributes
			CFIndex attributeCount;
			error = AXUIElementGetAttributeValueCount(element, kAXChildrenAttribute, &attributeCount);
			for(int i = 0; i < attributeCount; ++i){
				AXUIElementRef textElement;
				CFArrayRef values;
				error = AXUIElementCopyAttributeValues(element, kAXChildrenAttribute, i, 1, &values);
				textElement = CFArrayGetValueAtIndex(values, 0);
				//Is this the right text?
				CFTypeRef textValue;
				error = AXUIElementCopyAttributeValue(textElement, kAXValueAttribute, &textValue);
				CFStringRef text = (CFStringRef)textValue;
				NSString *refText = @"iTunes will verify the restore with Apple. After this process is complete, you will have the option to restore your contacts, calendars, text messages and other settings.";
				if(CFStringCompare(text, (CFStringRef)refText, 0)){
					return YES;
				}
			}
		}
		return NO;
	};
	ODUUIElement *restoreDialog = [self findElementMatchingTest:restoreDialogTest];
	//ODUUIElement *restoreDialogButton = [iTunesElement getElementForAttribute:(NSString *)kAXFocusedUIElementAttribute];
	NSLog(@"Restore Dialog Button: %@", restoreDialog);
	//[restoreDialogButton performSelector:@selector(AXPress)];
}

-(IBAction)restore:(id)sender{
	[self findElementMatchingTest:NULL];
	//ODUUIElement *system = [[ODUUIElement systemElement] retain];
	//NSLog(@"System Element: \n%@", system);
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

-(ODUUIElement *)findElementMatchingTest:(BOOL (^)(AXUIElementRef element))test{
	//Start moving the mouse
	CGEventRef mouseMove = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, CGPointMake(0.0, 0.0), kCGMouseButtonCenter);
	AXUIElementRef systemElement = [ODUUIElement systemElement].element;
	for(int i = 0; i < [[NSScreen screens] count]; ++i){
		NSScreen *screen = [[NSScreen screens] objectAtIndex:i];
		NSRect screenSize = [screen frame];
		for(int y = 0; y < screenSize.size.height; y += 20){
			for(int x = 0; x < screenSize.size.width; x += 20){
				//CGEventSetLocation(mouseMove, CGPointMake(x, y));
				//CGEventPost(kCGHIDEventTap, mouseMove);
				//Test The location
				AXUIElementRef element;
				AXError error = AXUIElementCopyElementAtPosition(systemElement, x, y, &element);
				if(test(element)){
					return [[[ODUUIElement alloc] initWithUIElement:element] autorelease];
				}
			}
		}
	}
	return nil;
}

@end
