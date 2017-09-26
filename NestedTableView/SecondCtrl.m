//
//  SecondCtrl.m
//  NestedTableView
//
//  Created by LOLITA on 2017/9/20.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "SecondCtrl.h"
#import "LolitaTableView.h"
#import "SubTableView.h"

@interface SecondCtrl ()<UITableViewDelegate,UITableViewDataSource,LolitaTableViewDelegate>
@property (strong ,nonatomic) LolitaTableView *mainTable;
@property (strong ,nonatomic) SubTableView *subTable;
@end

@implementation SecondCtrl

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
        _mainTable.delegate_StayPosition = self;
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
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<4) {
        static NSString *cellId = @"cellId0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"我是主TableCell%ld",indexPath.section];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.subTable];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<4) {
        return 44;
    }
    return self.subTable.frame.size.height;
}


// !!!: 悬停的位置
-(CGFloat)lolitaTableViewHeightForStayPosition:(LolitaTableView *)tableView{
    return [tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]].origin.y;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

