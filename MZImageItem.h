//
//  MZImageItem.h
//  test
//
//  Created by Mr.Yang on 16/5/25.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MZImageItem : NSObject

@property (nonatomic, strong)UIImage * image;//存储从相册中获取的uiimage
@property (nonatomic, assign)BOOL isPlaceHolder; //是否是站位图片

@end
