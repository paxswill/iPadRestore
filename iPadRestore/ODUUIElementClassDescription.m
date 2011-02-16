//
//  ODUUIElementClassDescription.m
//  iPadRestore
//
//  Created by Will Ross on 2/16/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import "ODUUIElementClassDescription.h"
#import "ODUUIElement.h"

@implementation ODUUIElementClassDescription

- (id)initWithAXUIElement:(AXUIElementRef)element{
    self = [super init];
    if (self) {
        // Initialization code here.
		attributeKeys = [[NSMutableArray alloc] init];
		toOneRelationshipKeys = [[NSMutableArray alloc] init];
		toManyRelationshipKeys = [[NSMutableArray alloc] init];
		CFMutableArrayRef attributeNames;
		AXError error;
		error = AXUIElementCopyAttributeNames(element, (CFArrayRef *)&attributeNames);
		if(error != kAXErrorSuccess){
			NSLog(@"Error Copying attribute names in init:\n%@", [ODUUIElement errorForAXError:error]);
		}
		for(int i = 0; i < [(NSArray *)attributeNames count]; ++i){
			//Get the attribute name
			CFStringRef attribute = CFArrayGetValueAtIndex(attributeNames, i);			
			//How many values does the attribute have?
			CFIndex attributeCount;
			error = AXUIElementGetAttributeValueCount(element, attribute, &attributeCount);
			//Check to see if this attribute is valid for this element
			if(error == kAXErrorAttributeUnsupported){
				error = kAXErrorSuccess;
				CFArrayRemoveValueAtIndex(attributeNames, i);
				--i;
				continue;
			}else if(error != kAXErrorSuccess){
				NSLog(@"Error retireving attribute count in init:\n%@", [ODUUIElement errorForAXError:error]);
			}
			//depending on how many values there are, put them in the value array
			if(attributeCount == 1){
				[attributeKeys addObject:(NSString *)attribute];
				[toOneRelationshipKeys addObject:(NSString *)attribute];
			}else if(attributeCount > 1){
				[attributeKeys addObject:(NSString *)attribute];
				[toManyRelationshipKeys addObject:(NSString *)attribute];
			}else{
				NSLog(@"Attribute %@ has no value", attribute);
			}
		}
		
    }
    return self;
}

+(ODUUIElementClassDescription *)classDescriptionForAXUIElement:(AXUIElementRef)element{
	ODUUIElementClassDescription *description = [[ODUUIElementClassDescription alloc] initWithAXUIElement:element];
	return [description autorelease];
}

- (void)dealloc
{
    [super dealloc];
}


-(NSArray *)attributeKeys{
	return [[attributeKeys retain] autorelease];
}

-(NSArray *)toOneRelationshipKeys{
	return [[toOneRelationshipKeys retain] autorelease];
}

-(NSArray *)toManyRelationshipKeys{
	return [[toManyRelationshipKeys retain] autorelease];
}

@end
