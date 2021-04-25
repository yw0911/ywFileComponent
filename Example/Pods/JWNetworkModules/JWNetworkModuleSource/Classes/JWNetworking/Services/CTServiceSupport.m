//
//  CTServiceSupport.m
//  Network
//
//  Created by 葛林晓 on 2018/7/10.
//  Copyright © 2018年 gelx. All rights reserved.
//

#import "CTServiceSupport.h"

@implementation CTServiceSupport

/*
 * key为service的Identifier
 * value为service的Class的字符串
 */
+ (NSDictionary<NSString *,NSString *> *)servicesKindsOfServiceFactory {
    return @{
             kCTServiceInternal:@"JWInternalService",
             kCTServiceExternal:@"JWExternalService",
             kCTServiceOpen:@"JWOpenService",
             kCTServiceSpecial:@"JWSpecialService",
             };
}

+ (NSString *)requestType:(CTAPIManagerRequestType)requestType {
    
    if (requestType == CTAPIManagerRequestTypeGet) {
        return @"GET";
    }
    
    if (requestType == CTAPIManagerRequestTypePost) {
        return @"POST";
    }
    
    if (requestType == CTAPIManagerRequestTypePut) {
        return @"PUT";
    }
    
    if (requestType == CTAPIManagerRequestTypeDelete) {
        return @"DELETE";
    }
    
    return @"GET";
}

+ (NSString *)userAgentOfHTTPHeaderField {
    
    NSString *userAgent = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
#if TARGET_OS_IOS
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#elif TARGET_OS_WATCH
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; watchOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[WKInterfaceDevice currentDevice] model], [[WKInterfaceDevice currentDevice] systemVersion], [[WKInterfaceDevice currentDevice] screenScale]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
#pragma clang diagnostic pop
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
    }
    
    userAgent = [userAgent stringByAppendingFormat:@"Joywok:%@",[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    return userAgent;
}

@end
