//
//  BLBView.m
//  ScrollPicturesDemo
//
//  Created by 天津车福终端研发 on 2018/6/28.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import "BLBView.h"
#import "LBView.h"
#import "CFMyImageView.h"
#import "UIImageView+WebCache.h"
#define SCREEN_WIDTH               ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT              ([[UIScreen mainScreen] bounds].size.height)


@interface BLBView()


@property(nonatomic, assign)CGPoint centerOfCircle;

/**
 背影图
 */
@property(nonatomic, weak)UIImageView* bottomImageView;
@property(nonatomic, weak)CFMyImageView* topImageView;
@property(nonatomic, weak)LBView* bannerView;


@end

@implementation BLBView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
   
    if(self)
    {
        __weak typeof(self)weakSelf = self;
        self.bannerContentMode = UIViewContentModeScaleAspectFill;
        
        UIImageView *bg = [UIImageView new];
        bg.frame = CGRectMake(0, 0, SCREEN_WIDTH, 190);
        self.bottomImageView = bg;
        [self addSubview:bg];
        CFMyImageView *secondBg = [CFMyImageView new];
        secondBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, 190);
        [self addSubview:secondBg];
        self.topImageView = secondBg;
        //mask
        LBView *view = [LBView new];
        self.bannerView = view;
        view.clickBlock=^(NSInteger index)
        {
            if(weakSelf.clickBlock)
            {
                weakSelf.clickBlock(index);
            }
        };
        view.bottomBackgroundImageBlock=^(NSInteger page)
        {
            NSURL *url = [NSURL URLWithString:weakSelf.bgImages[page]];
            [weakSelf.bottomImageView sd_setImageWithURL:url];
        };
        view.topBackgroundImageBlock=^(NSInteger index)
        {
            NSString *name = weakSelf.bgImages[index];
            if(weakSelf.topImageView.imageName==nil || weakSelf.topImageView.imageName.length==0
               || ![weakSelf.topImageView.imageName isEqualToString:name])
            {
                weakSelf.topImageView.hidden = NO;
                weakSelf.topImageView.imageName = name;
                NSURL *url = [NSURL URLWithString:name];
                [weakSelf.topImageView sd_setImageWithURL:url];
            }
        };
        view.scrollViewDidScrollBlock=^(CGFloat percent)
        {
            CGFloat x, y = 190 * .5, radius;
            CAShapeLayer *maskLayer = [CAShapeLayer new];
            
            if(percent>=0) //percent 大于0 向左滑
            {
                x = SCREEN_WIDTH + 20;
            }
            else         //percent 小于0 向右滑
            {
                x = -20;
            }
            weakSelf.centerOfCircle = CGPointMake(x, y);
            radius = percent * SCREEN_WIDTH * 2.;
            UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:self.centerOfCircle radius:radius startAngle:M_PI * .5 endAngle:M_PI * .5 + M_PI  clockwise:YES];
            maskLayer.path = path.CGPath;
            weakSelf.topImageView.layer.mask = maskLayer;
        };
        view.frame = CGRectMake(0, 40, SCREEN_WIDTH, [LBView myHeight]);
        [self addSubview:view];
    }
    return self;
}


-(void)setBgImages:(NSArray *)bgImages
{
    _bgImages = bgImages;
    
    if(bgImages.count>0)
    {
        NSURL *url = [NSURL URLWithString:self.bgImages.firstObject];
        [self.bottomImageView sd_setImageWithURL:url];
        self.bottomImageView.hidden = NO;
        
    }
    else
    {
        self.bottomImageView.hidden = YES;
    }
    self.topImageView.hidden = YES;
}

-(void)setBannerImages:(NSArray *)images
{
    _bannerImages = images;
    self.bannerView.images = images;
}
-(void)setBannerContentMode:(UIViewContentMode)bannerContentModel
{
    self.bannerView.bannerContentMode = bannerContentModel;
}
+(CGFloat)myHeight
{
    return 190.;
}

@end
