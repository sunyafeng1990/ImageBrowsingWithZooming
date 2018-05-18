//
//  CLAlbumImageViewController.h
//  CLAlbumnCollectionPractice
//
//  Created by 王路 on 16/5/31.
//  Copyright © 2016年 王路. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^downloadBlock)(NSInteger index);
typedef void(^MakePhotoBlock)(void);
@interface CLAlbumImageViewController : UIViewController

/** 点击下载按钮的回调 */
@property(nonatomic,copy)downloadBlock block;
/** 点击制作相册的回调 */
@property(nonatomic,copy)MakePhotoBlock makePhotoBlock;
/** 图片 -- 存放的是UIImage */
@property(nonatomic, strong)NSMutableArray<UIImage *> *images;

/** 图片 -- 存放的是URL字符串 */
@property(nonatomic, strong)NSMutableArray<NSString *> *imageURLs;

/** 图片 -- 存放的是ImageName字符串 */
@property(nonatomic, strong)NSMutableArray<NSString *> *imageNames;

/** 存放在每个imageView上的title */
@property(nonatomic, strong)NSMutableArray<NSString *> *imageTitles;

/** 存放在相册上的title */
@property(nonatomic, copy)NSString *albumTitle;

/** 是否无线轮播 */
@property(nonatomic, assign)BOOL isInfinity;

/** 滑动时是否自动隐藏自定义navigationBar */
@property(nonatomic, assign)BOOL isAutoHiddenBar;

/** 是否隐藏自定义navigationBar右边的按钮 */
@property(nonatomic, assign)BOOL isHiddenRightBarButton;

/** 当前图片的位置 */
@property(nonatomic, assign)NSInteger currentIndex;



/** 自定义navigationBar左边按钮的回调 */
@property(nonatomic, strong)void (^leftBarButtonBlock)(CLAlbumImageViewController *controller, NSInteger index);

/** 自定义navigationBar右边按钮的回调 */
@property(nonatomic, strong)void (^rightBarButtonBlock) (CLAlbumImageViewController *controller, NSInteger index);

/**
 *  自定义初始化方法
 *
 *  @param title         标题
 *  @param originalIndex 初始位置
 *  @param isInfinity    是否无限轮播
 */
- (instancetype)initWithTitle:(NSString *)title OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity;

// 暂时不用
- (instancetype)initWithFrame:(CGRect)frame OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity;

/**
 *  租租里面用的，点击图片进入浏览图片模式，模仿微信
 *
 *  @param target        从哪个控制器过来的
 *  @param title         标题
 *  @param originalIndex 初始位置
 *  @param isInfinity    是否需要无限轮播
 *  @param imageViews    所有的imageView，这个参数是为了点击动画
 */
- (void)showCLAlbumWithTarget:(__kindof UIViewController *)target Title:(NSString *)title OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity WithImageViews:(NSArray<UIImageView *> *)imageViews WithDelImageViewAction:(void (^) (NSInteger index))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger index))backImageViewBlock;

+ (void)showCLAlbumWithTarget:(__kindof UIViewController *)target title:(NSString *)title originalIndex:(NSInteger)originalIndex isInfinity:(BOOL)isInfinity imageUrls:(NSArray<NSString *> *)imageUrls WithDelImageViewAction:(void (^)(NSInteger))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger))backImageViewBlock;

//- (void)showCLAlbumWithTarget:(__kindof UIViewController *)target Title:(NSString *)title OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity WithSuperView:(__kindof UIView *)view WithIndexs:(NSArray<NSNumber *> *)indexs WithDelImageViewAction:(void (^)(NSInteger index))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger index))backImageViewBlock;

/**
 *  点击图片进入浏览图片模式 可删除
 *
 *  @param target             target
 *  @param title              标题
 *  @param originalIndex      初始位置
 *  @param isInfinity         是否需要轮播
 *  @param imageViews         所有的imageView,这个参数是为了点击动画
 *  @param delImageViewBlock  删除图片之后的操作
 *  @param backImageViewBlock 返回后的操作
 *  @param reloadView         如果删除了图片，刷新数据源要在这边进行，否则有bug
 */
+ (void)showCLAlbumWithTarget:(__kindof UIViewController *)target Title:(NSString *)title OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity WithImage:(NSArray<UIImage *> *)imageViews WithDelImageViewAction:(void (^) (NSInteger index))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger index))backImageViewBlock WithReloadView:(void (^)())reloadView;


+ (void)showCLAlbumWithTarget:(__kindof UIViewController *)target Title:(NSString *)title OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity WithImageViews:(NSArray<UIImage *> *)imageViews WithDelImageViewAction:(void (^) (NSInteger index))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger index))backImageViewBlock WithReloadView:(void (^)())reloadView;

+ (void)showCLAlbumWithTarget:(__kindof UIViewController *)target title:(NSString *)title originalIndex:(NSInteger)originalIndex isInfinity:(BOOL)isInfinity images:(NSArray<NSString *> *)images deleteBlock:(void (^) (NSInteger index))deleteBlock backBlock:(void (^)(NSInteger index))backBlock reloadBlock:(void (^)())reloadBlock;

- (void)syf_showCLAlbumWithTarget:(__kindof UIViewController *)target title:(NSString *)title originalIndex:(NSInteger)originalIndex isInfinity:(BOOL)isInfinity imageUrls:(NSArray<NSString *> *)imageUrls WithDelImageViewAction:(void (^)(NSInteger))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger))backImageViewBlock;


@end
