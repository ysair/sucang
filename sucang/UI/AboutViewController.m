//
//  AboutViewController.m
//  sucang
//
//  Created by yangsai on 15/10/20.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "AboutViewController.h"
#import "BLHeader.h"

@implementation AboutViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.labelUserName.text = [BLManager sharedManager].account.userName;
}

- (IBAction)doLogout:(id)sender
{
    [[BLManager sharedManager] userLogout];
    [self performSegueWithIdentifier:@"Logout" sender:sender];
}

@end
