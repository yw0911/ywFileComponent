//
//  CTDiskCacheCenter.m
//  BLNetworking
//
//  Created by casa on 2016/11/21.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "CTDiskCacheCenter.h"
#import "CTCacheCenter.h"
#import <YYCache/YYCache.h>

NSString * const kCTDiskCacheCenterCachedObjectKeyPrefix = @"kCTDiskCacheCenterCachedObjectKeyPrefix";

@interface CTDiskCacheCenter ()

@property (nonatomic, strong) YYDiskCache *diskCache;

@end

@implementation CTDiskCacheCenter

- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            [self cleanAllOldDataInPlist];
        });
    }
    return self;
}

- (CTURLResponse *)fetchCachedRecordWithKey:(NSString *)key
{
    NSString *actualKey = [NSString stringWithFormat:@"%@%@",kCTDiskCacheCenterCachedObjectKeyPrefix, key];
    CTURLResponse *response = nil;
    NSDictionary *data = [self.diskCache objectForKey:actualKey];
    if (data) {
        NSDictionary *fetchedContent = data;
        NSNumber *lastUpdateTimeNumber = fetchedContent[@"lastUpdateTime"];
        NSDate *lastUpdateTime = [NSDate dateWithTimeIntervalSince1970:lastUpdateTimeNumber.doubleValue];
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastUpdateTime];
        if (timeInterval < [fetchedContent[@"cacheTime"] doubleValue]) {
            response = [[CTURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:fetchedContent[@"content"] options:0 error:NULL]];
        } else {
            [self.diskCache removeObjectForKey:actualKey withBlock:nil];
        }
    }
    return response;
}

- (void)saveCacheWithResponse:(CTURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime
{
    if (response.content) {
        NSDictionary *data = @{
                               @"content":response.content,
                               @"lastUpdateTime":@([NSDate date].timeIntervalSince1970),
                               @"cacheTime":@(cacheTime)
                               };
        if (data) {
            NSString *actualKey = [NSString stringWithFormat:@"%@%@",kCTDiskCacheCenterCachedObjectKeyPrefix, key];
            [self.diskCache setObject:data forKey:actualKey withBlock:nil];
        }
    }
}

- (void)cleanAll
{
    [self.diskCache removeAllObjectsWithBlock:nil];
}

//更换存储时进行数据清理
- (void)cleanAllOldDataInPlist
{
    NSArray *keys = @[];
    @autoreleasepool {
        NSDictionary *defaultsDict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        keys = [[defaultsDict allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", kCTDiskCacheCenterCachedObjectKeyPrefix]];
    }
    for(NSString *key in keys) {
        if ([[CTCacheCenter sharedInstance] shouldRemoveCache:key]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
    }    
}

- (YYDiskCache *)diskCache {
    if (!_diskCache) {
        NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [cacheFolder stringByAppendingPathComponent:@"NetworkCache"];
        _diskCache = [[YYDiskCache alloc] initWithPath:path];
        //10000 条
        _diskCache.countLimit = 10000;
        //500M
        _diskCache.costLimit = 500*1000*1000;
        _diskCache.autoTrimInterval = 60*60;
    }
    return _diskCache;
}

@end
