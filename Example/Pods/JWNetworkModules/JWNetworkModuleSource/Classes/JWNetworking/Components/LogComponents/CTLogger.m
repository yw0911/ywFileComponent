//
//  AXLogger.m
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTLogger.h"

#import "NSObject+AXNetworkingMethods.h"
#import "NSMutableString+AXNetworkingMethods.h"
#import "NSArray+AXNetworkingMethods.h"
#import "NSURLRequest+CTNetworkingMethods.h"
#import "NSDictionary+AXNetworkingMethods.h"

#import "CTApiProxy.h"
#import "CTServiceFactory.h"
#import "CTNetworkingDefines.h"

@interface CTLogger ()

@end

@implementation CTLogger

+ (NSString *)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(id <CTServiceProtocol>)service
{
    NSMutableString *logString = nil;
#ifdef DEBUG
    
    CTServiceAPIEnvironment enviroment = request.service.apiEnvironment;
    NSString *enviromentString = nil;
    if (enviroment == CTServiceAPIEnvironmentDevelop) {
        enviromentString = @"Develop";
    }
    if (enviroment == CTServiceAPIEnvironmentReleaseCandidate) {
        enviromentString = @"Pre Release";
    }
    if (enviroment == CTServiceAPIEnvironmentRelease) {
        enviromentString = @"Release";
    }
    
    logString = [NSMutableString stringWithString:@"\n\n********************************************************\nRequest Start\n********************************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", [apiName CT_defaultValue:@"N/A"]];
    [logString appendFormat:@"Method:\t\t\t%@\n", request.HTTPMethod];
    [logString appendFormat:@"Service:\t\t%@\n", [service class]];
    [logString appendFormat:@"Status:\t\t\t%@\n", enviromentString];
    [logString appendURLRequest:request];
    
    [logString appendFormat:@"\n\n********************************************************\nRequest End\n********************************************************\n\n\n\n"];
    NSLog(@"%@", logString);
#endif
    return logString;
}

+ (NSString *)logDebugInfoWithResponse:(NSHTTPURLResponse *)response rawResponseData:(NSData *)rawResponseData responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error
{
    NSMutableString *logString = nil;
#ifdef DEBUG

    BOOL isSuccess = error ? NO : YES;
    
    logString = [NSMutableString stringWithString:@"\n\n=========================================\nAPI Response\n=========================================\n\n"];
    
    [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    responseString = responseString.length > 1000 ? @"Content数据太大，请打断点查看" : responseString;
    [logString appendFormat:@"Content:\n\t%@\n\n", responseString];
    [logString appendFormat:@"Request URL:\n\t%@\n\n", request.URL];
    NSString *originRequestParams = request.originRequestParams.CT_jsonString;
    originRequestParams = originRequestParams.length > 1000 ? @"原始请求参数数据太大，请打断点查看" : originRequestParams;
    [logString appendFormat:@"Request Data:\n\t%@\n\n",originRequestParams];
    NSString *rawResponseString = [[NSString alloc] initWithData:rawResponseData encoding:NSUTF8StringEncoding];
    rawResponseString = rawResponseString.length > 1000 ? @"Raw Response String 数据太大，请打断点查看" : rawResponseString;
    [logString appendFormat:@"Raw Response String:\n\t%@\n\n", rawResponseString];
    [logString appendFormat:@"Raw Response Header:\n\t%@\n\n", response.allHeaderFields];
    if (isSuccess == NO) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
    
    [logString appendURLRequest:request];
    
    [logString appendFormat:@"\n\n=========================================\nResponse End\n=========================================\n\n"];
 
    NSLog(@"%@", logString);
#endif
    
    return logString;
}

+(NSString *)logDebugInfoWithCachedResponse:(CTURLResponse *)response methodName:(NSString *)methodName service:(id <CTServiceProtocol>)service params:(NSDictionary *)params
{
    NSMutableString *logString = nil;
#ifdef DEBUG

    logString = [NSMutableString stringWithString:@"\n\n=========================================\nCached Response                             \n=========================================\n\n"];

    [logString appendFormat:@"API Name:\t\t%@\n", [methodName CT_defaultValue:@"N/A"]];
    [logString appendFormat:@"Service:\t\t%@\n", [service class]];
    [logString appendFormat:@"Method Name:\t%@\n", methodName];
    [logString appendFormat:@"Params:\n%@\n\n", params];
    NSString *originRequestParams = response.originRequestParams.CT_jsonString;
    originRequestParams = originRequestParams.length > 1000 ? @"原始请求参数数据太大，请打断点查看" : originRequestParams;
    NSString *acturlRequestParams = response.acturlRequestParams.CT_jsonString;
    acturlRequestParams = acturlRequestParams.length > 1000 ? @"实际请求参数数据太大，请打断点查看" : acturlRequestParams;
    [logString appendFormat:@"Origin Params:\n%@\n\n", originRequestParams];
    [logString appendFormat:@"Actual Params:\n%@\n\n", acturlRequestParams];
    [logString appendFormat:@"Content:\n\t%@\n\n", response.contentString];
    
    [logString appendFormat:@"\n\n=========================================\nResponse End\n=========================================\n\n"];
    NSLog(@"%@", logString);
#endif
    
    return logString;
}

@end
