//
//  ViewItemViewController.m
//  sucang
//
//  Created by yangsai on 15/10/27.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "ViewItemViewController.h"
#import "BLHeader.h"
#import "MBProgressHUD.h"
#import "ItemDataCell.h"
#import "MJRefresh.h"

@interface ViewItemViewController () <UITableViewDataSource, UITableViewDelegate>
{
    BLItemData *_headerData;
    BLItem *_editingItem;
}

- (void)updateControls;

@end

@implementation ViewItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINib *nib = [UINib nibWithNibName:@"ItemDataCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ItemDataCell"];
    self.tableView.rowHeight = 30;
    
    _headerData = [[BLItemData alloc] init];
    _headerData.id = 0;
    _headerData.name = @"名称";
    _headerData.value = @"数值";
    _headerData.referValue = @"参考值";
    _headerData.mark = @"标记";

    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
    {
        [[BLManager sharedManager] dataGetItemDetailWithItem:self.item
                                                     success:^
         {
             [self.tableView.header endRefreshing];
             [self updateControls];
             [self.tableView reloadData];
         }
                                                     failure:^(NSError *error)
         {
             [self.tableView.header endRefreshing];
         }];
    }];
    
    ((MJRefreshStateHeader *)self.tableView.header).lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.header beginRefreshing];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.item.name;
    [self updateControls];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _editingItem = nil;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    self.textViewNotes.editable = editing;
    
    if (!editing)
    {
        //save
        _editingItem.notes = self.textViewNotes.text;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[BLManager sharedManager] dataUpdateItemDetailWithItem:self.item
                                                        newItem:_editingItem
                                                        success:^
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
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
}

- (void)updateControls
{
    _editingItem = [self.item copy];
    if (_editingItem.date && (NSNull *)self.item.date != [NSNull null])
    {
        self.labelDate.text = _editingItem.date;
    }
    else
    {
        self.labelDate.text = @"";
    }
    self.labelAddress.text = _editingItem.address;
    self.labelName.text = _editingItem.name;
    self.textViewNotes.text = _editingItem.notes;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return [_editingItem.datas count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemDataCell" forIndexPath:indexPath];
    //BLItem *item = [self.category.items objectAtIndex:indexPath.row];
    //cell.item = item;
    if (indexPath.section == 0)
    {
        cell.data = _headerData;
        cell.isHeader = YES;
    }
    else
    {
        cell.data = [_editingItem.datas objectAtIndex:indexPath.row];
        cell.isHeader = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ItemDataCell *cell = (ItemDataCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    //[self performSegueWithIdentifier:@"ShowItem" sender:cell.item];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
