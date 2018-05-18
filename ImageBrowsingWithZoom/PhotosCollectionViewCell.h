//
//  PhotosCollectionViewCell.h
//  DownloadPictureTest
//
//  Created by lemo on 2018/3/20.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UIImageView *markImg;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *isDownloadIcon;
@property(nonatomic,strong)UIProgressView *progressView;
@end
