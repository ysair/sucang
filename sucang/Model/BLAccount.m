//
//  BLAccount.m
//  sucang
//
//  Created by yangsai on 15/10/20.
//  Copyright © 2015年 yangsai. All rights reserved.
//

#import "BLAccount.h"

@implementation BLAccount

- (BOOL)isLogined
{
    return self.userName && self.token && ![self.userName isEqualToString:@""] && ![self.token isEqualToString:@""];
}

- (NSString *)userID
{
    if (!_userID)
    {
        _userID = _userName;
    }
    return _userID;
}

- (NSString *)token
{
    if (!_token)
    {
        _token = @"";
    }
    return _token;
}

- (NSString *)oauthType
{
    if (!_oauthType)
    {
        _oauthType = @"";
    }
    return _oauthType;
}

@end
