//
//  ABStudent.h
//  MapsDZ-37-38
//
//  Created by Александр on 12.06.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>



@interface ABStudent : NSObject

@property (strong, nonatomic) NSString *firstName;

@property (strong, nonatomic) NSString *lastName;

@property (strong, nonatomic) NSDate *dateOfBirth;

@property (strong, nonatomic) NSString *photoStudent;

@property (nonatomic, assign) CLLocationDegrees newLatitude;

@property (nonatomic, assign) CLLocationDegrees newLongitude;


+ (ABStudent *)randomStudent;

+ (double)generatorDeltaCoordinate;

@end
