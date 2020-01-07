//
//  ZZAVPlayerMacro.h

//  Created by on 2020/1/7.
//

#ifndef ZZAVPlayerMacro_h
#define ZZAVPlayerMacro_h

/// 类型相关
#define ZZAVPlayer_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define ZZAVPlayer_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define ZZAVPlayer_IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

/// 手机类型相关
//判断iPhone5系列
#define ZZAVPlayer_IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPhone6系列
#define ZZAVPlayer_IS_IPHONE_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iphone6+系列
#define ZZAVPlayer_IS_IPHONE_6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPhoneX
#define ZZAVPlayer_IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPHoneXr
#define ZZAVPlayer_IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPhoneXs
#define ZZAVPlayer_IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPhoneXs Max
#define ZZAVPlayer_IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPhone 11
#define ZZAVPlayer_IS_IPHONE_11 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPhone 11 Pro
#define ZZAVPlayer_IS_IPHONE_11_Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPhoneXs 11 Pro Max
#define ZZAVPlayer_IS_IPHONE_11_Pro_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)

/// 屏幕尺寸相关
#define ZZAVPlayer_SCREEN_W  ([[UIScreen mainScreen] bounds].size.width)
#define ZZAVPlayer_SCREEN_H ([[UIScreen mainScreen] bounds].size.height)
#define ZZAVPlayer_SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])

#define ZZAVPlayer_SCREEN_MAX_LENGTH (MAX(ZZAVPlayer_SCREEN_W, ZZAVPlayer_SCREEN_H))
#define ZZAVPlayer_SCREEN_MIN_LENGTH (MIN(ZZAVPlayer_SCREEN_W, ZZAVPlayer_SCREEN_H))

#define ZZAVPlayer_IS_IPHONE_XP ((ZZAVPlayer_IS_IPHONE_X==YES || ZZAVPlayer_IS_IPHONE_Xr ==YES || ZZAVPlayer_IS_IPHONE_Xs== YES || ZZAVPlayer_IS_IPHONE_Xs_Max== YES || ZZAVPlayer_IS_IPHONE_11 == YES || ZZAVPlayer_IS_IPHONE_11_Pro== YES || ZZAVPlayer_IS_IPHONE_11_Pro_Max== YES) ? YES : NO)

/// 导航栏高度
#define ZZAVPlayer_NAVIGATION_BAR_HEIGHT (ZZAVPlayer_IS_IPHONE_XP?88.0f:64.0f)
/// 状态栏高度
#define ZZAVPlayer_STATUS_BAR_HEIGHT (ZZAVPlayer_IS_IPHONE_XP?44:20.0f)
/// tabBar高度
#define ZZAVPlayer_TABBAR_BAR_HEIGHT (ZZAVPlayer_IS_IPHONE_XP?83.0f:49.0f)
/// 底部安全区域高度
#define ZZAVPlayer_Safe_HEIGHT (ZZAVPlayer_IS_IPHONE_XP? 34.0f:0.0f)

#endif /* ZZAVPlayerMacro_h */
