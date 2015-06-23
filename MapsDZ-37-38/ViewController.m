//
//  ViewController.m
//  MapsDZ-37-38
//
//  Created by Александр on 12.06.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKOverlay.h>
#import "ABMapAnnotation.h"
#import "UIView+MKAnnotationView.h"
#import "ABMeetingAnnotation.h"
#import "ABStudent.h"
#import "ABMeeting.h"
#import "ABStudentDataTableViewController.h"





@interface ViewController () <MKMapViewDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSMutableArray *studentArray;
@property (strong, nonatomic) NSArray *womanNameArray;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (strong, nonatomic) MKDirections *directions;
@property (assign, nonatomic) CLLocationCoordinate2D center;
@property (strong, nonatomic) NSMutableArray *annotations;

@property (strong, nonatomic) NSArray *studentDataArray;

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic)UIPopoverController *popoverMeeting;

@property (strong, nonatomic) NSMutableArray *coordKey;
@property (strong, nonatomic) NSMutableArray *annatObj;
@property (strong, nonatomic) NSMutableDictionary *dictionary;

@property (strong, nonatomic) NSOperation *currentOperation;

@property (strong, nonatomic) NSOperationQueue *queue;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *meetingButton;
@property (strong, nonatomic) UILabel *studentCircleLabel1;
@property (strong, nonatomic) UILabel *studentCircleLabel2;
@property (strong, nonatomic) UILabel *studentCircleLabel3;
@property (strong, nonatomic) UILabel *studentsComeToMeetingLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    
     UIBarButtonItem *zoomButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(actionShowAll:)];
    
    self.meetingButton = [[UIBarButtonItem  alloc] initWithImage:[UIImage imageNamed:@"meetingButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(actionMeeting:)];
    
    UIBarButtonItem *routeButton = [[UIBarButtonItem  alloc] initWithImage:[UIImage imageNamed:@"rout.png"] style:UIBarButtonItemStylePlain target:self action:@selector(actionRout:)];
    
    self.navigationItem.rightBarButtonItems = @[zoomButton, addButton, self.meetingButton, routeButton];
    
    self.geoCoder = [[CLGeocoder alloc] init];
    
    self.studentArray = [NSMutableArray array];
    
    self.annotations = [NSMutableArray array];
    
    self.womanNameArray = @[@"Emily", @"Emma", @"Olivia", @"Hannah", @"Abigail", @"Isabella", @"Ashley", @"Samantha", @"Elizabeth", @"Alexis", @"Grace", @"Sophia", @"Emily", @"Michael", @"Emma", @"Hannah", @"Isabella"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary     *)launchOptions
{
  
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    return YES;
}

- (void)dealloc {
    
    if ([self.geoCoder isGeocoding]) {
        [self.geoCoder cancelGeocode];
    }
    
    if ([self.directions isCalculating]) {
        [self.directions cancel];
    }
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        
        renderer.lineWidth = 2.f;
        renderer.strokeColor = [UIColor colorWithRed:0.f green:0.5f blue:1.f alpha:0.9f];
        
        return renderer;
    } else if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        
        renderer.lineWidth = 2.f;
        renderer.strokeColor = [UIColor redColor];
        
        return renderer;
        
    }
    return nil;
}

#pragma mark - Actions

- (void)actionAdd:(UIBarButtonItem*)sender {
    
    for (int i = 0; i < 30; i++) {
        
        [self.studentArray addObject:[ABStudent randomStudent]];
    }

    for (int i = 0; i < [self.studentArray count]; i++) {
        
        ABMapAnnotation *annotation = [[ABMapAnnotation alloc] init];
        
        ABStudent *student = [self.studentArray objectAtIndex:i];
        
        CLLocationDegrees latitude = student.newLatitude;
        CLLocationDegrees longitude = student.newLongitude;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        annotation.title = [NSString stringWithFormat:@"%@ %@", student.lastName, student.firstName];
        
        NSDate *data = student.dateOfBirth;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        
        NSString *stringDate = [dateFormatter stringFromDate:data];
        
        annotation.subtitle = stringDate;
        
        annotation.coordinate = coordinate;
        
        [self.mapView addAnnotation:annotation];
        
        [self.annotations addObject:annotation];
        
        [self showStudentsRadiusMeeting];
        
    }
    
    self.dictionary = [[NSMutableDictionary alloc] initWithObjects:self.annatObj forKeys:self.coordKey];
}

