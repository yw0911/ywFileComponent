//
//  JWAFNTransformBoundaryTool.m
//  joywok
//
//  Created by winds on 2019/10/14.
//  Copyright © 2019 Dogesoft. All rights reserved.
//

#import "JWAFNTransformBoundaryTool.h"
#import "JWNetworkingConfigureManager.h"

@implementation JWAFNTransformBoundaryTool

+(void)tansformBoundaryWith:(id)formData withSetFileInternalBody:(BOOL)body {
    int enableWAFChangeAFNBoundary = JWNetworkingConfigureManager.defaultManager.enableWAFChangeAFNBoundary;
    if (!enableWAFChangeAFNBoundary) {
        return;
    }
    NSObject *parts = [((NSObject *)formData) valueForKey:@"bodyStream"];
    NSArray *bodys = [parts valueForKey:@"HTTPBodyParts"];
    for (NSObject *body in bodys) {
        NSString *value = [body valueForKey:@"boundary"];
        if ([value containsString:@"Boundary+"]) {
            value  = [value stringByReplacingOccurrencesOfString:@"Boundary+" withString:@"Boundary"];
        }
        [body setValue:value forKey:@"boundary"];
    }
    body = YES;
    if (body) {
        NSString * value  = [((NSObject *)formData) valueForKey:@"boundary"];
        if ([value containsString:@"Boundary+"]) { // 包含边界特殊字符+ 需替换
            value  = [value stringByReplacingOccurrencesOfString:@"Boundary+" withString:@"Boundary"];
            
        }
        [((NSObject *)formData) setValue:value forKey:@"boundary"];
    }
}

+(void)setRequestContentType:(NSMutableURLRequest *)request {
    int enableWAFChangeAFNBoundary = JWNetworkingConfigureManager.defaultManager.enableWAFChangeAFNBoundary;
    if (!enableWAFChangeAFNBoundary) {
        return;
    }
    NSString * headContentType  = [request.allHTTPHeaderFields objectForKey:@"Content-Type"];
    if ([headContentType containsString:@"Boundary+"]) { // 包含边界特殊字符+ 需替换
        headContentType  = [headContentType stringByReplacingOccurrencesOfString:@"Boundary+" withString:@"Boundary"];
        [request setValue:headContentType forHTTPHeaderField:@"Content-Type"];
    }
}
@end
