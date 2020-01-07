//
//  ZZAVPlayerVC.h

//  Created by  on 2019/11/25.
//  Copyright © 2019 . All rights reserved.
//
/**
 ZZAVPlayerVC *vc = [[ZZAVPlayerVC alloc]init];
 vc.modalPresentationStyle = UIModalPresentationFullScreen;
 vc.fileArray = @[];
 [self presentViewController:vc animated:YES completion:^{}];
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZAVPlayerVC : UIViewController

@property(nonatomic,copy)NSString *fileName;
@property(nonatomic,copy)NSString *filePath;
@property(nonatomic,strong)NSMutableArray *fileArray;
@end

NS_ASSUME_NONNULL_END
