//
//  HMPieChartView.h
//  HMChart
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface HMPieValue : NSObject

// 每个section的值
@property (nonatomic, assign) CGFloat number;
// 相应section的颜色
@property (nonatomic, strong) UIColor *color;
// 显示text
@property (nonatomic, strong) NSString *text;

+ (HMPieValue *)getNumber:(CGFloat)number color:(UIColor *)color text:(NSString *)text;

@end

@interface HMPieChartView : UIView

// 数据源
@property (nonatomic, strong) NSMutableArray<HMPieValue *> *dataArray;
// 圆饼半径
@property (nonatomic, assign) CGFloat radius;
// 是否需要动画
@property (nonatomic, assign) BOOL needAnimation;
// 动画类型
@property (nonatomic, assign) BOOL draWAlong;
// 动画执行时间
@property (nonatomic, assign) CGFloat duration;
// 是否显示文字
@property (nonatomic, assign) BOOL showText;


- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray;

- (void)HMPieChartViewClickedCompletion:(CompletionIndexWithValue)completionIndexWithValue;

@end
