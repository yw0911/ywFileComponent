//
//  JWNetworkSupport.m
//  Network
//
//  Created by 葛林晓 on 2018/7/12.
//  Copyright © 2018年 gelx. All rights reserved.
//

#import "JWNetworkSupport.h"
#import <AFNetworking/AFHTTPSessionManager.h>

NSString * const JWNetworkingReachabilityDidChangeNotification = @"JWNetworkingReachabilityDidChangeNotification";
NSString * const JWNetworkingReachabilityNotificationOldStatusItem = @"JWNetworkingReachabilityNotificationOldStatusItem";
NSString * const JWNetworkingReachabilityNotificationStatusItem = @"JWNetworkingReachabilityNotificationStatusItem";

@interface JWNetworkSupport ()

@property (readwrite, nonatomic, assign) JWNetworkReachabilityStatus networkReachabilityStatus;

@end

@implementation JWNetworkSupport

+ (instancetype)sharedInstance {
    static JWNetworkSupport *networkSupport;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkSupport = [[self alloc] init];
    });
    return networkSupport;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.networkReachabilityStatus = JWNetworkReachabilityStatusUnknown;
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [self networkingReachabilityDidChange:status];
        }];
    }
    return self;
}

- (void)networkingReachabilityDidChange:(AFNetworkReachabilityStatus)status {
    JWNetworkReachabilityStatus oldStatus = self.networkReachabilityStatus;
    self.networkReachabilityStatus = (NSInteger)status;

    //公共处理
    if (status == AFNetworkReachabilityStatusNotReachable) {
        //处理无网络
        
    }
    
    //post notification
    NSDictionary *userInfo = @{JWNetworkingReachabilityNotificationOldStatusItem:@(oldStatus),
                               JWNetworkingReachabilityNotificationStatusItem:@(status)};
    [[NSNotificationCenter defaultCenter] postNotificationName:JWNetworkingReachabilityDidChangeNotification object:nil userInfo:userInfo];
}

- (BOOL)isReachable {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

/**
    NotificationName: AFNetworkingReachabilityDidChangeNotification
    userInfo: @{ AFNetworkingReachabilityNotificationStatusItem: @(status) }
 */
- (void)startNetworkMonitoring {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)stopNetworkMonitoring {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
