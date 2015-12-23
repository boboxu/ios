//
//  BaiduViewController.h
//  tracktest
//
//  Created by rolandxu on 12/23/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface BaiduViewController : UIViewController
@property (retain, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *tvLocation;
- (IBAction)actionFollow:(id)sender;

@end
