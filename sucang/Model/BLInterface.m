//
//  BLInterface.m
//  sucang
//
//  Created by yangsai on 15/10/20.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "BLInterface.h"
#import "AFNetworking.h"

static NSString* const BASE_ADDRESS = @"http://app.bzline.cn/";
static NSString* const ERROR_DOMAIN = @"BZLine";

@interface BLInterface()

- (AFHTTPRequestOperationManager *)getRequestOperationManager;
- (void)handleResponseWithDict:(NSDictionary *)dict
                       success:(BLInterfaceSuccessBlock)success
                       failure:(BLInterfaceFailureBlock)failure;

@end

@implementation BLInterface

+ (instancetype)sharedInterface
{
    static __strong BLInterface *interface;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        interface = [[BLInterface alloc] init];
    });
    return interface;
}

- (AFHTTPRequestOperationManager *)getRequestOperationManager
{
    static __strong AFHTTPRequestOperationManager *manager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        //如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        securityPolicy.validatesDomainName = YES;
        
        manager.securityPolicy = securityPolicy;
    });
        
    return manager;
}

- (void)handleResponseWithDict:(NSDictionary *)dict
                       success:(BLInterfaceSuccessBlock)success
                       failure:(BLInterfaceFailureBlock)failure
{
    NSString *status = dict[@"status"];
    if ([status intValue] == 0)
    {
        success(dict);
    }
    else
    {
        NSString *error_no = dict[@"error_no"];
        NSString *message = dict[@"message"];
        NSError *err = [NSError errorWithDomain:ERROR_DOMAIN code:[error_no intValue] userInfo:@{NSLocalizedDescriptionKey: message}];
        failure(err);
    }
}

- (void)userRegisterWithUserName:(NSString*)userName
                        password:(NSString*)password
                     information:(NSDictionary*)information
                         success:(BLInterfaceSuccessBlock)success
                         failure:(BLInterfaceFailureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [self getRequestOperationManager];
    
    NSDictionary *parameters = @{@"action": @"register", @"email":userName, @"password":password, @"infomation":@""};
    NSLog(@"POST: %@", parameters);
    
    [manager POST:[BASE_ADDRESS stringByAppendingString:@"account/manager/"]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response: %@", responseObject);
         [self handleResponseWithDict:responseObject success:success failure:failure];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         failure(error);
     }];
}

- (void)userLoginWithUserName:(NSString*)userName
                     password:(NSString*)password
                      success:(BLInterfaceSuccessBlock)success
                      failure:(BLInterfaceFailureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [self getRequestOperationManager];
    
    NSDictionary *parameters = @{@"action": @"login", @"email":userName, @"password":password};
    NSLog(@"POST: %@", parameters);
    
    [manager POST:[BASE_ADDRESS stringByAppendingString:@"account/manager/"]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response: %@", responseObject);
         [self handleResponseWithDict:responseObject success:success failure:failure];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         failure(error);
     }];
}

- (void)userVerifyWithUserID:(NSString*)userID
                       token:(NSString*)token
                   oauthType:(NSString*)oauthType
                     success:(BLInterfaceSuccessBlock)success
                     failure:(BLInterfaceFailureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [self getRequestOperationManager];
    
    NSDictionary *parameters = @{@"action": @"verify_tokenid", @"userid":userID, @"tokenid":token};
    NSLog(@"POST: %@", parameters);
    
    [manager POST:[BASE_ADDRESS stringByAppendingString:@"account/manager/"]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response: %@", responseObject);
         [self handleResponseWithDict:responseObject success:success failure:failure];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         failure(error);
     }];
}

- (void)dataGetCategoryWithUserID:(NSString*)userID
                            token:(NSString*)token
                        oauthType:(NSString*)oauthType
                           offset:(NSInteger)offset
                            count:(NSInteger)count
                          success:(BLInterfaceSuccessBlock)success
                          failure:(BLInterfaceFailureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [self getRequestOperationManager];
    
    NSDictionary *parameters = @{@"action": @"get_category", @"userid":userID, @"tokenid":token, @"oauth_ower":oauthType};
    NSLog(@"POST: %@", parameters);
    
    [manager POST:[BASE_ADDRESS stringByAppendingString:@"uassay/managerCategory/"]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response: %@", responseObject);
         [self handleResponseWithDict:responseObject success:success failure:failure];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         failure(error);
     }];
}

