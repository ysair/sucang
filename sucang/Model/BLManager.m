//
//  BLManager.m
//  sucang
//
//  Created by yangsai on 15/10/20.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "BLManager.h"
#import "BLInterface.h"
#import "BLAccount.h"
#import "BLCategory.h"
#import "BLItem.h"
#import "BLItemData.h"

@interface BLManager()

@property (nonatomic, strong) BLInterface *blInterface;

- (instancetype)init;
- (void)loadConfig;
- (void)saveConfig;
- (BOOL)validateEmail:(NSString *)email;

@end

static NSString* const KEY_USERID       = @"userid";
static NSString* const KEY_USERNAME     = @"username";
static NSString* const KEY_TOKEN        = @"token";
static NSString* const KEY_OAUTHTYPE    = @"oauthtype";

@implementation BLManager

+ (instancetype)sharedManager
{
    static __strong BLManager *manager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[BLManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadConfig];
    }
    return self;
}

- (BLInterface *)blInterface
{
    if (!_blInterface) {
        _blInterface = [BLInterface sharedInterface];
    }
    return _blInterface;
}

- (NSMutableArray *)categorys
{
    if (!_categorys)
    {
        _categorys = [NSMutableArray array];
    }
    return _categorys;
}

- (NSArray *)categoryIcons
{
    if (!_categoryIcons)
    {
        NSString* File = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:File];
        _categoryIcons = [dict objectForKey:@"CategoryIcons"];
    }
    return _categoryIcons;
}

- (void)loadConfig
{
    if (!_account)
    {
        _account = [[BLAccount alloc] init];
    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    self.account.userID = [def objectForKey:KEY_USERID];
    self.account.userName = [def objectForKey:KEY_USERNAME];
    self.account.token = [def objectForKey:KEY_TOKEN];
    self.account.oauthType = [def objectForKey:KEY_OAUTHTYPE];
}

- (void)saveConfig
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (self.account && self.account.userName && ![self.account.userName isEqualToString:@""])
    {
        [def setValue:self.account.userID forKey:KEY_USERID];
        [def setValue:self.account.userName forKey:KEY_USERNAME];
        [def setValue:self.account.token forKey:KEY_TOKEN];
        [def setValue:self.account.oauthType forKey:KEY_OAUTHTYPE];
        [def synchronize];
    }
    else
    {
        [def removeObjectForKey:KEY_USERID];
        [def removeObjectForKey:KEY_USERNAME];
        [def removeObjectForKey:KEY_TOKEN];
        [def removeObjectForKey:KEY_OAUTHTYPE];
        [def synchronize];
    }
}

- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)userValidWithEmail:(NSString *)email
                  password:(NSString *)password
{
    return [self validateEmail:email] && [password length] >= 6;
}

- (void)userRegisterWithAccount:(BLAccount *)account
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *error))failure;
{
    [self.blInterface userRegisterWithUserName:account.userName
                                      password:account.password information:Nil
                                       success:^(NSDictionary *dictionary)
    {
        self.account = account;
        self.account.token = dictionary[@"tokenid"];
        [self saveConfig];
        success();
    }
                                       failure:^(NSError *error)
    {
        failure(error); 
    }];
}

- (void)userLoginWithAccount:(BLAccount *)account
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure;
{
    [self.blInterface userLoginWithUserName:account.userName
                                   password:account.password
                                    success:^(NSDictionary *dictionary)
    {
        self.account = account;
        self.account.userID = self.account.userName;
        self.account.token = dictionary[@"tokenid"];
        [self saveConfig];
        success();
    }
                                    failure:^(NSError *error)
    {
        failure(error);
    }];
}

- (void)userVerifyWithAccount:(BLAccount *)account
                      success:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure
{
    [self.blInterface userVerifyWithUserID:account.userID
                                     token:account.token
                                 oauthType:account.oauthType
                                   success:^(NSDictionary *dictionary)
    {
        success();
    }
                                     failure:^(NSError *error)
    {
        account.token = @"";
        failure(error);
    }];
}

- (void)userLogout
{
    if (self.account)
    {
        self.account.token = @"";
        self.account.oauthType = @"";
        [self saveConfig];
    }
}

- (void)dateGetCategorysWithSuccess:(void (^)(void))success
                            failure:(void (^)(NSError *error))failure
{
    [self.blInterface dataGetCategoryWithUserID:self.account.userID
                                          token:self.account.token
                                      oauthType:self.account.oauthType
                                         offset:0
                                          count:0
                                        success:^(NSDictionary *dictionary)
    {
        [self.categorys removeAllObjects];

        NSString *datas = dictionary[@"datas"];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:[datas dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

        for (NSDictionary *dict in arr)
        {
            BLCategory *category = [[BLCategory alloc] init];
            category.id = [dict[@"id"] integerValue];
            category.name = dict[@"name"];
            category.image = dict[@"imageid"];
            [self.categorys addObject:category];
        }
        success();
    }
                                        failure:^(NSError *error)
    {
        failure(error);
    }];
}

- (void)dateAddCategorysWithCategory:(BLCategory *)category
                             success:(void (^)(void))success
                             failure:(void (^)(NSError *error))failure
{
    [self.blInterface dataAddCategoryWithUserID:self.account.userID
                                          token:self.account.token
                                      oauthType:self.account.oauthType
                                   categoryName:category.name
                                  categoryImage:category.image
                                        success:^(NSDictionary *dictionary)
     {
         category.id = [dictionary[@"id"] integerValue];
         [self.categorys addObject:category];
         success();
     }
                                        failure:^(NSError *error)
     {
         failure(error);
     }];
}

- (void)dataAddItemWithCategory:(BLCategory *)category
                    imageFormat:(NSString *)imageFormat   //jpg png
                      imageData:(NSData *)imageData
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *error))failure
{
    [self.blInterface dataAddItemWithUserID:self.account.userID
                                      token:self.account.token
                                  oauthType:self.account.oauthType
                                 categoryID:category.id
                                imageFormat:imageFormat
                                  imageData:imageData
                                    success:^(NSDictionary *dictionary)
     {
         success();
     }
                                        failure:^(NSError *error)
     {
         failure(error);
     }];
}

