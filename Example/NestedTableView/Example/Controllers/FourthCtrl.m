//
//  FourthCtrl.m
//  NestedTableView
//
//  Created by LL on 2020/7/27.
//  Copyright © 2020 LOLITA0164. All rights reserved.
//

#import "FourthCtrl.h"
#import "LLNestedTableView.h"
#import "SubCollectionView.h"
#import "SubTableView.h"
#import "TitlesView.h"
#define getRandomNumberFromAtoB(A,B) (int)(A+(arc4random()%(B-A+1)))
#define kNavBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44.0)
static CGFloat const kHeaderViewHeight = 50.0f;

@interface FourthCtrl () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet LLNestedTableView *mainTable;
@property (strong ,nonatomic) UIScrollView *contentView;
@property (strong ,nonatomic) TitlesView *titlesView;

@end

@implementation FourthCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainTable.typeNested = LLNestedScrollContainerTypeMain;
    _mainTable.contentInsetAdjustmentBehavior = NO;
    if (@available(iOS 15.0, *)) {
        _mainTable.sectionHeaderTopPadding = 0;
    }
    typeof(self) __weak ws = self;
    _mainTable.stayPosition = ^CGFloat() {
        return [ws.mainTable rectForSection:2].origin.y;
    };
    
    
    UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    footerView.textAlignment = NSTextAlignmentCenter;
    footerView.backgroundColor = [UIColor brownColor];
    footerView.text = @"我是主tableFooterView";
    _mainTable.tableFooterView = footerView;
}

-(UIScrollView *)contentView {
    if (_contentView == nil) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.mainTable.frame.size.height-kHeaderViewHeight-40);
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentView.contentSize = CGSizeMake(frame.size.width*2, frame.size.height);
        _contentView.pagingEnabled = YES;
        _contentView.bounces = YES;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.delegate = self;
        for (int i=0; i<2; i++) {
            if (i==0) {
                SubTableView *aSubTable = [[SubTableView alloc] initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
                [_contentView addSubview:aSubTable];
            }
            else {
                SubCollectionView *aSubCollection = [[SubCollectionView alloc] initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
                [_contentView addSubview:aSubCollection];
            }
        }
    }
    return _contentView;
}

-(TitlesView *)titlesView{
    if (_titlesView==nil) {
        _titlesView = [[TitlesView alloc] initWithTitleArray:@[@"列表视图",@"集合视图"]];
        __weak typeof(self) weakSelf = self;
        _titlesView.titleClickBlock = ^(NSInteger row){
            if (weakSelf.contentView) {
                weakSelf.contentView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width*row, 0);
            }
        };
    }
    return _titlesView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section<2) {
        return 4;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0||indexPath.section==1) {
        static NSString *cellId = @"cellId0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"我是主TableSection%ld",indexPath.section];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.contentView];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeaderViewHeight;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0||section==1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"section%ld头部",section];
        label.backgroundColor = UIColor.groupTableViewBackgroundColor;
        return (UIView*)label;
    }
    return self.titlesView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0||indexPath.section==1) {
        return 40;
    }
    return self.contentView.bounds.size.height;
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.contentView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger pageNum = offsetX/[UIScreen mainScreen].bounds.size.width;
        [self.titlesView setItemSelected:pageNum];
    }
}


// 控制多个容器之间同时滚动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.mainTable) {
        self.contentView.scrollEnabled = NO;
    }
    else if (scrollView == self.contentView) {
        self.mainTable.scrollEnabled = NO;
    }
    else {
        scrollView.scrollEnabled = YES;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.mainTable.scrollEnabled = YES;
    self.contentView.scrollEnabled = YES;
}

@end
