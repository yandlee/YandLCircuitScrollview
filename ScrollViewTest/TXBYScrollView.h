//
//  TXBYScrollView.h
//  ScrollViewTest
//
//  Created by YandL on 16/4/20.
//  Copyright © 2016年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    // 本地图片
    ScrollImageLocal,
    // 网络图片
    ScrollImageCyber
    
} ScrollImageType;

/**
 *  scrollView点击代理
 */
@protocol TXBYScrollViewDelegate <NSObject>

- (void)scrollViewClickAtIndex:(NSIndexPath *)indexPath;

@end

@interface TXBYScrollView : UIView  <UIScrollViewDelegate>
/**
 *  scrollView点击代理
 */
@property (nonatomic, weak) id<TXBYScrollViewDelegate> delegate;
/**
 *  滚动间隔时间
 */
@property (nonatomic, assign) NSInteger scrollTime;
/**
 *  非当前页码颜色
 */
@property (nonatomic, retain) UIColor *backPageColor;
/**
 *  当前页码颜色
 */
@property (nonatomic, retain) UIColor *currentPageColor;

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
- (instancetype)initWithFrame:(CGRect)frame type:(ScrollImageType)scrollImageType imageArr:(NSArray *)arr isAutoScroll:(BOOL)autoScroll;

/**
 *  设置scrollview的属性
 */
- (void)setScrollProperty;

@end
