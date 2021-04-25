//
//  JWNetworkSupport.h
//  Network
//
//  Created by 葛林晓 on 2018/7/12.
//  Copyright © 2018年 gelx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JWNetworkReachabilityStatus) {
    JWNetworkReachabilityStatusUnknown          = -1,
    JWNetworkReachabilityStatusNotReachable     = 0,
    JWNetworkReachabilityStatusReachableViaWWAN = 1,
    JWNetworkReachabilityStatusReachableViaWiFi = 2,
};

FOUNDATION_EXPORT NSString * const JWNetworkingReachabilityDidChangeNotification;
FOUNDATION_EXPORT NSString * const JWNetworkingReachabilityNotificationOldStatusItem;
FOUNDATION_EXPORT NSString * const JWNetworkingReachabilityNotificationStatusItem;

@interface JWNetworkSupport : NSObject

@property (readonly, nonatomic, assign) JWNetworkReachabilityStatus networkReachabilityStatus;

@property (nonatomic, assign, readonly) BOOL isReachable;

+ (instancetype)sharedInstance;

/**
 NotificationName: AFNetworkingReachabilityDidChangeNotification
 userInfo: @{ AFNetworkingReachabilityNotificationStatusItem: @(status) }
 */
- (void)startNetworkMonitoring;
- (void)stopNetworkMonitoring;


@end
