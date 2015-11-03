//
//  BLItem.h
//  sucang
//
//  Created by yangsai on 15/10/23.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLItem : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, strong) NSMutableArray *datas;

@end
