//
//  ViewController.h
//  RunTimeTest
//
//  Created by dcj on 16/3/30.
//  Copyright © 2016年 YQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTMobBannerView.h" //导入GDTMobBannerView.h头文件

@interface ViewController : UIViewController<GDTMobBannerViewDelegate> {
    GDTMobBannerView *_bannerView;//声明一个GDTMobBannerView的实例 
}


@end

