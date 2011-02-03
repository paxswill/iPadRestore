//
//  ODURestoreController.h
//  iPadRestore
//
//  Created by Will Ross on 1/31/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ODURestoreController : NSViewController {
@private
    NSButton *rescan;
	NSButton *restore;
	NSMutableArray *iPads;
}
@property (readwrite, nonatomic, retain) IBOutlet NSButton *rescan;
@property (readwrite, nonatomic, retain) IBOutlet NSButton *restore;
@property (readwrite, nonatomic, retain) NSMutableArray *iPads;

-(IBAction)rescan:(id)sender;

@end
