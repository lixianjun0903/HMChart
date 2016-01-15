//
//  HMEndPointButton.h
//  HMChart
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMChartBackgroundView.h"

@class HMEndPointButton;

/// 折线端点点击协议
@protocol HMEndPointButtonDelegate <NSObject>

- (void)pressCircleArc:(HMEndPointButton *)circle;

@end

/// 提示内容
@interface HMPointShowMessageView : UIView

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, assign) BOOL showMessage;

- (instancetype)initWithUserInfo:(HMValue *)userInfo superView:(UIView *)superView;

- (void)setShowPoint:(CGPoint)showPoint circleRadius:(CGFloat)circleRadius;

@end

/// 折线端点
@interface HMEndPointButton : UIButton

@property (nonatomic, weak)   id delegate;
@property (nonatomic, strong) id userInfo;

@property (nonatomic, strong) HMPointShowMessageView *message;

@property (nonatomic, strong) UIColor *circleColor;

+ (HMEndPointButton *)defaultRadius:(CGFloat)radius center:(CGPoint)center userInfo:(id)userInfo delegate:(id)delegate;

@end
