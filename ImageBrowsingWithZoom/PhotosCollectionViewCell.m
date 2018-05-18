//
//  PhotosCollectionViewCell.m
//  DownloadPictureTest
//
//  Created by lemo on 2018/3/20.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import "PhotosCollectionViewCell.h"
#import "UIView+SDAutoLayout.h"
@implementation PhotosCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    self.userInteractionEnabled=YES;
    [self.contentView addSubview:self.icon];
    
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.markImg];
    
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.isDownloadIcon];
    
  }
  return self;
}
- (UIImageView *)isDownloadIcon
{
  if (!_isDownloadIcon) {
    _isDownloadIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,68*WScreenWidth,66*WScreenWidth)];
    _isDownloadIcon.image = [UIImage imageNamed:@"已下载"];
    _isDownloadIcon.hidden = YES;
  }
  return _isDownloadIcon;
}
-(UIImageView *)icon{
  if (!_icon) {
    _icon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _icon.image=[UIImage imageNamed:@"xiaoxi_img_wuxiaoxitishi"];
    _icon.layer.cornerRadius=5;
    _icon.userInteractionEnabled=YES;
    _icon.layer.masksToBounds=YES;
    _icon.contentMode=UIViewContentModeScaleAspectFill;
    
    
  }
  return _icon;
}
-(UIView *)bgView{
  if (!_bgView) {
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-22, self.bounds.size.width, 23)];
    _bgView.backgroundColor=kAppThemeColor;
    _bgView.alpha=0.3;
    _bgView.userInteractionEnabled=YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds      byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft  cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    _bgView.layer.mask = maskLayer;
  }
  return _bgView;
}
-(UIImageView *)markImg{
  
  if (!_markImg) {
    _markImg=[[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width-18)/2,self.bgView.top+(22-10)/2 , 18, 10)];
    _markImg.image=[UIImage imageNamed:@"未选中提示icon"];
    _markImg.contentMode=UIViewContentModeScaleAspectFit;
    _markImg.userInteractionEnabled=YES;
  }
  return _markImg;
  
}
-(UIProgressView *)progressView
{
  if (!_progressView) {
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0,self.bounds.size.height -3,self.bounds.size.width ,3)];
    _progressView.progressViewStyle = UIProgressViewStyleDefault;
    _progressView.progressTintColor = [UIColor colorWithHexString:@"#a48d2a"];
    _progressView.progress  = 0.0f;
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    _progressView.hidden = YES;
  }
  return _progressView;
}
@end
