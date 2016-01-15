//
//  HMChartBackgroundView.h
//  HMChart
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CoreFoundation/CFBase.h>

typedef NS_ENUM(NSUInteger, ChartType) {
    ChartTypeBrokenline,
    ChartTypeBar,
};

#define FONT(x) [UIFont systemFontOfSize:x]

#define MARGIN_LEFT 35              // 统计图的左间隔
#define MARGIN_TOP 50               // 统计图的顶部间隔
#define MARGIN_BETWEEN_X_POINT 50   // X轴的坐标点的间距
#define Y_SECTION 5                 // 纵坐标轴的区间数

@interface HMBasicLayer : CAShapeLayer

/// 标示
@property (nonatomic, assign) NSInteger tag;
/// layer位置
@property (nonatomic, assign) NSInteger currenTIndex;
/// 所占百分比
@property (nonatomic, assign) CGFloat percent;
/// 显示text
@property (nonatomic, strong) NSString *text;
/// info
@property (nonatomic, strong) id userInfo;

/// Add Animation Method
- (void)addAnimationForKeypath:(NSString *)keyPath fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration delegate:(id)delegate;

@end

@interface HMValue : NSObject

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, strong) UIColor *color;

+ (HMValue *)getX:(CGFloat)x y:(CGFloat)y color:(UIColor *)color;

+ (HMValue *)getX:(CGFloat)x y:(CGFloat)y;

@end

@interface HMChartBackgroundView : UIView {
    ChartType chartType;
}

@property (nonatomic, assign) CGFloat maxXValue;
@property (nonatomic, assign) CGFloat maxYValue;

@property (nonatomic, assign) CGFloat perXValue;
@property (nonatomic, assign) CGFloat perYValue;

/// X、Y轴描述字体颜色
@property (nonatomic, strong) UIColor *xValueTextColor;
@property (nonatomic, strong) UIColor *yValueTextColor;
/// X、Y轴描述字体大小
@property (nonatomic, assign) CGFloat xValueFont;
@property (nonatomic, assign) CGFloat yValueFont;
/// X、Y分区数量
@property (nonatomic, assign) NSInteger xSectionNum;
@property (nonatomic, assign) NSInteger ySectionNum;
/// X、Y轴默认间隔
@property (nonatomic, assign) CGFloat xDistance;
@property (nonatomic, assign) CGFloat yDistance;

@property (nonatomic, assign) CGFloat marKWidth;
/// 是否需要动画
@property (nonatomic, assign) BOOL animation;
/// 动画执行时间
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, strong) NSMutableArray<HMValue *> *dataArray;

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray;

// 坐标转换
- (CGFloat)getFrameX:(CGFloat)x;
- (CGFloat)getFrameY:(CGFloat)y;

@end