- (void)dataGetItemsWithCategory:(BLCategory *)category
                          offset:(NSInteger)offset
                           count:(NSInteger)count
                         success:(void (^)(void))success
                         failure:(void (^)(NSError *error))failure
{
    [self.blInterface dataGetItemsWithUserID:self.account.userID
                                       token:self.account.token
                                   oauthType:self.account.oauthType
                                  categoryID:category.id
                                      offset:offset
                                       count:count
                                     success:^(NSDictionary *dictionary)
     {
         [category.items removeAllObjects];
         
         NSString *datas = dictionary[@"datas"];
         NSArray *arr = [NSJSONSerialization JSONObjectWithData:[datas dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         for (NSDictionary *dict in arr)
         {
             BLItem *item = [[BLItem alloc] init];
             item.id = [dict[@"id"] integerValue];
             item.name = dict[@"name"];
             item.date = dict[@"date"];
             item.address = dict[@"address"];
             item.notes = dict[@"notes"];

             [category.items addObject:item];
         }
         success();
     }
                                     failure:^(NSError *error)
     {
         failure(error);
     }];
}

- (void)dataGetItemDetailWithItem:(BLItem *)item
                          success:(void (^)(void))success
                          failure:(void (^)(NSError *error))failure
{
    [self.blInterface dataGetItemDetailWithUserID:self.account.userID
                                            token:self.account.token
                                        oauthType:self.account.oauthType
                                           itemID:item.id
                                          success:^(NSDictionary *dictionary)
     {
         NSString *datas = dictionary[@"datas"];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[datas dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         NSDictionary *dict = json[@"item"];
         
         item.date = dict[@"date"];
         item.address = dict[@"address"];
         item.notes = dict[@"notes"];
         
         [item.datas removeAllObjects];
         NSArray *arr = json[@"table_datas"];
         for (NSDictionary *dict in arr)
         {
             BLItemData *data = [[BLItemData alloc] init];
             data.id = [dict[@"id"] intValue];
             data.name = dict[@"name"];
             data.value = dict[@"value"];
             data.referValue = dict[@"refer_value"];
             data.mark = dict[@"mark"];
             [item.datas addObject:data];
         }
         success();
     }
                                          failure:^(NSError *error)
     {
         failure(error);
     }];
}

- (void)dataUpdateItemDetailWithItem:(BLItem *)item
                             newItem:(BLItem *)newItem
                             success:(void (^)(void))success
                             failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = [NSMutableDictionary dictionary];
    NSString *itemDatas = nil;
    
    if (![item.notes isEqualToString:newItem.notes])
    {
        [dict setValue:newItem.notes forKey:@"item_notes"];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<[item.datas count]; i++)
    {
        BLItemData *data = [item.datas objectAtIndex:i];
        BLItemData *newData = [newItem.datas objectAtIndex:i];
        if (![data isEqualToData:newData])
        {
            NSDictionary *dt = [NSMutableDictionary dictionary];
            [dt setValue:[NSNumber numberWithInteger:newData.id] forKey:@"id"];
            if (![data.name isEqualToString:newData.name])
            {
                [dt setValue:newData.name forKey:@"name"];
            }
            if (![data.value isEqualToString:newData.value])
            {
                [dt setValue:newData.value forKey:@"value"];
            }
            if (![data.referValue isEqualToString:newData.referValue])
            {
                [dt setValue:newData.referValue forKey:@"refer_value"];
            }
            if (![data.mark isEqualToString:newData.mark])
            {
                [dt setValue:newData.mark forKey:@"mark"];
            }
            [arr addObject:dt];
        }
    }
    if ([arr count] > 0)
    {
        [dict setValue:arr forKey:@"table_datas"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *err;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
        if (err)
        {
            failure(err);
            return;
        }
        itemDatas = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSError *err = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"JSON Error"}];
        failure(err);
        return;
    }
    
    [self.blInterface dataUpdateItemDetailWithUserID:self.account.userID
                                               token:self.account.token
                                           oauthType:self.account.oauthType
                                              itemID:item.id
                                           itemDatas:itemDatas
                                             success:^(NSDictionary *dictionary)
     {
         BLCategory *category = nil;
         for (category in self.categorys)
         {
             for (int i=0; i<[category.items count]; i++)
             {
                 if (item.id == ((BLItem*)[category.items objectAtIndex:i]).id)
                 {
                     [category.items replaceObjectAtIndex:i withObject:newItem];
                     category = nil;
                     break;
                 }
             }
             if (!category)
             {
                 break;
             }
         }//*/
         success();
     }
                                          failure:^(NSError *error)
     {
         failure(error);
     }];
}

@end
