//
//  LLNestedTableView.h
//  LLToolbox_Example
//
//  Created by 骆亮 on 2019/12/12.
//  Copyright © 2019 LOLITA0164. All rights reserved.
//

/*
 解决列表联动的问题
 */

#import <UIKit/UIKit.h>

static NSString *const LLNestedTableViewStopNotification = @"LLNestedTableViewStop"; // 滚动停止通知

typedef NS_ENUM(NSInteger , LLNestedTableViewType) {
    LLNestedTableViewTypeNormal, //该类型和 UITableView 一致，未做其他设置
    LLNestedTableViewTypeMain, //主列表的类型
    LLNestedTableViewTypeSub //子列表的类型
};

@protocol LLNestedTableViewProtocol;
@interface LLNestedTableView : UITableView
/// 列表是否可滚动
@property (assign, nonatomic, readonly) BOOL canScroll;
/// 联动的标识，主从列表需要设置为一致（可选），为了防止多个页面联动列表之间的错乱通知问题
@property (assign, nonatomic) NSString* flag;
/// 当前列表的类型
@property (assign, nonatomic) LLNestedTableViewType typeNested;
/// 嵌套列表代理
@property (weak, nonatomic) id <LLNestedTableViewProtocol> delegateNested;
@end



@protocol LLNestedTableViewProtocol <NSObject>
@required
/// 列表悬停的位置
-(CGFloat)llNestedTableViewStayPosition:(LLNestedTableView*)tableView;
@end
