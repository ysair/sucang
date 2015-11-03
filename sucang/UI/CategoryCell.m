//
//  CategoryCell.m
//  sucang
//
//  Created by yangsai on 15/10/22.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "CategoryCell.h"
#import "BLHeader.h"

@implementation CategoryCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setCategory:(BLCategory *)category
{
    _category = category;
    if (_category)
    {
        self.labelCaption.text = _category.name;
        
        self.imageIcon.image = [UIImage imageNamed:_category.icon];
    }
}

- (void)setHideCaption:(BOOL)hideCaption
{
    _hideCaption = hideCaption;
    if (_hideCaption)
    {
        self.labelCaption.hidden = YES;
        
        UIImageView *imageview = self.imageIcon;
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[imageview]-2-|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(imageview)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-2-[imageview]-2-|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(imageview)]];
        [self removeConstraints:self.constraints];
        [self addConstraints:constraints];
    }
}

@end
