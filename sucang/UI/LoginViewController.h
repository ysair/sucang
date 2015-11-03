//
//  LoginViewController.h
//  sucang
//
//  Created by yangsai on 15/10/19.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

- (IBAction)doLogin:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)textFieldChanged:(UITextField *)sender;

@end
