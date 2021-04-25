//
//  JWBaseAPIVaildator.m
//  joywok
//
//  Created by 上上签 on 2021/4/2.
//  Copyright © 2021 Dogesoft. All rights reserved.
//

#import "JWBaseAPIVaildator.h"

@implementation JWBaseAPIVaildator

#pragma mark - CTAPIManagerValidator
- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return CTAPIManagerErrorTypeNoError;
}

- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    NSDictionary *status = [data objectForKey:@"JMStatus"];
    if (status == nil) {
        return CTAPIManagerErrorTypeNoContent;
    }
    
    NSInteger code = [[status objectForKey:@"code"] integerValue];
    if (code != 0) {
        return CTAPIManagerErrorTypeNoContent;
    }
    return CTAPIManagerErrorTypeNoError;
}

@end
