//
//  HMChartBackgroundView.m
//  HMChart
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "HMChartBackgroundView.h"

@implementation HMBasicLayer

- (void)addAnimationForKeypath:(NSString *)keyPath
                     fromValue:(CGFloat)fromValue
                       toValue:(CGFloat)toValue
                      duration:(CGFloat)duration
                      delegate:(id)delegate {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.duration = duration;
    animation.delegate = delegate;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    [self addAnimation:animation forKey:keyPath];
}

- (NSString *)text {
    if (_text) { return _text; } else { return @""; }
}

@end

@implementation HMValue

+ (HMValue *)getX:(CGFloat)x y:(CGFloat)y color:(UIColor *)color {
    HMValue *value = [HMValue getX:x y:y];
    value.color = color;
    return value;
}

+ (HMValue *)getX:(CGFloat)x y:(CGFloat)y {
    HMValue *value = [[HMValue alloc] init];
    value.x = x;
    value.y = y;
    return value;
}

- (UIColor *)color {
    return _color ? _color : [UIColor clearColor];
}

@end

@implementation HMChartBackgroundView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        [self getMaxValue:dataArray];
    }
    return self;
}

// Get Max Value
- (void)getMaxValue:(NSArray *)dataArray {
    self.maxXValue = 0;
    self.maxYValue = 0;
    
    for (HMValue *value in self.dataArray) {
        self.maxXValue = self.maxXValue > value.x ? self.maxXValue : value.x;
        self.maxYValue = self.maxYValue > value.y ? self.maxYValue : value.y;
    }
}

