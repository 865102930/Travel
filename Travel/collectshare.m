//
//  collectshare.m
//  旅游资源采集
//
//  Created by Alonezzz on 2017/3/14.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "collectshare.h"


#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]


static collectshare* sharedInstance = nil;

@implementation collectshare

+ (collectshare*)sharedInstanceMethod
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id)init
{
    if (self = [super init])
    {
        //是否绑定
        [self getconfig];
        
    }
    return self;
}

-(void)clear
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:@"" forKey:@"username"];
    [defaults setValue:@"" forKey:@"truename"];
    [defaults setValue:@"" forKey:@"pwd"];
    [defaults setValue:0 forKey:@"pid"];
    [defaults setValue:@"" forKey:@"token"];
    [defaults setValue:0 forKey:@"unitid"];
    [defaults setValue:@"" forKey:@"areacode"];
    [defaults synchronize];
    
    _username = @"";
    _truename = @"";
    _pid = 0;
    _token = @"";
}

-(void)getconfig
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _username = [userDefaults stringForKey:@"username"];
    _truename = [userDefaults stringForKey:@"truename"];
    _pwd = [userDefaults stringForKey:@"pwd"];
    _unitid = [userDefaults integerForKey:@"unitid"];
    
    _pid = [userDefaults integerForKey:@"pid"];
    _token = [userDefaults stringForKey:@"token"];
    _areacode = [userDefaults stringForKey:@"areacode"];
}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString ;
    
}


@end
