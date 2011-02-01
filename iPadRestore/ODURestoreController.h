//
//  ODURestoreController.h
//  iPadRestore
//
//  Created by Will Ross on 1/31/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SystemEvents.h"
#import "iTunes.h"

@interface ODURestoreController : NSViewController {
@private
    NSButton *rescan;
	NSButton *restore;
	NSMutableArray *iPads;
	
	//Scripting Bridge fun objects
	SystemEventsApplication *systemEvents;
	iTunesApplication *iTunes;
}
@property (readwrite, nonatomic, retain) IBOutlet NSButton *rescan;
@property (readwrite, nonatomic, retain) IBOutlet NSButton *restore;
@property (readwrite, nonatomic, retain) NSMutableArray *iPads;
@property (readwrite, nonatomic, retain) SystemEventsApplication *systemEvents;
@property (readwrite, nonatomic, retain) iTunesApplication *iTunes;

-(IBAction)rescan:(id)sender;

@end
