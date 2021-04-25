//
//  JWNetRequestLimitedManager.m
//  joywok
//
//  Created by Lgl on 2020/5/29.
//  Copyright © 2020 Dogesoft. All rights reserved.
//

#import "JWNetRequestLimitedManager.h"

@interface JWNetRequestLimitedManager ()
@property (nonatomic, strong) NSMutableDictionary *resource;
@end

@implementation JWNetRequestLimitedManager

+ (instancetype)sharedLimitedManager {
    static JWNetRequestLimitedManager *limitedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        limitedManager = [[JWNetRequestLimitedManager alloc] init];
    });
    return limitedManager;
}

- (BOOL)addRequestIdentifier:(NSString *)identifier {
    BOOL result = NO;
    NSDate *currentDate = [NSDate date];
    NSDate *date = self.resource[identifier];
    if (date) {
        if ([currentDate timeIntervalSinceDate:date] >= 60) {
            self.resource[identifier] = currentDate;
            result = YES;
        }else {
            result = NO;
        }
    }else {
        self.resource[identifier] = currentDate;
        result = YES;
    }
    return result;
}

- (BOOL)removeRequestIdentifier:(NSString *)identifier {
    BOOL result = NO;
    NSDate *date = self.resource[identifier];
    if (date) {
        [self.resource removeObjectForKey:identifier];
        result = YES;
    }else {
        result = NO;
    }
    return result;
}

- (void)removeAllRequestIdentifier {
    [self.resource removeAllObjects];
}

- (NSMutableDictionary *)resource {
    if (!_resource) {
        _resource = [NSMutableDictionary dictionary];
    }
    return _resource;
}

@end
