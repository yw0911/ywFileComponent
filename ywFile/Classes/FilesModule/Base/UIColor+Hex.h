//  Created by Jason Morrissey

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)jw_colorWithHex:(long)hexColor;
+ (UIColor *)jw_colorWithHex:(long)hexColor alpha:(float)opacity;
+ (instancetype)colorWithHexString:(NSString *)hexStr;
+ (instancetype)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)opacity;
//+ (instancetype)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
+ (UIColor *)getNewColorWith:(UIColor *)color alpha:(CGFloat)alpha;
@end
