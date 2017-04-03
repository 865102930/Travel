//
//  MapViewController.m
//  旅游资源采集
//
//  Created by gz on 17/3/16.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface MapViewController ()<BMKLocationServiceDelegate, BMKMapViewDelegate>

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureButton)];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_mapView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64,  [UIScreen mainScreen].bounds.size.width, 15)];
    label.text = @"⚠️拖动地图选择位置";
    label.font = [UIFont systemFontOfSize:12];
    [_mapView addSubview:label];
    
    UIImageView *locationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location@2x"]];
    locationImage.frame = CGRectMake(self.view.center.x - 6.8, self.view.center.y - 30,  13.5, 30);
    [_mapView addSubview:locationImage];
    [self locationStart];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
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

#pragma mark - Location定位

- (void)locationStart {
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView setMapType:BMKMapTypeStandard];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView setZoomLevel:18];
    _locService = [[BMKLocationService alloc]init];
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.headingFilter = kCLHeadingFilterNone;
    _locService.delegate = self;
    [_locService startUserLocationService];
    
}

#pragma mark - BMKLocationServiceDelegate

// 定位加获取地理位置
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = userLocation.location.coordinate;//将当前用户的位置移动到中心点
    _userLocation = userLocation;
    [_locService stopUserLocationService];
}

#pragma mark - BMKMapViewDelegate 百度地图代理方法

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (self.centerLocationBlock) {
        _localtionString = [NSString stringWithFormat:@"%f,%f", _mapView.centerCoordinate.latitude, _mapView.centerCoordinate.longitude];
        self.centerLocationBlock(_localtionString);
    }
}

#pragma mark - Button实现方法
- (void)sureButton{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
