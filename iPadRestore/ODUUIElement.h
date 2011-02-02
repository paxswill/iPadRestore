//
//  ODUUIElement.h
//  iPadRestore
//
//  Created by Will Ross on 2/2/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface ODUUIElement : NSObject {
@private
    AXUIElementRef element;
	NSDictionary *attributes;
	NSDictionary *actions;
}
@property (nonatomic, readwrite, retain) __attribute__((NSObject)) AXUIElementRef element;
@property (nonatomic, readwrite, retain) NSDictionary *attributes;
@property (nonatomic, readwrite, retain) NSDictionary *actions;

-(id)initWithUIElement:(AXUIElementRef)uiElement;
+(ODUUIElement *)elementForApplicationBundle:(NSString *)bundleIdentifier;
+(ODUUIElement *)elementForProcessID:(pid_t)pid;
+(ODUUIElement *)systemElement;

@end
