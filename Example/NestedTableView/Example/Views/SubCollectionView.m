//
//  SubCollectionView.m
//  NestedTableView
//
//  Created by LL on 2020/7/27.
//  Copyright © 2020 LOLITA0164. All rights reserved.
//

#import "SubCollectionView.h"

@implementation SubCollectionView 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionView.frame = self.bounds;
        [self addSubview:self.collectionView];
        self.backgroundColor = UIColor.whiteColor;
        self.collectionView.backgroundColor = UIColor.whiteColor;
    }
    return self;
}


- (LLNestedCollectionView *)collectionView {
    if (_collectionView==nil) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat item_w_h = (UIScreen.mainScreen.bounds.size.width - 5 * 20) / 4.0;
        layout.itemSize = CGSizeMake(item_w_h, item_w_h);
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        _collectionView = [[LLNestedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.collectionViewLayout = layout;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.typeNested = LLNestedScrollContainerTypeSub;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"UICollectionViewCell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    cell.backgroundColor = UIColor.groupTableViewBackgroundColor;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 20;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSString* tip = [NSString stringWithFormat:@"%u",arc4random_uniform(1000)];
    [cell.contentView addSubview:[self getLabel:tip frm:cell.bounds]];
    return cell;
}


-(UILabel*)getLabel:(NSString*)title frm:(CGRect)frame{
    UILabel* lb = [[UILabel alloc] initWithFrame:frame];
    lb.text = title;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:15];
    return lb;
}


@end
