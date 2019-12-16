//
//  SubTableView.h
//  NestedTable
//
//  Created by LOLITA on 2017/9/19.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LLNestedTableView.h"
#define getRandomNumberFromAtoB(A,B) (int)(A+(arc4random()%(B-A+1)))

@interface SubTableView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic) LLNestedTableView *table;

@end
