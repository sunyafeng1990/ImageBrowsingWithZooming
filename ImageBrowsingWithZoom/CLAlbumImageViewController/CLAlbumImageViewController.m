//
//  CLAlbumImageViewController.m
//  CLAlbumnCollectionPractice
//
//  Created by lemo on 2018/5/17.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//


#import "CLAlbumImageViewController.h"
#import "CLAlbumImageModel.h"
#import "CLAlbumImageCollectionViewCell.h"
#import "CLAlbumImageNavigationBar.h"

static NSString *const cellReuse = @"CLAlbumImageCollectionViewCell";
static const CGFloat maxRepeatCount = 1000;
static const NSTimeInterval animationTime = 0.5;

@interface CLAlbumImageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

/** 用collection来展示图片 */
@property(nonatomic, strong)UICollectionView *CLCollectionView;

/** 当前图片的indexPath */
@property(nonatomic, strong)NSIndexPath* currentIndexPath;

/** 相册的title展示 */
@property(nonatomic, strong)UITextView *albumTitleView;

/** 自定义的navigationBar */
@property(nonatomic, strong)CLAlbumImageNavigationBar *albumImageBar;

/** 数据源 */
@property(nonatomic, strong)NSMutableArray<CLAlbumImageModel *> *models;

/** 状态栏状态 */
@property(nonatomic, assign)BOOL isBarHidden;


@end

@implementation CLAlbumImageViewController

