//
//  CategoryCell.h
//  sucang
//
//  Created by yangsai on 15/10/22.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLHeader.h"

@interface CategoryCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelCaption;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;

@property (nonatomic, strong) BLCategory *category;
@property (nonatomic, assign) BOOL hideCaption;

@end
