//
//  BLAccount.h
//  sucang
//
//  Created by yangsai on 15/10/20.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLAccount : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *oauthType;
@property (nonatomic, readonly) BOOL isLogined;

@end
