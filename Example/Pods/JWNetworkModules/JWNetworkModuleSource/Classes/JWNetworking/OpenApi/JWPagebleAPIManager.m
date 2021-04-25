//
//  JWPagebleAPIManager.m
//  Network
//
//  Created by 葛林晓 on 2018/7/12.
//  Copyright © 2018年 gelx. All rights reserved.
//

#import "JWPagebleAPIManager.h"
#import "JWNetworkingConfigureManager.h"
#import "JWBaseAPIVaildator.h"
#import "CTServiceSupport.h"

@interface JWPagebleAPIManager () <CTAPIManagerParamSource>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) CTAPIManagerRequestType requestType;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *serviceIdentifier;

@property (nonatomic, assign, readwrite) NSUInteger currentPageNumber;
@property (nonatomic, assign, readwrite) BOOL isFirstPage;
@property (nonatomic, assign, readwrite) BOOL isLastPage;

@property (nonatomic, assign) NSUInteger totalPage;
@property (nonatomic, strong) id <CTAPIManagerValidator>internalAPIvalidator;

@end

@implementation JWPagebleAPIManager
@synthesize pageSize;

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
    //如果有筛选功能，暂不做判断
    if (!_isFilter && _isFirstPage && self.isLoading) {
        return 0;
    }
    
    _currentPageNumber = 0;
    
    return [super loadData];
}

#pragma mark - CTPagableAPIManager

- (void)loadNextPage {
    if(!_isFirstPage && self.isLoading) {
        return ;
    }
    
    _currentPageNumber ++;
    [super loadData];
}

- (BOOL)isFirstPage {
    return _currentPageNumber == 0;
}

- (BOOL)isLastPage {
    return (_currentPageNumber+1) >= _totalPage;
}

#pragma mark - InnerInterceptor

- (BOOL)beforePerformSuccessWithResponse:(CTURLResponse *)response
{
    NSDictionary *status = [response.content objectForKey:@"JMStatus"];
    NSUInteger total_num = [[status objectForKey:@"total_num"] unsignedIntegerValue];
    NSUInteger pagesize = [[status objectForKey:@"pagesize"] unsignedIntegerValue];
    if (pagesize > 0) {
        if(total_num > 0){
            _totalPage = (total_num / pagesize) + (total_num % pagesize == 0 ? 0 : 1);
        }else{
            _totalPage = 0;
        }
    }

    return [super beforePerformSuccessWithResponse:response];
}

- (void)afterPerformFailWithResponse:(CTURLResponse *_Nullable)response
{
    if (_currentPageNumber > 0) {
        _currentPageNumber --;
    }

    [super afterPerformFailWithResponse:response];
}

#pragma mark -

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *reformParams = [NSMutableDictionary dictionaryWithDictionary:params];
    reformParams[@"pageno"] = @(_currentPageNumber);
    reformParams[@"pagesize"] = @(self.pageSize);
    return reformParams;
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
