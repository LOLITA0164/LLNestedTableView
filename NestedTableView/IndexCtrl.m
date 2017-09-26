//
//  IndexCtrl.m
//  NestedTableView
//
//  Created by LOLITA on 2017/9/20.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "IndexCtrl.h"
#import "FirstCtrl.h"
#import "SecondCtrl.h"
#import "ThirdCtrl.h"

@interface IndexCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic) UITableView *table;

@property (copy ,nonatomic) NSArray *datas;

@end

@implementation IndexCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"嵌套列表";
    
    [self.view addSubview:self.table];
}

-(NSArray *)datas{
    if (_datas==nil) {
        _datas =  @[
                    @[@"情况一",@"FirstCtrl"],
                    @[@"情况二",@"SecondCtrl"],
                    @[@"情况三",@"ThirdCtrl"]
                    ];
    }
    return _datas;
}


-(UITableView *)table{
    if (_table==nil) {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [UIView new];
    }
    return _table;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [self.datas[indexPath.row] firstObject];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = [self.datas[indexPath.row] firstObject];
    NSString *className = [self.datas[indexPath.row] lastObject];
    Class class = NSClassFromString(className);
    UIViewController *ctrl = [class new];
    ctrl.title = title;
    [self.navigationController pushViewController:ctrl animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
