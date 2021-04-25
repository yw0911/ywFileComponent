//
//  CTCache.m
//  RTNetworking
//
//  Created by casa on 14-5-26.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTMemoryCacheDataCenter.h"
#import "CTMemoryCachedRecord.h"
#import <malloc/malloc.h>
#import "CTCacheCenter.h"

@interface CTMemoryCacheDataCenter ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation CTMemoryCacheDataCenter

#pragma mark - public method
- (CTURLResponse *)fetchCachedRecordWithKey:(NSString *)key
{
    CTURLResponse *result = nil;
    CTMemoryCachedRecord *cachedRecord = [self.cache objectForKey:key];
    if (cachedRecord != nil) {
        if (cachedRecord.isOutdated || cachedRecord.isEmpty) {
            [self.cache removeObjectForKey:key];
        } else {
            result = [[CTURLResponse alloc] initWithData:cachedRecord.content];
        }
    }
    return result;
}

- (void)saveCacheWithResponse:(CTURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime
{
    CTMemoryCachedRecord *cachedRecord = [self.cache objectForKey:key];
    if (cachedRecord == nil) {
        cachedRecord = [[CTMemoryCachedRecord alloc] init];
    }
    cachedRecord.cacheTime = cacheTime;
    [cachedRecord updateContent:[NSJSONSerialization dataWithJSONObject:response.content options:0 error:NULL]];
    [self.cache setObject:cachedRecord forKey:key cost:malloc_size((__bridge const void *)cachedRecord)];
}

- (void)cleanAll
{
    [self.cache removeAllObjects];
}

#pragma mark - getters and setters
- (NSCache *)cache
{
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = 20;
        _cache.totalCostLimit = 10*1024*1024;
    }
    return _cache;
}

@end