#pragma mark setter
- (void)setIsInfinity:(BOOL)isInfinity{
    //  默认是无限循环的，如果不无限循环，则collectionView只有一个section
    _isInfinity = isInfinity;
    //  无限滚动时，默认滑动位置是中间
    if ((_imageNames.count >= 2 || _images.count >= 2 || _imageURLs.count >= 2) && _isInfinity) {
        [_CLCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:maxRepeatCount / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    [_CLCollectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if ((_imageNames.count >= 2 || _images.count >= 2 || _imageURLs.count >= 2) && _isInfinity) {
        [_CLCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:maxRepeatCount / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }else{
        [_CLCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    _albumImageBar.currentIndex = _currentIndex;
}

- (void)setIsHiddenRightBarButton:(BOOL)isHiddenRightBarButton{
    _isHiddenRightBarButton = isHiddenRightBarButton;
    if (_albumImageBar) {
        _albumImageBar.doneButton.hidden = _isHiddenRightBarButton;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController) {
        self.navigationController.navigationBar.hidden = YES;
    }
    
}
- (void)dealloc
{
    NSLog(@"==============销毁控制器%s",__FUNCTION__);

}
#pragma mark 重写系统的方法
- (void)viewDidLoad {
    [super viewDidLoad];
  
    //  状态栏的格式 白色 如果状态栏不显示，需要修改plist文件中的View controller-based status bar appearance 设为NO
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   //    给数据源赋值
    [self initDataSource];
    //    创建子视图
    [self setupSubViews];
    //  初始化设置
    [self defaultConfigure];
}
- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (self.navigationController) {
        self.navigationController.navigationBar.hidden = NO;
    }
}
#pragma mark —— 私有方法
- (void)defaultConfigure{
    //  如果给的初始位置过大，默认给最后面的一个照片
    if (_models.count < _currentIndex + 1 && _models && _currentIndex) {
        _currentIndex = _models.count - 1;
    }
    //  初始位置
    [self setCurrentIndex:_currentIndex];
    //  默认状态栏是不显示的，因为切换的时候是先取反
    _isBarHidden        = NO;
    self.view.userInteractionEnabled = YES;
}

- (void)setupSubViews{
    __weak CLAlbumImageViewController *weakSelf = self;
    //    创建Layout
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize                     = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);                      //  item的size
    layout.minimumInteritemSpacing      = 0;                //  最小间距
    layout.minimumLineSpacing           = 0;                //  最小间距
    
    layout.scrollDirection              = UICollectionViewScrollDirectionHorizontal;
    //    创建collectionView
    _CLCollectionView                   = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    _CLCollectionView.delegate          = self;
    _CLCollectionView.dataSource        = self;
    _CLCollectionView.pagingEnabled     = YES;              //  每次滑动一个屏幕的宽度
    _CLCollectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_CLCollectionView];
    
    //  给scrollView添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    [_CLCollectionView addGestureRecognizer:tap];
    
    //    注册自定义的cell
    [_CLCollectionView registerClass:[CLAlbumImageCollectionViewCell class] forCellWithReuseIdentifier:cellReuse];
    
    //  自定义navigationBar
    _albumImageBar                      = [[CLAlbumImageNavigationBar alloc]init];
    _albumImageBar.frame                = CGRectMake(0, 0, self.view.frame.size.width, [CLAlbumImageNavigationBar fixedHeight]);

    _albumImageBar.sum                  = _models.count;            //  最大照片数量
    _albumImageBar.currentIndex         = _currentIndex;        //  当前照片的位置
    _albumImageBar.backgroundColor      = [[UIColor blackColor] colorWithAlphaComponent:0.5];      //  bar的颜色
    _albumImageBar.doneButton.hidden    = _isHiddenRightBarButton;  // 是否隐藏右边按钮
    _albumImageBar.backButtonBlock      = ^void(NSInteger index){   //  返回按钮回调
        if (weakSelf.leftBarButtonBlock) {
            weakSelf.leftBarButtonBlock(weakSelf, index - 1);
        }
    };
    _albumImageBar.donButtonBlock       = ^void(NSInteger index){   //  确定按钮的回调
        if (weakSelf.rightBarButtonBlock) {
            weakSelf.rightBarButtonBlock(weakSelf, index - 1);
        }
    };
    [self.view addSubview:_albumImageBar];
    
    [self.view bringSubviewToFront:_albumTitleView];
}

- (void)initDataSource{
    _models = [NSMutableArray arrayWithCapacity:0];
    //    给imageView的图片赋值
    if (_imageNames) {
        for (int i = 0; i < _imageNames.count; i++) {
            CLAlbumImageModel *model = [[CLAlbumImageModel alloc]init];
            model.imageName = _imageNames[i];
            [_models addObject:model];
        }
    }else if (_imageURLs){
        for (int i = 0; i < _imageURLs.count; i++) {
            CLAlbumImageModel *model = [[CLAlbumImageModel alloc]init];
            model.imageURL = _imageURLs[i];
            [_models addObject:model];
        }
    }else if (_images){
        for (int i = 0; i < _images.count; i++) {
            CLAlbumImageModel *model = [[CLAlbumImageModel alloc]init];
            model.image = _images[i];
            [_models addObject:model];
        }
    }
    //    给imageView上的title赋值
    if (_imageTitles && _models.count > 0) {
        for (int i = 0; i < _models.count; i++) {
            CLAlbumImageModel *model = _models[i];
            model.title = _imageTitles[i];
        }
    }
    
    //    给整个相册的title赋值
    if (_albumTitle) {
        CGFloat font = 16;
      
      CGRect rect = [_albumTitle boundingRectWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil];
  
        _albumTitleView                     = [[UITextView alloc]init];
        _albumTitleView.font   = [UIFont systemFontOfSize:font];        //  字体大小
        _albumTitleView.textColor           = [UIColor whiteColor];     //  字体白色
        _albumTitleView.backgroundColor     = [[UIColor blackColor] colorWithAlphaComponent:0.5];                               //  背景颜色
        _albumTitleView.text                = _albumTitle;              //  标题内容
        _albumTitleView.editable            = NO;                       //  textView不可编辑
        
        
        CGFloat labelX          = self.view.frame.origin.x;
        CGFloat labelW          = self.view.frame.size.width;
        CGFloat labelH          = rect.size.height + 20;
        CGFloat labelY  = self.view.frame.size.height - labelH;
        _albumTitleView.frame  = CGRectMake(labelX, labelY, labelW, labelH);
        [self.view addSubview:_albumTitleView];
    }
}
- (void)setIsBarHidden:(BOOL)isBarHidden{
    _isBarHidden = isBarHidden;
    CGFloat font = 16;
    CGRect rect = [_albumTitle boundingRectWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil];
    CGFloat labelH = rect.size.height + 20;
   CGFloat  labelY = self.view.frame.size.height - labelH;
  
    if (isBarHidden) {
        //  隐藏自定义的navigationBar
        [UIView animateWithDuration:animationTime animations:^{
            CGRect frame = _albumImageBar.frame;

            frame.origin.y = -([CLAlbumImageNavigationBar fixedHeight] + 20);
            _albumImageBar.frame  = frame;
        }];
        //  隐藏titleTextView
        [UIView animateWithDuration:animationTime animations:^{
            CGRect frame = _albumTitleView.frame;
         
            frame.origin.y = labelY + labelH;
         
            _albumTitleView.frame = frame;
        }];
        //  隐藏状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
    }else{
        //  还原自定义navigationBar的初始位置
        [UIView animateWithDuration:animationTime animations:^{
            CGRect frame = _albumImageBar.frame;

              frame.origin.y = 0;
            _albumImageBar.frame = frame;
        }];
        //  还原titleTextView的初始位置
        [UIView animateWithDuration:animationTime animations:^{
            CGRect frame = _albumTitleView.frame;
            frame.origin.y = labelY;
            _albumTitleView.frame = frame;
        }];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 150ull * NSEC_PER_MSEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            //  显示状态栏
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        });
    }
}
//  轻拍手势
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    self.isBarHidden = !_isBarHidden;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CLAlbumImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuse forIndexPath:indexPath];
    CLAlbumImageModel *model = _models[indexPath.row];
    cell.model = model;
    cell.scrollView.tag  = indexPath.row;
    cell.CLImageView.tag = indexPath.row;

    self.currentIndexPath = indexPath;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_isInfinity) {
        return maxRepeatCount;
    }else{
        return 1;
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentImageIndex = (NSInteger)((scrollView.contentOffset.x + (self.view.frame.size.width / 2.0)) / self.view.frame.size.width) % _models.count;
    _currentIndex = currentImageIndex;
    _albumImageBar.currentIndex = _currentIndex;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //  开始滑动就隐藏状态栏
    if (!_isBarHidden && _isAutoHiddenBar) {
        self.isBarHidden  = !_isBarHidden;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //  无线滚动时，如果滚动的位置超过了2/3，就自动返回中间位置
    if (scrollView.contentOffset.x > (maxRepeatCount * 2 / 3.0) * _CLCollectionView.frame.size.width * _models.count) {
        if (_imageNames.count > 2 || _images.count > 2 || _imageURLs.count > 2) {
            [_CLCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:maxRepeatCount / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
          
        }
    }
#pragma mark  - -将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
  int autualIndex = scrollView.contentOffset.x  / _CLCollectionView.bounds.size.width;
  for (UIView *view in scrollView.subviews) {
    if ([view isKindOfClass:[CLAlbumImageCollectionViewCell class]]) {
      CLAlbumImageCollectionViewCell * cell = (CLAlbumImageCollectionViewCell *)view;
      if (cell.CLImageView.tag != autualIndex) {
         cell.scrollView.zoomScale = 1.0;
      }
    }
    
  }
  
  
}

#pragma mark - 公有方法
- (instancetype)initWithTitle:(NSString *)title OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity
{
    self = [super init];
    if (self) {
        //  给属性赋初值
        _currentIndex   = originalIndex;            //  初始位置
        _isInfinity     = isInfinity;               //  是否无限轮播
        _albumTitle     = title;                    //  标题内容
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity{
    self = [super init];
    if (self) {
        //  给属性赋初值
        _currentIndex = originalIndex;
        _isInfinity = isInfinity;
    }
    return self;
}

- (void)showCLAlbumWithTarget:(__kindof UIViewController *)target Title:(NSString *)title OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity WithImageViews:(NSArray<UIImageView *> *)imageViews WithDelImageViewAction:(void (^)(NSInteger))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger))backImageViewBlock{
    
    NSLog(@"Method : %s, Line : %d, imageviews = %@", __FUNCTION__, __LINE__, imageViews);
    __block NSMutableArray<UIImageView *> *imageViewArray = [imageViews mutableCopy];
    
    __block CLAlbumImageViewController *albumVC = [[CLAlbumImageViewController alloc]initWithTitle:title OriginalIndex:originalIndex IsInfinity:isInfinity];
    
    // 将所有的frame记录下来
    NSMutableArray<NSArray *> *frameArray = [NSMutableArray arrayWithCapacity:imageViewArray.count];
    [imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frameWithView = imageView.frame;
        CGRect frameWithTarget = [imageView convertRect:imageView.bounds toView:target.view];
        NSArray *temp = @[[NSValue valueWithCGRect:frameWithView], [NSValue valueWithCGRect:frameWithTarget]];
        [frameArray addObject:temp];
    }];
    
    albumVC.isAutoHiddenBar = YES;
    //  记录下第一个imageView的frame，如果删除到最后一个，自动退出图片浏览
    UIImageView *firstImageView = imageViews[0];
    __block CGRect firstFrame = [firstImageView convertRect:firstImageView.bounds toView:target.view];
    //  创建一个临时数组，获取到所有的ImageView
    NSMutableArray<UIImage *> *temp = [NSMutableArray arrayWithCapacity:0];
    
    [imageViewArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        [temp addObject:imageView.image];
    }];
    albumVC.images = [temp mutableCopy];
    
    //  获取到点击的imageView
    __block __block UIImageView *imageView = imageViewArray[originalIndex];
    
    //  另外创建一个临时的imageView覆盖住这个imageView
    __block __block UIImageView *tempImageView = [UIImageView new];
    tempImageView.image = imageView.image;
    CGRect frame = [imageView convertRect:imageView.bounds toView:target.view];
    tempImageView.frame = CGRectMake(frame.origin.x, frame.origin.y + 62, frame.size.width, frame.size.height);
    tempImageView.backgroundColor = [UIColor blackColor];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    
    //  给临时的ImageView添加动画
    [UIView animateWithDuration:animationTime animations:^{
        tempImageView.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        [target presentViewController:albumVC animated:NO completion:^{
            [tempImageView removeFromSuperview];
        }];
    }];
    
    
    if (delImageViewBlock) {
        //  给右边的删除按钮添加方法
        albumVC.rightBarButtonBlock = ^void(CLAlbumImageViewController *controller, NSInteger index){
            controller.isHiddenRightBarButton = NO;
            //  先删除相册中的imageView
            [controller.models removeObjectAtIndex:index];
            controller.currentIndex = index - 1 < 0 ? 0 : index - 1;
            controller.albumImageBar.sum --;
            //  如果相册中的imageView的数量为0，则自动退出图片浏览
            if (controller.models.count <= 0) {
                tempImageView.image = nil;
                tempImageView.frame = [UIScreen mainScreen].bounds;
                [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
                [controller dismissViewControllerAnimated:NO completion:^{
                    [UIView animateWithDuration:animationTime animations:^{
                        tempImageView.frame = CGRectMake(firstFrame.origin.x, firstFrame.origin.y + 62, firstFrame.size.width, firstFrame.size.height);
                    } completion:^(BOOL finished) {
                        [tempImageView removeFromSuperview];
                    }];
                }];
            }
            
            //  再刷新相册中的数据源
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.currentIndexPath.section];
            [controller.CLCollectionView reloadSections:indexSet];
//            //  再将删除的哪一个图片传出去，让外面的相册也刷新数据源
//            delImageViewBlock(index);
            //  删除设置动画用的imageView数组中对应的imageView
            [imageViewArray removeObjectAtIndex:index];
            if (delImageViewBlock) {
                //  再将删除的哪一个图片传出去，让外面的相册也刷新数据源
                delImageViewBlock(index);
            }
        };
    }else{
        albumVC.isHiddenRightBarButton = YES;
    }
    
    // 给左边的返回按钮添加方法
    albumVC.leftBarButtonBlock = ^void (CLAlbumImageViewController *controller, NSInteger index){
        // 将返回的图片的位置传出去
        if (backImageViewBlock) {
            backImageViewBlock(index);
        }
//        NSLog(@"Method : %s, Line : %d, imageViewArray.count = %ld, index = %ld", __FUNCTION__, __LINE__, imageViewArray.count, index);
        NSLog(@"Method : %s, Line : %d, imageViewArray = %@", __FUNCTION__, __LINE__, imageViewArray);
        //  获取到返回时的正在显示的imageView
        imageView = imageViewArray[index];
        NSLog(@"Method : %s, Line : %d, imageView.x = %.2f, imageView.y = %.2f, imageView.w = %.2f, imageView.h = %.2f", __FUNCTION__, __LINE__, imageView.bounds.origin.x, imageView.bounds.origin.y, imageView.bounds.size.width, imageView.bounds.size.height);
        tempImageView.image = imageView.image;
        tempImageView.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
        
        [controller dismissViewControllerAnimated:NO completion:^{
            [UIView animateWithDuration:animationTime animations:^{
                CGRect frame = [imageView convertRect:imageView.bounds toView:target.view];
                NSLog(@"Method : %s, Line : %d, imageView.x = %.2f, imageView.y = %.2f, imageView.w = %.2f, imageView.h = %.2f", __FUNCTION__, __LINE__, imageView.bounds.origin.x, imageView.bounds.origin.y, imageView.bounds.size.width, imageView.bounds.size.height);
                NSLog(@"Method : %s, Line : %d, x = %.2f, y = %.2f, w = %.2f, h = %.2f", __FUNCTION__, __LINE__, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
                tempImageView.frame = CGRectMake(frame.origin.x, frame.origin.y + 62, frame.size.width, frame.size.height);
            } completion:^(BOOL finished) {
                [tempImageView removeFromSuperview];
            }];
        }];
    };
}



//传递图片字符
+ (void)showCLAlbumWithTarget:(__kindof UIViewController *)target title:(NSString *)title originalIndex:(NSInteger)originalIndex isInfinity:(BOOL)isInfinity imageUrls:(NSArray<NSString *> *)imageUrls WithDelImageViewAction:(void (^)(NSInteger))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger))backImageViewBlock{
    
    __block NSMutableArray<NSString *> *imageViewArray = [imageUrls mutableCopy];
    
    CLAlbumImageViewController *albumVC = [[CLAlbumImageViewController alloc]initWithTitle:title OriginalIndex:originalIndex IsInfinity:isInfinity];
    @WXLWeakObj(albumVC);

    albumVC.isAutoHiddenBar = YES;

    albumVC.imageURLs = [imageUrls copy];
    [target presentViewController:albumVC animated:YES completion:nil];
    if (delImageViewBlock) {
        albumVC.rightBarButtonBlock = ^void(CLAlbumImageViewController *controller, NSInteger index){
            controller.isHiddenRightBarButton = NO;
            [controller.models removeObjectAtIndex:index];
            controller.currentIndex = index - 1 < 0 ? 0 : index - 1;
            controller.albumImageBar.sum --;
            if (controller.models.count <= 0) {
                [controller dismissViewControllerAnimated:YES completion:nil];
            }
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:albumVCWeak.currentIndexPath.section];
            [controller.CLCollectionView reloadSections:indexSet];
            [imageViewArray removeObjectAtIndex:index];
            if (delImageViewBlock) {
                delImageViewBlock(index);
            }
        };
    }else{
        albumVC.isHiddenRightBarButton = YES;
    }

    albumVC.leftBarButtonBlock = ^void (CLAlbumImageViewController *controller, NSInteger index){
        if (backImageViewBlock) {
            backImageViewBlock(index);
        }
        [controller dismissViewControllerAnimated:YES completion:nil];
    };
}


