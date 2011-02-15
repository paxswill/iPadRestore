//
//  ODUAccessUtilities.m
//  iPadRestore
//
//  Created by Will Ross on 2/1/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import "ODUAccessUtilities.h"
//#import <SecurityFoundation/SFAuthorization.h>


@implementation ODUAccessUtilities

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

+(BOOL)checkAPIAccess{
	if(!AXAPIEnabled() || !AXIsProcessTrusted()){
		//Accessibility not enabled
		//Authorize, add permissions, restart
		//SFAuthorization *auth = [[SFAuthorization alloc] initWithFlags:kAuthorizationFlagDefaults rights:NULL environment:kAuthorizationEmptyEnvironment];
		//TODO: Check authorization
		return NO;
	}else{
		return YES;
	}
}



@end
