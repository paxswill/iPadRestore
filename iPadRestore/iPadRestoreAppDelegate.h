//
//  iPadRestoreAppDelegate.h
//  iPadRestore
//
//  Created by Will Ross on 1/31/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface iPadRestoreAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
