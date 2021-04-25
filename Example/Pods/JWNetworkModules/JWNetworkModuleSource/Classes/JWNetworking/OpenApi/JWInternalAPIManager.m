//
//  JWInternalAPIManager.m
//  Network
//
//  Created by 葛林晓 on 2018/7/11.
//  Copyright © 2018年 gelx. All rights reserved.
//

#import "JWInternalAPIManager.h"
#import "CTServiceSupport.h"
#import "JWBaseAPIVaildator.h"
#import "JWNetworkingConfigureManager.h"

@interface JWInternalAPIManager () <CTAPIManagerParamSource>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) CTAPIManagerRequestType requestType;
@property (nonatomic, strong) NSString *serviceIdentifier;

@property (nonatomic, strong) id <CTAPIManagerValidator> internalAPIvalidator;
@property (nonatomic, strong) NSDictionary *md5CachedDict;
@end

@implementation JWInternalAPIManager

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
- (NSDictionary *)loadDataWithMD5CompletionBlockWithSuccess:(JWRequestCompletionBlock)successCallback fail:(JWRequestCompletionBlock)failCallback;
{
    [self setCacheKeyMask:CTAPIManagerCacheKeyMaskDefaultButParams];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValuesForKeysWithDictionary:_params];
    [dict removeObjectForKey:@"md5"];
    [dict removeObjectForKey:@"updated_at"];
    NSDictionary *cacheDict = [self loadCacheData].content;
    self.md5CachedDict = cacheDict;
    NSString *md5 = [[cacheDict objectForKey:@"JMStatus"] objectForKey:@"md5"];
    NSString *updated_at = [[cacheDict objectForKey:@"JMStatus"] objectForKey:@"updated_at"];
    if (md5) {
        [dict setObject:md5 forKey:@"md5"];
    }
    if (updated_at) {
        [dict setObject:updated_at forKey:@"updated_at"];
    }
    _params = [dict copy];
    [self loadDataWithoutCacheWithCompletionBlockWithSuccess:successCallback fail:failCallback];
    if (cacheDict) {
        return cacheDict;
    }
    return nil;
}

- (BOOL)shouldCacheDataWithResponse:(CTURLResponse *_Nullable)response {
    if (response.content && self.md5CachedDict) {
        NSString *md5 = [[response.content objectForKey:@"JMStatus"] objectForKey:@"md5"];
        NSInteger updated_at = [[[response.content objectForKey:@"JMStatus"] objectForKey:@"updated_at"] integerValue];
        NSString *cachedMd5 = [[self.md5CachedDict objectForKey:@"JMStatus"] objectForKey:@"md5"];
        NSInteger cachedUpdated_at = [[[self.md5CachedDict objectForKey:@"JMStatus"] objectForKey:@"updated_at"] integerValue];
        if ((md5.length && [md5 isEqualToString:cachedMd5])||(updated_at > 0 && updated_at == cachedUpdated_at)) {
            return NO;
        }
    }
    return YES;
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

- (BOOL)needLimitRequest {
    return _limitRequest;
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
