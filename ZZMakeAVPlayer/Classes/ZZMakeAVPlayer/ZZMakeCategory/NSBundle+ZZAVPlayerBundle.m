//
//  NSBundle+ZZAVPlayerBundle.m

//  Created by  on 2020/1/7.
//

#import "NSBundle+ZZAVPlayerBundle.h"
#import "ZZAVPlayerView.h"

@implementation NSBundle (ZZAVPlayerBundle)

+ (NSURL *)zzAVPlayerResourcesBundleURL {
    //先获取framework 的 bundle
    NSBundle *bundle = [NSBundle bundleForClass:[ZZAVPlayerView class]];
    return [bundle URLForResource:@"ZZMakePlayerResources" withExtension:@"bundle"];
}

+ (instancetype)getCurrentBundle {
    //再获取我们自己手动创建的bundle
    return [self bundleWithURL:[self zzAVPlayerResourcesBundleURL]];
}

@end
