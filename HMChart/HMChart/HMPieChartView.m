//
//  HMPieChartView.m
//  HMChart
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "HMPieChartView.h"

#define TEXT_TAG 10000

@interface HMPieChartLayer : CAShapeLayer

// layer位置
@property (nonatomic, assign) NSInteger index;
// 所占百分比
@property (nonatomic, assign) CGFloat percent;
// 显示text
@property (nonatomic, strong) NSString *text;
// info
@property (nonatomic, strong) id userInfo;

// 添加动画方法
- (void)addArcAnimationForKeypath:(NSString *)keyPath
                        fromValue:(CGFloat)fromValue
                          toValue:(CGFloat)toValue
                         duration:(CGFloat)duration
                         delegate:(id)delegate;

@end

@implementation HMPieChartLayer

- (void)addArcAnimationForKeypath:(NSString *)keyPath
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

@implementation HMPieValue

+ (HMPieValue *)getNumber:(CGFloat)number color:(UIColor *)color text:(NSString *)text {
    HMPieValue *pie = [[HMPieValue alloc] init];
    pie.number = number;
    pie.color = color ? color : [UIColor clearColor];
    pie.text = text;
    return pie;
}

- (NSString *)text {
    if (_text) { return _text; } else { return @""; }
}

@end

@interface HMPieChartView ()

@property (nonatomic, copy) CompletionIndexWithValue completionIndexWithValue;

@property (nonatomic, weak) id delegate;
/// 百分比
@property (nonatomic, strong) NSMutableArray *percentArray;
/// 弧度
@property (nonatomic, strong) NSMutableArray *angleArray;

@property (nonatomic, assign) CGPoint pieCenter;

@end


@implementation HMPieChartView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self buildDataSource:dataArray];
    }
    return self;
}


- (void)dealloc {
    self.completionIndexWithValue = nil;
}

- (void)buildDataSource:(NSArray<HMPieValue *> *)dataArray {
    self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    
    __block CGFloat totalNumber = 0;
    [dataArray enumerateObjectsUsingBlock:^(HMPieValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalNumber += obj.number;
    }];
    
    __block NSMutableArray *percentArray = [NSMutableArray array];
    __block NSMutableArray *angleArray = [NSMutableArray array];
    [dataArray enumerateObjectsUsingBlock:^(HMPieValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat percent = obj.number / totalNumber;
        CGFloat angle = [self convertAngle:percent];
        [percentArray addObject:@(percent)];
        [angleArray addObject:@(angle)];
    }];
    self.percentArray = [NSMutableArray arrayWithArray:percentArray];
    self.angleArray = [NSMutableArray arrayWithArray:angleArray];
}

- (void)drawRect:(CGRect)rect {
    
    for (int i = 0; i < self.dataArray.count; i ++) {
        UIView *subview = (UIView *)[self viewWithTag:i + TEXT_TAG];
        [subview removeFromSuperview];
    }
    
    __block CGFloat startAngle = 0;
    __block CGFloat endAngle = 0;
    
    __weak __typeof(self) weakSelf = self;
    
    [self.angleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat durationAngle = [obj floatValue];
        startAngle = endAngle;
        endAngle = durationAngle + startAngle;
        
        [weakSelf drawPinTogetherStartAngle:startAngle endAngle:endAngle index:idx];
    }];
    
    if (!self.draWAlong && self.needAnimation) {
        // 动画覆盖蒙板，太特么假了
        HMPieChartLayer *masKLayer = [HMPieChartLayer layer];
        masKLayer.lineWidth = self.radius;
        masKLayer.lineCap = kCALineCapButt;
        masKLayer.strokeColor = [UIColor whiteColor].CGColor;
        masKLayer.fillColor = [UIColor clearColor].CGColor;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, &CGAffineTransformIdentity, self.pieCenter.x, self.pieCenter.y, self.radius / 2, 0, M_PI * 2, NO);
        
        [masKLayer addArcAnimationForKeypath:@"strokeEnd" fromValue:0 toValue:1 duration:self.duration delegate:self];
        
        masKLayer.path = path;
        self.layer.mask = masKLayer;
    }
}

