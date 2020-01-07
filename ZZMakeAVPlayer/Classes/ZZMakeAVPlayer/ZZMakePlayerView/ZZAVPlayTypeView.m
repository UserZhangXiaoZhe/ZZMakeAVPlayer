//
//  ZZAVPlayTypeView.m

//  Created by  on 2020/1/6.
//  Copyright © 2020 . All rights reserved.
//

#import "ZZAVPlayTypeView.h"

@interface ZZAVPlayTypeView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *menuTableView;
@property(nonatomic, strong) NSArray *dataArr;
@property(nonatomic, strong) NSArray *imageArr;

@end

@implementation ZZAVPlayTypeView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
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
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = UIColor.whiteColor;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(didSelectWithTypeView:type:)]) {
        [self.delegate didSelectWithTypeView:self type:indexPath.row];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size.height * 0.9/self.dataArr.count;
}

#pragma mark - Getters and Setters
- (UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.2, 0, self.frame.size.width*0.6, self.frame.size.height) style:UITableViewStylePlain];
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
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"单次播放",@"重复播放",@"顺序播放",@"随机播放",@"循环播放"];
    }
    return _dataArr;
}
-(NSArray *)imageArr{
    if (!_imageArr) {
        _imageArr = @[@"bookshelf_setView_sel",@"bookshelf_sort_sel",@"bookshelf_history_sel",@"bookshelf_upload_sel",@"bookshelf_history_sel"];
    }
    return _imageArr;
}

@end
