//
//  TimeLineView.h
//
//  Created by Nacho on 25/11/14.
//  Copyright (c) 2014 nachooya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineChartView : UIView

- (id)    initWithFrame:       (CGRect)frame;
- (id)    initWithCoder:       (NSCoder *)decoder;
- (void)  layoutSubviews;
- (void)  newTimeLineWithName: (NSString*)name;
- (void)  newEventForTimeLine: (NSString*)name eventName:(NSString*)eventName startTimeSeconds:(double)start endTimeSeconds:(double)end;
- (void)  update;

@end

