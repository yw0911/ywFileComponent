//
//  JWExternalService.m
//  Network
//
//  Created by 葛林晓 on 2018/7/11.
//  Copyright © 2018年 gelx. All rights reserved.
//

#import "JWExternalService.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "JWAFNTransformBoundaryTool.h"
@interface JWExternalService ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation JWExternalService
@synthesize apiEnvironment;

#pragma mark - public methods
- (NSURLRequest *)requestWithParams:(NSDictionary *)params methodName:(NSString *)methodName requestType:(CTAPIManagerRequestType)requestType
{
    NSString *method = [CTServiceSupport requestType:requestType];
    NSString *urlString = [NSString stringWithFormat:@"%@",methodName];
    NSMutableURLRequest *request;
    if (requestType == CTAPIManagerRequestTypePost) {
        request = [self.httpRequestSerializer multipartFormRequestWithMethod:method URLString:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [JWAFNTransformBoundaryTool tansformBoundaryWith:formData withSetFileInternalBody:YES];
        } error:nil];
    } else {
        request = [self.httpRequestSerializer requestWithMethod:method URLString:urlString parameters:params error:nil];
    }
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    [request setValue:[CTServiceSupport userAgentOfHTTPHeaderField] forHTTPHeaderField:@"User-Agent"];

    request.originRequestParams = params;
    request.actualRequestParams = params;
    [JWAFNTransformBoundaryTool setRequestContentType:request];
    return request;
}

- (NSDictionary *)resultWithResponseData:(NSData *)responseData response:(NSURLResponse *)response request:(NSURLRequest *)request error:(NSError **)error
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[kCTApiProxyValidateResultKeyResponseData] = responseData;
    result[kCTApiProxyValidateResultKeyResponseJSONString] = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if (responseData) result[kCTApiProxyValidateResultKeyResponseJSONObject] = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
    return result;
}

#pragma mark - getters and setters

- (CTServiceAPIEnvironment)apiEnvironment
{
    return CTServiceAPIEnvironmentRelease;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        [_httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return _httpRequestSerializer;
}

@end
