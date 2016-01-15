//
//  HMEndPointButton.m
//  HMChart
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "HMEndPointButton.h"

@implementation HMPointShowMessageView

- (instancetype)initWithUserInfo:(HMValue *)userInfo superView:(UIView *)superView {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        HMValue *value = (HMValue *)userInfo;
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.text = [NSString stringWithFormat:@"  x:%.2f  \n  y:%.2f  ", value.x, value.y];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.messageLabel.font = FONT(9);
        self.messageLabel.textColor = [UIColor darkTextColor];
        [self.messageLabel sizeToFit];
        self.messageLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
        self.messageLabel.clipsToBounds = YES;
        self.messageLabel.layer.cornerRadius = 5;
        [self addSubview:self.messageLabel];
        
        [superView addSubview:self];
        
        self.alpha = 0;
        self.showMessage = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    self.showMessage = !self.showMessage;
}

- (void)setShowPoint:(CGPoint)showPoint circleRadius:(CGFloat)circleRadius {
    
    CGSize labelSize = self.messageLabel.frame.size;
    labelSize.width += 10;
    labelSize.height += 10;
    CGFloat arrowHeight = 4;
    
    self.frame = CGRectMake(showPoint.x - labelSize.width / 2, showPoint.y - labelSize.height - arrowHeight - circleRadius, labelSize.width, labelSize.height + arrowHeight + circleRadius);
    self.messageLabel.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    
    [self setNeedsDisplay];
}

- (void)setShowMessage:(BOOL)showMessage {
    _showMessage = showMessage;
    if (_showMessage) {
        self.hidden = NO;
        [UIView animateWithDuration:0.2f animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

- (void)drawRect:(CGRect)rect {
    CGSize labelSize = self.messageLabel.frame.size;
    CGFloat arrowWidth = 3 * 2;
    CGFloat arrowHeight = 4;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, self.messageLabel.backgroundColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.messageLabel.backgroundColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextMoveToPoint(context, labelSize.width / 2 - arrowWidth / 2, labelSize.height);
    CGContextAddLineToPoint(context, labelSize.width / 2, labelSize.height + arrowHeight);
    CGContextAddLineToPoint(context, labelSize.width / 2 + arrowWidth / 2, labelSize.height);
    CGContextAddLineToPoint(context, labelSize.width / 2 - arrowWidth / 2, labelSize.height);
    
    CGContextFillPath(context);
}

@end

@interface HMEndPointButton ()

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint pointCenter;

@end

@implementation HMEndPointButton

+ (HMEndPointButton *)defaultRadius:(CGFloat)radius center:(CGPoint)center userInfo:(id)userInfo delegate:(id)delegate {
    HMEndPointButton *circle = [HMEndPointButton buttonWithType:UIButtonTypeCustom];
    circle.frame = CGRectMake(0, 0, radius * 6, radius * 6);
    circle.center = center;
    circle.backgroundColor = [UIColor clearColor];
    [circle addTarget:circle action:NSSelectorFromString(@"pressCircleArc:") forControlEvents:UIControlEventTouchUpInside];
    circle.userInfo = userInfo;
    circle.delegate = delegate;
    circle.radius = radius;
    [circle setNeedsDisplay];
    
    circle.message = [[HMPointShowMessageView alloc] initWithUserInfo:userInfo superView:delegate];
    [circle.message setShowPoint:center circleRadius:radius];
    return circle;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.radius);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextSetStrokeColorWithColor(context, self.circleColor.CGColor);
    
    CGContextAddArc(context, self.pointCenter.x, self.pointCenter.y, self.radius / 2, 0, M_PI * 2, NO);
    CGContextStrokePath(context);
}

- (void)pressCircleArc:(HMEndPointButton *)circle {
    
    circle.message.showMessage = !circle.message.showMessage;
    
    if ([circle.delegate respondsToSelector:@selector(pressCircleArc:)]) {
        [circle.delegate pressCircleArc:circle];
    }
}

- (UIColor *)circleColor {
    return _circleColor ? _circleColor : [UIColor redColor];
}

- (CGPoint)pointCenter {
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    return center;
}

@end
