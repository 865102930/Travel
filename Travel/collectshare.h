//
//  collectshare.h
//  旅游资源采集
//
//  Created by Alonezzz on 2017/3/14.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectshare : NSObject

//使用单例模式

+(collectshare*)sharedInstanceMethod;

@property (nonatomic,strong) NSString* username;
@property (nonatomic,strong) NSString* truename;
@property (nonatomic,strong) NSString* pwd;
@property (nonatomic) NSInteger unitid;
@property (nonatomic) NSInteger pid;
@property (nonatomic,strong) NSString* token;
@property (nonatomic,strong) NSString* areacode;


-(void)clear;
-(void)getconfig;
-(NSString*)getUniqueStrByUUID;
@end
