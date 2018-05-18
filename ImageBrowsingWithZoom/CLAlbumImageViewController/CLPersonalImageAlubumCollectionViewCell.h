//
//  CLPersonalImageAlubumCollectionViewCell.h
//  ImageBrowsingWithZoom
//
//  Created by lemo on 2018/5/18.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLPersonalImageAlubumCollectionViewCell : UICollectionViewCell
/** 图片的URL */
@property(nonatomic, copy)NSString *imageURL;

/** 图片名 */
@property(nonatomic, copy)NSString *imageName;

/** 图片Image */
@property(nonatomic, strong)UIImage *image;
@end
