//
//  ODUUIElement.h
//  iPadRestore
//
//  Created by Will Ross on 2/2/11.
//  Copyright 2011 Old Dominion University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface ODUUIElement : NSObject {
@private
    AXUIElementRef element;
	NSDictionary *attributes;
	NSDictionary *actions;
	NSArray *children;
	NSMutableSet *toManyAttributes;
}
@property (nonatomic, readwrite, retain) __attribute__((NSObject)) AXUIElementRef element;
@property (nonatomic, readwrite, retain) NSDictionary *attributes;
@property (nonatomic, readwrite, retain) NSDictionary *actions;
@property (nonatomic, readonly) NSArray *children;
@property (nonatomic, readwrite, retain) NSMutableSet *toManyAttributes;

-(id)initWithUIElement:(AXUIElementRef)uiElement;
+(ODUUIElement *)elementForApplicationBundle:(NSString *)bundleIdentifier;
+(ODUUIElement *)elementForProcessID:(pid_t)pid;
+(ODUUIElement *)systemElement;

-(ODUUIElement *)getChildAtIndex:(NSUInteger)childIndex;
-(ODUUIElement *)getElementForAttribute:(NSString *)attribute;
-(void)refresh;

@end
