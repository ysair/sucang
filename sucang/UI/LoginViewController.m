//
//  LoginViewController.m
//  sucang
//
//  Created by yangsai on 15/10/19.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "LoginViewController.h"
#import "BLHeader.h"
#import "MBProgressHUD.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) BLManager *manager;

@end

@implementation LoginViewController

- (BLManager *)manager
{
    return [BLManager sharedManager];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textFieldUsername.delegate = self;
    self.textFieldPassword.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.manager.account && (!self.manager.account.oauthType || [self.manager.account.oauthType isEqualToString:@""]))
    {
        self.textFieldUsername.text = [BLManager sharedManager].account.userName;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textFieldUsername)
    {
        [self.textFieldPassword becomeFirstResponder];
    }
    else if (textField == self.textFieldPassword)
    {
        if (self.buttonLogin.enabled)
        {
            [textField resignFirstResponder];
            [self doLogin:self.buttonLogin];
        }
    }
    return YES;
}

- (IBAction)doLogin:(id)sender
{
    [self.view endEditing:YES];
    BLAccount *account = [[BLAccount alloc] init];
    account.userName = self.textFieldUsername.text;
    account.password = self.textFieldPassword.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[BLManager sharedManager] userLoginWithAccount:account
                                            success:^
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"LoginToMain" sender:sender];
    }
                                            failure:^(NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"错误"
                                    message:error.localizedDescription
                                   delegate:Nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
    }];
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)textFieldChanged:(UITextField *)sender
{
    self.buttonLogin.enabled = [[BLManager sharedManager] userValidWithEmail:self.textFieldUsername.text password:self.textFieldPassword.text];
}

@end
