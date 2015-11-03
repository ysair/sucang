//
//  BLManager.h
//  sucang
//
//  Created by yangsai on 15/10/20.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLAccount, BLCategory, BLItem, BLItemData;

//success:(BLInterfaceSuccessBlock)success
//failure:(BLInterfaceFailureBlock)failure

@interface BLManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) BLAccount *account;
@property (nonatomic, strong) NSMutableArray *categorys;
@property (nonatomic, strong) NSArray *categoryIcons;

- (BOOL)userValidWithEmail:(NSString *)email
                  password:(NSString *)password;
- (void)userRegisterWithAccount:(BLAccount *)account
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *error))failure;
- (void)userLoginWithAccount:(BLAccount *)account
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure;
- (void)userVerifyWithAccount:(BLAccount *)account
                      success:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure;
- (void)userLogout;

- (void)dateGetCategorysWithSuccess:(void (^)(void))success
                            failure:(void (^)(NSError *error))failure;
- (void)dateAddCategorysWithCategory:(BLCategory *)category
                             success:(void (^)(void))success
                             failure:(void (^)(NSError *error))failure;
- (void)dataAddItemWithCategory:(BLCategory *)category
                    imageFormat:(NSString *)imageFormat   //jpg png
                      imageData:(NSData *)imageData
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *error))failure;
- (void)dataGetItemsWithCategory:(BLCategory *)category
                          offset:(NSInteger)offset
                           count:(NSInteger)count
                         success:(void (^)(void))success
                         failure:(void (^)(NSError *error))failure;
- (void)dataGetItemDetailWithItem:(BLItem *)item
                          success:(void (^)(void))success
                          failure:(void (^)(NSError *error))failure;
- (void)dataUpdateItemDetailWithItem:(BLItem *)item
                             newItem:(BLItem *)newItem
                             success:(void (^)(void))success
                             failure:(void (^)(NSError *error))failure;
@end
