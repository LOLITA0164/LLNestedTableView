//
//  TitlesView.h
//  NestedTableView
//
//  Created by LOLITA on 2017/9/19.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitlesView : UIView

-(instancetype)initWithTitleArray:(NSArray *)titleArray;

-(void)setItemSelected: (NSInteger)column;

typedef void (^TitleClickBlock)(NSInteger);
@property (nonatomic, strong) TitleClickBlock titleClickBlock;  // 回调点击事件

@end
