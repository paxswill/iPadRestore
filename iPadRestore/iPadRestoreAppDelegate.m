//
//  iPadRestoreAppDelegate.m
//  iPadRestore
//
//  Created by Will Ross on 1/31/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import "iPadRestoreAppDelegate.h"
#import "ODURestoreController.h"

@implementation iPadRestoreAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Put the custom view in the window
	ODURestoreController *restoreController = [[ODURestoreController alloc] initWithNibName:@"ODURestoreView" bundle:[NSBundle mainBundle]];
	[self.window setContentView:restoreController.view];
	NSLog(@"Restore Controller set up");
}

@end
