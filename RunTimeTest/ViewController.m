//
//  ViewController.m
//  RunTimeTest
//
//  Created by dcj on 16/3/30.
//  Copyright © 2016年 YQ. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "Student.h"

@interface ViewController ()

{
    NSTimer *_timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    unsigned int outCount = 0;
    Ivar *vars = class_copyIvarList([Student class], &outCount); // 获取到所有的成员变量列表
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = vars[i]; // 取出第i个位置的成员变量
        
        const char *propertyName = ivar_getName(ivar); // 获取变量名
        const char *propertyType = ivar_getTypeEncoding(ivar); // 获取变量编码类型
        printf("---%s--%s\n", propertyName, propertyType);
        
    }
     */
    [self initSomeADInfo];

    _timer =  [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(initSomeADInfo) userInfo:nil repeats:YES];  

}
- (BOOL)validateEmail:(NSString *)email
{
    //是否是邮箱 
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//正则判断手机号码格式
- (BOOL)validatePhone:(NSString *)phone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        if([regextestcm evaluateWithObject:phone] == YES) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:phone] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:phone] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else 
    {
        return NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//广电通广告
- (void)initSomeADInfo{
    [_bannerView removeFromSuperview];
    /*
     * 创建Banner干告View *
     * banner条的宽度开发者可以进行手动设置,用以满足开发场景需求或是适配最新版本的iphone
     * banner条的高度干点通侧强烈建议开发者采用推荐的高度,否则显示效果会有影响
     * 干点通提供3种尺寸供开发者在不同设备上使用,这里以320*50为例 */
    
    _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 100, 320, 48) appkey:@"100720253" placementId:@"9079537207574943610"];
    
    _bannerView.delegate = self; // 设置Delegate
    _bannerView.currentViewController = self; //设置当前的ViewController 
    _bannerView.interval = 0; //【可选】设置干告轮播时间;范围为30~120秒,0表示不轮播
    
    _bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭
    _bannerView.showCloseBtn = YES; //【可选】展示关闭按钮;默认显示
    _bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
    
    [self.view addSubview:_bannerView]; //添加到当前的view中 
    
    [_bannerView loadAdAndShow]; //加载干告并展示
}

// 请求干告条数据成功后调用
- (void)bannerViewDidReceived{

    NSLog(@"回调成功");
}


// 请求干告条数据失败后调用
- (void)bannerViewFailToReceived:(NSError *)error{
    NSLog(@"回调失败");

} 


// 应用进入后台时调用
- (void)bannerViewWillLeaveApplication{
    
    
}

// 广告条曝光回调
- (void)bannerViewWillExposure
{

}
// 广告条点击回调
- (void)bannerViewClicked
{
    NSLog(@"点击广告条");


}

// banner条被用户关闭时调用
- (void)bannerViewWillClose{

}

- (void)getLinkFromText{

    NSString *string = @"";
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [string substringWithRange:match.range];
        　　　　 NSLog(@"substringForMatch");
    }
}

- (void)dealloc{

    _bannerView.delegate = nil;
    _bannerView.currentViewController = nil;
}
@end
