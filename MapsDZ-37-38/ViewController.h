//
//  ViewController.h
//  MapsDZ-37-38
//
//  Created by Александр on 12.06.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@class MKMapView;

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

