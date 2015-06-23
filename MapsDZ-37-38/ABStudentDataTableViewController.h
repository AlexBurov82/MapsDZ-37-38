//
//  ABStudentDataTableViewController.h
//  MapsDZ-37-38
//
//  Created by Александр on 16.06.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABStudentDataTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *localityLabel;
@property (weak, nonatomic) IBOutlet UILabel *administrativeAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *postalCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *thoroughfareLabel;


@property (strong, nonatomic) NSArray *studentDataArray;

@end
