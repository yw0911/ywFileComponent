//
//  JWNetRequestLimitedManager.h
//  joywok
//
//  Created by Lgl on 2020/5/29.
//  Copyright © 2020 Dogesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWNetRequestLimitedManager : NSObject

+ (instancetype)sharedLimitedManager;

- (BOOL)addRequestIdentifier:(NSString *)identifier;
- (BOOL)removeRequestIdentifier:(NSString *)identifier;

- (void)removeAllRequestIdentifier;

@end

