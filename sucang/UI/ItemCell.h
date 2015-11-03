//
//  ItemCell.h
//  sucang
//
//  Created by yangsai on 15/10/23.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLItem;

@interface ItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (nonatomic, strong) BLItem *item;

@end
