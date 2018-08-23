//
//  LBView.m
//  ScrollPicturesDemo
//
//  Created by 天津车福终端研发 on 2018/6/28.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import "LBView.h"
#import "CFMyImageView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#define SCREEN_WIDTH               ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT              ([[UIScreen mainScreen] bounds].size.height)


@interface LBView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic, assign)NSInteger currentPage;

@property(nonatomic, assign)CGFloat lastContentOffset;
/**滚动的偏移 */
@property(nonatomic, assign)CGFloat scrolledOffset;



@end
@implementation LBView

-(void)setImages:(NSArray *)images
{
    _images = images;
    
    [self setUpWithImages:images];
}

-(void)setUpWithImages:(NSArray*)images
{
    [self.timer invalidate];
    self.scrollView.delegate = nil;
    [self.scrollView removeFromSuperview];
    
    if(images.count==0) //
    {
        self.pageControl.hidden = YES;
        return;
    }
    self.lastContentOffset = 0;
    self.scrolledOffset = 0;
    self.currentPage = 0;
    //图片个数大于1
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [LBView myHeight])];
    [self addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    if(images.count>1)
    {
        NSString * imageName = images.lastObject;
        UIView *imageView = [self createImageView:imageName tag:images.count-1];
        imageView.frame = self.scrollView.bounds;
        [self.scrollView addSubview:imageView];
        for (int i = 0; i < images.count; i++)
        {
            NSString * imageName = images[i];
            UIView *imageView = [self createImageView:imageName tag:i];
            imageView.frame = self.scrollView.bounds;
            [self.scrollView addSubview:imageView];
        }
        //最后一个
        imageName = images.firstObject;
        imageView = [self createImageView:imageName tag:0];
        imageView.frame = self.scrollView.bounds;
        [self.scrollView addSubview:imageView];
    }
    else  //图片个数小于1
    {
        for (int i = 0; i < images.count; i++)
        {
            NSString * imageName = images[i];
            UIView *imageView = [self createImageView:imageName tag:i];
            imageView.frame = self.scrollView.bounds;
            [self.scrollView addSubview:imageView];
        }
    }
    NSInteger count = self.scrollView.subviews.count;
    for(int i=0; i<count; i++)
    {
        UIView *view = self.scrollView.subviews[i];
        CGRect frame = view.frame;
        frame.origin.x = i * frame.size.width;
        view.frame = frame;
    }
    self.scrollView.contentSize = CGSizeMake(count * SCREEN_WIDTH, 0);
  
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = images.count;
    if(self.images.count>1)
    {
        self.scrollView.delegate = self;
        [self setupTimer];
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        UIView *view = self.scrollView.subviews[1];
        view.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }
   else
   {
       UIView *view = self.scrollView.subviews[0];
       view.transform = CGAffineTransformMakeScale(1.2, 1.2);
   }
    self.pageControl.hidden = NO;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}
