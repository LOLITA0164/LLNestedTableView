//
//  ThirdCtrl.m
//  NestedTableView
//
//  Created by LOLITA on 2017/9/20.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "ThirdCtrl.h"
#import "LLNestedTableView.h"
#import "SubView.h"
#import "TitlesView.h"
#define getRandomNumberFromAtoB(A,B) (int)(A+(arc4random()%(B-A+1)))
#define kNavBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44.0)
static CGFloat const kHeaderViewHeight = 50.0f;

@interface ThirdCtrl ()<UITableViewDelegate,UITableViewDataSource>
@property (strong ,nonatomic) LLNestedTableView *mainTable;
@property (strong ,nonatomic) SubView *subView;
@property (strong ,nonatomic) TitlesView *titlesView;
@end

@implementation ThirdCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTable.contentInsetAdjustmentBehavior = NO;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.mainTable];
}

-(SubView *)subView{
    if (_subView==nil) {
        _subView = [[SubView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.mainTable.frame.size.height-kHeaderViewHeight-40)];
        _subView.contentView.delegate = self;
    }
    return _subView;
}

-(TitlesView *)titlesView{
    if (_titlesView==nil) {
        _titlesView = [[TitlesView alloc] initWithTitleArray:@[@"列表0",@"列表1",@"列表2"]];
        __weak typeof(self) weakSelf = self;
        _titlesView.titleClickBlock = ^(NSInteger row){
            if (weakSelf.subView.contentView) {
                weakSelf.subView.contentView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width*row, 0);
            }
        };
    }
    return _titlesView;
}


-(LLNestedTableView *)mainTable{
    if (_mainTable==nil) {
        _mainTable = [[LLNestedTableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kNavBarHeight) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.tableFooterView = [UIView new];
        _mainTable.showsVerticalScrollIndicator = NO;
        _mainTable.typeNested = LLNestedScrollContainerTypeMain;
        _mainTable.contentInsetAdjustmentBehavior = NO;
        if (@available(iOS 15.0, *)) {
            _mainTable.sectionHeaderTopPadding = 0;
        }
        typeof(self) __weak ws = self;
        _mainTable.stayPosition = ^CGFloat() {
            return [ws.mainTable rectForSection:2].origin.y;
        };
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        headerView.text = @"我是主tableHeaderView";
        headerView.textAlignment = NSTextAlignmentCenter;
        headerView.backgroundColor = [UIColor yellowColor];
        _mainTable.tableHeaderView = headerView;
        UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        footerView.textAlignment = NSTextAlignmentCenter;
        footerView.backgroundColor = [UIColor brownColor];
        footerView.text = @"我是主tableFooterView";
        _mainTable.tableFooterView = footerView;
    }
    return _mainTable;
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
        [cell.contentView addSubview:self.subView];
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
    return self.subView.bounds.size.height;
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.subView.contentView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger pageNum = offsetX/[UIScreen mainScreen].bounds.size.width;
        [self.titlesView setItemSelected:pageNum];
    }
}


// 控制多个容器之间同时滚动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.mainTable) {
        self.subView.contentView.scrollEnabled = NO;
    }
    else if (scrollView == self.subView.contentView) {
        self.mainTable.scrollEnabled = NO;
    }
    else {
        scrollView.scrollEnabled = YES;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.mainTable.scrollEnabled = YES;
    self.subView.contentView.scrollEnabled = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
