//
//  ZZAVPlayerURLSession.m
//  Created  on 2020/12/7.
//

#import "ZZAVPlayerURLSession.h"
#import <AVFoundation/AVFoundation.h>

@interface ZZAVPlayerURLSession ()
<AVAssetResourceLoaderDelegate>


@end



@implementation ZZAVPlayerURLSession

#pragma mark - AVAssetResourceLoaderDelegate
-(BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    return YES;
}
@end
