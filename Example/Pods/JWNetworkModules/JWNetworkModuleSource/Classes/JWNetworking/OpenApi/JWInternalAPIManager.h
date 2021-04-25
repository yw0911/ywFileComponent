//
//  JWInternalAPIManager.h
//  Network
//
//  Created by 葛林晓 on 2018/7/11.
//  Copyright © 2018年 gelx. All rights reserved.
//  JW数据源（base）

#import "CTAPIBaseManager.h"

#import "CTNetworking.h"

@interface JWInternalAPIManager : CTAPIBaseManager <CTAPIManager>

@property (nonatomic, assign) BOOL limitRequest;
@property (nonatomic, strong) NSDictionary *params;


- (instancetype)initWithRequestUrl:(NSString *)url;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params;
- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier;
- (NSDictionary *)loadDataWithMD5CompletionBlockWithSuccess:(JWRequestCompletionBlock)successCallback fail:(JWRequestCompletionBlock)failCallback;

@end
