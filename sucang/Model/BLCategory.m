//
//  BLCategory.m
//  sucang
//
//  Created by yangsai on 15/10/21.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "BLCategory.h"
#import "BLManager.h"

@implementation BLCategory

- (NSMutableArray *)items
{
    if (!_items)
    {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSString *)icon
{
    if (self.id == -1)
        return @"categoryAdd";
    NSArray *arr = [BLManager sharedManager].categoryIcons;
    for (NSString *str in arr)
    {
        if ([self.image isEqualToString:str])
        {
            return self.image;
        }
    }
    return [arr objectAtIndex:0];
}

@end
