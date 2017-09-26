//
//  FirstCtrl.m
//  NestedTableView
//
//  Created by LOLITA on 2017/9/20.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "FirstCtrl.h"
#import "LolitaTableView.h"
#import "SubTableView.h"

@interface FirstCtrl ()<UITableViewDelegate,UITableViewDataSource>
@property (strong ,nonatomic) LolitaTableView *mainTable;
@property (strong ,nonatomic) SubTableView *subTable;
@end

@implementation FirstCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.mainTable];
}

-(SubTableView *)subTable{
    if (_subTable==nil) {
        _subTable = [[SubTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    }
    return _subTable;
}

-(LolitaTableView *)mainTable{
    if (_mainTable==nil) {
        _mainTable = [[LolitaTableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.tableFooterView = [UIView new];
        _mainTable.type = LolitaTableViewTypeMain;
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
