//
//  TXBYScrollView.m
//  ScrollViewTest
//
//  Created by YandL on 16/4/20.
//  Copyright © 2016年 txby. All rights reserved.
//

#import "TXBYScrollView.h"
#import "SDWebImage/UIImageView+WebCache.h"

#define scrollFrame self.frame

@interface TXBYScrollView ()
/**
 *  定时器
 */
@property(nonatomic,strong)NSTimer *timer;
/**
 *  scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  页码
 */
@property (nonatomic, strong) UIPageControl *pageControl;
/**
 *  处理后的图片数组
 */
@property (nonatomic, strong) NSMutableArray *imgArr;
/**
 *  要显示的图片数组
 */
@property (nonatomic, strong) NSArray *allImgArr;
/**
 *  图片类型（本地/网络）
 */
@property (nonatomic, assign) ScrollImageType scrollImageType;
/**
 *  是否自动滚动
 */
@property (nonatomic, assign) BOOL isAutoScroll;

@end

@implementation TXBYScrollView


/**
 *  创建一个循环滚动的scrollview
 *
 *  @param frame           视图frame
 *  @param scrollImageType 图片来源类型
 *  @param arr             图片数组
 *  @param autoScroll      是否自动滚动
 *  @param time            滚动时间
 *
 */
- (instancetype)initWithFrame:(CGRect)frame type:(ScrollImageType)scrollImageType imageArr:(NSArray *)arr isAutoScroll:(BOOL)autoScroll {
    if (self = [super init]) {
        self.frame = CGRectMake((int)frame.origin.x, (int)frame.origin.y, (int)frame.size.width, (int)frame.size.height);
        self.scrollImageType = scrollImageType;
        self.allImgArr = arr;
        self.isAutoScroll = autoScroll;
    }
    return self;
}

/**
 *  设置scrollview的属性
 */
- (void)setScrollProperty {
    [self setUpImages];
    [self setUpScrollView];
}

/**
 *  处理图片地址
 */
- (void)setUpImages {
    self.imgArr = [NSMutableArray array];
    for (id img in self.allImgArr) {
        [self.imgArr addObject:img];
    }
    [self.imgArr addObject:[self.imgArr objectAtIndex:0]];
    [self.imgArr insertObject:[self.imgArr objectAtIndex:self.imgArr.count - 2] atIndex:0];
}

/**
 *  设置视图
 */
- (void)setUpScrollView {
    // 设置scrollview属性
    // CGRect bounds = scrollFrame;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollFrame.size.width, scrollFrame.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.imgArr.count * scrollFrame.size.width, scrollFrame.size.height);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
    
    [self addSubview:self.scrollView];
    
    // 设置pagecontrol的属性
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(scrollFrame.size.width - 20 * (self.imgArr.count - 2), scrollFrame.size.height - 20, 20 * (self.imgArr.count - 2), 20)];
    
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.pageIndicatorTintColor = self.backPageColor;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageColor;
    self.pageControl.numberOfPages = self.imgArr.count - 2;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    
    
    // 根据图片数组设置scrollview
    float imgViewWidth = scrollFrame.size.width;
    float imgViewHeight = scrollFrame.size.height;
    for (int i = 0; i < self.imgArr.count; i ++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        // 如果是地址
        if (self.scrollImageType == ScrollImageCyber) {
            // 取出图片地址 创建滚动视图
            NSString *imgUrl = self.imgArr[i];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                       placeholderImage:nil];
        }
        // 是图片
        else {
            // 取出图片
            UIImage *img = self.imgArr[i];
            imgView.image = img;
        }
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.frame = CGRectMake(imgViewWidth * i, 0, imgViewWidth, imgViewHeight);
        imgView.userInteractionEnabled = YES;
        // 添加单击手势
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imgView addGestureRecognizer:tapGesture];
        [self.scrollView addSubview:imgView];
        
    }
    if (self.isAutoScroll) {
        [self addTimer];
    }
}

/**
 *  图片点击
 */
- (void)handleTap:(UITapGestureRecognizer*)recognizer {
    if ([self.delegate respondsToSelector:@selector(scrollViewClickAtIndex:)]) {
        [self.delegate scrollViewClickAtIndex:[NSIndexPath indexPathForRow:self.pageControl.currentPage inSection:self.tag]];
    }
}

/**
 *  添加定时器
 */
- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollTime target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

/**
 *  移除计时器
 */
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  轮播图片
 */
- (void)nextImage {
    //显示下一张图片
    NSInteger page = 0;
        if (self.pageControl.currentPage == self.imgArr.count - 2) {
            page = 0;
        }
        else {
            page = self.pageControl.currentPage + 1;
        }
    CGFloat offSetX = (page + 1 ) * self.scrollView.frame.size.width;
    CGPoint offSet = CGPointMake(offSetX, 0);
    // 循环滚动
    [self.scrollView setContentOffset:offSet animated:YES];
}

#pragma mark   ===============scrollDelegate===============

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.isAutoScroll) {
        //停止计时器
        [self removeTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.isAutoScroll) {
        //开启定时器
        [self addTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int width = scrollFrame.size.width;
    if ((int)scrollView.contentOffset.x % width == 0) {
        int page = (int)scrollView.contentOffset.x / width - 1;
        // 当前页码
        self.pageControl.currentPage = page;
    }
    if (((int)scrollView.contentOffset.x) / width == self.imgArr.count - 1) {
        if (((int)scrollView.contentOffset.x) % width == 0) {
            [self.scrollView setContentOffset:CGPointMake(width, 0)];
        }
    }
    else if ((int)scrollView.contentOffset.x == 0) {
        [self.scrollView setContentOffset:CGPointMake(width * (self.imgArr.count - 2), 0)];
    }
}

@end
