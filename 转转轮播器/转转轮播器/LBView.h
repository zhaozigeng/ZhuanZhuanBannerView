//
//  LBView.h
//  ScrollPicturesDemo
//
//  Created by 天津车福终端研发 on 2018/6/28.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBView : UIView


@property(nonatomic, strong)NSArray *images;
/** 定义banner高度 */
+(CGFloat)myHeight;

@property(nonatomic, copy)void(^scrollViewDidScrollBlock)(CGFloat percent);
@property(nonatomic, copy)void(^bottomBackgroundImageBlock)(NSInteger index);
@property(nonatomic, copy)void(^topBackgroundImageBlock)(NSInteger index);
@property(nonatomic, copy)void(^clickBlock)(NSInteger index);
@property(nonatomic, assign)UIViewContentMode bannerContentMode;
@end
