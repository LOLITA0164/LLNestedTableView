//
//  SubView.m
//  NestedTableView
//
//  Created by LOLITA on 2017/9/19.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import "SubView.h"
#import "SubTableView.h"

@implementation SubView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentView.contentSize = CGSizeMake(frame.size.width*3, frame.size.height);
        _contentView.pagingEnabled = YES;
        _contentView.bounces = YES;
        _contentView.delegate = self;
        _contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentView];
        
        for (int i=0; i<3; i++) {
            SubTableView *aSubTable = [[SubTableView alloc] initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
            [_contentView addSubview:aSubTable];
        }
        
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pageNum = offsetX/[UIScreen mainScreen].bounds.size.width;
    if (self.scrollEventBlock) {
        self.scrollEventBlock(pageNum);
    }
}

@end
