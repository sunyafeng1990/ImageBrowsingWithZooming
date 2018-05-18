//
//  CLAlbumView.m
//  CLAlbumnCollectionPractice
//
//  Created by lemo on 2018/5/17.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import "CLAlbumView.h"
#import "CLPersonalImageAlubumCollectionViewCell.h"

static NSString *const personalImageAlubumCollectionViewCell = @"CLPersonalImageAlubumCollectionViewCell";
static const NSInteger maxRepeatCount = 100;

@interface CLAlbumView ()<UICollectionViewDataSource, UICollectionViewDelegate>

/** 数据源 */
@property(nonatomic, strong)NSMutableArray *imageDataSources;

/** 是否无限轮播 */
@property(nonatomic, assign)BOOL isInfinity;

///** 当前图片位置 */
//@property(nonatomic, assign)NSInteger currentIndex;

/** 当前图片位置展示 */
@property(nonatomic, strong)UILabel *indexLabel;

/** collectionView */
@property(nonatomic, strong)UICollectionView *mainCollectionView;

@end

@implementation CLAlbumView

#pragma mark - setter
- (void)setImageURLs:(NSArray<NSString *> *)imageURLs{
    _imageURLs              = imageURLs;
    self.imageDataSources   = [NSMutableArray arrayWithArray:_imageURLs];
    [_mainCollectionView reloadData];
    [self setCurrentIndex:_currentIndex];
}

- (void)setImages:(NSArray<UIImage *> *)images{
    _images                 = images;
    self.imageDataSources   = [NSMutableArray arrayWithArray:_images];
    [_mainCollectionView reloadData];
    [self setCurrentIndex:_currentIndex];
}

- (void)setImageNames:(NSArray<NSString *> *)imageNames{
    _imageNames             = imageNames;
    self.imageDataSources   = [NSMutableArray arrayWithArray:_imageNames];
    [_mainCollectionView reloadData];
    [self setCurrentIndex:_currentIndex];
}


- (void)setIsInfinity:(BOOL)isInfinity{
    //  默认是无限循环的，如果不无限循环，则collectionView只有一个section
    _isInfinity = isInfinity;
    //  无限滚动时，默认滑动位置是中间
    if ((_imageNames.count >= 2 || _images.count >= 2 || _imageURLs.count >= 2) && _isInfinity) {
        [_mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:maxRepeatCount / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    [_mainCollectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if (_imageDataSources.count > 0) {
        if ((_imageNames.count >= 2 || _images.count >= 2 || _imageURLs.count >= 2) && _isInfinity) {
            [_mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:maxRepeatCount / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }else{
            [_mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex + 1, _imageDataSources.count];
    }else{
        _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex, _imageDataSources.count];
    }
}


#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //  创建子视图
        [self setupSubViews];
        //  2.注册cell
        [_mainCollectionView registerClass:[CLPersonalImageAlubumCollectionViewCell class] forCellWithReuseIdentifier:personalImageAlubumCollectionViewCell];
    }
    return self;
}

- (void)layoutSubviews{
    //  布局显示标题的label
    CGSize size         = [_indexLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    CGFloat width       = size.width + 10;
    _indexLabel.frame   = CGRectMake(self.frame.size.width - 15 - width, self.frame.size.height - 10 - width, width, width);
    _indexLabel.layer.cornerRadius = width / 2.0;
    
}


#pragma mark - 私有方法
- (void)setupSubViews{
    // 当前位置展示
    _indexLabel                 = [[UILabel alloc]init];
    _indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];              //  背景颜色
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex, _imageDataSources.count];                                  //  标题
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.font            = [UIFont systemFontOfSize:18];    //  标题字体大小
    _indexLabel.clipsToBounds   = YES;                             //  切掉多余部分
    _indexLabel.textAlignment   = NSTextAlignmentCenter;           //  中间对齐
    [self addSubview:_indexLabel];
    
    //  collectionView
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    layout.minimumInteritemSpacing      = 0;                       //  中间的最小间距(列）
    layout.minimumLineSpacing           = 0;                       //  最小间距（行）
    layout.scrollDirection              = UICollectionViewScrollDirectionHorizontal;
    _mainCollectionView                 = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];                       //  创建collectionView
    _mainCollectionView.delegate        = self;                    //  代理
    _mainCollectionView.dataSource      = self;                    //  dataSource代理
    _mainCollectionView.pagingEnabled   = YES;                     //  翻一整页
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_mainCollectionView];
    
    [self insertSubview:_mainCollectionView belowSubview:_indexLabel];
    
    // 给collectionView添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
    [_mainCollectionView addGestureRecognizer:tap];
}

- (void)doTap:(UITapGestureRecognizer *)tap{
    if (self.tapImageViewBlock) {
        self.tapImageViewBlock(_currentIndex);
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageDataSources.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CLPersonalImageAlubumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:personalImageAlubumCollectionViewCell forIndexPath:indexPath];
    if (_imageNames) {
        cell.imageName  = _imageNames[indexPath.row];
    }else if (_images){
        cell.image      = _images[indexPath.row];
    }else if (_imageURLs){
        cell.imageURL   = _imageURLs[indexPath.row];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_isInfinity) {
        return maxRepeatCount;
    }else{
        return 1;
    }
}


#pragma mark - UICollectionViewDelegate

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentImageIndex = (NSInteger)((scrollView.contentOffset.x + (self.frame.size.width / 2.0)) / self.frame.size.width) % _imageDataSources.count;
    _currentIndex               = currentImageIndex;
    _indexLabel.text            = [NSString stringWithFormat:@"%ld/%ld", _currentIndex + 1, _imageDataSources.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //  无线滚动时，如果滚动的位置超过了2/3，就自动返回中间位置
    if (scrollView.contentOffset.x > (maxRepeatCount * 2 / 3.0) * _mainCollectionView.frame.size.width * _imageDataSources.count) {
        if (_imageNames.count > 2 || _images.count > 2 || _imageURLs.count > 2) {
            [_mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:maxRepeatCount / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    }
}


#pragma mark - 公共
- (instancetype)initWithFrame:(CGRect)frame OriginalIndex:(NSInteger)originalIndex IsInfinity:(BOOL)isInfinity{
    _currentIndex = originalIndex;
    _isInfinity = isInfinity;
    return [self initWithFrame:frame];
}

@end
