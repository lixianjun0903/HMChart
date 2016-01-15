//
//  HMBrokenlineChartView.m
//  HMChart
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "HMBrokenlineChartView.h"

@interface HMBrokenlineChartView () <HMEndPointButtonDelegate>

@property (nonatomic, copy) CompletionValue completionValue;

@end

@implementation HMBrokenlineChartView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray {
    self = [super initWithFrame:frame dataArray:dataArray];
    if (self) {
        chartType = ChartTypeBrokenline;
    }
    return self;
}

- (void)dealloc {
    self.completionValue = nil;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    HMBasicLayer *linelayer = [HMBasicLayer layer];
    linelayer.lineCap = kCALineCapRound;
    linelayer.lineJoin = kCALineJoinBevel;
    linelayer.lineWidth = 0.5f;
    linelayer.strokeColor = self.lineColor.CGColor;
    linelayer.fillColor = [UIColor clearColor].CGColor;
    
    CGMutablePathRef linepath = CGPathCreateMutable();
    for (NSInteger i = 0; i < self.dataArray.count - 1; i ++) {
        HMValue *startValue = self.dataArray[i];
        HMValue *endValue   = self.dataArray[i + 1];
        
        CGPathMoveToPoint(linepath, &CGAffineTransformIdentity, [self getFrameX:startValue.x], [self getFrameY:startValue.y]);
        CGPathAddLineToPoint(linepath, &CGAffineTransformIdentity, [self getFrameX:endValue.x], [self getFrameY:endValue.y]);
    }
    linelayer.path = linepath;
    [self.layer addSublayer:linelayer];
    CGPathRelease(linepath);
    
    if (self.animation) {
        [linelayer addAnimationForKeypath:@"strokeEnd" fromValue:0 toValue:1 duration:self.duration delegate:self];
    }
    
    if (self.needCloud) {
        CAShapeLayer *cloudlayer = [CAShapeLayer layer];
        cloudlayer.lineCap = kCALineCapRound;
        cloudlayer.lineJoin = kCALineJoinMiter;
        cloudlayer.lineWidth = 0.f;
        cloudlayer.strokeColor = [UIColor clearColor].CGColor;
        cloudlayer.fillColor = self.cloudColor.CGColor;
        cloudlayer.fillMode = kCAFillModeForwards;
        cloudlayer.fillRule = kCAFillRuleEvenOdd;
        cloudlayer.frame = rect;
        
        CGMutablePathRef cloudpath = CGPathCreateMutable();
        
        HMValue *firstValue = self.dataArray.firstObject;
        CGPathMoveToPoint(cloudpath, &CGAffineTransformIdentity, [self getFrameX:firstValue.x], [self getFrameY:firstValue.y]);
        
        for (NSInteger i = 0; i < self.dataArray.count; i ++) {
            HMValue *startValue = self.dataArray[i];
            CGPathAddLineToPoint(cloudpath, &CGAffineTransformIdentity, [self getFrameX:startValue.x], [self getFrameY:startValue.y]);
        }
        
        HMValue *lastValue = self.dataArray.lastObject;
        CGPathAddLineToPoint(cloudpath, &CGAffineTransformIdentity, [self getFrameX:lastValue.x], [self getFrameY:0]);
        CGPathAddLineToPoint(cloudpath, &CGAffineTransformIdentity, [self getFrameX:firstValue.x], [self getFrameY:0]);
        CGPathAddLineToPoint(cloudpath, &CGAffineTransformIdentity, [self getFrameX:firstValue.x], [self getFrameY:firstValue.y]);
        
        cloudlayer.path = cloudpath;
        [self.layer addSublayer:cloudlayer];
        CGPathRelease(cloudpath);
    }
}

/// HMEndPointButtonDelegate
- (void)pressCircleArc:(HMEndPointButton *)circle {
    if (self.completionValue) {
        self.completionValue(circle.userInfo);
    }
}

- (UIColor *)lineColor {
    return _lineColor ? _lineColor : [UIColor redColor];
}

- (UIColor *)cloudColor {
    return _cloudColor ? _cloudColor : [UIColor colorWithWhite:0.75 alpha:0.5];
}

/// CAAnimation Delegate
- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.showPoint) {
        [self.dataArray enumerateObjectsUsingBlock:^(HMValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HMEndPointButton *circle = [HMEndPointButton defaultRadius:2.5 center:CGPointMake([self getFrameX:obj.x], [self getFrameY:obj.y]) userInfo:obj delegate:self];
            circle.circleColor = [UIColor redColor];
            [self addSubview:circle];
        }];
    }
}

- (void)HMBrokenlineChartViewClickedCompletion:(CompletionValue)completionValue {
    self.completionValue = completionValue;
}

@end
