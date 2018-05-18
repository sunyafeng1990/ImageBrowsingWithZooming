//
//  CLAlbumImageModel.h
//  CLAlbumnCollectionPractice
//
//  Created by 王路 on 16/5/31.
//  Copyright © 2016年 王路. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLAlbumImageTitleLabelType) {
    CLAlbumImageTitleLabelTypeNone,            // 不显示titleLabel
    CLAlbumImageTitleLabelTypeTop,             // 显示在顶端
    CLAlbumImageTitleLabelTypeBottom,          // 显示在底部
};

@interface CLAlbumImageModel : NSObject

/** 图片名称 */
@property(nonatomic, copy)NSString *imageName;

/** 图片的URL */
@property(nonatomic, copy)NSString *imageURL;

/** UIImage */
@property(nonatomic, strong)UIImage *image;

/** 标题内容 */
@property(nonatomic, copy)NSString *title;

/** titleLabel的显示样式 */
@property(nonatomic, assign)CLAlbumImageTitleLabelType titleLabelType;

@end
