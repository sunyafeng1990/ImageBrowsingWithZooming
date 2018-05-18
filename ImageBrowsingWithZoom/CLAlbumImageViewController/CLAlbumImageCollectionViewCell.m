//
//  CLAlbumImageCollectionViewCell.m
//  CLAlbumnCollectionPractice
//
//  Created by lemo on 2018/5/17.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import "CLAlbumImageCollectionViewCell.h"
#import "CLAlbumImageModel.h"
#import "UIImageView+WebCache.h"
  //是否支持横屏
#define shouldSupportLandscape NO
//是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES
#define kIsFullWidthForLandScape NO
//图片缩放的比例
#define MaxSCale 2.0f //最大缩放比例
#define MinScale 0.5f //最小缩放比例

//  titleLabel的高度
static const CGFloat titleLabelH = 70;

@interface CLAlbumImageCollectionViewCell ()<UIActionSheetDelegate,UIScrollViewDelegate>
@property(nonatomic,assign)CGFloat totalScale;



/** 用来展示每个图片上的内容 */
@property(nonatomic, strong)UILabel *CLTitleLabel;

/** titleLabel的显示样式 */
@property(nonatomic, assign)CLAlbumImageTitleLabelType titleLabelType;



@end

@implementation CLAlbumImageCollectionViewCell

#pragma mark - setter
- (void)setTitleLabelType:(CLAlbumImageTitleLabelType)titleLabelType{
    _titleLabelType = titleLabelType;
    [self setNeedsLayout];
}

- (void)setModel:(CLAlbumImageModel *)model{
    _model = model;
    WS(weakSelf);
    if (_model.titleLabelType) {
        self.titleLabelType = _model.titleLabelType;
    }else{
        self.titleLabelType = CLAlbumImageTitleLabelTypeNone; // 默认titleLabel
    }
    
        //    TitleLabel
    if ([_model.title isEqualToString:@""] || _model.title == nil || _model.titleLabelType == CLAlbumImageTitleLabelTypeNone) {
        _CLTitleLabel.hidden = YES;
    }else{
        _CLTitleLabel.text = _model.title;
    }
    
        //    ImageView
    if ((_model.image && _model.imageURL) || (_model.image && _model.imageName) || (_model.imageURL && _model.imageName) || (_model.imageName && _model.image && _model.imageURL)) {
        NSAssert(1, @"**********************UIImage/ImageURL/ImageName不能同时存在*****************");
    }
    if (_model.imageName) {
        _CLImageView.image = [UIImage imageNamed:_model.imageName];
    }else if (_model.imageURL){
        [_CLImageView setShowActivityIndicatorView:YES];
        
        _CLImageView.frame = CGRectMake(0, 0, _CLImageView.frame.size.width, _CLImageView.frame.size.height);
        _scrollView.contentSize = self.CLImageView.frame.size;
        _CLImageView.center = [self centerOfScrollViewContent:self.scrollView];
        _scrollView.contentOffset = CGPointZero;
        [_CLImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageURL]placeholderImage:[UIImage imageNamed:@"背景图.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [weakSelf adjustFrames:image];
            
        }];
    }else if (_model.image){
        _CLImageView.image = _model.image;
    }
}
#pragma mark - 重写系统的方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.totalScale = 1.0;
//        创建子视图
        [self setupSubViews];
    }
    return self;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
   
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, KScreenWidth , KScreenHeight);
        [_scrollView addSubview:self.CLImageView];
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = YES;
    }
    return _scrollView;
}
- (UIImageView *)CLImageView
{
    if (!_CLImageView) {
        _CLImageView = [[UIImageView alloc]init];
        _CLImageView.frame = CGRectMake(0, 0,KScreenWidth, KScreenHeight);
        _CLImageView.userInteractionEnabled = YES;
        
    }
    return _CLImageView;
}

