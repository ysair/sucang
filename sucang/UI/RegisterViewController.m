//
//  RegisterViewController.m
//  sucang
//
//  Created by yangsai on 15/10/19.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "RegisterViewController.h"
#import "BLHeader.h"
#import "MBProgressHUD.h"

@interface RegisterViewController () <UITextFieldDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textFieldUsername.delegate = self;
    self.textFieldPassword.delegate = self;
    self.textFieldPassword2.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textFieldUsername becomeFirstResponder];
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
        [self.textFieldPassword2 becomeFirstResponder];
    }
    else if (textField == self.textFieldPassword2)
    {
        if (self.buttonRegister.enabled)
        {
            [textField resignFirstResponder];
            [self doRegister:self.buttonRegister];
        }
    }
    return YES;
}

- (IBAction)doRegister:(id)sender
{
    [self.view endEditing:YES];
    BLAccount *account = [[BLAccount alloc] init];
    account.userName = self.textFieldUsername.text;
    account.password = self.textFieldPassword.text;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[BLManager sharedManager] userRegisterWithAccount:account
                                               success:^
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"RegisterToMain" sender:sender];
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
    self.buttonRegister.enabled = (self.textFieldPassword.text == self.textFieldPassword2.text) && [[BLManager sharedManager] userValidWithEmail:self.textFieldUsername.text password:self.textFieldPassword.text];
}
     
@end
