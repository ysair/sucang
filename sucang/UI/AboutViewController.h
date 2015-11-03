//
//  AboutViewController.h
//  sucang
//
//  Created by yangsai on 15/10/20.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelUserName;

- (IBAction)doLogout:(id)sender;

@end
