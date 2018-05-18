//
//  CLAlbumImageCollectionViewCell.h
//  CLAlbumnCollectionPractice
//
//  Created by 王路 on 16/5/31.
//  Copyright © 2016年 王路. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLAlbumImageModel;


@interface CLAlbumImageCollectionViewCell : UICollectionViewCell

/* 往期放生才显示的下载按钮 */
@property(nonatomic,strong)UIButton *downloadBtn;
/* 往期放生才显示的制作相册按钮*/
@property(nonatomic,strong)UIButton *makeBtn;

/** 数据源model */
@property(nonatomic, strong)CLAlbumImageModel *model;

/** 用来展示图片的imageView */
@property(nonatomic, strong)UIImageView *CLImageView;

@property(nonatomic,strong)UIScrollView *scrollView;

@end
