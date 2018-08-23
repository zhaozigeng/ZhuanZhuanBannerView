//
//  BLBView.h
//  ScrollPicturesDemo
//
//  Created by 天津车福终端研发 on 2018/6/28.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 大轮播器
 */
//背景图和banner图的数量必须相同，否则会崩溃
//只支持网络图片，如果要支持本地图本，需改代码
@interface BLBView : UIView
/** 定义轮播器高度 */
+(CGFloat)myHeight;

/**
 背景图
 */
@property(nonatomic, strong)NSArray *bgImages;
/**
 banaer 图
 */
@property(nonatomic, strong)NSArray *bannerImages;
/**
 banner 图的contentModel ,默认值为UIViewContentModeScaleAspectFill
 */
@property(nonatomic, assign)UIViewContentMode bannerContentMode;
/**
 点击事件
 */
@property(nonatomic, copy)void(^clickBlock)(NSInteger index);
@end