- (void)actionMeeting:(UIBarButtonItem*)sender {
    
    ABMeetingAnnotation *annotation = [[ABMeetingAnnotation alloc] init];
    
    ABMeeting *meeting = [ABMeeting randomMeeting];
    
    CLLocationDegrees latitude = meeting.newLatitude;
    CLLocationDegrees longitude = meeting.newLongitude;
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    self.center = coordinate;
    
    annotation.title = @"Meeting";
    
    annotation.coordinate = coordinate;
    
    [self.mapView addAnnotation:annotation];
        
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    UIView *studentMeetingView = [[UIView alloc] initWithFrame:CGRectMake(0, navBarHeight + statusBarHeight, 240, 190)];
    
    studentMeetingView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    
    [self.mapView addSubview:studentMeetingView];
    
    self.studentCircleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    
    self.studentCircleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 200, 30)];
    
    self.studentCircleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 30)];
    
    self.studentsComeToMeetingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 200, 30)];
    
    self.studentsComeToMeetingLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UIFont *font = [UIFont systemFontOfSize:12.0];
    
    self.studentsComeToMeetingLabel.font = font;
    
    self.studentsComeToMeetingLabel.textColor = [UIColor blueColor];
    
    [studentMeetingView addSubview:self.studentCircleLabel1];
    [studentMeetingView addSubview:self.studentCircleLabel2];
    [studentMeetingView addSubview:self.studentCircleLabel3];
    [studentMeetingView addSubview:self.studentsComeToMeetingLabel];
    
    [self showStudentsRadiusMeeting];
    
    self.meetingButton.enabled = NO;

}


- (void)actionShowAll:(UIBarButtonItem*)sender {
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annatation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location = annatation.coordinate;
        
        MKMapPoint center = MKMapPointForCoordinate(location);
        
        static double delta = 20000;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
}

- (void) showAlertWithTitle:(NSString*) title andMessage:(NSString*)message {
    
    [[[UIAlertView alloc]
      initWithTitle:@"Location"
      message:message delegate:nil
      cancelButtonTitle:@"Ok"
      otherButtonTitles: nil] show];
}

- (void) actionDescription:(UIButton*)sender {
    
    ABStudentDataTableViewController *sdtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ABStudentDataTableViewController"];
    
    UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:sdtvc];
    
    pc.delegate = self;
    
    self.popover = pc;

    MKAnnotationView *annotationView = [sender superAnnotationView];

    if (!annotationView) {
        return;
    }
    
    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];

    if ([self.geoCoder  isGeocoding]) {
        
        [self.geoCoder cancelGeocode];
    }
    
    [self.geoCoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            
                            if (error) {
                                NSLog(@"%@", [error localizedDescription]);
                                
                            } else {
                                
                                if ([placemarks count] > 0) {
                                    MKPlacemark *plaseMark = [placemarks firstObject];
                                    
                                    NSString *localityString = nil;
                                    NSString *administrativeAreaString = nil;
                                    NSString *countryString = nil;
                                    NSString *postalCodeString = nil;
                                    NSString *thoroughfareString = nil;

                                    if (plaseMark.thoroughfare) {
                                        thoroughfareString = plaseMark.thoroughfare;
                                    } else {
                                        thoroughfareString = @"no data";
                                    }
                                    if (plaseMark.location) {
                                        localityString = plaseMark.locality;
                                    } else {
                                        localityString = @"no data";
                                    }
                                    if (plaseMark.administrativeArea) {
                                        administrativeAreaString = plaseMark.administrativeArea;
                                    } else {
                                        administrativeAreaString = @"no data";
                                    }
                                    if (plaseMark.country) {
                                        countryString = plaseMark.country;
                                    } else {
                                        countryString = @"no data";
                                    }
                                    if (plaseMark.postalCode) {
                                        postalCodeString = plaseMark.postalCode;
                                    } else {
                                        postalCodeString = @"no data";
                                    }

                                    
                                    sdtvc.studentDataArray = [self studentData:sdtvc fromAnnotation:annotationView locality:localityString administrativeArea:administrativeAreaString country:countryString postalCode:postalCodeString thoroughfare:thoroughfareString];
                                    
                                    [pc presentPopoverFromRect:sender.bounds
                                                        inView:sender
                                      permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown | UIPopoverArrowDirectionLeft
                                                      animated:YES];

                                }
                            }
                        }];
}


