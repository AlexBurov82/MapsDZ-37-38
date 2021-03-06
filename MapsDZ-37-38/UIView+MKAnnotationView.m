//
//  UIView+MKAnnotationView.m
//  MapsDZ-37-38
//
//  Created by Александр on 14.06.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "UIView+MKAnnotationView.h"
#import <MapKit/MKAnnotationView.h>

@implementation UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView {
    
    if ([self isKindOfClass:[MKAnnotationView class]]) {
        return (MKAnnotationView*)self;
    }
    
    if (!self.superview) {
        return nil;
    }
    
    return [self.superview superAnnotationView];
}


@end
