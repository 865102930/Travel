//
//  interface.h
//  旅游资源采集
//
//  Created by Alonezzz on 2017/3/14.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"
#import "Result.h"

@interface interface : NSObject

+(void)login:(RequestLogin*)requestlogin LoginResult:(getResult)resultblock;

+(void)GetServiceTime:(getResult)resultblock;

+(void)InitData:(getResult)resultblock;

+(void)SyncData:(NSString *)lastSyncTime syncResult:(getResult)resultblock;

+(void)UpLoadImage:(NSString*)imagefilename mediaResult:(UploadResult)resultblock;

+(void)UpLoadInfoUnit:(RequestInfoUnit*)requestinfounit UnitResult:(UploadResult)resultblock;

@end


