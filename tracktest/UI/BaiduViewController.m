//
//  BaiduViewController.m
//  tracktest
//
//  Created by rolandxu on 12/23/15.
//  Copyright © 2015 rolandxu. All rights reserved.
//

#import "BaiduViewController.h"
#import "BaiduManager.h"

@interface BaiduViewController ()
<BMKMapViewDelegate,BaiduManagerDelegate,BMKLocationServiceDelegate>
{
}
@property (nonatomic,retain) NSMutableArray * locationArr;
@property (nonatomic, strong)BMKPolyline *poly;
@end

@implementation BaiduViewController

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.locationArr = [NSMutableArray array];
    [_mapView setZoomLevel:19];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
    [self _startLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

-(void)_startLocation
{
    [BaiduManager shareInstance].delegate = self;
    [[BaiduManager shareInstance] startLocation];
}

-(void)_stopLocation
{
    [[BaiduManager shareInstance] stopLocation];
    [BaiduManager shareInstance].delegate = nil;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
    
    [self _saveDataToLocationArr:userLocation.location];
//    [self _testLocation:userLocation.location];
    [_mapView removeOverlays:_mapView.overlays];
    [self drawLine];
    
    [self printLog];
}

- (IBAction)actionFollow:(id)sender {
    [self _stopLocation];
    [self _startLocation];
}

-(void)_testLocation:(CLLocation*)location
{
    CLLocationDegrees lati = location.coordinate.latitude;
    CLLocationDegrees longi = location.coordinate.longitude;
    
    double factor = 0.0001;
    for(int i = 0;i<10;i++)
    {
        CLLocation* location = [[CLLocation alloc] initWithLatitude:(lati - factor*i) longitude:(longi - factor*i)];
        [self _saveDataToLocationArr:location];
    }
    
    [self _saveDataToLocationArr:location];
    
    for(int i = 0;i<10;i++)
    {
        CLLocation* location = [[CLLocation alloc] initWithLatitude:(lati + factor*i) longitude:(longi + factor*i)];
        [self _saveDataToLocationArr:location];
    }
}

-(BOOL)_saveDataToLocationArr:(CLLocation *)location{
    
    if (self.locationArr.count>=1) {
        NSArray *arr=[self.locationArr lastObject];
        CLLocation *location11=[[CLLocation alloc]initWithLatitude:[arr[0] doubleValue] longitude:[arr[1] doubleValue]];
        CLLocationDistance distance=[location distanceFromLocation:location11];

        NSString *lastTimeString=arr[2];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        formatter.locale = [NSLocale currentLocale];
        NSDate * lastDate = [formatter dateFromString:lastTimeString];
        NSTimeInterval interval=[location.timestamp timeIntervalSinceDate:lastDate]-28800;
        //设置速度大于一定值的点过滤
        if (distance/interval>25) {
            return NO;
        }
        if (distance>3) {
            NSArray *detainLocationArr=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%lf",location.coordinate.latitude],[NSString stringWithFormat:@"%lf",location.coordinate.longitude],[NSString stringWithFormat:@"%@",location.timestamp],nil];
            [self.locationArr addObject:detainLocationArr];
            return YES;
        }
        return NO;
    }else{
        NSArray *detainLocationArr=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%lf",location.coordinate.latitude],[NSString stringWithFormat:@"%lf",location.coordinate.longitude],[NSString stringWithFormat:@"%@",location.timestamp],nil];
        [self.locationArr addObject:detainLocationArr];
        return YES;
    }
}
-(void)printLog
{
    NSMutableArray *arr=self.locationArr;
    CLLocationCoordinate2D *coor= (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D)*arr.count);
    NSString* string = [[NSString alloc] initWithString:self.tvLocation.text];
    for (int i=0; i<arr.count; i++) {
        NSArray *arr1=arr[i];
        NSString *str=arr1[0];
        NSString *str1=arr1[1];
        coor[i].latitude=[str doubleValue];
        coor[i].longitude=[str1 doubleValue];
        string = [NSString stringWithFormat:@"%@\n%@,%@",string,str1,str];
    }
    
    [self.tvLocation setText:string];
}
#pragma mark -设置画线点
-(void)drawLine{
    NSMutableArray *arr=self.locationArr;
    CLLocationCoordinate2D *coor= (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D)*arr.count);
    for (int i=0; i<arr.count; i++) {
        NSArray *arr1=arr[i];
        NSString *str=arr1[0];
        NSString *str1=arr1[1];
        coor[i].latitude=[str doubleValue];
        coor[i].longitude=[str1 doubleValue];
    }
     _poly = [BMKPolyline polylineWithCoordinates:coor count:arr.count];
    [self.mapView addOverlay:_poly];
    free(coor);
}

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#pragma mark -设置地图折线
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polygonView=[[BMKPolylineView alloc]initWithOverlay:overlay];
        polygonView.strokeColor=UIColorFromHex(0x0089d8);
        polygonView.lineWidth=5.0;
        return polygonView;
    }
    return nil;
}

@end
