//
//  ODURestoreController.h
//  iPadRestore
//
//  Created by Will Ross on 1/31/11.
//  Copyright 2011 Old Dominion University. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ODUUIElement.h"

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
-(IBAction)restore:(id)sender;
-(ODUUIElement *)findElementMatchingTest:(BOOL (^)(AXUIElementRef element))test;
@end
