//
//  CLAlbumImageNavigationBarBackButton.m
//  CLAlbumnCollectionPractice
//
//  Created by 虞昌杰 on 16/6/10.
//  Copyright © 2016年 王路. All rights reserved.
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
