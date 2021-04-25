//
//  CTServiceSupport.h
//  Network
//
//  Created by 葛林晓 on 2018/7/10.
//  Copyright © 2018年 gelx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTNetworkingDefines.h"

static NSString * const kCTServiceInternal = @"internalService";
static NSString * const kCTServiceExternal = @"externalService";
static NSString * const kCTServiceOpen     = @"openService";
static NSString * const kCTServiceSpecial  = @"specialService";

@interface CTServiceSupport : NSObject

/*
 * key为service的Identifier
 * value为service的Class的字符串
 */
+ (NSDictionary<NSString *,NSString *> *)servicesKindsOfServiceFactory;

+ (NSString *)requestType:(CTAPIManagerRequestType)requestType;

+ (NSString *)userAgentOfHTTPHeaderField;

@end
