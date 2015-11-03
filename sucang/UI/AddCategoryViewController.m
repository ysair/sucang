//
//  AddCategoryViewController.m
//  sucang
//
//  Created by yangsai on 15/10/23.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "BLHeader.h"
#import "CategoryCell.h"
#import "MBProgressHUD.h"
#import "ViewCategoryViewController.h"

@interface AddCategoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
{
    NSMutableArray *_icons;
    NSString *_icon;
}

@end

@implementation AddCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _icons = [NSMutableArray array];
    for (NSString *str in [BLManager sharedManager].categoryIcons)
    {
        BLCategory *category = [[BLCategory alloc] init];
        category.image = str;
        [_icons addObject:category];
    }

    UINib *nib = [UINib nibWithNibName:@"CategoryCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"CategoryCell"];
    
    self.barButtonDone.enabled = NO;
    self.textFieldName.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.textFieldName becomeFirstResponder];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.barButtonDone.enabled)
        [self doneClick:self.barButtonDone];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    if ([segue.identifier isEqualToString:@"AddCategorySuccess"])
    {
        ((ViewCategoryViewController *)segue.destinationViewController).category = sender;
    }
}

- (IBAction)nameChanged:(id)sender
{
    self.barButtonDone.enabled = ![self.textFieldName.text isEqualToString:@""];
}

- (IBAction)doneClick:(id)sender
{
    [self.view endEditing:YES];
    BLCategory *category = [[BLCategory alloc] init];
    category.name = self.textFieldName.text;
    category.image = _icon;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[BLManager sharedManager] dateAddCategorysWithCategory:category
                                                    success:^
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         //UINavigationController *nc = self.navigationController;
         //[self.navigationController popViewControllerAnimated:NO];
         //[((CategorysViewController *)nc.topViewController) viewCategory:category];
         [self performSegueWithIdentifier:@"AddCategorySuccess" sender:category];
         NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
         [arr removeObjectAtIndex:1];
         [self.navigationController setViewControllers:arr animated:NO];
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

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_icons count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    cell.hideCaption = YES;
    cell.category = [_icons objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.view.frame.size.width;
    
    width = width * 15 / 100;
    return CGSizeMake(width, width);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = width * 2 / 100;
    width = width * 5 / 100;
    
    return UIEdgeInsetsMake(height, width, height, width);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    _icon = cell.category.icon;
    self.imageViewIcon.image = [UIImage imageNamed:_icon];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
