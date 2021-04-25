//
//  JWOpenService.m
//  joywok
//
//  Created by 葛林晓 on 2018/9/21.
//  Copyright © 2018年 Dogesoft. All rights reserved.
//

#import "JWOpenService.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "JWAFNTransformBoundaryTool.h"
@interface JWOpenService ()

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *host;

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation JWOpenService
@synthesize apiEnvironment;

#pragma mark - public methods
- (NSURLRequest *)requestWithParams:(NSDictionary *)params methodName:(NSString *)methodName requestType:(CTAPIManagerRequestType)requestType
{
    NSString *method = [CTServiceSupport requestType:requestType];
    NSString *urlString = [NSString stringWithFormat:@"%@",methodName];
    BOOL haveHost = ([urlString containsString:@"http://"] || [urlString containsString:@"https://"]);
    NSMutableDictionary *appendParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if (!haveHost) {
        urlString = [NSString stringWithFormat:@"%@%@", self.host, methodName];
    }
    
    NSMutableURLRequest *request;
    if (requestType == CTAPIManagerRequestTypePost) {
        request = [self.httpRequestSerializer multipartFormRequestWithMethod:method URLString:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [JWAFNTransformBoundaryTool tansformBoundaryWith:formData withSetFileInternalBody:YES];
        } error:nil];
    } else {
        request = [self.httpRequestSerializer requestWithMethod:method URLString:urlString parameters:params error:nil];
    }
    [request setValue:[CTServiceSupport userAgentOfHTTPHeaderField] forHTTPHeaderField:@"User-Agent"];
    if (!haveHost) {
        if (self.access_token) {
            [request setValue:[self.access_token CT_Base64Encode] forHTTPHeaderField:@"ACCESS-TOKEN"];
        }
    }

    request.originRequestParams = params;
    request.actualRequestParams = appendParams;
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
