//
//  ViewController.m
//  ScrollViewTest
//
//  Created by YandL on 16/4/20.
//  Copyright © 2016年 txby. All rights reserved.
//

#import "ViewController.h"
#import "TXBYScrollView.h"

#define img1 @"http://image.365jilu.com/big/2016/20160415/p1agcj4b0m1que1ro4ko4iv89475.jpg"
#define img2 @"http://image.365jilu.com/big/2016/20160415/p1agcj67ta7701o8bopq571q895.jpg"
#define img3 @"http://image.365jilu.com/big/2016/20160415/p1agcj53eg1v17mmt1fik7s57c35.jpg"
#define img4 @"http://image.365jilu.com/big/2016/20160415/p1agcdn3101soojlb1kiqmluas35.jpg"

@interface ViewController () <TXBYScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = [UIScreen mainScreen].bounds.size;
    // 创建网络图片数组
    NSArray *urlArr = [NSArray arrayWithObjects:img1, img2, img3, img4, img2, img3, nil];
    TXBYScrollView *cyberView = [[TXBYScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.width / 1.5) type:ScrollImageCyber imageArr:urlArr isAutoScroll:YES];
    // 设置代理
    cyberView.delegate = self;
    cyberView.tag = 1000;
    cyberView.scrollTime = 2.5f;
    cyberView.backPageColor = [UIColor redColor];
    cyberView.currentPageColor = [UIColor greenColor];
    [cyberView setScrollProperty];
    [self.view addSubview:cyberView];
    
    // 创建本地图片数组
    NSMutableArray *localImgArr = [NSMutableArray array];
    for (int i = 1; i < 6; i ++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        [localImgArr addObject:img];
    }
    TXBYScrollView *localView = [[TXBYScrollView alloc] initWithFrame:CGRectMake(size.width * 0.25, size.width / 1.5 + 30, size.width * 0.5, size.width * 0.75) type:ScrollImageLocal imageArr:[NSArray arrayWithArray:localImgArr] isAutoScroll:NO];
    // 设置代理
    localView.delegate = self;
    localView.tag = 1001;
    localView.backPageColor = [UIColor lightGrayColor];
    localView.currentPageColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f];
    [localView setScrollProperty];
    [self.view addSubview:localView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark   =========TXBYScrollViewDelegate==========
- (void)scrollViewClickAtIndex:(NSIndexPath *)indexPath {
    NSLog(@"你点击了第%ld个view第%ld张",(long)indexPath.section,(long)indexPath.row);
}

@end
