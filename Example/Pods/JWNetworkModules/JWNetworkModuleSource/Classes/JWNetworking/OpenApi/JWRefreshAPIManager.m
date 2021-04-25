//
//  JWRefreshAPIManager.m
//  joywok
//
//  Created by 葛林晓 on 2018/7/14.
//  Copyright © 2018年 Dogesoft. All rights reserved.
//

#import "JWRefreshAPIManager.h"
#import "CTServiceSupport.h"
#import "JWBaseAPIVaildator.h"
#import "JWNetworkingConfigureManager.h"

@interface JWRefreshAPIManager () <CTAPIManagerParamSource>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) CTAPIManagerRequestType requestType;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *serviceIdentifier;
@property (nonatomic, strong) id <CTAPIManagerValidator>internalAPIvalidator;

@end

@implementation JWRefreshAPIManager

#pragma mark - life cycle

- (instancetype)initWithRequestUrl:(NSString *)url
{
    return [self initWithRequestUrl:url type:CTAPIManagerRequestTypeGet params:nil serviceIdentifier:kCTServiceInternal];
}

- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type
{
    return [self initWithRequestUrl:url type:type params:nil serviceIdentifier:kCTServiceInternal];
}

- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params
{
    return [self initWithRequestUrl:url type:type params:params serviceIdentifier:kCTServiceInternal];
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
        if (JWNetworkingConfigureManager.defaultManager.interseptorCls) {
            Class class = JWNetworkingConfigureManager.defaultManager.interseptorCls;
            _internalAPIvalidator = [class new];
            self.validator = _internalAPIvalidator;
        }else {
            _internalAPIvalidator= [[JWBaseAPIVaildator alloc] init];
            self.validator = _internalAPIvalidator;
        }
        self.cachePolicy = CTAPIManagerCachePolicyMemory | CTAPIManagerCachePolicyDisk;
    }
    return self;
}

#pragma mark -

- (NSInteger)loadData {
    
    if (self.isLoading) {
        return 0;
    }
    
    return [super loadData];
}

#pragma mark - CTAPIManager

- (NSString *_Nonnull)methodName
{
    return _url;
}

- (NSString *_Nonnull)serviceIdentifier
{
    return _serviceIdentifier ?: kCTServiceInternal;
}

- (CTAPIManagerRequestType)requestType
{
    return _requestType;
}

- (NSString *)access_token {
    return JWNetworkingConfigureManager.defaultManager.access_token;;
}

- (NSString *)domain_id {
    return JWNetworkingConfigureManager.defaultManager.domain_id;
}

- (NSString *)host {
    return JWNetworkingConfigureManager.defaultManager.host;
}

#pragma mark - CTAPIManagerParamSource

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager
{
    return _params;
}

@end
