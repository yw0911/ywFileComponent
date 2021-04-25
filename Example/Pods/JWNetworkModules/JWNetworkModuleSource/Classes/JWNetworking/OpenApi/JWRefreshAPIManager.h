//
//  JWRefreshAPIManager.h
//  joywok
//
//  Created by 葛林晓 on 2018/7/14.
//  Copyright © 2018年 Dogesoft. All rights reserved.
//  只有下拉刷新的API（extension）

#import "CTAPIBaseManager.h"

@interface JWRefreshAPIManager : CTAPIBaseManager <CTAPIManager>

- (instancetype)initWithRequestUrl:(NSString *)url;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier;

@end
