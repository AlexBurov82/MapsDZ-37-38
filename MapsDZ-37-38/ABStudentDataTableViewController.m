//
//  ABStudentDataTableViewController.m
//  MapsDZ-37-38
//
//  Created by Александр on 16.06.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ABStudentDataTableViewController.h"

@implementation ABStudentDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstNameLabel.text = [NSString stringWithFormat:@"%@", [self.studentDataArray objectAtIndex:0]];
    self.lastNameLabel.text = [NSString stringWithFormat:@"%@", [self.studentDataArray objectAtIndex:1]];
    self.dateOfBirthLabel.text = [NSString stringWithFormat:@"%@", [self.studentDataArray objectAtIndex:2]];
    self.genderLabel.text = [NSString stringWithFormat:@"%@", [self.studentDataArray objectAtIndex:3]];
    
    self.localityLabel.text = [NSString stringWithFormat:@"%@", [self.studentDataArray objectAtIndex:4]];
    
    self.administrativeAreaLabel.text = [NSString stringWithFormat:@"%@", [self.studentDataArray objectAtIndex:5]];
    self.countryLabel.text = [NSString stringWithFormat:@"%@", [self.studentDataArray objectAtIndex:6]];
    self.postalCodeLabel.text = [NSString stringWithFormat:@"%@", [self.studentDataArray objectAtIndex:7]];
    self.thoroughfareLabel.text = [NSString stringWithFormat:@"%@", [self.studentDataArray objectAtIndex:8]];
    
    
}

- (void) dealloc {
    NSLog(@"ABStudentDataTableViewController.h deallocated");
}


@end


