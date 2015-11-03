//
//  ItemDataCell.h
//  sucang
//
//  Created by yangsai on 15/10/27.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLItemData;

@interface ItemDataCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldValue;
@property (weak, nonatomic) IBOutlet UITextField *textFieldReferValue;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMark;

- (IBAction)nameChanged:(UITextField *)sender;
- (IBAction)valueChanged:(UITextField *)sender;
- (IBAction)referValueChanged:(UITextField *)sender;
- (IBAction)markChanged:(UITextField *)sender;

@property (nonatomic, strong) BLItemData *data;
@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, strong) BLItemData *dataChanged;

@end