- (void)showCLAlbumWithTarget:(__kindof UIViewController *)target Title:(NSString *)title OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity WithSuperView:(__kindof UIView *)view WithIndexs:(NSArray<NSNumber *> *)indexs WithDelImageViewAction:(void (^)(NSInteger))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger))backImageViewBlock{
    NSMutableArray *imageViews = [view.subviews mutableCopy];
    for (int i = 0; i < indexs.count; i++) {
        [imageViews removeObjectAtIndex:[indexs[i] integerValue]];
    }
    __block NSMutableArray<UIImageView *> *imageViewArray = [imageViews mutableCopy];
    
    __block CLAlbumImageViewController *albumVC = [[CLAlbumImageViewController alloc]initWithTitle:title OriginalIndex:originalIndex IsInfinity:isInfinity];
    
    // 将所有的frame记录下来
    NSMutableArray<NSArray *> *frameArray = [NSMutableArray arrayWithCapacity:imageViewArray.count];
    [imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frameWithView = imageView.frame;
        CGRect frameWithTarget = [imageView convertRect:imageView.bounds toView:target.view];
        NSArray *temp = @[[NSValue valueWithCGRect:frameWithView], [NSValue valueWithCGRect:frameWithTarget]];
        [frameArray addObject:temp];
    }];
    
    albumVC.isAutoHiddenBar = YES;
    //  记录下第一个imageView的frame，如果删除到最后一个，自动退出图片浏览
    UIImageView *firstImageView = imageViews[0];
    __block CGRect firstFrame = [firstImageView convertRect:firstImageView.bounds toView:target.view];
    //  创建一个临时数组，获取到所有的ImageView
    NSMutableArray<UIImage *> *temp = [NSMutableArray arrayWithCapacity:0];
    
    [imageViewArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        [temp addObject:imageView.image];
    }];
    albumVC.images = [temp mutableCopy];
    
    //  获取到点击的imageView
    __block __block UIImageView *imageView = imageViewArray[originalIndex];
    
    //  另外创建一个临时的imageView覆盖住这个imageView
    __block __block UIImageView *tempImageView = [UIImageView new];
    tempImageView.image = imageView.image;
    CGRect frame = [imageView convertRect:imageView.bounds toView:target.view];
    tempImageView.frame = CGRectMake(frame.origin.x, frame.origin.y + 62, frame.size.width, frame.size.height);
    tempImageView.backgroundColor = [UIColor blackColor];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    
    //  给临时的ImageView添加动画
    [UIView animateWithDuration:animationTime animations:^{
        tempImageView.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        [target presentViewController:albumVC animated:NO completion:^{
            [tempImageView removeFromSuperview];
        }];
    }];
    
    
    if (delImageViewBlock) {
        //  给右边的删除按钮添加方法
        albumVC.rightBarButtonBlock = ^void(CLAlbumImageViewController *controller, NSInteger index){
            controller.isHiddenRightBarButton = NO;
            //  先删除相册中的imageView
            [controller.models removeObjectAtIndex:index];
            controller.currentIndex = index - 1 < 0 ? 0 : index - 1;
            controller.albumImageBar.sum --;
            //  如果相册中的imageView的数量为0，则自动退出图片浏览
            if (controller.models.count <= 0) {
                tempImageView.image = nil;
                tempImageView.frame = [UIScreen mainScreen].bounds;
                [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
                [controller dismissViewControllerAnimated:NO completion:^{
                    [UIView animateWithDuration:animationTime animations:^{
                        tempImageView.frame = CGRectMake(firstFrame.origin.x, firstFrame.origin.y + 62, firstFrame.size.width, firstFrame.size.height);
                    } completion:^(BOOL finished) {
                        [tempImageView removeFromSuperview];
                    }];
                }];
            }
            
            //  再刷新相册中的数据源
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.currentIndexPath.section];
            [controller.CLCollectionView reloadSections:indexSet];
            // 再将删除的哪一个图片传出去，让外面的相册也刷新数据源
            //   delImageViewBlock(index);
            //  删除设置动画用的imageView数组中对应的imageView
            [imageViewArray removeObjectAtIndex:index];
            if (delImageViewBlock) {
                //  再将删除的哪一个图片传出去，让外面的相册也刷新数据源
                delImageViewBlock(index);
            }
        };
    }else{
        albumVC.isHiddenRightBarButton = YES;
    }
    
    // 给左边的返回按钮添加方法
    albumVC.leftBarButtonBlock = ^void (CLAlbumImageViewController *controller, NSInteger index){
        // 将返回的图片的位置传出去
        if (backImageViewBlock) {
            backImageViewBlock(index);
        }
        NSLog(@"Method : %s, Line : %d, imageViewArray = %@", __FUNCTION__, __LINE__, imageViewArray);
        //  获取到返回时的正在显示的imageView
        imageView = imageViewArray[index];
        NSLog(@"Method : %s, Line : %d, imageView.x = %.2f, imageView.y = %.2f, imageView.w = %.2f, imageView.h = %.2f", __FUNCTION__, __LINE__, imageView.bounds.origin.x, imageView.bounds.origin.y, imageView.bounds.size.width, imageView.bounds.size.height);
        tempImageView.image = imageView.image;
        tempImageView.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
        
        [controller dismissViewControllerAnimated:NO completion:^{
            [UIView animateWithDuration:animationTime animations:^{
                CGRect frame = [imageView convertRect:imageView.bounds toView:target.view];
                NSLog(@"Method : %s, Line : %d, imageView.x = %.2f, imageView.y = %.2f, imageView.w = %.2f, imageView.h = %.2f", __FUNCTION__, __LINE__, imageView.bounds.origin.x, imageView.bounds.origin.y, imageView.bounds.size.width, imageView.bounds.size.height);
                NSLog(@"Method : %s, Line : %d, x = %.2f, y = %.2f, w = %.2f, h = %.2f", __FUNCTION__, __LINE__, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
                tempImageView.frame = CGRectMake(frame.origin.x, frame.origin.y + 62, frame.size.width, frame.size.height);
            } completion:^(BOOL finished) {
                [tempImageView removeFromSuperview];
            }];
        }];
    };
    
}

