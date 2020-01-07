//
//  UIImage+ZZAVPlayerImage.m

//  Created by  on 2020/1/7.
//

#import "UIImage+ZZAVPlayerImage.h"
#import "NSBundle+ZZAVPlayerBundle.h"

@implementation UIImage (ZZAVPlayerImage)
+ (UIImage *)getImageWithNamed:(NSString *)imageName{

    NSString *realName = [NSString stringWithFormat:@"%@@2x",imageName];
    
    NSString *path = [[NSBundle getCurrentBundle] pathForResource:realName ofType:@"png"];
    
    UIImage *loadingImage = [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return loadingImage;
}
@end
