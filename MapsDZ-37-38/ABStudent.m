//
//  ABStudent.m
//  MapsDZ-37-38
//
//  Created by Александр on 12.06.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ABStudent.h"

@implementation ABStudent

static NSString *firstNames[] = {@"Jacob", @"Emily", @"Michael", @"Emma", @"Joshua", @"Madison", @"Matthew", @"Olivia", @"Ethan", @"Hannah", @"Andrew", @"Abigail", @"Sarah", @"Isabella", @"William", @"Ashley", @"Joseph", @"Samantha", @"Christopher", @"Elizabeth", @"Anthony", @"Alexis", @"Ryan", @"Daniel", @"Nicholas", @"Anthony", @"David", @"Grace", @"Alexander", @"Sophia", @"Jacob", @"Emily", @"Michael", @"Emma", @"Joshua", @"Madison", @"Matthew", @"Olivia", @"Ethan", @"Hannah", @"Sarah", @"Isabella", @"William", @"Ashley", @"Joseph", @"Samantha", @"Christopher", @"Elizabeth", @"Anthony", @"Alexis"};

static NSString *lastNames[] = {@"Abramson", @"Warren", @"Adamson", @"Holiday", @"Addington", @"Boolman", @"Mansfield", @"Bootman", @"Marlow", @"Bosworth", @"Mason", @"Donovan", @"Peacock", @"Pearcy", @"Dowman", @"Peterson", @"Dutton", @"Peacock", @"Duncan", @"Porter", @"Dunce", @"Quincy", @"Durham", @"Raleigh", @"Goodman", @"Abramson", @"Gustman", @"Watson", @"Haig", @"Wayne", @"Abramson", @"Warren", @"Adamson", @"Holiday", @"Addington", @"Boolman", @"Mansfield", @"Bootman", @"Marlow", @"Bosworth", @"Mason", @"Donovan", @"Peacock", @"Pearcy", @"Dowman", @"Peterson", @"Dutton", @"Peacock", @"Duncan", @"Porter"};

static int nameCount = 50;

+ (ABStudent *)randomStudent {
    
    ABStudent *student = [[ABStudent alloc] init];
    
    student.firstName = firstNames[arc4random() % nameCount];
    student.lastName = lastNames[arc4random() % nameCount];
    student.dateOfBirth = [self generateRandomDateOfBirth];
    student.newLatitude = 37.33233141 + [self generatorDeltaCoordinate];
    student.newLongitude = -122.03121860 + [self generatorDeltaCoordinate];
    
    student.photoStudent = [NSString stringWithFormat:@"%d.png", ((arc4random()%5000)+100)/100];
    
    return student;
}

+ (NSDate *) generateRandomDateOfBirth {
    
    int r1 = arc4random_uniform((int)2500);
    int r2 = arc4random_uniform(23);
    int r3 = arc4random_uniform(59);
    
    NSString *currentStringDate = @"01.01.1988";
    NSDateFormatter *dateFormatterStr = [NSDateFormatter new];
    [dateFormatterStr setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatterStr setDateFormat:@"dd.MM.yyyy"];
    
    NSDate *currentDate = [dateFormatterStr dateFromString:currentStringDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *offsetComponents = [NSDateComponents new];
    [offsetComponents setDay:(r1*-1)];
    [offsetComponents setHour:r2];
    [offsetComponents setMinute:r3];
    
    NSDate *randomDate = [gregorian dateByAddingComponents:offsetComponents
                                                    toDate:currentDate options:0];
    
    return randomDate;
}

+ (double)generatorDeltaCoordinate {
    
    double max = 0.2;
    double min = -0.2;
    double deltaCoordinate = ((double)arc4random() / UINT32_MAX) * (max - min) + min;

    return deltaCoordinate;
}


@end


