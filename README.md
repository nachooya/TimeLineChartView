TimeLineChartView
=================

iOS UIView to show Timelines in a Chart

![Alt text](/example.png?raw=true "TimeLineChartView")

# Usage

Copy TimeLineChartView.? files to your project.
Then instanciate the view and add lines and events:

```
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

    [self.view addSubview:timeLineChartView];
}
```