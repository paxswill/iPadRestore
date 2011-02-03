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
	ODUUIElement *iTunesElement = [[ODUUIElement elementForApplicationBundle:@"com.apple.iTunes"] retain];
	if(iTunesElement != nil){
		NSLog(@"iTunesElement: %@", iTunesElement);
	}else{
		NSLog(@"Screwup on aisle 3");
	}
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
