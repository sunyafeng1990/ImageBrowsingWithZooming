//
//  PhotosCollectionViewCell.m
//  DownloadPictureTest
//
//  Created by lemo on 2018/5/18.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import "PhotosCollectionViewCell.h"
@implementation PhotosCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self.contentView addSubview:self.icon];
    
  }
  return self;
}

-(UIImageView *)icon{
  if (!_icon) {
    _icon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _icon.userInteractionEnabled=YES;
    _icon.contentMode=UIViewContentModeScaleAspectFill;
    _icon.layer.cornerRadius=5;
    _icon.layer.masksToBounds=YES;
    
  }
  return _icon;
}

@end
