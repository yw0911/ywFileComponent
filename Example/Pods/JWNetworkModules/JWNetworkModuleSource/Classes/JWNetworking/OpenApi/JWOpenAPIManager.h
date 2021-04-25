//
//  JWOpenAPIManager.h
//  joywok
//
//  Created by 葛林晓 on 2018/9/21.
//  Copyright © 2018年 Dogesoft. All rights reserved.
//  公开的、开放的API，需要根据url是否包含host来拼接host、添加access_token，
//  以后可能会有JMStatus验证（目前没有）

#import "CTAPIBaseManager.h"
#import "CTNetworking.h"

@interface JWOpenAPIManager : CTAPIBaseManager <CTAPIManager>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *params;

- (instancetype)initWithRequestUrl:(NSString *)url;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier;

@end
