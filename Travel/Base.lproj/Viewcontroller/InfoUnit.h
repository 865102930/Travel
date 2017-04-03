//
//  InfoUnit.h
//  旅游资源采集
//
//  Created by gz on 17/3/15.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "DBObject.h"
#import "Request.h"
#import "AreaCodeButton.h"


typedef void(^InfoUnitBlock)(NSString* unitname);

@interface InfoUnit : UITableViewController {
    BMKLocationService *_locService;
    BMKUserLocation *_userLocation;
    BMKPoiSearch *_searcher;
    
    NSString *subString;
    NSString *fieldString;
    NSString *busStrings;
}

@property (nonatomic) DBTypeInfo* TypeInfo;

@property (nonatomic,strong) RequestInfoUnit* requestinfounit;

@property (nonatomic, strong) id obj;
@property (nonatomic, strong) id subObj;

@property (nonatomic,copy) InfoUnitBlock infounitblock;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;


@end


