//
//  LolitaTableView.h
//  NestedTableView
//
//  Created by LOLITA on 2017/9/19.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kScrollStopNotificationName = @"scrollStop"; // 滚动停止通知

typedef NS_ENUM(NSInteger , LolitaTableViewType) {
    LolitaTableViewTypeMain,
    LolitaTableViewTypeSub
};

@protocol LolitaTableViewDelegate;

@interface LolitaTableView : UITableView

@property (assign, nonatomic) LolitaTableViewType type;

@property (nonatomic,weak) id <LolitaTableViewDelegate> delegate_StayPosition;

@end



@protocol LolitaTableViewDelegate <NSObject>

@required
-(CGFloat)lolitaTableViewHeightForStayPosition:(LolitaTableView*)tableView; // 悬停的位置

@end
