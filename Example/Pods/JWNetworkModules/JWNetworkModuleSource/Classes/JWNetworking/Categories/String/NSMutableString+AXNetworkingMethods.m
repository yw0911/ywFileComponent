//
//  NSMutableString+AXNetworkingMethods.m
//  RTNetworking
//
//  Created by casa on 14-5-17.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "NSMutableString+AXNetworkingMethods.h"
#import "NSObject+AXNetworkingMethods.h"
#import "NSURLRequest+CTNetworkingMethods.h"
#import "NSDictionary+AXNetworkingMethods.h"
#import "JWNetworkingConfigureManager.h"

@implementation NSMutableString (AXNetworkingMethods)

- (void)appendURLRequest:(NSURLRequest *)request
{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@&access_token=%@", request.URL,JWNetworkingConfigureManager.defaultManager.access_token];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    NSString *originRequestParams = request.originRequestParams.CT_jsonString;
    originRequestParams = originRequestParams.length > 1000 ? @"原始请求参数数据太大，请打断点查看" : originRequestParams;
    NSString *acturlRequestParams = request.actualRequestParams.CT_jsonString;
    acturlRequestParams = acturlRequestParams.length > 1000 ? @"实际请求参数数据太大，请打断点查看" : acturlRequestParams;
    [self appendFormat:@"\n\nHTTP Origin Params:\n\t%@", originRequestParams];
    [self appendFormat:@"\n\nHTTP Actual Params:\n\t%@", acturlRequestParams];
    [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] CT_defaultValue:@"\t\t\t\tN/A"]];

    NSMutableString *headerString = [[NSMutableString alloc] init];
    [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *header = [NSString stringWithFormat:@" -H \"%@: %@\"", key, obj];
        [headerString appendString:header];
    }];

    [self appendString:@"\n\nCURL:\n\t curl"];
    [self appendFormat:@" -X %@", request.HTTPMethod];
    
    if (headerString.length > 0) {
        [self appendString:headerString];
    }
    if (request.HTTPBody.length > 0) {
        [self appendFormat:@" -d '%@'", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] CT_defaultValue:@"\t\t\t\tN/A"]];
    }
    
    [self appendFormat:@" %@", request.URL];
}

@end
