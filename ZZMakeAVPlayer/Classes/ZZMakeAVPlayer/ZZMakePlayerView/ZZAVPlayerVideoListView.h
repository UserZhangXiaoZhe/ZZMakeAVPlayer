//
//  ZZAVPlayerVideoListView.h

//  Created by  on 2020/1/7.
//  Copyright © 2020 . All rights reserved.
//

/**
 说明：视频播放列表
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZAVPlayerVideoListView;
@protocol ZZAVPlayerVideoListViewDelegate <NSObject>

@optional
- (void)didSelectWithVideoListView:(ZZAVPlayerVideoListView *_Nullable)popView type:(NSInteger )type;

@end


@interface ZZAVPlayerVideoListView : UIView

@property (nonatomic, weak) id<ZZAVPlayerVideoListViewDelegate> delegate;

@property(nonatomic, strong) NSArray *dataArr;
@end

NS_ASSUME_NONNULL_END
