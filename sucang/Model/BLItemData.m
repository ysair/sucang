//
//  BLItemData.m
//  sucang
//
//  Created by yangsai on 15/10/26.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "BLItemData.h"

@implementation BLItemData

- (id)copyWithZone:(NSZone *)zone
{
    BLItemData *data = [[[self class] allocWithZone:zone] init];
    data.id  = self.id;
    data.name = self.name;
    data.value = self.value;
    data.referValue = self.referValue;
    data.mark = self.mark;
    return data;
}

- (BOOL)isEqualToData:(BLItemData *)data
{
    return self.id == data.id
        && [self.name isEqualToString:data.name]
        && [self.value isEqualToString:data.value]
        && [self.referValue isEqualToString:data.referValue]
        && [self.mark isEqualToString:data.mark];
}

@end
