//
//  ODUiPad.h
//  iPadRestore
//
//  Created by Will Ross on 1/31/11.
//  Copyright 2011 Naval Research Lab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ODUiPad : NSObject {
@private
    NSString *serialNumber;
}
@property (readwrite, nonatomic, retain) NSString *serialNumber;
@end