- (void)drawRect:(CGRect)rect {
    
    self.perXValue = self.maxXValue / self.xSectionNum;
    self.perYValue = self.maxYValue / self.ySectionNum;
    
    CGContextRef lineContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(lineContext, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(lineContext, [UIColor brownColor].CGColor);
    CGContextSetLineCap(lineContext, kCGLineCapButt);
    CGContextSetLineJoin(lineContext, kCGLineJoinBevel);
    CGContextSetLineWidth(lineContext, 0.5f);
    
    // 绘制横线
    for (NSInteger i = 0; i <= self.ySectionNum; i ++) {
        CGPoint startPoint = CGPointMake(MARGIN_LEFT, MARGIN_TOP + i * self.yDistance);
        CGPoint endPoint = CGPointMake(MARGIN_LEFT + self.xDistance * (self.xSectionNum + 1), MARGIN_TOP + i * self.yDistance);
        [self horizontalAddLineStartPoint:startPoint endPoint:endPoint context:lineContext];
    }
    
    // 绘制竖线
    for (NSInteger i = 0; i < 2; i ++) {
        CGPoint startPoint = CGPointMake(MARGIN_LEFT + i * self.xDistance * (self.xSectionNum + 1), MARGIN_TOP);
        CGPoint endPoint = CGPointMake(MARGIN_LEFT + i * self.xDistance * (self.xSectionNum + 1), MARGIN_TOP + self.yDistance * self.ySectionNum);
        [self verticalAddLineStartPoint:startPoint endPoint:endPoint context:lineContext];
    }
    
    // 添加描述
    if (chartType == ChartTypeBrokenline) {
        /**
         * 折线图
         */
        // add xValue
        for (NSInteger i = 1; i <= self.xSectionNum; i ++) {
            NSString *xValue = [NSString stringWithFormat:@"%.2f", self.perXValue * i];
            UILabel *xLabel = [self addXValue:xValue frame:CGRectMake(0, 0, self.xDistance, 30)];
            xLabel.center = CGPointMake(MARGIN_LEFT + i * self.xDistance, MARGIN_TOP + 10 + self.yDistance * self.ySectionNum);
            [self addSubview:xLabel];
        }
        
        // add yValue
        for (NSInteger i = 1; i <= self.ySectionNum; i ++) {
            NSString *yValue = [NSString stringWithFormat:@"%.2f", self.perYValue * i];
            UILabel *yLabel = [self addYValue:yValue frame:CGRectMake(0, 0, 32, 20)];
            CGPoint center = yLabel.center;
            center = CGPointMake(center.x, MARGIN_TOP + (self.ySectionNum - i) * self.yDistance);
            yLabel.center = center;
            [self addSubview:yLabel];
        }
    } else if (chartType == ChartTypeBar) {
        /**
         * 柱状图
         */
        for (NSInteger i = 1; i <= self.xSectionNum; i ++) {
            HMValue *value = self.dataArray[i - 1];
            NSString *xValue = [NSString stringWithFormat:@"%.2f", value.x];
            UILabel *xLabel = [self addXValue:xValue frame:CGRectMake(0, 0, self.xDistance, 30)];
            xLabel.center = CGPointMake(MARGIN_LEFT + i * self.xDistance, MARGIN_TOP + 10 + self.yDistance * self.ySectionNum);
            [self addSubview:xLabel];
        }
        
        // add yValue
        for (NSInteger i = 1; i <= self.ySectionNum; i ++) {
            NSString *yValue = [NSString stringWithFormat:@"%.2f", self.perYValue * i];
            UILabel *yLabel = [self addYValue:yValue frame:CGRectMake(0, 0, 32, 20)];
            CGPoint center = yLabel.center;
            center = CGPointMake(center.x, MARGIN_TOP + (self.ySectionNum - i) * self.yDistance);
            yLabel.center = center;
            [self addSubview:yLabel];
        }
    }
    
    [self addXSectionMark:lineContext];
    CGContextStrokePath(lineContext);
}

/**
 * 绘制坐标及分割线
 */
- (void)horizontalAddLineStartPoint:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint
                            context:(CGContextRef)context {
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
}

- (void)verticalAddLineStartPoint:(CGPoint)startPoint
                         endPoint:(CGPoint)endPoint
                          context:(CGContextRef)context {
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
}

- (void)addXSectionMark:(CGContextRef)context {
    for (NSInteger i = 1; i <= self.xSectionNum; i ++) {
        CGContextMoveToPoint(context, MARGIN_LEFT + i * self.xDistance, MARGIN_TOP + self.ySectionNum * self.yDistance - self.marKWidth);
        CGContextAddLineToPoint(context, MARGIN_LEFT + i * self.xDistance, MARGIN_TOP + self.ySectionNum * self.yDistance);
    }
}

/**
 * x、y 坐标轴 label 添加
 */
- (UILabel *)addXValue:(NSString *)xValue frame:(CGRect)frame {
    UILabel *xLabel = [[UILabel alloc] initWithFrame:frame];
    xLabel.text = xValue;
    xLabel.textAlignment = NSTextAlignmentCenter;
    xLabel.backgroundColor = [UIColor clearColor];
    xLabel.font = FONT(self.xValueFont);
    xLabel.textColor = self.xValueTextColor;
    return xLabel;
}

- (UILabel *)addYValue:(NSString *)yValue frame:(CGRect)frame {
    UILabel *yLabel = [[UILabel alloc] initWithFrame:frame];
    yLabel.text = yValue;
    yLabel.textAlignment = NSTextAlignmentRight;
    yLabel.backgroundColor = [UIColor clearColor];
    yLabel.font = FONT(self.yValueFont);
    yLabel.textColor = self.yValueTextColor;
    return yLabel;
}

// Value Convert To Frame
- (CGFloat)getFrameX:(CGFloat)x {
    CGFloat resultX = (MARGIN_LEFT + (self.xSectionNum * self.xDistance) * (x / self.maxXValue));
    return  resultX;
}

- (CGFloat)getFrameY:(CGFloat)y {
    CGFloat resultY = (MARGIN_TOP + self.ySectionNum * self.yDistance) - ((self.ySectionNum * self.yDistance) * (y / self.maxYValue));
    return resultY;
}

// Get Default Value
- (UIColor *)xValueTextColor {
    return _xValueTextColor ? _xValueTextColor : [UIColor darkTextColor];
}

- (UIColor *)yValueTextColor {
    return _yValueTextColor ? _yValueTextColor : [UIColor darkTextColor];
}

- (CGFloat)xValueFont {
    return (_xValueFont != 0) ? _xValueFont : 9;
}

- (CGFloat)yValueFont {
    return (_yValueFont != 0) ? _yValueFont : 9;
}

- (NSInteger)xSectionNum {
    if (chartType == ChartTypeBar) {
        return self.dataArray.count;
    }
    return (_xSectionNum != 0) ? _xSectionNum : 10;
}

- (NSInteger)ySectionNum {
    return (_ySectionNum != 0) ? _ySectionNum : 5;
}

- (CGFloat)xDistance {
    return (_xDistance != 0) ? _xDistance : 35;
}

- (CGFloat)yDistance {
    return (_yDistance != 0) ? _yDistance : 30;
}

- (CGFloat)marKWidth {
    return (_marKWidth != 0) ? _marKWidth : 2;
}

- (CGFloat)duration {
    return (_duration != 0) ? _duration : 2;
}


@end
