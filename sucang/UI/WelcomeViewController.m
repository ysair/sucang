//
//  WelcomeViewController.m
//  sucang
//
//  Created by yangsai on 15/10/21.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "WelcomeViewController.h"
#import "BLHeader.h"

@implementation WelcomeViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BLManager *manager = [BLManager sharedManager];
    if (manager.account.isLogined)
    {
        [manager userVerifyWithAccount:manager.account
                               success:^
        {
            [self performSegueWithIdentifier:@"WelcomeToMain" sender:self];
        }
                               failure:^(NSError *error)
        {
            [self performSegueWithIdentifier:@"WelcomeToLogin" sender:self];
        }];
    }
    else
    {
        [self performSegueWithIdentifier:@"WelcomeToLogin" sender:self];
    };
}

@end
