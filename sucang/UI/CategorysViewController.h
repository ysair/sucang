//
//  CategorysViewController.h
//  sucang
//
//  Created by yangsai on 15/10/22.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCategory;

@interface CategorysViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *labelNullInfo;

@end
