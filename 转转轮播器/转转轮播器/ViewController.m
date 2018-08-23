//
//  ViewController.m
//  ScrollPicturesDemo
//
//  Created by Orient on 2017/11/17.
//  Copyright © 2017年 Orient. All rights reserved.
//

#import "ViewController.h"
#import "BLBView.h"
#define SCREEN_WIDTH               ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT              ([[UIScreen mainScreen] bounds].size.height)

@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong)BLBView *bannerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BLBView *view = [BLBView new];
    self.bannerView = view;
    //必须 先设置contentMode 才会起作用
    view.bannerContentMode = UIViewContentModeScaleAspectFill;
    //背景图
    view.bgImages = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530611999947&di=d366fbc34227cf0509d75a58f694febc&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01d6fc554bb54d000001bf7249bbc1.jpg%401280w_1l_2o_100sh.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530611999947&di=07fe1b76eb85f92a3ffcaa6a18472f9e&imgtype=0&src=http%3A%2F%2Fwww.yxad.com%2FNews%2FUploadFiles_1696%2F201802%2F2018022210570295.jpg",];
    //banaer图
    view.bannerImages = @[@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1683290459,1218017372&fm=27&gp=0.jpg",
                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530611574285&di=bb110fce807ecb8beaca748d66741738&imgtype=0&src=http%3A%2F%2Fwww.czhmall.com%2Fimages%2F201606%2Fthumb_img%2F2665_thumb_G_1466316807347.jpg",];
    view.clickBlock=^(NSInteger index)
    {
        NSLog(@"\n%zd", index);
    };
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [BLBView myHeight]);
    [self.view addSubview:view];
}
/** 没图 */
- (IBAction)noImageClick:(id)sender {
    self.bannerView.bgImages = @[];
    //banaer图
    self.bannerView.bannerImages = @[];
}

/** 2张图 */
- (IBAction)image2Click:(id)sender {
    self.bannerView.bgImages = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530611999947&di=d366fbc34227cf0509d75a58f694febc&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01d6fc554bb54d000001bf7249bbc1.jpg%401280w_1l_2o_100sh.jpg",
                                 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530611999947&di=07fe1b76eb85f92a3ffcaa6a18472f9e&imgtype=0&src=http%3A%2F%2Fwww.yxad.com%2FNews%2FUploadFiles_1696%2F201802%2F2018022210570295.jpg",];
    //banaer图
    self.bannerView.bannerImages = @[@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1683290459,1218017372&fm=27&gp=0.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530611574285&di=bb110fce807ecb8beaca748d66741738&imgtype=0&src=http%3A%2F%2Fwww.czhmall.com%2Fimages%2F201606%2Fthumb_img%2F2665_thumb_G_1466316807347.jpg",];
}
//3张图
- (IBAction)image3Click:(id)sender {
    self.bannerView.bgImages = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530611999947&di=d366fbc34227cf0509d75a58f694febc&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01d6fc554bb54d000001bf7249bbc1.jpg%401280w_1l_2o_100sh.jpg",
                                 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530611999947&di=07fe1b76eb85f92a3ffcaa6a18472f9e&imgtype=0&src=http%3A%2F%2Fwww.yxad.com%2FNews%2FUploadFiles_1696%2F201802%2F2018022210570295.jpg",
                                 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530615879082&di=5c71d2513d0de511a6222630566f016e&imgtype=0&src=http%3A%2F%2Fimg.meyet.com%2Fforum%2Fmonth_1006%2F10062011315e3ae965b63d0ea7.jpg"];
    //banaer图
    self.bannerView.bannerImages = @[@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1683290459,1218017372&fm=27&gp=0.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530611574285&di=bb110fce807ecb8beaca748d66741738&imgtype=0&src=http%3A%2F%2Fwww.czhmall.com%2Fimages%2F201606%2Fthumb_img%2F2665_thumb_G_1466316807347.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530615879082&di=4d5740ca30457e997ffda36f9f78a914&imgtype=0&src=http%3A%2F%2Fimgres.roboo.com%2Fgroup8%2FM00%2F80%2FB2%2FwKhkDVdjUJmAIYHgAABXiMDlHOY954.jpg"];
    
}

@end
