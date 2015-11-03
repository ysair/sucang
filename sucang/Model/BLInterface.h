//
//  BLInterface.h
//  sucang
//
//  Created by yangsai on 15/10/20.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BLInterfaceSuccessBlock void (^)(NSDictionary *dictionary)
#define BLInterfaceFailureBlock void (^)(NSError *error)

@interface BLInterface : NSObject

+ (instancetype)sharedInterface;

- (void)userRegisterWithUserName:(NSString*)userName
                        password:(NSString*)password
                     information:(NSDictionary*)information
                         success:(BLInterfaceSuccessBlock)success
                         failure:(BLInterfaceFailureBlock)failure;

- (void)userLoginWithUserName:(NSString*)userName
                     password:(NSString*)password
                      success:(BLInterfaceSuccessBlock)success
                      failure:(BLInterfaceFailureBlock)failure;

- (void)userVerifyWithUserID:(NSString*)userID
                       token:(NSString*)token
                   oauthType:(NSString*)oauthType
                     success:(BLInterfaceSuccessBlock)success
                     failure:(BLInterfaceFailureBlock)failure;

- (void)dataGetCategoryWithUserID:(NSString*)userID
                            token:(NSString*)token
                        oauthType:(NSString*)oauthType
                           offset:(NSInteger)offset
                            count:(NSInteger)count
                          success:(BLInterfaceSuccessBlock)success
                          failure:(BLInterfaceFailureBlock)failure;
- (void)dataAddCategoryWithUserID:(NSString*)userID
                            token:(NSString*)token
                        oauthType:(NSString*)oauthType
                     categoryName:(NSString*)categoryName
                    categoryImage:(NSString*)categoryImage
                          success:(BLInterfaceSuccessBlock)success
                          failure:(BLInterfaceFailureBlock)failure;
- (void)dataAddItemWithUserID:(NSString*)userID
                        token:(NSString*)token
                    oauthType:(NSString*)oauthType
                   categoryID:(NSInteger)categoryID
                  imageFormat:(NSString *)imageFormat   //jpg png
                    imageData:(NSData *)imageData
                      success:(BLInterfaceSuccessBlock)success
                      failure:(BLInterfaceFailureBlock)failure;
- (void)dataGetItemsWithUserID:(NSString*)userID
                         token:(NSString*)token
                     oauthType:(NSString*)oauthType
                    categoryID:(NSInteger)categoryID
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                       success:(BLInterfaceSuccessBlock)success
                       failure:(BLInterfaceFailureBlock)failure;
- (void)dataGetItemDetailWithUserID:(NSString*)userID
                              token:(NSString*)token
                          oauthType:(NSString*)oauthType
                             itemID:(NSInteger)itemID
                            success:(BLInterfaceSuccessBlock)success
                            failure:(BLInterfaceFailureBlock)failure;
- (void)dataUpdateItemDetailWithUserID:(NSString*)userID
                                 token:(NSString*)token
                             oauthType:(NSString*)oauthType
                                itemID:(NSInteger)itemID
                             itemDatas:(NSString *)itemDatas
                               success:(BLInterfaceSuccessBlock)success
                               failure:(BLInterfaceFailureBlock)failure;
//*/
@end
