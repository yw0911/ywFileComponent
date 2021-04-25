//
//  AXServiceFactory.m
//  RTNetworking
//
//  Created by casa on 14-5-12.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTServiceFactory.h"

/*************************************************************************/

@interface CTServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation CTServiceFactory

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CTServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTServiceFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (id <CTServiceProtocol>)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (id <CTServiceProtocol>)newServiceWithIdentifier:(NSString *)identifier
{
    if ([[CTServiceSupport servicesKindsOfServiceFactory] valueForKey:identifier]) {
        NSString *classStr = [[CTServiceSupport servicesKindsOfServiceFactory] valueForKey:identifier];
        id service = [[NSClassFromString(classStr) alloc]init];
        NSAssert(service, [NSString stringWithFormat:@"无法创建service，请检查servicesKindsOfServiceFactory提供的数据是否正确"],service);
        return service;
    }else {
        NSAssert(NO, @"servicesKindsOfServiceFactory中无法找不到相匹配identifier");
    }
    
    return nil;
}

@end
