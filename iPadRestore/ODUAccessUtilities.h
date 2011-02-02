//
//  ODUAccessUtilities.h
//  iPadRestore
//
//  Created by Will Ross on 2/1/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <AppKit/NSAccessibility.h>
#import <Carbon/Carbon.h>

@interface ODUAccessUtilities : NSObject {
@private
    AXUIElementRef applicationElement;
}


+(BOOL)checkAPIAccess;


@end
