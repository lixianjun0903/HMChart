//
//  HMBarChartView.m
//  HMChart
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "HMBarChartView.h"

#define MASKPATH_TAG 20000

@interface HMBarChartView ()

@property (nonatomic, copy) CompletionValue completionValue;

@end

@implementation HMBarChartView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray {
    self = [super initWithFrame:frame dataArray:dataArray];
    if (self) {
        chartType = ChartTypeBar;
    }
    return self;
}

- (void)dealloc {
    self.completionValue = nil;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    for (CALayer *sublayer in self.layer.sublayers) {
        if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
            [sublayer removeFromSuperlayer];
        }
    }
    
    [self.dataArray enumerateObjectsUsingBlock:^(HMValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self drawBarChart:obj i:idx];
    }];
}

- (void)drawBarChart:(HMValue *)value i:(NSInteger)i {
    HMBasicLayer *barlayer = [HMBasicLayer layer];
    barlayer.lineCap = kCALineCapButt;
    barlayer.lineWidth = self.barWidth;
    barlayer.fillColor = [self convertColor:value.color].CGColor;
    barlayer.strokeColor = [self convertColor:value.color].CGColor;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, MARGIN_LEFT + (i + 1) * self.xDistance, [self getFrameY:0]);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, MARGIN_LEFT + (i + 1) * self.xDistance, [self getFrameY:value.y]);
    
    barlayer.path = path;
    [self.layer addSublayer:barlayer];
    CGPathRelease(path);
    
    if (self.animation) {
        [barlayer addAnimationForKeypath:@"strokeEnd" fromValue:0 toValue:1 duration:self.duration delegate:self];
    }
    
    [self addMaskClickedPath:i value:value superLayer:barlayer];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (UIColor *)convertColor:(UIColor *)color {
    if (color != [UIColor whiteColor] && color != [UIColor clearColor] && color != nil) {
        return color;
    }
    return self.backgroundColor;
}

- (UIColor *)barColor {
    return _barColor ? _barColor : [UIColor lightGrayColor];
}

- (CGFloat)barWidth {
    return _barWidth ? _barWidth : 12;
}

/// Touch Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    [self touchLayerWithPoint:point];
}

- (void)touchLayerWithPoint:(CGPoint)point {
    NSMutableArray *subbarLayers = [NSMutableArray array];
    for (CALayer *sublayer in self.layer.sublayers) {
        if ([sublayer isKindOfClass:[HMBasicLayer class]]) {
            if (((HMBasicLayer *)sublayer).tag == MASKPATH_TAG) {
                [subbarLayers addObject:sublayer];
            }
        }
    }
    __weak __typeof(self) weakSelf = self;
    
    [subbarLayers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HMBasicLayer *layer = (HMBasicLayer *)obj;
        CGPathRef path = layer.path;
        if (CGPathContainsPoint(path, &CGAffineTransformIdentity, point, NO)) {
            if (weakSelf.completionValue) {
                weakSelf.completionValue(layer.userInfo);
            }
        }
    }];
}

- (void)HMBarChartViewClickedCompletion:(CompletionValue)completionValue {
    self.completionValue = completionValue;
}


/// CAAnimation Delegate
- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)addMaskClickedPath:(NSInteger)index value:(HMValue *)value superLayer:(HMBasicLayer *)superLayer {
    HMBasicLayer *barlayer = [HMBasicLayer layer];
    barlayer.lineCap = kCALineCapButt;
    barlayer.fillColor = [UIColor clearColor].CGColor;
    
    barlayer.userInfo = value;
    barlayer.currenTIndex = index;
    barlayer.tag = MASKPATH_TAG;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(MARGIN_LEFT + (index + 1) * self.xDistance - self.barWidth / 2, [self getFrameY:value.y], self.barWidth, [self getFrameY:0] - [self getFrameY:value.y]));
    barlayer.path = path;
    [self.layer addSublayer:barlayer];
    CGPathRelease(path);
}

@end
