//
//  JWSpecialService.m
//  joywok
//
//  Created by 葛林晓 on 2019/8/8.
//  Copyright © 2019 Dogesoft. All rights reserved.
//

#import "JWSpecialService.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "JWAFNTransformBoundaryTool.h"
#import "JWNetworkingConfigureManager.h"

@interface JWSpecialService ()

@property (nonatomic, strong) NSString *host;

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation JWSpecialService
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
    
    //package:xxxxx // 包名
    //nonce:xxxx // 随机字符串，6 位，客户端自生成；
    //timestamp:xxxx // 时间戳，整值，10 位；
    //signature=SHA1(package=com.joywok.starbucks&type=app_log&nonce=xxxxx&timestamp=1557759876)
    NSString *package = JWNetworkingConfigureManager.defaultManager.appBundleID;
    NSString *nonce = [[NSUUID UUID].UUIDString substringToIndex:6];
    NSString *timestamp = [NSString stringWithFormat:@"%ld",@([NSDate date].timeIntervalSince1970).longValue];
    NSString *signature = [NSString stringWithFormat:@"package=%@&type=app_log&nonce=%@&timestamp=%@",package,nonce,timestamp];
    NSString *signatureSHA1 = [signature CT_SHA1];

    [request setValue:package forHTTPHeaderField:@"package"];
    [request setValue:nonce forHTTPHeaderField:@"nonce"];
    [request setValue:timestamp forHTTPHeaderField:@"timestamp"];
    [request setValue:signatureSHA1 forHTTPHeaderField:@"signature"];
    
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
