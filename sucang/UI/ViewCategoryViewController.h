//
//  ViewCategoryViewController.h
//  sucang
//
//  Created by yangsai on 15/10/23.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCategory;

@interface ViewCategoryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BLCategory *category;

- (IBAction)doAddItem:(id)sender;

@end
