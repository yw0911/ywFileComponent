//
//  JWPagebleAPIManager.h
//  Network
//
//  Created by 葛林晓 on 2018/7/12.
//  Copyright © 2018年 gelx. All rights reserved.
//  page的API（extension）

#import "CTAPIBaseManager.h"

#import "CTNetworking.h"

@interface JWPagebleAPIManager : CTAPIBaseManager <CTAPIManager, CTPagableAPIManager>

@property (nonatomic, assign) BOOL isFilter;

- (instancetype)initWithRequestUrl:(NSString *)url;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier;

@end
