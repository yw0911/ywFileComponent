//
//  JWAFNTransformBoundaryTool.h
//  joywok
//
//  Created by winds on 2019/10/14.
//  Copyright © 2019 Dogesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface JWAFNTransformBoundaryTool : NSObject

/**
 * @ formData AFN 网络协议中的模型，用来更改设置完成后的bodyStream中的boundary （仅参数字典不包含图片）
 * @ body 如果需要上传网络图片，需要替换 formData中的 boundary （替换完供图片上传使用） 暂时默认都改动 yes
 **/
+(void)tansformBoundaryWith:(id)formData withSetFileInternalBody:(BOOL)body;
/**
 * @ 更改设置完成后的 request 的"Content-Type"中的 boundary 和上述方法配合使用才有效
 * 
 **/
+(void)setRequestContentType:(NSMutableURLRequest *)request;
@end

NS_ASSUME_NONNULL_END
