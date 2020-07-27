//
//  SubCollectionView.h
//  NestedTableView
//
//  Created by LL on 2020/7/27.
//  Copyright © 2020 LOLITA0164. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLNestedCollectionView.h"
#define getRandomNumberFromAtoB(A,B) (int)(A+(arc4random()%(B-A+1)))

@interface SubCollectionView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong ,nonatomic) LLNestedCollectionView *collectionView;

@end

