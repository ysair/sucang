//
//  ItemDataCell.m
//  sucang
//
//  Created by yangsai on 15/10/27.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "ItemDataCell.h"
#import "BLItemData.h"

@interface ItemDataCell ()

@property (nonatomic, assign) BOOL inEditing;

@end

@implementation ItemDataCell

- (void)awakeFromNib
{
    for (UIView *view in self.contentView.subviews)
    {
        view.layer.borderWidth = 1;
        view.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    }
    self.editing = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(BLItemData *)data
{
    _data = data;
    if (data)
    {
        self.textFieldName.text = self.data.name;
        self.textFieldValue.text = self.data.value;
        self.textFieldReferValue.text = self.data.referValue;
        self.textFieldMark.text = self.data.mark;
    }
}

- (void)setIsHeader:(BOOL)isHeader
{
    _isHeader = isHeader;
    UIColor *bkcolor = [UIColor whiteColor];
    if (self.isHeader)
    {
        bkcolor = [UIColor lightGrayColor];
    }
    for (UIView *view in self.contentView.subviews)
    {
        view.backgroundColor =  bkcolor;
    }
}

- (void)setInEditing:(BOOL)inEditing
{
    _inEditing = inEditing;
    self.textFieldName.enabled = _inEditing;
    self.textFieldValue.enabled = _inEditing;
    self.textFieldReferValue.enabled = _inEditing;
    self.textFieldMark.enabled = _inEditing;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    self.inEditing = editing;
}

- (IBAction)nameChanged:(UITextField *)sender
{
    self.data.name = sender.text;
}

- (IBAction)valueChanged:(UITextField *)sender
{
    self.data.value = sender.text;
}

- (IBAction)referValueChanged:(UITextField *)sender
{
    self.data.referValue = sender.text;
}

- (IBAction)markChanged:(UITextField *)sender
{
    self.data.mark = sender.text;
}

@end
