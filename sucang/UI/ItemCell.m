//
//  ItemCell.m
//  sucang
//
//  Created by yangsai on 15/10/23.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "ItemCell.h"
#import "BLHeader.h"

@implementation ItemCell

- (void)awakeFromNib
{
    for (UIView *view in self.contentView.subviews)
    {
        view.layer.borderWidth = 1;
        view.layer.cornerRadius = 5;
        view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(BLItem *)item
{
    _item = item;
    self.labelName.text = self.item.name;
}

@end
