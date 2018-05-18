//
//  CLAlbumImageNavigationBar.m
//  CLAlbumnCollectionPractice
//
//  Created by lemo on 2018/5/17.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import "CLAlbumImageNavigationBar.h"
#import "CLAlbumImageNavigationBarBackButton.h"

@interface CLAlbumImageNavigationBar ()
/** 返回按钮 */
@property(nonatomic, strong)CLAlbumImageNavigationBarBackButton *backButton;

/** 图片位置展示的label */
@property(nonatomic, strong)UILabel *indexLabel;

@end

@implementation CLAlbumImageNavigationBar

#pragma mark - -重写系统的方法

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 默认配置
        [self defaultConfigure];
        [self setupSubViews];
        
    }
    return self;
}
- (CGFloat)fixNumberInAllIPhonePro6WithNumber:(CGFloat)number{
  if (IS_IPHONE_6) {
    return number;
  }else if (IS_IPHONE_4){
    return 480.0 * number / 667.0;
  }else if (IS_IPHONE_5){
    return 568.0 * number / 667.0;
  }else{
    return 736.0 * number / 667.0;
  }
  
}
- (void)layoutSubviews{
    CGFloat y           = 20;
  if (IS_IPHONE_X) {
    y = 35;
  }
    CGFloat h           = self.frame.size.height - y;
    CGFloat backBtnX    = 15;
    CGFloat backBtnW    =  [self fixNumberInAllIPhonePro6WithNumber:50];
    //  左边按钮的frame
    _backButton.frame   = CGRectMake(backBtnX, y, backBtnW, h);
    
    CGFloat indexLabelW = 100;
//    CGFloat indexLabelX = CGRectGetMaxX(_backButton.frame);
    CGFloat indexLabelX = self.frame.size.width / 2 - indexLabelW / 2;
    //  中间label的frame
    _indexLabel.frame   = CGRectMake(indexLabelX, y, indexLabelW, h);
    
    CGFloat doneBtnW    = h;
    CGFloat doneBtnX    = self.frame.size.width - doneBtnW;
    //  右边按钮的frame
    _doneButton.frame = CGRectMake(doneBtnX, y, doneBtnW, h);
}

#pragma mark setter
- (void)setSum:(NSInteger)sum{
    _sum = sum;
    NSInteger currentIndex = _currentIndex ? _currentIndex : 0;
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", currentIndex, _sum];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex + 1;
    NSInteger sum = _sum ? _sum : -1;
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex, sum];
}

#pragma mark 私有方法
// 创建子视图 （返回按钮 + 图片位置 + 完成/删除按钮）
- (void)setupSubViews{
//    返回按钮
    _backButton = [CLAlbumImageNavigationBarBackButton buttonWithType:UIButtonTypeCustom];
    _backButton.imageView.contentMode   = UIViewContentModeCenter;
    _backButton.titleLabel.font         = [UIFont systemFontOfSize:14];
    [_backButton setImage:[UIImage imageNamed:@"common_nav_btn_return"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self addSubview:_backButton];
    
//    当前图片位置展示
    _indexLabel                 = [[UILabel alloc]init];
    _indexLabel.textColor       = [UIColor whiteColor];
    _indexLabel.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:_indexLabel];
    
//    完成按钮展示
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton setImage:[UIImage imageNamed:@"图片删除"] forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_doneButton];
}

- (void)defaultConfigure{
    // 打开用户交互
    self.userInteractionEnabled = YES;
}

// 点击返回按钮
- (void)clickBackButton:(UIButton *)sender{
    if (self.backButtonBlock) {
        self.backButtonBlock(_currentIndex);
    }
}

// 点击确定按钮
- (void)clickDoneButton:(UIButton *)sender{
    if (self.donButtonBlock) {
        self.donButtonBlock(_currentIndex);
    }
}

#pragma mark 公有方法
+(CGFloat)fixedHeight{
  
  if (IS_IPHONE_X) {
    return 83;
  }
  return 64;
}


@end
