//
//  CLAlbumView.h
//  CLAlbumnCollectionPractice
//
//  Created by lemo on 2018/5/17.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLAlbumView : UIView

/** 图片 -- 存放的是UIImage */
@property(nonatomic, strong)NSArray<UIImage *> *images;

/** 图片 -- 存放的是URL字符串 */
@property(nonatomic, strong)NSArray<NSString *> *imageURLs;

/** 图片 -- 存放的是ImageName字符串 */
@property(nonatomic, strong)NSArray<NSString *> *imageNames;

/** 当前图片位置 */
@property(nonatomic, assign)NSInteger currentIndex;

/** 点击事件的回调 */
@property(nonatomic, strong)void (^tapImageViewBlock) (NSInteger index);

/**
 *  自定义初始化方法
 *
 *  @param frame         布局
 *  @param originalIndex 初始位置
 *  @param isInfinity    是否无限轮播
 *
 */
- (instancetype)initWithFrame:(CGRect)frame OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity;


@end
