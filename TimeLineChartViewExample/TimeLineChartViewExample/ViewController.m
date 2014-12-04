//
//  ViewController.m
//  TimeLineChartViewExample
//
//  Created by Nacho on 4/12/14.
//  Copyright (c) 2014 nachooya.net. All rights reserved.
//
#import "TimeLineChartView.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    TimeLineChartView* timeLineChartView = [[TimeLineChartView alloc] init];
    [timeLineChartView setFrame:self.view.frame];
    
    [timeLineChartView newTimeLineWithName:@"Line 1"];
    
    [timeLineChartView newEventForTimeLine:@"Line 1" eventName:@"Event 1" startTimeSeconds:0   endTimeSeconds:10];
    [timeLineChartView newEventForTimeLine:@"Line 1" eventName:@"Event 1" startTimeSeconds:10  endTimeSeconds:20];
    [timeLineChartView newEventForTimeLine:@"Line 1" eventName:@"Event 1" startTimeSeconds:30  endTimeSeconds:45];
    [timeLineChartView newEventForTimeLine:@"Line 1" eventName:@"Event 1" startTimeSeconds:45  endTimeSeconds:50];
    
    [timeLineChartView newTimeLineWithName:@"Line 2"];
    
    [timeLineChartView newEventForTimeLine:@"Line 2" eventName:@"Event 1" startTimeSeconds:10   endTimeSeconds:15];
    [timeLineChartView newEventForTimeLine:@"Line 2" eventName:@"Event 1" startTimeSeconds:20  endTimeSeconds:35];
    [timeLineChartView newEventForTimeLine:@"Line 2" eventName:@"Event 1" startTimeSeconds:55  endTimeSeconds:75];
    
    [timeLineChartView newTimeLineWithName:@"Line 3"];
    
    [timeLineChartView newEventForTimeLine:@"Line 3" eventName:@"Event 1" startTimeSeconds:0   endTimeSeconds:10];
    [timeLineChartView newEventForTimeLine:@"Line 3" eventName:@"Event 1" startTimeSeconds:30  endTimeSeconds:45];
    [timeLineChartView newEventForTimeLine:@"Line 3" eventName:@"Event 1" startTimeSeconds:45  endTimeSeconds:50];
    [timeLineChartView newEventForTimeLine:@"Line 3" eventName:@"Event 1" startTimeSeconds:60  endTimeSeconds:70];
    
    [self.view addSubview:timeLineChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
