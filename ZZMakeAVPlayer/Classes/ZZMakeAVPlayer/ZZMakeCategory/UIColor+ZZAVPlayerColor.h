//
//  UIColor+ZZAVPlayerColor.h

//  Created by on 2020/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZZAVPlayerColor)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (instancetype)rgba:(NSUInteger)rgba;
+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a;

@end

NS_ASSUME_NONNULL_END
