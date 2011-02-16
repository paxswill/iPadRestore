//
//  ODUUIElementClassDescription.h
//  iPadRestore
//
//  Created by Will Ross on 2/16/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface ODUUIElementClassDescription : NSClassDescription {
@private
    NSMutableArray *attributeKeys;
	NSMutableArray *toOneRelationshipKeys;
	NSMutableArray *toManyRelationshipKeys;
}

- (id)initWithAXUIElement:(AXUIElementRef)element;
+(ODUUIElementClassDescription *)classDescriptionForAXUIElement:(AXUIElementRef)element;

-(NSArray *)attributeKeys;
-(NSArray *)toOneRelationshipKeys;
-(NSArray *)toManyRelationshipKeys;

@end
