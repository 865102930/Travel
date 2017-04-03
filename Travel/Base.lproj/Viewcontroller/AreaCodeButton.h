//
//  AreaCodeButton.h
//  旅游资源采集
//
//  Created by gz on 17/3/23.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DBObject.h"

@interface AreaCodeButton : NSObject

@property (nonatomic,strong) DBAreaCode *areacodeinfo;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic,strong) NSString* areacodelike;

@end
