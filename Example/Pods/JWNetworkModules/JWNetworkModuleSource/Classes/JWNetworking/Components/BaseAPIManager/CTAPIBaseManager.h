//
//  AJKBaseManager.h
//  casatwy2
//
//  Created by casa on 13-12-2.
//  Copyright (c) 2013年 casatwy inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTURLResponse.h"
#import "CTNetworkingDefines.h"

typedef void(^JWRequestCompletionBlock)(__kindof CTAPIBaseManager * _Nonnull apimanager);

@interface CTAPIBaseManager : NSObject <NSCopying>

// outter functions
@property (nonatomic, weak) id <CTAPIManagerCallBackDelegate> _Nullable delegate;
@property (nonatomic, weak) id <CTAPIManagerParamSource> _Nullable paramSource;
@property (nonatomic, weak) id <CTAPIManagerValidator> _Nullable validator;
@property (nonatomic, weak) NSObject<CTAPIManager> * _Nullable child; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) id <CTAPIManagerInterceptor> _Nullable interceptor;

// cache
@property (nonatomic, assign) CTAPIManagerCachePolicy cachePolicy;
@property (nonatomic, assign) CTAPIManagerCacheKeyMask cacheKeyMask;
@property (nonatomic, copy)   NSString *cacheKey;
@property (nonatomic, assign) NSTimeInterval memoryCacheSecond; // 默认 7 * 86400
@property (nonatomic, assign) NSTimeInterval diskCacheSecond; // 默认 7 * 86400
@property (nonatomic, assign) BOOL shouldIgnoreCache;  //默认NO

// response
@property (nonatomic, strong) CTURLResponse * _Nonnull response;
@property (nonatomic, readonly) CTAPIManagerErrorType errorType;
@property (nonatomic, copy, readonly) NSString * _Nullable errorMessage;

// before loading
@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

// block
@property (nonatomic, strong, nullable) JWRequestCompletionBlock successBlock;
@property (nonatomic, strong, nullable) JWRequestCompletionBlock failBlock;


@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *domain_id;
@property (nonatomic, strong) NSString *host;
////不拦截错误码的网络请求集合
//@property(nonatomic,strong)NSArray *blackList;

//Request Configuration
- (void)setCompletionBlockWithSuccess:(JWRequestCompletionBlock)successCallback fail:(JWRequestCompletionBlock)failCallback;

// start
- (NSInteger)loadData;
- (NSInteger)loadDataWithCompletionBlockWithSuccess:(JWRequestCompletionBlock)successCallback fail:(JWRequestCompletionBlock)failCallback;

// start without cache
- (NSInteger)loadDataWithoutCache;
- (NSInteger)loadDataWithoutCacheWithCompletionBlockWithSuccess:(JWRequestCompletionBlock)successCallback fail:(JWRequestCompletionBlock)failCallback;

//start from cache
- (CTURLResponse *)loadCacheData;//可先用这个方法直接返回缓存数据

- (void)loadDataFromCache;
- (void)loadDataFromCacheWithCompletionBlockWithSuccess:(JWRequestCompletionBlock)successCallback fail:(JWRequestCompletionBlock)failCallback;

//先 cache 后 请求数据
- (NSInteger)loadDataWithCacheElseRequest;
- (NSInteger)loadDataWithCacheElseRequestWithCompletionBlockWithSuccess:(JWRequestCompletionBlock)successCallback fail:(JWRequestCompletionBlock)failCallback;

// cancel
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

// finish
- (id _Nullable )fetchDataWithReformer:(id <CTAPIManagerDataReformer> _Nullable)reformer;
- (void)cleanData;
@end

@interface CTAPIBaseManager (InnerInterceptor)

- (BOOL)beforePerformSuccessWithResponse:(CTURLResponse *_Nullable)response;
- (void)afterPerformSuccessWithResponse:(CTURLResponse *_Nullable)response;

- (BOOL)beforePerformFailWithResponse:(CTURLResponse *_Nullable)response;
- (void)afterPerformFailWithResponse:(CTURLResponse *_Nullable)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *_Nullable)params;
- (void)afterCallingAPIWithParams:(NSDictionary *_Nullable)params;

- (BOOL)shouldCacheDataWithResponse:(CTURLResponse *_Nullable)response;

@end

@interface CTAPIBaseManager (JWExtension)

@property (nonatomic, assign, readonly) NSInteger recordedRequestId;

- (void)cancelRequest;

@end

