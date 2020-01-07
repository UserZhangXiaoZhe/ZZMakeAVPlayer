//
//  ZZAVPlayTypeView.h

//  Created by  on 2020/1/6.
//  Copyright © 2020 . All rights reserved.
//

/**
 说明：播放循环方式
*/

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class ZZAVPlayTypeView;
@protocol ZZAVPlayTypeViewDelegate <NSObject>

@optional
- (void)didSelectWithTypeView:(ZZAVPlayTypeView *_Nullable)popView type:(NSInteger )type;

@end


@interface ZZAVPlayTypeView : UIView

@property (nonatomic, weak) id<ZZAVPlayTypeViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
