//
//  ViewController.m
//  locationTest1
//
//  Created by mac on 2017/5/24.
//  Copyright © 2017年 mac. All rights reserved.
//  获取定位服务
//  导入两个包：CoreLocation（定位，获得经纬度）、AddressBook（将经纬度转换为地理反编码，获取国家等）
//  Info.plist 添加该项 Privacy - Location Always Usage Description ，值为说明文字（主要是说后续操作和结果），还有 Privacy - Location Always Usage Description 也是如此。
//

#import "ViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <AddressBook/AddressBook.h>

@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *curLocation;

@end

@implementation ViewController
@synthesize locationManager,curLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"1");
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    locationManager = [[CLLocationManager alloc] init];
    //kCLLocationAccuracyHundredMeters导航精确到100米
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    //如果没有授权则请求用户授权
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        [locationManager requestAlwaysAuthorization];
    }
    
    locationManager.delegate = self;
    //距离过滤器，定义了设备移动后获得位置的最小距离，单位是米
    locationManager.distanceFilter = 1000.0f;
    [locationManager startUpdatingLocation];

}

#pragma mark Core Location 委托方法用于实现位置的更新
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    curLocation = [locations lastObject];
    NSLog(@"纬度：%f，经度：%3.5f",curLocation.coordinate.latitude,curLocation.coordinate.longitude);
    [locationManager stopUpdatingLocation];
    [self reverse];
}

-(void)reverse{
    CLGeocoder *gl = [[CLGeocoder alloc] init];
    
    [gl reverseGeocodeLocation:curLocation completionHandler:^(NSArray *placemarks,NSError *error){
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        
        if([placemarks count] >0){
            CLPlacemark *placemark = placemarks[0];
        NSLog(@"name=%@,country=%@,locality=%@,administrativeArea=%@,subLocality=%@",placemark.name,placemark.country,placemark.locality,placemark.administrativeArea,placemark.subLocality);
        }
    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"error:%@",error);
    [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
