//
//  UIColor+ZZAVPlayerColor.m

//  Created by on 2020/1/7.
//

#import "UIColor+ZZAVPlayerColor.h"

@implementation UIColor (ZZAVPlayerColor)

+ (UIColor *)colorWithHexString:(NSString *)hexString{
    if (!hexString)
        return nil;
    
    NSString* hex = [NSString stringWithString:hexString];
    if ([hex hasPrefix:@"#"])
        hex = [hex substringFromIndex:1];
    
    if (hex.length == 6)
        hex = [hex stringByAppendingString:@"FF"];
    else if (hex.length != 8)
        return nil;
    
    uint32_t rgba;
    NSScanner* scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&rgba];
    
    return [UIColor rgba:rgba];
}

+ (instancetype)rgba:(NSUInteger)rgba {
    return [self r:(rgba >> 24)&0xFF g:(rgba >> 16)&0xFF b:(rgba >> 8)&0xFF a:rgba&0xFF];
}
+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a {
    UIColor *color = [UIColor colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:a / 255.];
    return color;
}

@end
