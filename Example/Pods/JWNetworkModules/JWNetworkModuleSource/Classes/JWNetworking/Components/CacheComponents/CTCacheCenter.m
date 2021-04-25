//
//  CTCacheCenter.m
//  BLNetworking
//
//  Created by casa on 2016/11/21.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "CTCacheCenter.h"
#import "CTMemoryCacheDataCenter.h"
#import "CTMemoryCachedRecord.h"
#import "CTLogger.h"
#import "CTServiceFactory.h"
#import "NSDictionary+AXNetworkingMethods.h"
#import "CTDiskCacheCenter.h"
#import "CTMemoryCacheDataCenter.h"
#import "NSString+AXNetworkingMethods.h"

@interface CTCacheCenter ()

@property (nonatomic, strong) CTMemoryCacheDataCenter *memoryCacheCenter;
@property (nonatomic, strong) CTDiskCacheCenter *diskCacheCenter;

@end

@implementation CTCacheCenter

+ (instancetype)sharedInstance
{
    static CTCacheCenter *cacheCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheCenter = [[CTCacheCenter alloc] init];
    });
    return cacheCenter;
}

- (CTURLResponse *)fetchDiskCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params cacheKeyMask:(CTAPIManagerCacheKeyMask)cacheKeyMask cacheKey:(NSString *)cacheKey 
{
    CTURLResponse *response = [self.diskCacheCenter fetchCachedRecordWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params cacheKeyMask:cacheKeyMask cacheKey:cacheKey]];
    if (response) {
        response.logString = [CTLogger logDebugInfoWithCachedResponse:response methodName:methodName service:[[CTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier] params:params];
    }
    return response;
}

- (CTURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params cacheKeyMask:(CTAPIManagerCacheKeyMask)cacheKeyMask cacheKey:(NSString *)cacheKey
{
    CTURLResponse *response = [self.memoryCacheCenter fetchCachedRecordWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params cacheKeyMask:cacheKeyMask cacheKey:cacheKey]];
    if (response) {
        response.logString = [CTLogger logDebugInfoWithCachedResponse:response methodName:methodName service:[[CTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier] params:params];
    }
    return response;
}

- (void)saveDiskCacheWithResponse:(CTURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheKeyMask:(CTAPIManagerCacheKeyMask)cacheKeyMask cacheKey:(NSString *)cacheKey cacheTime:(NSTimeInterval)cacheTime
{
    if (response.content) {
        [self.diskCacheCenter saveCacheWithResponse:response key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:response.originRequestParams cacheKeyMask:cacheKeyMask cacheKey:cacheKey] cacheTime:cacheTime];
    }
}

- (void)saveMemoryCacheWithResponse:(CTURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheKeyMask:(CTAPIManagerCacheKeyMask)cacheKeyMask cacheKey:(NSString *)cacheKey cacheTime:(NSTimeInterval)cacheTime
{
    if (response.content) {
        [self.memoryCacheCenter saveCacheWithResponse:response key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:response.originRequestParams cacheKeyMask:cacheKeyMask cacheKey:cacheKey] cacheTime:cacheTime];
    }
}

- (void)cleanAllDiskCache
{
    [self.diskCacheCenter cleanAll];
}

- (void)cleanAllMemoryCache
{
    [self.memoryCacheCenter cleanAll];
}

- (NSArray *)cacheWhitelist {
    return @[
             ];
}

- (BOOL)shouldRemoveCache:(NSString *)cacheKey {
    NSArray *whitelist = [self cacheWhitelist];
    for (NSString *aKey in whitelist) {
        if ([cacheKey containsString:aKey]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - private methods
- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            methodName:(NSString *)methodName
                         requestParams:(NSDictionary *)requestParams
                          cacheKeyMask:(CTAPIManagerCacheKeyMask)cacheKeyMask
                              cacheKey:(NSString *)cacheKey
{
    if (cacheKeyMask == CTAPIManagerCacheKeyMaskCustom) {
        return cacheKey ?: @"";
    }
    
    if (cacheKeyMask == CTAPIManagerCacheKeyMaskDefaultButParams) {
        return [[NSString stringWithFormat:@"%@%@", serviceIdentifier, methodName] CT_MD5];
    }
    
    NSString *key = [[NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [requestParams CT_transformToUrlParamString]] CT_MD5];
    
    return key;
}

#pragma mark - getters and setters
- (CTDiskCacheCenter *)diskCacheCenter
{
    if (_diskCacheCenter == nil) {
        _diskCacheCenter = [[CTDiskCacheCenter alloc] init];
    }
    return _diskCacheCenter;
}

- (CTMemoryCacheDataCenter *)memoryCacheCenter
{
    if (_memoryCacheCenter == nil) {
        _memoryCacheCenter = [[CTMemoryCacheDataCenter alloc] init];
    }
    return _memoryCacheCenter;
}


@end
