//
//  MBProgressHUD+Extension.m
//
//  Created by yh on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // radius
    hud.cornerRadius = 3;
    // 透明度
    hud.opacity = .6;
    hud.labelFont = [UIFont systemFontOfSize:14];
    
    hud.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
    UITableView *v = (UITableView *)view;
    if ([v isMemberOfClass:[UITableView class]])
    {
        hud.yOffset = v.contentOffset.y;
    }
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
}

+ (void)showError:(NSString *)error toView:(UIView *)view
{
    [self show:error icon:@"alert_error_icon" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"alert_success_icon" view:view];
}

+ (void)showInfo:(NSString *)info toView:(UIView *)view
{
    [self show:info icon:@"alert_failed_icon" view:view];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    // radius
    hud.cornerRadius = 3;
    // 透明度
    hud.opacity = .6;
    hud.labelFont = [UIFont systemFontOfSize:14];
    
    UITableView *v = (UITableView *)view;
    if ([v isMemberOfClass:[UITableView class]])
    {
        hud.yOffset = v.contentOffset.y;
    }
    
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

@end