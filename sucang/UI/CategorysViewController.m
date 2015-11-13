//
//  CategorysViewController.m
//  sucang
//
//  Created by yangsai on 15/10/22.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "CategorysViewController.h"
#import "MJRefresh.h"
#import "BLHeader.h"
#import "CategoryCell.h"
#import "ViewCategoryViewController.h"

@interface CategorysViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    BLCategory *_categoryAdd;
    NSMutableArray *_nullCategorys;
}

- (void)createDefCategory;

@end

@implementation CategorysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [self createDefCategory];
    
    UINib *nib = [UINib nibWithNibName:@"CategoryCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"CategoryCell"];

    // 下拉刷新
    __block CategorysViewController *blockself = self;
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
    {
        [[BLManager sharedManager] dateGetCategorysWithSuccess:^
        {
            [blockself.collectionView.header endRefreshing];
            [blockself.collectionView reloadData];
            blockself.labelNullInfo.hidden = [BLManager sharedManager].categorys.count > 0;
        }
                                                       failure:^(NSError *error)
        {
            [blockself.collectionView.header endRefreshing];
        }];
    }];
    
    ((MJRefreshStateHeader *)self.collectionView.header).lastUpdatedTimeLabel.hidden = YES;
    [self.collectionView.header beginRefreshing];
}

- (void)createDefCategory
{
    _categoryAdd = [[BLCategory alloc] init];
    _categoryAdd.id = -1;
    _categoryAdd.name = @"　";
    
    _nullCategorys = [NSMutableArray array];
    for (int i=0; i<4; i++)
    {
        BLCategory *category = [[BLCategory alloc] init];
        category.id = 0;
        category.name = @"　";
        category.image = [BLManager sharedManager].categoryIcons[i];
        [_nullCategorys addObject:category];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSInteger count = 0;
    if (self.collectionView.numberOfSections == 2)
    {
        count = [self.collectionView numberOfItemsInSection:0];
    }
    if (count != [[BLManager sharedManager].categorys count])
    {
        [self.collectionView reloadData];
        self.labelNullInfo.hidden = [BLManager sharedManager].categorys.count > 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowCategory"])
    {
        ((ViewCategoryViewController *)segue.destinationViewController).category = sender;
    }
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if ([BLManager sharedManager].categorys.count == 0)
            return _nullCategorys.count;
        else
            return [BLManager sharedManager].categorys.count;
    }
    else
    {
        return 1;
    }
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        BLCategory *category = nil;
        if ([BLManager sharedManager].categorys.count == 0)
            category = _nullCategorys[indexPath.item];
        else
            category = [BLManager sharedManager].categorys[indexPath.item];
        cell.category = category;
        //cell.hideCaption = NO;
    }
    else
    {
        cell.category = _categoryAdd;
        //cell.hideCaption = YES;
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.view.frame.size.width;
    
    if (indexPath.section == 0)
    {
        width = width * 43 / 100;
        return CGSizeMake(width, width);
    }
    else
    {
        width = width * 20 / 100;
        return CGSizeMake(width, width * 1.2);
    }
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
    if (cell.category.id == _categoryAdd.id)
    {
        [self performSegueWithIdentifier:@"AddCategory" sender:cell.category];
    }
    else if (cell.category.id > 0)
    {
        [self performSegueWithIdentifier:@"ShowCategory" sender:cell.category];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    return cell.category.id != 0;
}

@end
