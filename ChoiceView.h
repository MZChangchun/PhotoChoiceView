//
//  ChoiceView.h
//  test
//
//  Created by Mr.Yang on 16/5/25.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZImageItem.h"

@interface ChoiceView : UIView

@property (nonatomic, strong)UICollectionView * collection;

@property (nonatomic, strong)NSMutableArray * array;
@property (nonatomic, weak)UIViewController * controller;
@property (nonatomic, assign)BOOL isFlower;
@property (nonatomic, strong)UILabel * title;

@property (nonatomic, copy)NSString * imageURL;

@property (nonatomic, assign)BOOL isXiuGai;

@property (nonatomic, assign)BOOL isDefault;

- (instancetype)initWithFrame:(CGRect)frame withController:(UIViewController *)controller;

@end
