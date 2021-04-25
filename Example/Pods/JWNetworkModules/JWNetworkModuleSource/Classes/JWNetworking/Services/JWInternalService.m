//
//  JWInternalService.m
//  Network
//
//  Created by 葛林晓 on 2018/7/11.
//  Copyright © 2018年 gelx. All rights reserved.
//

#import "JWInternalService.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "CTServiceSupport.h"
#import "JWAFNTransformBoundaryTool.h"
#import "JWNetworkingConfigureManager.h"

@interface JWInternalService ()

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *domain_id;
@property (nonatomic, strong) NSString *host;

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation JWInternalService
@synthesize apiEnvironment;

#pragma mark - public methods
- (NSURLRequest *)requestWithParams:(NSDictionary *)params methodName:(NSString *)methodName requestType:(CTAPIManagerRequestType)requestType
{
    NSString *method = [CTServiceSupport requestType:requestType];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.host, methodName];
    NSMutableDictionary *appendParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if (self.domain_id) {
        appendParams[@"domain_id"] = self.domain_id;
    }
    
    appendParams[@"lang"] = JWNetworkingConfigureManager.defaultManager.lang;
    NSMutableURLRequest *request;
    if (requestType == CTAPIManagerRequestTypePost) {
        request = [self.httpRequestSerializer multipartFormRequestWithMethod:method URLString:urlString parameters:appendParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [JWAFNTransformBoundaryTool tansformBoundaryWith:formData withSetFileInternalBody:YES];
        } error:nil];
    } else {
        request = [self.httpRequestSerializer requestWithMethod:method URLString:urlString parameters:appendParams error:nil];
    }
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    [request setValue:[CTServiceSupport userAgentOfHTTPHeaderField] forHTTPHeaderField:@"User-Agent"];
    if (self.access_token) {
        [request setValue:[self.access_token CT_Base64Encode] forHTTPHeaderField:@"ACCESS-TOKEN"];
    }
    
    request.originRequestParams = params;
    request.actualRequestParams = appendParams;
    [JWAFNTransformBoundaryTool setRequestContentType:request];
    return request;
}

- (NSDictionary *)resultWithResponseData:(NSData *)responseData response:(NSURLResponse *)response request:(NSURLRequest *)request error:(NSError **)error
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    if (responseData) {
        result[kCTApiProxyValidateResultKeyResponseData] = responseData;
        result[kCTApiProxyValidateResultKeyResponseJSONString] = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        result[kCTApiProxyValidateResultKeyResponseJSONObject] = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
    }
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
