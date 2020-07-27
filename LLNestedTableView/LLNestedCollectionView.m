//
//  LLNestedCollectionView.m
//  Demo
//
//  Created by LL on 2020/7/27.
//  Copyright © 2020 LL. All rights reserved.
//

#import "LLNestedCollectionView.h"

@implementation LLNestedCollectionView
@synthesize canScroll = _canScroll;
@synthesize flag = _flag;
@synthesize typeNested = _typeNested;
@synthesize stayPosition = _stayPosition;

-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
    // 默认都可以滚动
    self.canScroll = YES;
    self.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    // 监听列表滚动的通知
    [NSNotificationCenter.defaultCenter addObserverForName:LLNestedScrollContainerStopNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        
        // 这里触发手动控制主从列表的滚动与否
        UIView <LLNestedScrollContainerDelegate> * obj = note.object;
        if (self.typeNested == LLNestedScrollContainerTypeNormal ||
            (self.flag.length && ![self.flag isEqualToString:obj.flag]))
        { return; }
        
        
        // 当发送通知方和当前对象不一致，则表示当前对象需要开启滚动
        if (self != obj) { self.canScroll = YES; }
        
        // 把其他所有的sub都移动到顶部,除去主的，其他table皆不能滚动
        if (obj.typeNested == LLNestedScrollContainerTypeSub && self.typeNested == LLNestedScrollContainerTypeSub) {
            [self setContentOffset:CGPointZero];
            self.canScroll = NO;
        }
        
    }];
}

-(void)setTypeNested:(LLNestedScrollContainerType)typeNested{
    _typeNested = typeNested;
    // sub 类型的默认不能滚动
    self.canScroll = typeNested == LLNestedScrollContainerTypeSub ? NO : YES;
}


/// 向下传递手势，触发主列表的滚动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (self.typeNested == LLNestedScrollContainerTypeMain) {   // 主table类型的需要兼容手势
        return YES;
    }
    return NO;
}



/// 重写，参与滚动事件
-(void)setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    if (self.typeNested == LLNestedScrollContainerTypeNormal) {
        return; // 普通类型不做修改
    }
    CGFloat y = contentOffset.y;
    switch (self.typeNested) {

            // 主列表类型
        case LLNestedScrollContainerTypeMain:
        {
            CGFloat stayPosition = self.stayPosition();
            if (self.canScroll) {
                // 当主列表滚动位置超过预设时，我们发出通知，让子列表不能滚动
                if (y > stayPosition) {
                    contentOffset.y = stayPosition;
                    [super setContentOffset:contentOffset];
                    self.canScroll = NO;
                    [NSNotificationCenter.defaultCenter postNotificationName:LLNestedScrollContainerStopNotification object:self];
                } else {
                    [super setContentOffset:contentOffset];
                }
            } else {
                contentOffset.y = stayPosition; // 让其“停止”在预设位置，取消动画，否则会因为时间差一直循环
                [super setContentOffset:contentOffset animated:NO];
            }

        }
            break;

            // 子列表类型
        case LLNestedScrollContainerTypeSub:
        {
            if (self.canScroll) {
                // 当子列表被下拉到最初位置时，我们让其“停止”，并发送通知，让主列表可以滚动
                if (y < 0) {
                    [super setContentOffset:CGPointZero];
                    self.canScroll = NO;
                    [NSNotificationCenter.defaultCenter postNotificationName:LLNestedScrollContainerStopNotification object:self];
                } else {
                    [super setContentOffset:contentOffset];
                }
            } else {
                [super setContentOffset:CGPointZero];
            }
        }
            break;
        default:
            break;
    }
}


-(void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}







@end