+ (void)showCLAlbumWithTarget:(__kindof UIViewController *)target Title:(NSString *)title OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity WithImage:(NSMutableArray<UIImage *> *)images WithDelImageViewAction:(void (^) (NSInteger index))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger index))backImageViewBlock WithReloadView:(void (^)(void))reloadView{
    // 记录删除的block是否已经执行
   __block BOOL isDel = NO;
    
    CLAlbumImageViewController *albumVC = [[CLAlbumImageViewController alloc]initWithTitle:title OriginalIndex:originalIndex IsInfinity:isInfinity];
    albumVC.isAutoHiddenBar = YES;
    //  记录下第一个imageView的frame，如果删除到最后一个，自动退出图片浏览
    UIImageView *firstImageView = [[UIImageView alloc] initWithImage:images[0]];
    CGRect firstFrame = [firstImageView convertRect:firstImageView.bounds toView:target.view];
    albumVC.images = images;
    
    //  获取到点击的imageView
    UIImageView *imageView = [[UIImageView alloc] initWithImage:images[originalIndex]];
    
    //  另外创建一个临时的imageView覆盖住这个imageView
    UIImageView *tempImageView = [UIImageView new];
    tempImageView.image = imageView.image;
    CGRect frame = [imageView convertRect:imageView.bounds toView:target.view];
    tempImageView.frame = CGRectMake(frame.origin.x, frame.origin.y + 62, frame.size.width, frame.size.height);
    tempImageView.backgroundColor = [UIColor blackColor];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    
    //  给临时的ImageView添加动画
    [UIView animateWithDuration:animationTime animations:^{
        tempImageView.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        [target presentViewController:albumVC animated:NO completion:^{
            [tempImageView removeFromSuperview];
        }];
    }];
    
    @WXLWeakObj(albumVC);
    if (delImageViewBlock) {
        //  给右边的删除按钮添加方法
        albumVC.rightBarButtonBlock = ^void(CLAlbumImageViewController *controller, NSInteger index){
            controller.isHiddenRightBarButton = NO;
            //  先删除相册中的imageView
            [controller.models removeObjectAtIndex:index];
            controller.currentIndex = index - 1 < 0 ? 0 : index - 1;
            controller.albumImageBar.sum --;
            //  如果相册中的imageView的数量为0，则自动退出图片浏览
            if (controller.models.count <= 0) {
                // 用完了imageView 再刷新数据源
                tempImageView.image = nil;
                tempImageView.frame = [UIScreen mainScreen].bounds;
                [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
                [controller dismissViewControllerAnimated:NO completion:^{
                    [UIView animateWithDuration:animationTime animations:^{
                        tempImageView.frame = CGRectMake(firstFrame.origin.x, firstFrame.origin.y + 62, firstFrame.size.width, firstFrame.size.height);
                    } completion:^(BOOL finished) {
                        if (reloadView) {
                            reloadView();
                        }
                        [tempImageView removeFromSuperview];
                    }];
                }];
            }
            
            //  再刷新相册中的数据源
            @WXLStrongObj(albumVC);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:albumVCStrong.currentIndexPath.section];
            [controller.CLCollectionView reloadSections:indexSet];
            //            //  再将删除的哪一个图片传出去，让外面的相册也刷新数据源
            //            delImageViewBlock(index);
            //  删除设置动画用的imageView数组中对应的imageView
            [images removeObjectAtIndex:index];
            if (delImageViewBlock) {
                isDel = YES;
                //  再将删除的哪一个图片传出去，让外面的相册也刷新数据源
                delImageViewBlock(index);
            }
        };
    }else{
        albumVC.isHiddenRightBarButton = YES;
    }
    
    // 给左边的返回按钮添加方法
    albumVC.leftBarButtonBlock = ^void (CLAlbumImageViewController *controller, NSInteger index){
        // 将返回的图片的位置传出去
        if (backImageViewBlock) {
            backImageViewBlock(index);
        }
        //  获取到返回时的正在显示的imageView
        UIImageView *imageView = [[UIImageView alloc] initWithImage:images[index]];
        tempImageView.image = imageView.image;
        tempImageView.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
        
        [controller dismissViewControllerAnimated:NO completion:^{
            [UIView animateWithDuration:animationTime animations:^{
                CGRect frame = [imageView convertRect:imageView.bounds toView:target.view];
                tempImageView.frame = CGRectMake(frame.origin.x, frame.origin.y + 62, frame.size.width, frame.size.height);
                // 用完了imageView 再刷新数据源
                if (reloadView && isDel) {
                    reloadView();
                }
            } completion:^(BOOL finished) {
                [tempImageView removeFromSuperview];
            }];
        }];
    };
}

