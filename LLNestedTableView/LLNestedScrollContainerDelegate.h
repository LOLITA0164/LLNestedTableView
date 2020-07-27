//
//  LLNestedScrollContainerDelegate.h
//  Demo
//
//  Created by LL on 2020/7/27.
//  Copyright © 2020 LL. All rights reserved.
//

#import <Foundation/Foundation.h>

// 滚动停止通知
static NSString *const LLNestedScrollContainerStopNotification = @"LLNestedScrollContainerStop";

typedef NS_ENUM(NSInteger , LLNestedScrollContainerType) {
    LLNestedScrollContainerTypeNormal,
    LLNestedScrollContainerTypeMain, //主类型
    LLNestedScrollContainerTypeSub //子类型
};

@protocol LLNestedScrollContainerDelegate <NSObject>
/// 列表是否可滚动
@property (assign, nonatomic) BOOL canScroll;
/// 联动的标识，主从列表需要设置为一致（可选），为了防止多个页面联动列表之间的错乱通知问题
@property (assign, nonatomic) NSString* flag;
/// 当前列表的类型
@property (assign, nonatomic) LLNestedScrollContainerType typeNested;
/// 悬停位置，main类型使用
@property (copy, nonatomic) CGFloat(^stayPosition)(void);
@end


