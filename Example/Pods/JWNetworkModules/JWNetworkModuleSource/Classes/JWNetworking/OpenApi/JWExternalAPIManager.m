//
//  JWExternalAPIManager.m
//  Network
//
//  Created by 葛林晓 on 2018/7/11.
//  Copyright © 2018年 gelx. All rights reserved.
//

#import "JWExternalAPIManager.h"

@interface JWExternalAPIManager () <CTAPIManagerValidator, CTAPIManagerParamSource>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) CTAPIManagerRequestType requestType;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *serviceIdentifier;

@end

@implementation JWExternalAPIManager

#pragma mark - life cycle

- (instancetype)initWithRequestUrl:(NSString *)url
{
    return [self initWithRequestUrl:url type:CTAPIManagerRequestTypeGet params:nil serviceIdentifier:kCTServiceExternal];
}

- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type
{
    return [self initWithRequestUrl:url type:type params:nil serviceIdentifier:kCTServiceExternal];
}

- (instancetype)initWithRequestUrl:(NSString *)url type:(CTAPIManagerRequestType)type params:(NSDictionary *)params
{
    return [self initWithRequestUrl:url type:type params:params serviceIdentifier:kCTServiceExternal];
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
        self.validator = self;
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
    return _serviceIdentifier ?: kCTServiceExternal;
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

#pragma mark - CTAPIManagerValidator
- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return CTAPIManagerErrorTypeNoError;
}

- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return CTAPIManagerErrorTypeNoError;
}

@end
