//
//  ODURestoreController.m
//  iPadRestore
//
//  Created by Will Ross on 1/31/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import "ODURestoreController.h"
#import "ODUiPad.h"
#import "ODUUIElement.h"

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
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