- (void) actionDirection:(UIButton*)sender {
    
    MKAnnotationView *annotationView = [sender superAnnotationView];
    
    if (!annotationView) {
        return;
    }
    
    if ([self.directions isCalculating]) {
        [self.directions cancel];
    }
    
    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                   addressDictionary:nil];
    
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    request.destination = destination;
    
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    request.requestsAlternateRoutes = YES;
    
    self.directions = [[MKDirections alloc] initWithRequest:request];
    
    [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            [self showAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
            
        } else if ([response.routes count] == 0) {
            [self showAlertWithTitle:@"Error" andMessage:@"No routes found"];
        } else {
            
            [self.mapView removeOverlays:[self.mapView overlays]];
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (MKRoute *route in response.routes) {
                [array addObject:route.polyline];
            }
            
            [self.mapView addOverlays:array level:MKOverlayLevelAboveLabels];
        }
    }];
}

- (void)actionRout:(UIButton*)sender {
    
    NSInteger studentsCount = 0;
    for (ABMapAnnotation *annotation in self.annotations) {
        if (!annotation) {
            return;
        }
        if ([self.directions isCalculating]) {
            [self.directions cancel];
        }
        BOOL willTakePartInMeeting = NO;
        CLLocationCoordinate2D centerCoord = self.center;
        CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerCoord.latitude longitude:centerCoord.longitude];
        CLLocationCoordinate2D coordinate = annotation.coordinate;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        CLLocationDistance dist = [location distanceFromLocation:centerLocation];
        if (dist <= 5000) {
            willTakePartInMeeting = (int)(arc4random_uniform(10 * 1000) / 1000);    //90%
        } else if (dist <= 10000) {
            willTakePartInMeeting = (int)(arc4random_uniform(2.5f * 1000) / 1000);  //60%
        } else if (dist <= 15000) {
            willTakePartInMeeting = (int)(arc4random_uniform(1.5f * 1000) / 1000);  //33%
        } else {
            willTakePartInMeeting = (int)(arc4random_uniform(1.5f * 1000) / 1000);  //9%
            
        }
        if (willTakePartInMeeting) {
            MKDirectionsRequest *request = [MKDirectionsRequest new];
            MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:self.center addressDictionary:nil];
            request.source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
            MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
            MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
            request.destination = destination;
            request.transportType = MKDirectionsTransportTypeAny;
            request.requestsAlternateRoutes = NO;
            
            self.directions = [[MKDirections alloc] initWithRequest:request];
            [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                if (error) {
                    
                    [self showAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
                   
                } else if ([response.routes count] == 0) {
                } else {
                    NSMutableArray *array  = [NSMutableArray array];
                    for (MKRoute *route in response.routes) {
                        [array addObject:route.polyline];
                    }
                    [self.mapView addOverlays:array level:MKOverlayLevelAboveRoads];
                }
            }];
            studentsCount++;
        }
    }
    self.studentsComeToMeetingLabel.text = [NSString stringWithFormat:@"Students come to the Meeting - %ld", studentsCount];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identifierStudent = @"Student";
    static NSString *identifierMeeting = @"Meeting";

    if ([annotation isKindOfClass:[ABMapAnnotation class]]) {
        
        MKAnnotationView *pin = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifierStudent];
        
        if (!pin) {
            
            pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifierStudent];
            
            pin.canShowCallout = YES;
            
            NSArray *titleArray = [annotation.title componentsSeparatedByString:@" "];
            
            NSString *nameStudent = [NSString stringWithFormat:@"%@", [titleArray objectAtIndex:1]];
            
            if ([self.womanNameArray containsObject:nameStudent]) {
                NSString *imageNamed = [NSString stringWithFormat:@"woman-%d.png",(arc4random()%1600)/100];
                pin.image = [UIImage imageNamed:imageNamed];
            } else {
                NSString *imageNamed = [NSString stringWithFormat:@"man-%d.png",(arc4random()%1600)/100];
                pin.image = [UIImage imageNamed:imageNamed];
            }
            
            UIButton *descriptionButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            [descriptionButton addTarget:self action:@selector(actionDescription:) forControlEvents:UIControlEventTouchUpInside];
            
            pin.rightCalloutAccessoryView = descriptionButton;
            
            UIButton * directionButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [directionButton addTarget:self action:@selector(actionDirection:) forControlEvents:UIControlEventTouchUpInside];
            pin.leftCalloutAccessoryView = directionButton;
            
        } else {
            pin.annotation = annotation;
        }
        
        return pin;
        
    } else if ([annotation isKindOfClass:[ABMeetingAnnotation class]]) {
        
        MKAnnotationView *pin = [mapView dequeueReusableAnnotationViewWithIdentifier:identifierMeeting];
        
        if (!pin) {
            
            pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifierMeeting];
            
            pin.draggable = YES;
            
            pin.canShowCallout = YES;
            
            pin.image = [UIImage imageNamed:@"meeting.png"];
            
        } else {
            pin.annotation = annotation;
        }
        
        [self.mapView removeOverlays:[self.mapView overlays]];
        
        MKCircle *circle1 = [MKCircle circleWithCenterCoordinate:self.center radius:5000];
        MKCircle *circle2 = [MKCircle circleWithCenterCoordinate:self.center radius:10000];
        MKCircle *circle3 = [MKCircle circleWithCenterCoordinate:self.center radius:15000];
        
        [self.mapView addOverlays:@[circle1, circle2, circle3] level:MKOverlayLevelAboveRoads];

        return pin;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState == MKAnnotationViewDragStateStarting) {
        [self.mapView removeOverlays:[self.mapView overlays]];
    }
    
    else if (newState == MKAnnotationViewDragStateEnding) {
        
        self.center = view.annotation.coordinate;
        [self.mapView removeOverlays:[self.mapView overlays]];
        
        
        MKCircle *circle1 = [MKCircle circleWithCenterCoordinate:self.center radius:5000];
        MKCircle *circle2 = [MKCircle circleWithCenterCoordinate:self.center radius:10000];
        MKCircle *circle3 = [MKCircle circleWithCenterCoordinate:self.center radius:15000];
        
        [self.mapView addOverlays:@[circle1, circle2, circle3] level:MKOverlayLevelAboveRoads];
        
        [self showStudentsRadiusMeeting];
        
        view.dragState = MKAnnotationViewDragStateNone;
    }
}

