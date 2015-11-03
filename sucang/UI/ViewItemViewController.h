//
//  ViewItemViewController.h
//  sucang
//
//  Created by yangsai on 15/10/27.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLItem;

@interface ViewItemViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textViewNotes;

@property (nonatomic, strong) BLItem *item;

@end
