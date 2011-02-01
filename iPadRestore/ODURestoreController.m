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
@synthesize systemEvents;
@synthesize iTunes;

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
		self.iTunes = nil;
		self.systemEvents = nil;
    }
    
    return self;
}

-(IBAction)rescan:(id)sender{
	// If we don't have handles to iTunes/SystemEvents, get them
	if(!self.systemEvents){
		self.systemEvents = [SBApplication applicationWithBundleIdentifier:@"com.apple.systemevents"];
	}
	if(!self.iTunes){
		self.iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	}
	SystemEventsApplicationProcess *iTunesProcess = [[self.systemEvents applicationProcesses] objectWithName:@"iTunes"];
	SystemEventsWindow *iTunesWindow = nil;
	NSArray *element = [iTunesProcess UIElements];
	NSLog(@"Element count: %lu", [element count]);
	NSLog(@"Elements:\n%@", element);
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
