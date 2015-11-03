//
//  BLItemData.h
//  sucang
//
//  Created by yangsai on 15/10/26.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLItemData : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *referValue;
@property (nonatomic, copy) NSString *mark;

- (BOOL)isEqualToData:(BLItemData *)data;

@end
