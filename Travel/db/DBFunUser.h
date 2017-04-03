//
//  FirstPageDBOpt.h
//  addresslist
//
//  Created by 庄 严 on 14-8-8.
//  Copyright (c) 2014年 浙江省旅游信息中心. All rights reserved.
//

#import "DBOption.h"
#import "DBObject.h"

@interface DBFunUser : DBOption

//获得单位类型，省厅机关和省级下属
-(DBUserInfo*)GetUserInfo:(NSString*)userName;

-(void)SaveUserInfo:(DBUserInfo*)userInfo;

-(void)InitSuccess:(NSString*)serviceTime;

-(void)SaveLastSyncTime:(NSString*)serviceTime;

-(void)SavePAreaName:(NSString*)areaName;

-(void)InitData:(NSDictionary*)initData serviceTime:(NSString *)timeStr;

-(void)syncData:(NSDictionary*)initData serviceTime:(NSString *)timeStr;
//- (void)test;

@end
