//
//  HMBarChartView.h
//  HMChart
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "HMChartBackgroundView.h"
#import "Config.h"

/// 注意: 柱形图设置 xSectionNum 不要小于 [dataArray count]
@interface HMBarChartView : HMChartBackgroundView

@property (nonatomic, strong) UIColor *barColor;

@property (nonatomic, assign) CGFloat barWidth;

/// 柱形图点击回调
- (void)HMBarChartViewClickedCompletion:(CompletionValue)completionValue;

@end