- (void)layoutSubviews{
  
  _scrollView.frame = self.bounds;
  
//    TitleLabel
    CGFloat w = _CLImageView.frame.size.width;
    CGFloat h = _CLImageView.frame.size.height;
    CGFloat x = _CLImageView.frame.origin.x;
    
    CGFloat labelX = x;
    CGFloat labelW = w;
    CGFloat labelY ;
    CGFloat labelH = titleLabelH;
    switch (_titleLabelType) {
        case CLAlbumImageTitleLabelTypeNone:
            labelY = 0;
            break;
        case CLAlbumImageTitleLabelTypeBottom:
            labelY = h - titleLabelH;
            break;
        case CLAlbumImageTitleLabelTypeTop:
            labelY = titleLabelH;
            break;
    }
    _CLTitleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
}
#pragma mark - 私有方法
//创建子视图
- (void)setupSubViews{

  [self.contentView addSubview:self.scrollView];
  //长按保存图片手势
      UILongPressGestureRecognizer *logPressGesture =  [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapAction:)];
  
      [_CLImageView addGestureRecognizer:logPressGesture];
   
//    TitleLabel
    _CLTitleLabel = [[UILabel alloc]init];
    [_CLImageView addSubview:_CLTitleLabel];
}

#pragma mark 长按保存图片到本地
- (void)longTapAction:(UILongPressGestureRecognizer *)gesture{
 
  if (gesture.state == UIGestureRecognizerStateBegan) {
      //            保存到相册
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"是否保存到相册"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"保存"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) {
    // 第一个参数是要保存的图片对象，第二个参数是操作后由self调用第三个参数的方法，第四个参数是传递给回调方法的信息

    UIImageWriteToSavedPhotosAlbum(_CLImageView.image, self, @selector(image:finishedSaveWithError:contextInfo:), nil);
    
  }
}
  //保存图片到相册的回调方法
- (void)image:(UIImage *)image finishedSaveWithError:(NSError*)error contextInfo:(void*)contextInfo{
  if (error) {
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"无法保存" message:@"请在iPhone的“设置-隐私-照片”选项中，允许访问你的照片" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
    [alertView show];
  }else{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
  }
}
#pragma mark - -控制图片显示
- (void)adjustFrames:(UIImage *)image
{
  CGRect frame = self.scrollView.frame;
  if (image) {
     CGSize imageSize = image.size;
    if (imageSize.width >KScreenWidth) {
      imageSize.height =  imageSize.height*KScreenWidth/imageSize.width;
      imageSize.width  = KScreenWidth;
    }
    CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    if (kIsFullWidthForLandScape) {
      CGFloat ratio = frame.size.width/imageFrame.size.width;
      imageFrame.size.height = imageFrame.size.height*ratio;
      imageFrame.size.width = frame.size.width;
    } else{
      
      if (frame.size.width<=frame.size.height) {
        
        CGFloat ratio = frame.size.width/imageFrame.size.width;
        imageFrame.size.height = imageFrame.size.height*ratio;
        imageFrame.size.width = frame.size.width;
      }else{
        CGFloat ratio = frame.size.height/imageFrame.size.height;
        imageFrame.size.width = imageFrame.size.width*ratio;
        imageFrame.size.height = frame.size.height;
      }
    }
    
    self.CLImageView.frame = imageFrame;
    self.scrollView.contentSize = self.CLImageView.frame.size;
    self.CLImageView.center = [self centerOfScrollViewContent:self.scrollView];
    
    
    CGFloat maxScale = frame.size.height/imageFrame.size.height;
    maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
    maxScale = maxScale>MaxSCale?maxScale:MaxSCale;
    
    self.scrollView.minimumZoomScale = MinScale;
    self.scrollView.maximumZoomScale = maxScale;
    self.scrollView.zoomScale = 1.0f;
  }else{
    frame.origin = CGPointZero;
    self.CLImageView.frame = frame;
    self.scrollView.contentSize = self.CLImageView.frame.size;
  }
  self.scrollView.contentOffset = CGPointZero;
}


#pragma mark - -UIScrollViewDelegate
- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
  CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
  (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
  CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
  (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
  CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                     scrollView.contentSize.height * 0.5 + offsetY);
  return actualCenter;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return self.CLImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
  self.CLImageView.center = [self centerOfScrollViewContent:scrollView];
}


@end
