//
//  LLNestedTableView.m
//  LLToolbox_Example
//
//  Created by 骆亮 on 2019/12/12.
//  Copyright © 2019 LOLITA0164. All rights reserved.
//

#import "LLNestedTableView.h"
@interface LLNestedTableView ()
/// 列表是否可滚动
@property (assign, nonatomic, readwrite) BOOL canScroll;
@end
@implementation LLNestedTableView

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

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
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
    [NSNotificationCenter.defaultCenter addObserverForName:LLNestedTableViewStopNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        
        // 这里触发手动控制主从列表的滚动与否
        LLNestedTableView* table = note.object;
        if (self.typeNested == LLNestedTableViewTypeNormal ||
            ![table isKindOfClass:UITableView.class]||
            (self.flag.length && ![self.flag isEqualToString:table.flag]))
        { return; }
        
        
        // 当发送通知方和当前对象不一致，则表示当前对象需要开启滚动
        if (self != table) { self.canScroll = YES; }
        
        // 把其他所有的sub都移动到顶部,除去主的，其他table皆不能滚动
        if (table.typeNested == LLNestedTableViewTypeSub && self.typeNested == LLNestedTableViewTypeSub) {
            [self setContentOffset:CGPointZero];
            self.canScroll = NO;
        }
        
    }];
    

    // KVO 的方式实现联动
//    [self addKVO];
}

-(void)setTypeNested:(LLNestedTableViewType)typeNested{
    _typeNested = typeNested;
    // sub 类型的默认不能滚动
    self.canScroll = typeNested == LLNestedTableViewTypeSub ? NO : YES;
}


/// 向下传递手势，触发主列表的滚动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (self.typeNested == LLNestedTableViewTypeMain) {   // 主table类型的需要兼容手势
        return YES;
    }
    return NO;
}



/// 重写，参与滚动事件
-(void)setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    if (self.typeNested == LLNestedTableViewTypeNormal) {
        return; // 普通类型不做修改
    }
    CGFloat y = contentOffset.y;
    switch (self.typeNested) {

            // 主列表类型
        case LLNestedTableViewTypeMain:
        {
            CGFloat stayPosition = 0;
            // 获取到停留的位置
            if ([self.delegateNested respondsToSelector:@selector(llNestedTableViewStayPosition:)]) {
                stayPosition = [self.delegateNested llNestedTableViewStayPosition:self];
            }
            if (self.canScroll) {
                // 当主列表滚动位置超过预设时，我们发出通知，让子列表不能滚动
                if (y > stayPosition) {
                    contentOffset.y = stayPosition;
                    [super setContentOffset:contentOffset];
                    self.canScroll = NO;
                    [NSNotificationCenter.defaultCenter postNotificationName:LLNestedTableViewStopNotification object:self];
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
        case LLNestedTableViewTypeSub:
        {
            if (self.canScroll) {
                // 当子列表被下拉到最初位置时，我们让其“停止”，并发送通知，让主列表可以滚动
                if (y < 0) {
                    [super setContentOffset:CGPointZero];
                    self.canScroll = NO;
                    [NSNotificationCenter.defaultCenter postNotificationName:LLNestedTableViewStopNotification object:self];
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
//    [self removeObserver:self forKeyPath:@"contentOffset"];
}


















#pragma mark - kVO 的方式
-(void)addKVO{
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    if (![object isKindOfClass:LLNestedTableView.class]) {return;}
    
    CGPoint point = [[self valueForKey:@"contentOffset"] CGPointValue];
    if (self.typeNested == LLNestedTableViewTypeNormal) {
        return; // 普通类型不做修改
    }
    switch (self.typeNested) {
            
            // 主列表类型
        case LLNestedTableViewTypeMain:
        {
            CGFloat stayPosition = 0;
            // 获取到停留的位置
            if ([self.delegateNested respondsToSelector:@selector(llNestedTableViewStayPosition:)]) {
                stayPosition = [self.delegateNested llNestedTableViewStayPosition:self];
            }
            if (self.canScroll) {
                // 当主列表滚动位置超过预设时，我们发出通知，让子列表不能滚动
                if (point.y > stayPosition) {
                    [self setContentOffset:CGPointMake(point.x, stayPosition)];
                    self.canScroll = NO;
                    [NSNotificationCenter.defaultCenter postNotificationName:LLNestedTableViewStopNotification object:self];
                }
            } else {
                // 让其“停止”在预设位置
                [self setContentOffset:CGPointMake(point.x, stayPosition) animated:NO];
            }
            
        }
            break;
            
            // 子列表类型
        case LLNestedTableViewTypeSub:
        {
            if (self.canScroll) {
                // 当子列表被下拉到最初位置时，我们让其“停止”，并发送通知，让主列表可以滚动
                if (point.y < 0) {
                    [self setContentOffset:CGPointZero];
                    self.canScroll = NO;
                    [NSNotificationCenter.defaultCenter postNotificationName:LLNestedTableViewStopNotification object:self];
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



@end