#pragma mark - UIPopoverControllerDelegate


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
    self.popover = nil;
    
    self.popoverMeeting = nil;
}

#pragma mark - Other Methods

- (NSArray*)studentData:(ABStudentDataTableViewController*)controller fromAnnotation:(MKAnnotationView*)annotationView locality:(NSString*)localityString administrativeArea:(NSString*)administrativeAreaString country:(NSString*)countryString postalCode:(NSString*)postalCodeString thoroughfare:(NSString*)thoroughfareString {
    
    ABMapAnnotation *annotation = annotationView.annotation;
    
    NSArray *titleArray = [annotation.title componentsSeparatedByString:@" "];
    
    NSString *firstNameString = [NSString stringWithFormat:@"%@", [titleArray objectAtIndex:1]];
    NSString *lastNameString = [NSString stringWithFormat:@"%@", [titleArray objectAtIndex:0]];
    NSString *genderString;
    if ([self.womanNameArray containsObject:firstNameString]) {
        genderString = @"female";
    } else {
        genderString = @"male";
    }
    NSString *dateString = annotation.subtitle;
    
    NSArray *studentDataArray = [NSArray arrayWithObjects:firstNameString, lastNameString, dateString, genderString, localityString, administrativeAreaString, countryString, postalCodeString, thoroughfareString, nil];
    
    return studentDataArray;
    
}


-(void) showStudentsRadiusMeeting {
    
    NSInteger distance05km = 0;
    NSInteger distance10km = 0;
    NSInteger distance15km = 0;
    
    CLLocationCoordinate2D centerMeeting = self.center;
    
    CLLocation *centerLocatin = [[CLLocation alloc] initWithLatitude:centerMeeting.latitude longitude:centerMeeting.longitude];
    
    for (ABMapAnnotation *annotation in self.annotations) {
        
        CLLocationCoordinate2D coordinate = annotation.coordinate;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        CLLocationDistance distance = [location distanceFromLocation:centerLocatin];
        
        if (distance <= 5000) {
            distance05km++;
            
        } else if (distance <= 10000) {
            distance10km++;
            
        } else if (distance <= 15000) {
            distance15km++;
            
        }
        
        self.studentCircleLabel1.text = [NSString stringWithFormat:@"Students 05 km - %ld", (long)distance05km];
        self.studentCircleLabel2.text = [NSString stringWithFormat:@"Students 10 km - %ld", (long)distance10km];
        self.studentCircleLabel3.text = [NSString stringWithFormat:@"Students 15 km - %ld", (long)distance15km];
    }
}

@end
