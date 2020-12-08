//
//  ZZAVPlayerMacro.h
//  Created  on 2020/5/31.
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
//判断iPhone 11 Pro Max
#define ZZAVPlayer_IS_IPHONE_11_Pro_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPhone 12 mini
#define ZZAVPlayer_IS_IPHONE_12_mini ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPhone 12
#define ZZAVPlayer_IS_IPHONE_12 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPhone 12 Pro
#define ZZAVPlayer_IS_IPHONE_12_Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)
//判断iPhone 12 Pro Max
#define ZZAVPlayer_IS_IPHONE_12_ProMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) && ZZAVPlayer_IS_IPHONE : NO)

/// 屏幕尺寸相关
#define ZZAVPlayer_SCREEN_W  ([[UIScreen mainScreen] bounds].size.width)
#define ZZAVPlayer_SCREEN_H ([[UIScreen mainScreen] bounds].size.height)
#define ZZAVPlayer_SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])

#define ZZAVPlayer_SCREEN_MAX_LENGTH (MAX(ZZAVPlayer_SCREEN_W, ZZAVPlayer_SCREEN_H))
#define ZZAVPlayer_SCREEN_MIN_LENGTH (MIN(ZZAVPlayer_SCREEN_W, ZZAVPlayer_SCREEN_H))

#define ZZAVPlayer_IS_IPHONE_XP ((ZZAVPlayer_IS_IPHONE_X==YES || ZZAVPlayer_IS_IPHONE_Xr ==YES || ZZAVPlayer_IS_IPHONE_Xs== YES || ZZAVPlayer_IS_IPHONE_Xs_Max== YES || ZZAVPlayer_IS_IPHONE_11 == YES || ZZAVPlayer_IS_IPHONE_11_Pro== YES || ZZAVPlayer_IS_IPHONE_11_Pro_Max== YES || ZZAVPlayer_IS_IPHONE_12_mini == YES || ZZAVPlayer_IS_IPHONE_12 == YES || ZZAVPlayer_IS_IPHONE_12_Pro == YES || ZZAVPlayer_IS_IPHONE_12_ProMax == YES) ? YES : NO)

/// 导航栏高度
#define ZZAVPlayer_NAVIGATION_HEIGHT (ZZAVPlayer_IS_IPHONE_XP?88.0f:64.0f)
/// 状态栏高度
#define ZZAVPlayer_STATUS_HEIGHT (ZZAVPlayer_IS_IPHONE_XP?44:20.0f)
/// tabBar高度
#define ZZAVPlayer_TABBAR_HEIGHT (ZZAVPlayer_IS_IPHONE_XP?83.0f:49.0f)
/// 底部安全区域高度
#define ZZAVPlayer_Safe_HEIGHT (ZZAVPlayer_IS_IPHONE_XP? 34.0f:0.0f)


/// 控件尺寸比例
#define ZZAVPlayer_Rate         (ZZAVPlayer_SCREEN_W/375.f)
/// 实际尺寸
#define ZZAVPlayer_SuitSize(size)  ZZAVPlayer_Rate * (size)
/// 实际宽度
#define KWidthEX(x)  [UIScreen mainScreen].bounds.size.width / 375.f * (x)
/// 实际高度
#define KHeightEX(y) [UIScreen mainScreen].bounds.size.height / 667.f * (y)

#ifdef DEBUG// 如果有DEBUG这个宏就编译下面一句代码
#define AVLog(...) NSLog(@"\n--------------\n| >> method  : %s \n| >> line    : %d\n| >> message : %@\n-------------->",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__]);
#else // 如果没有DEBUG这个宏就编译下面一句代码
#define AVLog(...)
#endif


/** 弱引用 */
#define WeakSelf __weak typeof(self) weakSelf = self;
/** 避免self的提前释放 */
#define StrongSelf __weak typeof(weakSelf) self = weakSelf;


#endif /* ZZAVPlayerMacro_h */
