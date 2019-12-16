//
//  SubView.h
//  NestedTableView
//
//  Created by LOLITA on 2017/9/19.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubView : UIView<UIScrollViewDelegate>

@property (strong ,nonatomic) UIScrollView *contentView;

typedef void (^contentViewScrollEvent)(NSInteger);
@property (nonatomic, strong) contentViewScrollEvent scrollEventBlock;  // 回调点击事件

@end
