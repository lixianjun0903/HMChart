//
//  ViewController.m
//  HMChart
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "ViewController.h"
#import "HMChartView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.scrollView.contentSize = CGSizeMake(500, self.scrollView.contentSize.height);

}

- (IBAction)addBarChartView:(id)sender {
    HMValue *value1 = [HMValue getX:10 y:10 color:[UIColor redColor]];
    HMValue *value2 = [HMValue getX:30 y:120 color:[UIColor cyanColor]];
    HMValue *value3 = [HMValue getX:60 y:80 color:[UIColor yellowColor]];
    HMValue *value4 = [HMValue getX:80 y:10 color:[UIColor blackColor]];
    HMValue *value5 = [HMValue getX:100 y:100 color:[UIColor blueColor]];
    HMValue *value6 = [HMValue getX:110 y:109 color:[UIColor greenColor]];
    HMValue *value7 = [HMValue getX:150 y:90 color:[UIColor grayColor]];
    HMValue *value8 = [HMValue getX:180 y:60 color:[UIColor lightGrayColor]];
    
    NSArray *dataArray = @[value1, value2, value3, value4, value5, value6, value7, value8];
    
    HMBarChartView *barchart = [[HMBarChartView alloc] initWithFrame:CGRectMake(0, 0, 1000, CGRectGetHeight(self.scrollView.frame)) dataArray:dataArray];
    
    barchart.xDistance = 40;
    barchart.ySectionNum = 9;
    barchart.barWidth = 20;
    barchart.animation = YES;
    [self.scrollView addSubview:barchart];
    
    [barchart HMBarChartViewClickedCompletion:^(id returnValue) {
        NSLog(@"%@", returnValue);
    }];
    
    [self removeOtherSubview:barchart];
}

- (IBAction)addBrokenLineChartView:(id)sender {
    
    HMValue *value1 = [HMValue getX:10 y:10];
    HMValue *value2 = [HMValue getX:30 y:120];
    HMValue *value3 = [HMValue getX:60 y:80];
    HMValue *value4 = [HMValue getX:80 y:10];
    HMValue *value5 = [HMValue getX:100 y:100];
    HMValue *value6 = [HMValue getX:110 y:109];
    HMValue *value7 = [HMValue getX:150 y:90];
    HMValue *value8 = [HMValue getX:180 y:60];
    
    NSArray *valueArray = @[value1, value2, value3, value4, value5, value6, value7, value8];
    
    HMBrokenlineChartView *brokenline = [[HMBrokenlineChartView alloc] initWithFrame:CGRectMake(0, 0, 1000, CGRectGetHeight(self.scrollView.frame)) dataArray:valueArray];
    
    brokenline.animation = YES;
    brokenline.xSectionNum = 10;
    brokenline.ySectionNum = 10;
    brokenline.needCloud = YES;
    brokenline.showPoint = YES;
    [self.scrollView addSubview:brokenline];

    [brokenline HMBrokenlineChartViewClickedCompletion:^(id returnValue) {
        NSLog(@"%@", returnValue);
    }];
    
    [self removeOtherSubview:brokenline];

}

- (IBAction)addPieChartView:(id)sender {
    HMPieValue *value1 = [HMPieValue getNumber:30 color:[UIColor redColor] text:@"1"];
    HMPieValue *value2 = [HMPieValue getNumber:20 color:[UIColor blueColor] text:@"2"];
    HMPieValue *value3 = [HMPieValue getNumber:40 color:[UIColor greenColor] text:@"3"];
    HMPieValue *value4 = [HMPieValue getNumber:50 color:[UIColor grayColor] text:@"4"];
    HMPieValue *value5 = [HMPieValue getNumber:60 color:[UIColor magentaColor] text:@"5"];
    
    HMPieChartView *pieChart = [[HMPieChartView alloc] initWithFrame:CGRectMake(10, 10, 200, 150) dataArray:@[value1, value2, value3, value4, value5]];
    pieChart.radius = 100;
    pieChart.needAnimation = YES;
    pieChart.draWAlong = YES;
    pieChart.showText = YES;
    [self.scrollView addSubview:pieChart];

    [pieChart HMPieChartViewClickedCompletion:^(NSInteger index, id returnValue) {
        NSLog(@"%zd, %@", index, returnValue);
    }];
    
    [self removeOtherSubview:pieChart];
}

// remove other subview
- (void)removeOtherSubview:(UIView *)thisSubview {
    for (UIView *subView in self.scrollView.subviews) {
        if (thisSubview != subView && ![subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
}

@end
