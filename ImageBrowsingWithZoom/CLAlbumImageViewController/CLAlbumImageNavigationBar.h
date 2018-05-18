//
//  CLAlbumImageNavigationBar.h
//  CLAlbumnCollectionPractice
//
//  Created by lemo on 2018/5/17.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLAlbumImageNavigationBar : UIView

/** 返回按钮的回调 */
@property(nonatomic, copy)void (^backButtonBlock) (NSInteger index);

/** 确定按钮的回调 */
@property(nonatomic, copy)void (^donButtonBlock) (NSInteger index);

/** 总共多少张图片 */
@property(nonatomic, assign)NSInteger sum;

/** 当前图片的位置 */
@property(nonatomic, assign)NSInteger currentIndex;

/** 右边按钮，对这个按钮的操作比较多，所以放到外面 */
@property(nonatomic, strong)UIButton *doneButton;

+ (CGFloat)fixedHeight;

@end
