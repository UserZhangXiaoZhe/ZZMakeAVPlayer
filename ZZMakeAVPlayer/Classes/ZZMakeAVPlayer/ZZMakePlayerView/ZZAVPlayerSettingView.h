//
//  ZZAVPlayerSettingView.h

//  Created by  on 2020/1/7.
//  Copyright © 2020 . All rights reserved.
//

/**
 说明：
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZAVPlayerSettingView;
@protocol ZZAVPlayerSettingViewDelegate <NSObject>

@optional

@end


@interface ZZAVPlayerSettingView : UIView

@property (nonatomic, weak) id<ZZAVPlayerSettingViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
