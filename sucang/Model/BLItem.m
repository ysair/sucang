//
//  BLItem.m
//  sucang
//
//  Created by yangsai on 15/10/23.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "BLItem.h"
#import "BLItemData.h"

@implementation BLItem

- (NSMutableArray *)datas
{
    if (!_datas)
    {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (id)copyWithZone:(NSZone *)zone
{
    BLItem *item = [[[BLItem class] allocWithZone:zone] init];
    item.id = self.id;
    item.name = self.name;
    item.date = self.date;
    item.address = self.address;
    item.notes = self.notes;
    item.datas = [NSMutableArray array];
    for (BLItemData *data in self.datas)
    {
        [item.datas addObject:[data copy]];
    }
    return item;
}

@end