- (void)setupTimer{
    self.timer = [NSTimer timerWithTimeInterval:2. target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
   [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerChanged
{
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    //偏移的百分比
    NSInteger page = self.scrollView.contentOffset.x / width;
    UIView *view = self.scrollView.subviews[page];
    [UIView animateWithDuration:.2 animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        CGFloat width = CGRectGetWidth(self.scrollView.bounds);
        CGFloat offsetX;
        if(self.pageControl.currentPage == self.images.count-1) //判断是否是最后一页
        {
            offsetX = (self.scrollView.subviews.count-1) * width;
        }
        else
        {
            offsetX = (self.pageControl.currentPage + 2) * width;
        }
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
        self.lastContentOffset = self.scrollView.contentOffset.x;//判断左右滑动时
        self.scrolledOffset = 0;
    }];
}



- (UIPageControl *)pageControl{
    if(!_pageControl){
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
        _pageControl.numberOfPages = self.images.count;
        _pageControl.pageIndicatorTintColor = [UIColor redColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
        [self addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _pageControl;
}

#pragma make - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.lastContentOffset = scrollView.contentOffset.x;//判断左右滑动时
    self.scrolledOffset = 0;
    [self resetImageView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   [self setupTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.scrollViewDidScrollBlock)
    {
        //向左滑为正值 ，右滑为负
        self.scrolledOffset += scrollView.contentOffset.x -  self.lastContentOffset;
        //偏移的百分比
        CGFloat percent = self.scrolledOffset / CGRectGetWidth(scrollView.bounds);
        //计算页码
        [self calculateCurrentPage:percent];
        //更新遮盖
        self.scrollViewDidScrollBlock(percent);
        self.lastContentOffset = scrollView.contentOffset.x;
    }
}



/** 计算当前页 */
-(void)calculateCurrentPage:(CGFloat )percent
{
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    //偏移的百分比
    NSInteger page = self.scrollView.contentOffset.x / width;
    CGFloat remain = ABS(page * width - self.scrollView.contentOffset.x);
    if(remain==0) 
    {
        //判断是否到最后一页
        if(page==self.scrollView.subviews.count-1)
        {
            UIView *view = self.scrollView.subviews[page-1];
            view.transform = CGAffineTransformIdentity;
            self.scrolledOffset = 0;
            self.currentPage = 0;
            self.pageControl.currentPage = 0;
            self.scrollView.contentOffset = CGPointMake(width, 0);
            return;
        }
        else if(page==0)   //第一页
        {
            self.scrolledOffset = 0;
            self.currentPage = self.images.count -1;
            self.pageControl.currentPage = self.images.count -1;
            CGFloat offset = (self.scrollView.subviews.count-2) * width;
            self.scrollView.contentOffset = CGPointMake(offset, 0);
            return;
        }
        else
        {
            self.currentPage = page - 1;
            self.pageControl.currentPage = page - 1;
        }
        if(self.bottomBackgroundImageBlock)
        {
            self.bottomBackgroundImageBlock(self.currentPage);
        }
        
        UIView *view = self.scrollView.subviews[page];
        [UIView animateWithDuration:.2 animations:^{
            view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
    }
    else
    {
        if(self.topBackgroundImageBlock)
        {
            NSInteger nextPage , currentPage = self.currentPage;
            if(percent>=0) //percent 大于0 向左滑
            {
                nextPage =(currentPage < (self.images.count-1))? currentPage+1 : 0;
            }
            else
            {
                nextPage =(currentPage <=0)? self.images.count -1 :currentPage-1;
            }
            self.topBackgroundImageBlock(nextPage);
        }
    }
}

//创建一个
-(UIView*)createImageView:(NSString *)imageName tag:(NSInteger)tag
{
    CFMyImageView * imageView = [CFMyImageView new];
    imageView.clipsToBounds = YES;
    imageView.contentMode = self.bannerContentMode;
    imageView.backgroundColor = [UIColor grayColor];
    NSURL *url = [NSURL URLWithString:imageName];
    [imageView sd_setImageWithURL:url];
    imageView.imageName = imageName;
    UIButton *view = [UIButton new];
    view.tag = tag;
    [view addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    view.backgroundColor = [UIColor clearColor];
    view.frame = self.scrollView.bounds;
    imageView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width - 70, self.scrollView.bounds.size.height - 70);
    imageView.center = view.center;
    [view addSubview:imageView];
    return view;
}

-(void)resetImageView
{
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    //偏移的百分比
    NSInteger page = self.scrollView.contentOffset.x / width;
    UIView *view = self.scrollView.subviews[page];
    [UIView animateWithDuration:.2 animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setBannerContentMode:(UIViewContentMode)bannerContentModel
{
    _bannerContentMode = bannerContentModel;
}

-(void)click:(UIButton *)btn
{
    if(self.clickBlock)
    {
        self.clickBlock(btn.tag);
    }
}

+(CGFloat)myHeight
{
    return 150.;
}
@end
