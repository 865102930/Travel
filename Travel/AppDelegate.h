//
//  AppDelegate.h
//  Travel
//
//  Created by gz on 17/3/24.
//  Copyright © 2017年 gz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController *navigationController;
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;


@end

