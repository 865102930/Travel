//
//  MapViewController.h
//  旅游资源采集
//
//  Created by gz on 17/3/16.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>


typedef void(^ReturnBlock)(NSString *centerLocationStr);

@interface MapViewController : UIViewController {
    BMKLocationService *_locService;
    BMKMapView *_mapView;
    BMKUserLocation *_userLocation;
    NSString *_localtionString;
}


@property (nonatomic, assign) CGFloat centerLatitude;//纬度
@property (nonatomic, assign) CGFloat centerLongitude;//经度

@property (copy) ReturnBlock centerLocationBlock;


@end
