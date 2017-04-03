//
//  FirstPageDBOpt.m
//  addresslist
//
//  Created by 庄 严 on 14-8-8.
//  Copyright (c) 2014年 浙江省旅游信息中心. All rights reserved.
//

#import "DBFunInit.h"

@implementation DBFunInit

-(void)SaveUserInfo:(DBUserInfo*)userInfo
{
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"insert into userinfo (username,truename,isinit) values ('%@','%@',%ld) ",
                            userInfo.username,userInfo.truename,(long)userInfo.isinit];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        char *errorMsg;
        sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
    }
}

-(void)InitSuccess:(NSString*)userName
{
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"update userinfo set isinit = 1 where username = '%@'",userName];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        char *errorMsg;
        sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
    }
}


@end



