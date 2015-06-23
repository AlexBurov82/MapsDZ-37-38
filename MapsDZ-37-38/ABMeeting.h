//
//  ABMeeting.h
//  MapsDZ-37-38
//
//  Created by Александр on 21.06.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface ABMeeting : NSObject

@property (nonatomic, assign) CLLocationDegrees newLatitude;

@property (nonatomic, assign) CLLocationDegrees newLongitude;

+ (ABMeeting *)randomMeeting;

+ (double)generatorDeltaCoordinate;


@end
