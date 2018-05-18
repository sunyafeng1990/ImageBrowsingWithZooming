//
//  CLAlbumImageCollectionViewCell.h
//  CLAlbumnCollectionPractice
//
//  Created by lemo on 2018/5/17.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLAlbumImageModel;


@interface CLAlbumImageCollectionViewCell : UICollectionViewCell


/** 数据源model */
@property(nonatomic, strong)CLAlbumImageModel *model;

/** 用来展示图片的imageView */
@property(nonatomic, strong)UIImageView *CLImageView;

@property(nonatomic,strong)UIScrollView *scrollView;

@end
