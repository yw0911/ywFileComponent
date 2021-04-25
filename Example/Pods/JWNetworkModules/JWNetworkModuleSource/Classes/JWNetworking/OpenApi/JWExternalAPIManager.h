//
//  JWExternalAPIManager.h
//  Network
//
//  Created by 葛林晓 on 2018/7/11.
//  Copyright © 2018年 gelx. All rights reserved.
//  外部数据源（非JW数据源）

#import "CTAPIBaseManager.h"

#import "CTNetworking.h"

@interface JWExternalAPIManager : CTAPIBaseManager <CTAPIManager>

- (instancetype)initWithRequestUrl:(NSString *)url;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier;

@end
