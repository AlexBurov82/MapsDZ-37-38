//
//  ABMeetingAnnotation.h
//  MapsDZ-37-38
//
//  Created by Александр on 21.06.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface ABMeetingAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@end
