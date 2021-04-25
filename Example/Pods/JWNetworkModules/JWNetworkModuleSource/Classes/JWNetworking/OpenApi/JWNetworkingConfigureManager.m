//
//  JWNetworkingConfigureManager.m
//  joywok
//
//  Created by 上上签 on 2021/3/29.
//  Copyright © 2021 Dogesoft. All rights reserved.
//

#import "JWNetworkingConfigureManager.h"

@implementation JWNetworkingConfigureManager

+ (JWNetworkingConfigureManager *)defaultManager {
    static JWNetworkingConfigureManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[JWNetworkingConfigureManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.enableWAFChangeAFNBoundary = 1;
    }
    return self;
}

- (NSMutableArray *)whiteList {
    if (!_whiteList) {
        _whiteList = [NSMutableArray array];
    }
    return _whiteList;
}

@end
