//
//  HMBrokenlineChartView.h
//  HMChart
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "HMChartBackgroundView.h"
#import "Config.h"

@interface HMBrokenlineChartView : HMChartBackgroundView

// 是否需要阴影
@property (nonatomic, assign) BOOL needCloud;

// 是否需要圆点
@property (nonatomic, assign) BOOL showPoint;

// 折线颜色
@property (nonatomic, strong) UIColor *lineColor;

// 阴影颜色
@property (nonatomic, strong) UIColor *cloudColor;

/// 折线端点点击回调
- (void)HMBrokenlineChartViewClickedCompletion:(CompletionValue)completionValue;

@end
