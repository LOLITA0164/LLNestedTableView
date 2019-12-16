//
//  TitlesView.m
//  NestedTableView
//
//  Created by LOLITA on 2017/9/19.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "TitlesView.h"
@interface TitlesView()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleBtnArray;
@property (nonatomic, strong) UIView  *indicateLine;

@end

@implementation TitlesView

-(instancetype)initWithTitleArray:(NSArray *)titleArray{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _titleArray = titleArray;
        _titleBtnArray = [NSMutableArray array];
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        self.backgroundColor = [UIColor cyanColor];
        CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width/titleArray.count;
        
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, 50)];
            [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
            if (i==0) {
                [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:btn];
            [_titleBtnArray addObject:btn];
        }
        
        _indicateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50-1, btnWidth, 1)];
        _indicateLine.backgroundColor = [UIColor blueColor];
        [self addSubview:_indicateLine];
    }
    return self;
}

-(void)clickBtn : (UIButton *)btn{
    NSInteger tag = btn.tag;
    [self setItemSelected:tag];
    if (self.titleClickBlock) {
        self.titleClickBlock(tag);
    }
}

-(void)setItemSelected: (NSInteger)column{
    for (int i=0; i<_titleBtnArray.count; i++) {
        UIButton *btn = _titleBtnArray[i];
        if (i==column) {
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width/_titleBtnArray.count;
    _indicateLine.frame = CGRectMake(btnWidth*column, 50-1, btnWidth, 1);
}

@end
