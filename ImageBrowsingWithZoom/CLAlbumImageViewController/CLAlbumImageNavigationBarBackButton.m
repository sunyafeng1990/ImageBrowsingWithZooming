//
//  CLAlbumImageNavigationBarBackButton.m
//  CLAlbumnCollectionPractice
//
//  Created by lemo on 2018/5/17.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import "CLAlbumImageNavigationBarBackButton.h"

#define KImageW 13

@implementation CLAlbumImageNavigationBarBackButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = KImageW;
    CGFloat h = contentRect.size.height;
    return CGRectMake(x, y, w, h);
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x = KImageW + 3;
    CGFloat y = 0;
    CGFloat w = contentRect.size.width - KImageW;
    CGFloat h = contentRect.size.height;
    return CGRectMake(x, y, w, h);
}

@end
