//
//  ODUiPad.m
//  iPadRestore
//
//  Created by Will Ross on 1/31/11.
//  Copyright 2011 Old Dominion University. All rights reserved.
//

#import "ODUiPad.h"


@implementation ODUiPad

@synthesize serialNumber;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
