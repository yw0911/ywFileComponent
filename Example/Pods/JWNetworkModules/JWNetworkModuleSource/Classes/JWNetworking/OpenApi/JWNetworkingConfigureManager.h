//
//  JWNetworkingConfigureManager.h
//  joywok
//
//  Created by 上上签 on 2021/3/29.
//  Copyright © 2021 Dogesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTNetworkingDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface JWNetworkingConfigureManager : NSObject

/**请求token */
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *domain_id;
/**请求host 如：https://www.baidu.com */
@property (nonatomic, strong) NSString *host;
/**应用包名*/
@property (nonatomic, strong) NSString *appBundleID;
/**设备当前语言环境*/
@property (nonatomic, strong) NSString *lang;
/**不拦截错误码的网络请求集合*/
@property(nonatomic,strong)NSMutableArray *whiteList;
/**后台开启WAF 校验后 客户端修改 AFN中的边界值Boundary 防止被拦截 1.打开 0关闭 默认值1*/

@property(nonatomic,assign)int enableWAFChangeAFNBoundary;
//拦截器
@property(nonatomic,assign)Class <CTAPIManagerValidator>interseptorCls;

+ (JWNetworkingConfigureManager *)defaultManager;

@end

NS_ASSUME_NONNULL_END
