//
//  CLPersonalImageAlubumCollectionViewCell.m
//  ImageBrowsingWithZoom
//
//  Created by lemo on 2018/5/18.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import "CLPersonalImageAlubumCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface CLPersonalImageAlubumCollectionViewCell ()

/** 用来显示图片 */
@property(nonatomic, strong)UIImageView *imageView;

@end

@implementation CLPersonalImageAlubumCollectionViewCell

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            //  创建子视图
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews{
        //  布局子视图
    _imageView.frame = self.contentView.bounds;
}

#pragma mark - setter
- (void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}

- (void)setImageURL:(NSString *)imageURL{
    _imageURL = imageURL;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageURL] placeholderImage:[UIImage imageNamed:@"默认头像"]];
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    _imageView.image = [UIImage imageNamed:_imageName];
}

@end
