//
//  ABMeeting.m
//  MapsDZ-37-38
//
//  Created by Александр on 21.06.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ABMeeting.h"

@implementation ABMeeting

+ (ABMeeting *)randomMeeting {
    
    ABMeeting *meeting = [[ABMeeting alloc] init];
    
    meeting.newLatitude = 37.33233141 + [self generatorDeltaCoordinate];
    meeting.newLongitude = -122.03121860 + [self generatorDeltaCoordinate];
    
    return meeting;
}

+ (double)generatorDeltaCoordinate {
    
    double max = 0.05;
    double min = -0.05;
    double deltaCoordinate = ((double)arc4random() / UINT32_MAX) * (max - min) + min;
    
    return deltaCoordinate;
}

@end
