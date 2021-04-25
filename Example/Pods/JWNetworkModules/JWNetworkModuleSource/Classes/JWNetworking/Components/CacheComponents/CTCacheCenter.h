//
//  CTCacheCenter.h
//  BLNetworking
//
//  Created by casa on 2016/11/21.
//  Copyright © 2016年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTURLResponse.h"
#import "CTNetworkingDefines.h"

@interface CTCacheCenter : NSObject

+ (instancetype)sharedInstance;

- (CTURLResponse *)fetchDiskCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params cacheKeyMask:(CTAPIManagerCacheKeyMask)cacheKeyMask cacheKey:(NSString *)cacheKey;
- (CTURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params cacheKeyMask:(CTAPIManagerCacheKeyMask)cacheKeyMask cacheKey:(NSString *)cacheKey;

- (void)saveDiskCacheWithResponse:(CTURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName  cacheKeyMask:(CTAPIManagerCacheKeyMask)cacheKeyMask cacheKey:(NSString *)cacheKey cacheTime:(NSTimeInterval)cacheTime;
- (void)saveMemoryCacheWithResponse:(CTURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheKeyMask:(CTAPIManagerCacheKeyMask)cacheKeyMask cacheKey:(NSString *)cacheKey cacheTime:(NSTimeInterval)cacheTime;


/**
 通过 cacheWhitelist 来设置该cache不应该被remove

 @param cacheKey cacheKey
 @return should remove cache?
 */
- (BOOL)shouldRemoveCache:(NSString *)cacheKey;

- (void)cleanAllMemoryCache;
- (void)cleanAllDiskCache;

@end
