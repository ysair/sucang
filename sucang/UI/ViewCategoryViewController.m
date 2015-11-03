//
//  ViewCategoryViewController.m
//  sucang
//
//  Created by yangsai on 15/10/23.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "ViewCategoryViewController.h"
#import "ItemCell.h"
#import "BLHeader.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "ViewItemViewController.h"

@interface ViewCategoryViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation ViewCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ItemCell"];
    self.tableView.rowHeight = 40;
    
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
    {
        [[BLManager sharedManager] dataGetItemsWithCategory:self.category
                                                     offset:0
                                                      count:0
                                                    success:^
        {
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }
                                                    failure:^(NSError *error)
        {
            [self.tableView.header endRefreshing];
        }];
    }];
    
    ((MJRefreshStateHeader *)self.tableView.header).lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.labelName.text = self.category.name;
    self.imageViewIcon.image = [UIImage imageNamed:self.category.icon];
}

- (IBAction)doAddItem:(id)sender
{
    if (!_imagePicker)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:Nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    [[BLManager sharedManager] dataAddItemWithCategory:self.category
                                           imageFormat:@"jpg"
                                             imageData:data success:^
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.header beginRefreshing];
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
    //[data writeToFile:[NSHomeDirectory() stringByAppendingString:@"/1.jpg"] atomically:NO];
    //NSString *str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //NSLog(@"%@", str);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    if ([segue.identifier isEqualToString:@"ShowItem"])
    {
        ((ViewItemViewController *)segue.destinationViewController).item = sender;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.category.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    BLItem *item = [self.category.items objectAtIndex:indexPath.row];
    cell.item = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = (ItemCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowItem" sender:cell.item];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