+ (void)showCLAlbumWithTarget:(__kindof UIViewController *)target Title:(NSString *)title OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity WithImageViews:(NSMutableArray<UIImage *> *)imageViews WithDelImageViewAction:(void (^) (NSInteger index))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger index))backImageViewBlock WithReloadView:(void (^)())reloadView{
    // 记录删除的block是否已经执行
    __block BOOL isDel = NO;
    __block CLAlbumImageViewController *albumVC = [[CLAlbumImageViewController alloc]initWithTitle:title OriginalIndex:originalIndex IsInfinity:isInfinity];
    albumVC.isAutoHiddenBar = YES;
    albumVC.images = imageViews;
    [target presentViewController:albumVC animated:NO completion:nil];
    
    @WXLWeakObj(albumVC);
    if (delImageViewBlock) {
        //  给右边的删除按钮添加方法
        albumVC.rightBarButtonBlock = ^void(CLAlbumImageViewController *controller, NSInteger index){
            controller.isHiddenRightBarButton = NO;
            //  先删除相册中的imageView
            [controller.models removeObjectAtIndex:index];
            controller.currentIndex = index - 1 < 0 ? 0 : index - 1;
            controller.albumImageBar.sum --;
            //  如果相册中的imageView的数量为0，则自动退出图片浏览
            if (controller.models.count <= 0) {
                // 用完了imageView 再刷新数据源
                [controller dismissViewControllerAnimated:NO completion:^{
                    if (reloadView) {
                        reloadView();
                    }
                }];
            }
            @WXLStrongObj(albumVC);
            //  再刷新相册中的数据源
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:albumVCStrong.currentIndexPath.section];
            [controller.CLCollectionView reloadSections:indexSet];
            if (delImageViewBlock) {
                isDel = YES;
                //  再将删除的哪一个图片传出去，让外面的相册也刷新数据源
                delImageViewBlock(index);
            }
        };
    }else{
        albumVC.isHiddenRightBarButton = YES;
    }
    
    // 给左边的返回按钮添加方法
    albumVC.leftBarButtonBlock = ^void (CLAlbumImageViewController *controller, NSInteger index){
        // 将返回的图片的位置传出去
        if (backImageViewBlock) {
            backImageViewBlock(index);
        }
        [controller dismissViewControllerAnimated:NO completion:^{
            if (reloadView && isDel) {
                reloadView();
            }
        }];
    };
}


