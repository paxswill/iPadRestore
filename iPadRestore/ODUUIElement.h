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
}
@property (nonatomic, readwrite, retain) __attribute__((NSObject)) AXUIElementRef element;

-(id)initWithUIElement:(AXUIElementRef)uiElement;
+(ODUUIElement *)elementForApplicationBundle:(NSString *)bundleIdentifier;
+(ODUUIElement *)elementForProcessID:(pid_t)pid;
+(ODUUIElement *)systemElement;

-(ODUUIElement *)getChildAtIndex:(NSUInteger)childIndex;
-(ODUUIElement *)getElementForAttribute:(NSString *)attribute;

+(NSError *)errorForAXError:(AXError)error;

@end
