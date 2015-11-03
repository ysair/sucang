//
//  MainTabBarController.m
//  sucang
//
//  Created by yangsai on 15/10/29.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    void(^setimage)(UITabBarItem *, NSString *, NSString*) = ^(UITabBarItem *item, NSString *image, NSString *selectedImage)
    {
        item.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    };
    setimage([self.tabBar.items objectAtIndex:0], @"tabHome", @"tabHome_Selected");
    setimage([self.tabBar.items objectAtIndex:1], @"tabRefer", @"tabRefer_Selected");
    setimage([self.tabBar.items objectAtIndex:2], @"tabData", @"tabData_Selected");
    setimage([self.tabBar.items objectAtIndex:3], @"tabMe", @"tabMe_Selected");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
