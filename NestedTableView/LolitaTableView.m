//
//  LolitaTableView.m
//  NestedTableView
//
//  Created by LOLITA on 2017/9/19.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "LolitaTableView.h"

@interface LolitaTableView ()
@property (assign, nonatomic) BOOL canScroll;
@end

@implementation LolitaTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollStop:) name:kScrollStopNotificationName object:nil];
        self.canScroll = YES;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollStop:) name:kScrollStopNotificationName object:nil];
        self.canScroll = YES;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollStop:) name:kScrollStopNotificationName object:nil];
        self.canScroll = YES;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}


-(void)setType:(LolitaTableViewType)type{
    _type = type;
    self.canScroll = type==LolitaTableViewTypeSub?NO:YES;   // 子table默认不可滚动
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (self.type==LolitaTableViewTypeMain) {   // 主table类型的需要兼容手势
        return YES;
    }
    return NO;
}


- (void)setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    CGFloat y = contentOffset.y;
    if(self.type == LolitaTableViewTypeMain){   // main类型
        CGFloat stayPosition = self.tableHeaderView.frame.size.height;  // 默认停留的位置
        if ([self.delegate_StayPosition respondsToSelector:@selector(lolitaTableViewHeightForStayPosition:)]) {
            stayPosition = [self.delegate_StayPosition lolitaTableViewHeightForStayPosition:self];  // 获取到停留的位置
        }
        if(self.canScroll == YES){
            if(y > stayPosition){
                contentOffset.y = stayPosition;
                [super setContentOffset:contentOffset];
                self.canScroll = NO;
                // 发送通知，主类不可滚动
                [[NSNotificationCenter defaultCenter] postNotificationName:kScrollStopNotificationName object:self userInfo:nil];
            }else{ // main正常滚动
                [super setContentOffset:contentOffset];
            }
        }else{ // main禁止滚动
            contentOffset.y = stayPosition;
            [super setContentOffset:contentOffset];
        }
    }else if(self.type == LolitaTableViewTypeSub){ // sub类型
        if(self.canScroll == YES){
            if(y < 0){
                contentOffset.y = 0;
                [super setContentOffset:contentOffset];
                self.canScroll = NO;
                // 发送通知，子类不可滚动
                [[NSNotificationCenter defaultCenter] postNotificationName:kScrollStopNotificationName object:self userInfo:nil];
            }else{ // sub正常滚动
                [super setContentOffset:contentOffset];
            }
        }else{ // sub禁止滚动
            contentOffset.y = 0;
            [super setContentOffset:contentOffset];
        }
    }else{
        [super setContentOffset:contentOffset];
    }
}


- (void)scrollStop:(NSNotification *)notification{
    LolitaTableView *table = notification.object;
    // 把其他所有的sub都移动到顶部
    if (table.type == LolitaTableViewTypeSub && self.type == LolitaTableViewTypeSub) {
        [self setContentOffset:CGPointZero];
    }
    if(self != table){  // 发送通知的table和当前self不是同一个时，则需要滚动
        self.canScroll = YES;
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
