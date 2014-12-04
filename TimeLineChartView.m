//
//  TimeLineView.m
//
//  Created by Nacho on 25/11/14.
//  Copyright (c) 2014 nachooya. All rights reserved.
//

#import <objc/runtime.h>
#import "TimeLineChartView.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

uint32_t TimeLineColors[] = {
    0x3366cc,0xdc3912,0xff9900,0x109618,0x990099,0x0099c6,0xdd4477,
    0x66aa00,0xb82e2e,0x316395,0x994499,0x22aa99,0xaaaa11,0x6633cc,
    0xe67300,0x8b0707,0x651067,0x329262,0x5574a6,0x3b3eac,0xb77322,
    0x16d620,0xb91383,0xf4359e,0x9c5935,0xa9c413,0x2a778d,0x668d1c,
    0xbea413,0x0c5922,0x743411
};


@interface TimeLineEvent : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic) double            start;
@property (nonatomic) double            end;
@end

@implementation TimeLineEvent
@synthesize name, start, end;
@end

@interface TimeLineView : UIView
@property UILabel* labelName;
- (id)   initWithName: (NSString*) name;
- (void) setFrame:(CGRect)frame;
- (void) addEvent: (TimeLineEvent*)event rangeSeconds:(double)range color:(uint32_t)color;
@end

static char kTimeLineEventKey;

@implementation TimeLineView
@synthesize labelName;

- (id) initWithName: (NSString*) name {
    self = [super init];
    if (self) {
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
        labelName = [[UILabel alloc] init];
        [labelName setTextColor:[UIColor blackColor]];
        [labelName setText:name];
        [labelName setFont:[UIFont systemFontOfSize:12]];
        labelName.textAlignment = NSTextAlignmentCenter;
        labelName.layer.borderColor = [UIColor lightGrayColor].CGColor;
        labelName.layer.borderWidth = 1.0f;
        
        [self addSubview:labelName];
        
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [labelName setFrame:CGRectMake(0, 0, frame.size.width*0.2, frame.size.height)];
}

- (void) addEvent: (TimeLineEvent*)event rangeSeconds:(double)range color:(uint32_t)color {
    
    UILabel* label = [[UILabel alloc] init];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:event.name];
    [label setBackgroundColor:UIColorFromRGB (color)];

    [label setFont:[UIFont systemFontOfSize:12]];
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0f;
    
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
    [label addGestureRecognizer:tapGesture];
    
    CGFloat x = self.frame.size.width*0.2 + (event.start/range)*self.frame.size.width*0.8;
    CGFloat w = self.frame.size.width*0.8 * ((event.end-event.start)/range);
    
    [label setFrame:CGRectMake (x, 5, w, self.frame.size.height-10)];
    
    [self addSubview:label];
    
    objc_setAssociatedObject (self, &kTimeLineEventKey, event, OBJC_ASSOCIATION_RETAIN);

}

- (void) labelTap:(UIGestureRecognizer *)sender {
    
    UILabel* label = (UILabel*)sender.view;
    
    TimeLineEvent* event = objc_getAssociatedObject (self, &kTimeLineEventKey);
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:label.text
                                                    message:[NSString stringWithFormat:@"%@: %.2fs - %.2fs\nDuration: %.2f seconds", labelName.text, event.start, event.end, (event.end - event.start)]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    
    [toast show];

}


@end

@interface TimeLineChartView() {
    NSMutableDictionary* _timeLines;
    double               _minTime;
    double               _maxTime;
    uint                 _lastColorIndex;
}
@end

@implementation TimeLineChartView

- (id) initWithFrame: (CGRect)frame  {
    
    self = [super initWithFrame:frame];
    if (self) {
        _timeLines      = [[NSMutableDictionary alloc] init];
        _minTime        = DBL_MAX;
        _maxTime        = DBL_MIN;
        _lastColorIndex = 0;
    }
    return self;
}

- (id) initWithCoder: (NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    if (self) {
        _timeLines = [[NSMutableDictionary alloc] init];
        _minTime       = DBL_MAX;
        _maxTime       = DBL_MIN;
    }
    return self;
}

- (void) newTimeLineWithName: (NSString*)name {
    [_timeLines setObject:@{@"index":  [NSNumber numberWithInt:_timeLines.count],
                            @"events": [[NSMutableArray alloc] init]} forKey:name];
}

- (void) newEventForTimeLine: (NSString*)name eventName:(NSString*)eventName startTimeSeconds:(double)start endTimeSeconds:(double)end {
        
    NSMutableArray* timeLine = _timeLines[name][@"events"];
    if (timeLine != nil) {
    
        if (start < _minTime) _minTime = start;
        if (end   > _maxTime) _maxTime = end;
        
        TimeLineEvent* event = [TimeLineEvent alloc];
        event.name  = eventName;
        event.start = start;
        event.end   = end;
        
        [timeLine addObject:event];
    }
}

- (void) update {
    
    _lastColorIndex = 0;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    CGFloat timelineHeight = (height - 20) / [_timeLines count];
    __block CGFloat offsetY = 0;
    
    NSArray* sortedKeys = [_timeLines keysSortedByValueUsingComparator:^(id obj1, id obj2) {
        NSDictionary* o1 = (NSDictionary*)obj1;
        NSDictionary* o2 = (NSDictionary*)obj2;
        return (NSComparisonResult)[o1[@"index"] compare:o2[@"index"]];
    }];
    
    for (NSString* name in sortedKeys) {
        TimeLineView* tv = [[TimeLineView alloc] initWithName:name];
        [tv setFrame:CGRectMake (0, offsetY, width, timelineHeight)];
        [self addSubview:tv];
        offsetY += timelineHeight;
        
        for (TimeLineEvent* event in _timeLines[name][@"events"]) {
            [tv addEvent:event rangeSeconds:_maxTime-_minTime color:TimeLineColors[_lastColorIndex]];
            _lastColorIndex = (_lastColorIndex+1)%(sizeof(TimeLineColors)/sizeof TimeLineColors[0]);
        }
    }
    
    if (_minTime == DBL_MAX || _maxTime == DBL_MIN) return;
    
    int min  = floor (_minTime);
    int max  = ceil  (_maxTime);
    
    UILabel* labelMax = [[UILabel alloc] init];
    [labelMax setTextColor:[UIColor blackColor]];
    [labelMax setText:[NSString stringWithFormat:@"%d", max]];
    [labelMax setFont:[UIFont systemFontOfSize:12]];
    
    CGFloat maxLabelWidth = [labelMax.text
                             boundingRectWithSize:labelMax.frame.size
                             options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:@{ NSFontAttributeName:labelMax.font }
                             context:nil].size.width;
    

    int skip = width*0.2 / maxLabelWidth;
    skip = (skip == 0)?1:skip;
    
    for (int i = min; i < max; i=i+skip) {
        
        NSLog (@"lavel: %d min: %d max: %d skip: %d", i, min, max, skip);
        
        UILabel* label = [[UILabel alloc] init];
        [label setTextColor:[UIColor blackColor]];
        [label setText:[NSString stringWithFormat:@"%d", i]];
        [label setFont:[UIFont systemFontOfSize:12]];
        
        CGRect labelRect = [label.text
                            boundingRectWithSize:label.frame.size
                            options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{ NSFontAttributeName:label.font }
                            context:nil];
        
        CGFloat xOffset = width*0.8 / (max - min);
        
        [label setFrame:CGRectMake (width*0.2+xOffset*i - labelRect.size.width/2,
                                    height-20,
                                    labelRect.size.width,
                                    20)];
        [self addSubview:label];
    }
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self update];

}

@end