// multi path
- (void)drawPinTogetherStartAngle:(CGFloat)startAngle
                         endAngle:(CGFloat)endAngle
                            index:(NSUInteger)index {
    
    HMPieValue *pieValue = self.dataArray[index];
    
    HMPieChartLayer *layer = [HMPieChartLayer layer];
    layer.lineWidth = 0;
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.fillColor = pieValue.color.CGColor;
    layer.lineCap = kCALineCapButt;
    
    layer.index = index;
    layer.userInfo = self.dataArray[index];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, self.pieCenter.x, self.pieCenter.y);
    CGPathAddArc(path, &CGAffineTransformIdentity, self.pieCenter.x, self.pieCenter.y, self.radius, startAngle, endAngle, NO);
    
    layer.path = path;
    [self.layer addSublayer:layer];
    
    if (self.showText) {
        /// 添加文字
        [self showText:pieValue.text startAngle:startAngle endAngle:endAngle index:index];
    }
    
    if (self.draWAlong && self.needAnimation) {
        HMPieChartLayer *masKLayer = [HMPieChartLayer layer];
        masKLayer.lineCap = kCALineCapButt;
        masKLayer.lineWidth = self.radius;
        masKLayer.strokeColor = [UIColor whiteColor].CGColor;
        masKLayer.fillColor = [UIColor clearColor].CGColor;
        
        CGMutablePathRef masKPath = CGPathCreateMutable();
        CGPathAddArc(masKPath, &CGAffineTransformIdentity, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2, self.radius / 2, startAngle, endAngle, NO);
        
        masKLayer.path = masKPath;
        layer.mask = masKLayer;
        
        [masKLayer addArcAnimationForKeypath:@"strokeEnd" fromValue:0 toValue:1 duration:self.duration delegate:self];
    }
}

- (void)showText:(NSString *)text
      startAngle:(CGFloat)startAngle
        endAngle:(CGFloat)endAngle
           index:(NSInteger)index {
    
    UIView *temPView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.radius * 2, 50)];
    temPView.center = self.pieCenter;
    temPView.backgroundColor = [UIColor clearColor];
    UILabel *texTLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    texTLabel.text = text;
    texTLabel.textColor = [UIColor darkTextColor];
    texTLabel.backgroundColor = [UIColor clearColor];
    texTLabel.textAlignment = NSTextAlignmentCenter;
    texTLabel.font = [UIFont systemFontOfSize:12];
    texTLabel.center = CGPointMake(self.radius + self.radius / 2, CGRectGetHeight(temPView.frame) / 2);
    texTLabel.transform = CGAffineTransformMakeRotation(M_PI / 2);
    [temPView addSubview:texTLabel];
    temPView.transform = CGAffineTransformMakeRotation((startAngle + endAngle) / 2);
    [self addSubview:temPView];
    temPView.tag = TEXT_TAG + index;
    temPView.hidden = YES;
}

// 根据百分比返回弧度
- (CGFloat)convertAngle:(CGFloat)percent {
    return 2 * M_PI * percent;
}

- (CGFloat)radius {
    CGFloat defaultRadius = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) / 2;
    return _radius < defaultRadius ? _radius : defaultRadius;
}

- (CGFloat)duration {
    return (_duration != 0) ? _duration : 1.f;
}

- (CGPoint)pieCenter {
    return CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
}

/// Touches Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    [self touchLayerWithPoint:point];
}

- (void)touchLayerWithPoint:(CGPoint)point {
    
    NSMutableArray *sublayersArray = [NSMutableArray array];
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[HMPieChartLayer class]]) {
            [sublayersArray addObject:layer];
        }
    }
    
    [sublayersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HMPieChartLayer *layer = (HMPieChartLayer *)obj;
        CGPathRef path = layer.path;
        
        if (CGPathContainsPoint(path, &CGAffineTransformIdentity, point, NO)) {
            [self clickedOnPartlayer:layer];
        }
    }];
}

- (void)clickedOnPartlayer:(HMPieChartLayer *)layer {
    if (self.completionIndexWithValue) {
        self.completionIndexWithValue(layer.index, layer.userInfo);
    }
}

- (void)HMPieChartViewClickedCompletion:(CompletionIndexWithValue)completionIndexWithValue {
    self.completionIndexWithValue = completionIndexWithValue;
}

/// CAAnimation Delegate
- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    for (int i = 0; i < self.dataArray.count; i ++) {
        UIView *subview = (UIView *)[self viewWithTag:i + TEXT_TAG];
        subview.hidden = NO;
    }
}

@end