- (void)dataAddCategoryWithUserID:(NSString*)userID
                            token:(NSString*)token
                        oauthType:(NSString*)oauthType
                     categoryName:(NSString*)categoryName
                    categoryImage:(NSString*)categoryImage
                          success:(BLInterfaceSuccessBlock)success
                          failure:(BLInterfaceFailureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [self getRequestOperationManager];
    
    NSDictionary *parameters = @{@"action": @"create_category", @"userid":userID, @"tokenid":token, @"oauth_ower":oauthType, @"category_name": categoryName, @"category_image_id":categoryImage};
    NSLog(@"POST: %@", parameters);
    
    [manager POST:[BASE_ADDRESS stringByAppendingString:@"uassay/managerCategory/"]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response: %@", responseObject);
         [self handleResponseWithDict:responseObject success:success failure:failure];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         failure(error);
     }];
}

- (void)dataAddItemWithUserID:(NSString*)userID
                        token:(NSString*)token
                    oauthType:(NSString*)oauthType
                   categoryID:(NSInteger)categoryID
                  imageFormat:(NSString *)imageFormat
                    imageData:(NSData *)imageData
                      success:(BLInterfaceSuccessBlock)success
                      failure:(BLInterfaceFailureBlock)failure;
{
    AFHTTPRequestOperationManager *manager = [self getRequestOperationManager];
    
    NSDictionary *parameters = @{@"action": @"put_item_image", @"userid":userID, @"tokenid":token, @"oauth_ower":oauthType, @"category_id": [NSString stringWithFormat:@"%ld",categoryID], @"image_format":imageFormat, @"image_content":[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]};
    NSLog(@"POST: %@", parameters);
    
    [manager POST:[BASE_ADDRESS stringByAppendingString:@"uassay/managerItems/"]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response: %@", responseObject);
         [self handleResponseWithDict:responseObject success:success failure:failure];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         failure(error);
     }];
}

- (void)dataGetItemsWithUserID:(NSString*)userID
                         token:(NSString*)token
                     oauthType:(NSString*)oauthType
                    categoryID:(NSInteger)categoryID
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                       success:(BLInterfaceSuccessBlock)success
                       failure:(BLInterfaceFailureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [self getRequestOperationManager];
    
    NSDictionary *parameters = @{@"action": @"get_category_item_list", @"userid":userID, @"tokenid":token, @"oauth_ower":oauthType, @"category_id": [NSString stringWithFormat:@"%ld",categoryID], @"fetch_count":[NSString stringWithFormat:@"%ld",count], @"start_offset":[NSString stringWithFormat:@"%ld",offset]};
    NSLog(@"POST: %@", parameters);
    
    [manager POST:[BASE_ADDRESS stringByAppendingString:@"uassay/managerItems/"]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response: %@", responseObject);
         [self handleResponseWithDict:responseObject success:success failure:failure];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         failure(error);
     }];
}

- (void)dataGetItemDetailWithUserID:(NSString*)userID
                              token:(NSString*)token
                          oauthType:(NSString*)oauthType
                             itemID:(NSInteger)itemID
                            success:(BLInterfaceSuccessBlock)success
                            failure:(BLInterfaceFailureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [self getRequestOperationManager];
    
    NSDictionary *parameters = @{@"action": @"get_item_detail", @"userid":userID, @"tokenid":token, @"oauth_ower":oauthType, @"item_id": [NSString stringWithFormat:@"%ld",itemID]};
    NSLog(@"POST: %@", parameters);
    
    [manager POST:[BASE_ADDRESS stringByAppendingString:@"uassay/managerItems/"]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response: %@", responseObject);
         [self handleResponseWithDict:responseObject success:success failure:failure];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         failure(error);
     }];
}

- (void)dataUpdateItemDetailWithUserID:(NSString*)userID
                                 token:(NSString*)token
                             oauthType:(NSString*)oauthType
                                itemID:(NSInteger)itemID
                             itemDatas:(NSString *)itemDatas
                               success:(BLInterfaceSuccessBlock)success
                               failure:(BLInterfaceFailureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [self getRequestOperationManager];
    
    NSDictionary *parameters = @{@"action": @"update_item_detail", @"userid":userID, @"tokenid":token, @"oauth_ower":oauthType, @"item_id": [NSString stringWithFormat:@"%ld",itemID], @"datas":itemDatas};
    NSLog(@"POST: %@", parameters);
    
    [manager POST:[BASE_ADDRESS stringByAppendingString:@"uassay/managerItems/"]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Response: %@", responseObject);
         [self handleResponseWithDict:responseObject success:success failure:failure];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         failure(error);
     }];
}


@end
