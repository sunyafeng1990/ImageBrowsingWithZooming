//
//  CLAlbumImageNavigationBar.h
//  CLAlbumnCollectionPractice
//
//  Created by 王路 on 16/6/2.
//  Copyright © 2016年 王路. All rights reserved.
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
