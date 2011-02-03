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
	ODUUIElement *mainWindow = [[iTunesElement getElementForAttribute:(NSString *)kAXMainWindowAttribute] retain];;
	//Find the Sources Scroll area
	BOOL (^scrollTest)(id obj, NSUInteger idx, BOOL *stop) = ^BOOL(id obj, NSUInteger idx, BOOL *stop){
		ODUUIElement *child = (ODUUIElement *)obj;
		BOOL isScroll = [(NSString *)[child.attributes valueForKey:(NSString *)kAXRoleAttribute] isEqualToString:(NSString *)kAXScrollAreaRole];
		BOOL isSources = [(NSString *)[child.attributes valueForKey:(NSString *)kAXDescription] isEqualToString:@"sources"];
		return isScroll && isSources;
	};
	NSUInteger scrollIndex = [mainWindow.children indexOfObjectPassingTest:scrollTest];
	ODUUIElement *scrollArea = [mainWindow getChildAtIndex:scrollIndex];
	//Get the outline
	BOOL (^outlineTest)(id obj, NSUInteger idx, BOOL *stop) = ^BOOL(id obj, NSUInteger idx, BOOL *stop){
		ODUUIElement *child = (ODUUIElement *)obj;
		BOOL isOutline = [(NSString *)[child.attributes valueForKey:(NSString *)kAXRoleAttribute] isEqualToString:(NSString *)kAXOutlineRole];
		BOOL isSources = [(NSString *)[child.attributes valueForKey:(NSString *)kAXDescription] isEqualToString:@"sources"];
		return isOutline && isSources;
	};
	NSUInteger outlineIndex = [scrollArea.children indexOfObjectPassingTest:outlineTest];
	ODUUIElement *scrollOutline = [scrollArea getChildAtIndex:outlineIndex];
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
	[mainWindow performSelector:NSSelectorFromString(@"AXRaise")];
	// Do it twice, once to make the application active, another to select
	CGEventPost(kCGHIDEventTap, iPadClick);
	CGEventPost(kCGHIDEventTap, iPadClick);
	
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
