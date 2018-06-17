//
//  SubTableView.m
//  NestedTable
//
//  Created by LOLITA on 2017/9/19.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "SubTableView.h"

@implementation SubTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.table.frame = self.bounds;
        [self addSubview:self.table];
    }
    return self;
}


-(LolitaTableView *)table{
    if (_table==nil) {
        _table = [[LolitaTableView alloc] initWithFrame:CGRectZero];
        _table.delegate = self;
        _table.dataSource = self;
        _table.showsVerticalScrollIndicator = NO;
        _table.tableFooterView = [UIView new];
        _table.type = LolitaTableViewTypeSub;
    }
    return _table;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%u",arc4random_uniform(10000000)];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    label.text = [NSString stringWithFormat:@"子tableView的%ldsection",section];
    return (UIView*)label;
}



@end
