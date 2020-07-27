//
//  FirstCtrl.m
//  NestedTableView
//
//  Created by LOLITA on 2017/9/20.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "FirstCtrl.h"
#import "LLNestedTableView.h"
#import "SubTableView.h"

#define kNavBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44.0)

@interface FirstCtrl ()<UITableViewDelegate,UITableViewDataSource>
@property (strong ,nonatomic) LLNestedTableView *mainTable;
@property (strong ,nonatomic) SubTableView *subTable;
@end

@implementation FirstCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.mainTable];
}

-(SubTableView *)subTable{
    if (_subTable==nil) {
        _subTable = [[SubTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-kNavBarHeight)];
    }
    return _subTable;
}

-(LLNestedTableView *)mainTable{
    if (_mainTable==nil) {
        _mainTable = [[LLNestedTableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kNavBarHeight)];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.tableFooterView = [UIView new];
        _mainTable.typeNested = LLNestedScrollContainerTypeMain;
        typeof(self) __weak ws = self;
        _mainTable.stayPosition = ^CGFloat() {
            return ws.mainTable.tableHeaderView.frame.size.height;
        };
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        headerView.text = @"我是主tableHeaderView";
        headerView.textAlignment = NSTextAlignmentCenter;
        headerView.backgroundColor = [UIColor yellowColor];
        _mainTable.tableHeaderView = headerView;
    }
    return _mainTable;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell addSubview:self.subTable];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.subTable.frame.size.height;
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
