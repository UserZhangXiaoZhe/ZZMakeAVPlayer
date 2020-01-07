//
//  ZZAVPlayerVideoListView.m

//  Created by  on 2020/1/7.
//  Copyright © 2020 . All rights reserved.
//

#import "ZZAVPlayerVideoListView.h"
#import "ZZAVPlayerViewConfiguration.h"

@interface ZZAVPlayerVideoListView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *menuTableView;

@property(nonatomic, strong) NSArray *imageArr;

@end

@implementation ZZAVPlayerVideoListView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}

- (void)dealloc{
    
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

#pragma mark - Private methods
-(void)setupSubview{
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    [self addSubview:self.menuTableView];
}

#pragma mark - public methods


#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*myCell = @"BookHomeFolderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = UIColor.clearColor;
    
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.textLabel.text = dict[ZZKEY_VIDEONAME];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = UIColor.whiteColor;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(didSelectWithVideoListView:type:)]) {
        [self.delegate didSelectWithVideoListView:self type:indexPath.row];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - Getters and Setters
- (UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 54, self.frame.size.height) style:UITableViewStylePlain];
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _menuTableView.backgroundColor = [UIColor clearColor];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.showsVerticalScrollIndicator = NO;
        _menuTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //关闭自动适应，防止最顶部留白
        _menuTableView.estimatedRowHeight = 0;
        _menuTableView.estimatedSectionHeaderHeight = 0;
        _menuTableView.estimatedSectionFooterHeight = 0;
        _menuTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _menuTableView.scrollEnabled = YES;
        _menuTableView.tableFooterView = [[UIView alloc] init];
    }
    return _menuTableView;
}


@end
