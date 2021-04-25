//
//  JWOpenAPIManager.m
//  joywok
//
//  Created by 葛林晓 on 2018/9/21.
//  Copyright © 2018年 Dogesoft. All rights reserved.
//

#import "JWOpenAPIManager.h"

@interface JWOpenAPIManager () <CTAPIManagerParamSource>

@property (nonatomic, assign) CTAPIManagerRequestType requestType;
@property (nonatomic, strong) NSString *serviceIdentifier;

@end

@implementation JWOpenAPIManager

#pragma mark - life cycle

- (instancetype)initWithRequestUrl:(NSString *)url
{
    return [self initWithRequestUrl:url type:CTAPIManagerRequestTypeGet params:nil serviceIdentifier:kCTServiceOpen];
}

- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type
{
    return [self initWithRequestUrl:url type:type params:nil serviceIdentifier:kCTServiceOpen];
}

- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params
{
    return [self initWithRequestUrl:url type:type params:params serviceIdentifier:kCTServiceOpen];
}

- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier
{
    self = [self init];
    if (self) {
        
        _url = url;
        _requestType = type;
        _params = params;
        _serviceIdentifier = serviceIdentifier;
        
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.paramSource = self;
        self.cachePolicy = CTAPIManagerCachePolicyMemory | CTAPIManagerCachePolicyDisk;
    }
    return self;
}

#pragma mark - CTAPIManager
- (NSString *_Nonnull)methodName
{
    return _url;
}

- (NSString *_Nonnull)serviceIdentifier
{
    return _serviceIdentifier ?: kCTServiceOpen;
}

- (CTAPIManagerRequestType)requestType
{
    return _requestType;
}

#pragma mark - CTAPIManagerParamSource

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager
{
    return _params;
}

#pragma mark - getters and setters

- (NSString *)access_token {
    return JWNetworkingConfigureManager.defaultManager.access_token;;
}

- (NSString *)host {
    return JWNetworkingConfigureManager.defaultManager.host;
}


@end
