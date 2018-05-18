//
//  ViewController.m
//  ImageBrowsingWithZoom
//
//  Created by lemo on 2018/5/18.
//  Copyright © 2018年 孙亚锋. All rights reserved.
//

#import "ViewController.h"
#import "CLAlbumImageViewController.h"
#import "PhotosCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
/** 数据源数组*/
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"点击预览大图";
    [self.view addSubview:self.collectionView];
}
#pragma mark - - CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.backgroundColor = [UIColor clearColor];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.item]] placeholderImage:[UIImage imageNamed:@"背景图.jpg"]];
    
    return cell;
}
    //返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
    // 设置列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 8*WScreenWidth;
}
    //设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 8*WScreenWidth;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat top    = 10*WScreenWidth;
    CGFloat left   = 10*WScreenWidth;
    CGFloat bottom = 10*WScreenWidth;
    CGFloat right  = 10*WScreenWidth;
    return UIEdgeInsetsMake(top, left, bottom ,right);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [CLAlbumImageViewController showCLAlbumWithTarget:self title:@"" originalIndex:indexPath.item isInfinity:NO imageUrls:self.dataSource WithDelImageViewAction:nil WithBackImageViewAction:nil];
}

#pragma mark - -懒加载
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout  =[[UICollectionViewFlowLayout alloc]init];
        layout.itemSize=CGSizeMake((KScreenWidth-36*WScreenWidth)/3, (KScreenWidth-36*WScreenWidth)/3);
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth , KScreenHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PhotosCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        
    }
    return _collectionView;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource =[[NSMutableArray alloc]initWithObjects:
        @"http://pic.58pic.com/58pic/13/68/03/86S58PIC26b_1024.jpg",
        @"http://img.zcool.cn/community/018d4e554967920000019ae9df1533.jpg@900w_1l_2o_100sh.jpg",
        @"http://img.liuxue86.com/2015/0906/20150906043546913.jpg",
        @"http://img3.redocn.com/tupian/20150312/haixinghezhenzhubeikeshiliangbeijing_3937174.jpg",
        @"http://pic.58pic.com/58pic/12/07/05/08j58PIC7FA.jpg",
        @"http://www.taopic.com/uploads/allimg/140421/318743-140421213T910.jpg",
        @"http://pic2.nipic.com/20090424/1242397_110033072_2.jpg",
        @"http://img02.tooopen.com/images/20150507/tooopen_sy_122395947985.jpg",
        @"http://img.taopic.com/uploads/allimg/120727/201995-120HG1030762.jpg",
        @"http://img05.tooopen.com/images/20150820/tooopen_sy_139205349641.jpg",
        @"http://img3.redocn.com/tupian/20150106/aixinxiangkuang_3797284.jpg",
        @"http://img.zcool.cn/community/013f5958c53a47a801219c772a5335.jpg@900w_1l_2o_100sh.jpg",
        @"http://pic2.ooopic.com/12/22/95/08bOOOPICe2_1024.jpg",
        @"http://img07.tooopen.com/images/20170316/tooopen_sy_201956178977.jpg",
        @"http://img.taopic.com/uploads/allimg/140729/240450-140HZP45790.jpg",
        nil];
    }
    return _dataSource;
}

@end