+ (void)showCLAlbumWithTarget:(__kindof UIViewController *)target title:(NSString *)title originalIndex:(NSInteger)originalIndex isInfinity:(BOOL)isInfinity images:(NSArray<NSString *> *)images deleteBlock:(void (^) (NSInteger index))deleteBlock backBlock:(void (^)(NSInteger index))backBlock reloadBlock:(void (^)())reloadBlock{
    // 记录删除的block是否已经执行
    __block BOOL isDel = NO;
    __block CLAlbumImageViewController *albumVC = [[CLAlbumImageViewController alloc]initWithTitle:title OriginalIndex:originalIndex IsInfinity:isInfinity];
    albumVC.isAutoHiddenBar = YES;
  
    albumVC.imageURLs = [images mutableCopy];
    
    [target presentViewController:albumVC animated:NO completion:nil];
    
    @WXLWeakObj(albumVC);
    if (deleteBlock) {
        //  给右边的删除按钮添加方法
        albumVC.rightBarButtonBlock = ^void(CLAlbumImageViewController *controller, NSInteger index){
            controller.isHiddenRightBarButton = NO;
            //  先删除相册中的imageView
            
            [controller.models removeObjectAtIndex:index];
            controller.currentIndex = index - 1 < 0 ? 0 : index - 1;
            controller.albumImageBar.sum --;
            //  如果相册中的imageView的数量为0，则自动退出图片浏览
            @WXLStrongObj(albumVC);
            //  再刷新相册中的数据源
            [albumVCStrong.imageURLs removeObjectAtIndex:index];
            if (controller.models.count <= 0 || albumVCStrong.imageURLs.count<=0) {
                // 用完了imageView 再刷新数据源
                [controller dismissViewControllerAnimated:NO completion:nil];
            }
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:albumVCStrong.currentIndexPath.section];
            [controller.CLCollectionView reloadSections:indexSet];

            isDel = YES;
            //再将删除的哪一个图片传出去，让外面的相册也刷新数据源
            deleteBlock(index);
        };
    }else{
        albumVC.isHiddenRightBarButton = YES;
    }
    
    // 给左边的返回按钮添加方法
    albumVC.leftBarButtonBlock = ^void (CLAlbumImageViewController *controller, NSInteger index){
        // 将返回的图片的位置传出去
        if (backBlock) {
            backBlock(index);
        }
        [controller dismissViewControllerAnimated:NO completion:^{
            if (reloadBlock && isDel) {
                reloadBlock();
            }
        }];
    };
}
/*
  //传递图片字符
- (void)syf_showCLAlbumWithTarget:(__kindof UIViewController *)target title:(NSString *)title originalIndex:(NSInteger)originalIndex isInfinity:(BOOL)isInfinity imageUrls:(NSArray<NSString *> *)imageUrls WithDelImageViewAction:(void (^)(NSInteger))delImageViewBlock WithBackImageViewAction:(void (^)(NSInteger))backImageViewBlock{
  
  __block NSMutableArray<NSString *> *imageViewArray = [imageUrls mutableCopy];

  WS(weakSelf);
  
  _currentIndex   = originalIndex;//  初始位置
  _isInfinity     = isInfinity;
  self.isAutoHiddenBar = YES;
  
  self.imageURLs = [imageUrls copy];

  if (delImageViewBlock) {
    weakSelf.rightBarButtonBlock = ^void(CLAlbumImageViewController *controller, NSInteger index){
      controller.isHiddenRightBarButton = NO;
      [controller.models removeObjectAtIndex:index];
      controller.currentIndex = index - 1 < 0 ? 0 : index - 1;
      controller.albumImageBar.sum --;
      if (controller.models.count <= 0) {
        [controller dismissViewControllerAnimated:YES completion:nil];
      }
      NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:weakSelf.currentIndexPath.section];
      [controller.CLCollectionView reloadSections:indexSet];
      [imageViewArray removeObjectAtIndex:index];
      if (delImageViewBlock) {
        delImageViewBlock(index);
      }
    };
  }else{
    weakSelf.isHiddenRightBarButton = YES;
  }
  
  self.leftBarButtonBlock = ^void (CLAlbumImageViewController *controller, NSInteger index){
    if (backImageViewBlock) {
      backImageViewBlock(index);
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
  };
}
 */



@end
