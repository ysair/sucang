//
//  BLCategory.h
//  sucang
//
//  Created by yangsai on 15/10/21.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLCategory : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, readonly) NSString *icon;

@end
