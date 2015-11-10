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
    //[self performSegueWithIdentifier:@"Logout" sender:sender];
    
    //此方法防止堆栈过长
    NSString *storyboardName = @"Login";
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication].delegate  setWindow:window];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    window.rootViewController = [storyboard instantiateInitialViewController];
    [window makeKeyAndVisible];
}

@end
