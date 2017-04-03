//
//  FirstPageDBOpt.m
//  addresslist
//
//  Created by 庄 严 on 14-8-8.
//  Copyright (c) 2014年 浙江省旅游信息中心. All rights reserved.
//

#import "DBFunUser.h"
#import "collectshare.h"
#import "Result.h"

@implementation DBFunUser

-(DBUserInfo*)GetUserInfo:(NSString*)userName
{
    DBUserInfo* userinfo;
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"Select username,truename,isinit,areaname, synctime FROM userinfo Where username = '%@' ",userName];
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        if(sqlite3_prepare_v2(self.db, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                userinfo = [[DBUserInfo alloc] initWithName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]
                                                   TrueName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]
                                                     IsInit:sqlite3_column_int(statement, 2)
                                                  PAreaName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]
                                               lastSyncTime:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
            }
        }
        sqlite3_finalize(statement);
    }
    return  userinfo;
}

-(void)SaveUserInfo:(DBUserInfo*)userInfo
{
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"insert into userinfo (username,truename,isinit) values ('%@','%@',%ld) ",
                            userInfo.username,userInfo.truename,(long)userInfo.isinit];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        char *errorMsg;
        int result = sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        if (result == SQLITE_OK) {
            NSLog(@"成功");
        }
        sqlite3_close(self.db);
    }
}

-(void)SaveLastSyncTime:(NSString*)serviceTime
{
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"update userinfo set SyncTime='%@' where username = '%@'",
                            serviceTime,[[collectshare sharedInstanceMethod] username]];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        char *errorMsg;
        sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        sqlite3_close(self.db);
    }
}

-(void)InitSuccess:(NSString*)serviceTime
{
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"update userinfo set isinit = 1,SyncTime='%@' where username = '%@'",
                            serviceTime,[[collectshare sharedInstanceMethod] username]];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        char *errorMsg;
        sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        sqlite3_close(self.db);
    }
}

-(void)SavePAreaName:(NSString*)areaName
{
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"update userinfo set areaname='%@' where username = '%@'",
                            areaName,[[collectshare sharedInstanceMethod] username]];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        char *errorMsg;
        sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        sqlite3_close(self.db);
    }
}

-(void)InitData:(NSDictionary*)initData serviceTime:(NSString *)timeStr {
    //NSString* username = [[collectshare sharedInstanceMethod] username];
    
    NSString* areaname = [initData objectForKey:@"areaname"];
    NSArray* areacodes = [initData objectForKey:@"areacodes"];
    NSArray* typeinfos = [initData objectForKey:@"typeinfos"];
    NSArray* typefields = [initData objectForKey:@"typefields"];
    
    [self SavePAreaName:areaname];
    
    if ([self OpenDB])
    {
        
        //进行批量处理
        
        //const char *sqlStatement = [strsql cStringUsingEncoding:NSUTF8StringEncoding];
        
        char *errorMsg;
        //sqlite3_exec(self.db, "BEGIN;", 0, 0, &errorMsg);
        
        NSString *sqldelete = [NSString stringWithFormat:@"delete from areacodes where username = '%@'",[[collectshare sharedInstanceMethod] username]];
        const char *sqlDeleteStatement = [sqldelete cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_exec(self.db, sqlDeleteStatement, NULL, NULL, &errorMsg);
        
        
        
        for (int i = 0; i < areacodes.count; i++) {
            NSDictionary *areadict = areacodes[i];
            
            AreaCode *areacode = [[AreaCode alloc] initWithDictionary:areadict];
            NSString *sqlstring = [NSString stringWithFormat:@"insert into areacodes (username,areacode,areaname,zonecode,postcode) values ('%@','%@','%@','%@','%@')",[[collectshare sharedInstanceMethod] username],areacode.areacode,areacode.areaname,areacode.zonecode,areacode.postcode];
            const char *sqlStatement = [sqlstring cStringUsingEncoding:NSUTF8StringEncoding];
            
            sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        }
        
        
        NSString *sqldel = [NSString stringWithFormat:@"delete from typeinfos where username = '%@'",[[collectshare sharedInstanceMethod] username]];
        const char *sqlDelStatement = [sqldel cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_exec(self.db, sqlDelStatement, NULL, NULL, &errorMsg);
        
        for (int i = 0; i < typeinfos.count; i++) {
            NSDictionary *typeInfoDic = typeinfos[i];
            
            TypeInFos *typeInFos = [[TypeInFos alloc] initWithDictionary:typeInfoDic];
            NSString *sqlstring = [NSString stringWithFormat:@"insert into typeinfos (username,typeid,pid,orderno,typename,mobilememo,ptypeid,existschild,existsroom,existsscenic,deleteflag) values ('%@','%ld','%ld','%ld','%@','%@','%ld','%ld','%ld','%ld','%ld')",[[collectshare sharedInstanceMethod] username],typeInFos.typeid,typeInFos.pid,typeInFos.orderno,typeInFos.typename,typeInFos.mobilememo,typeInFos.ptypeid,typeInFos.existschild,typeInFos.existsroom,typeInFos.existsscenic,typeInFos.deleteflag];
            const char *sqlStatement = [sqlstring cStringUsingEncoding:NSUTF8StringEncoding];
            
            sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        }
        
        NSString *sqlTypeField = [NSString stringWithFormat:@"delete from typefields where username = '%@'",[[collectshare sharedInstanceMethod] username]];
        const char *sqlTypeFie = [sqlTypeField cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_exec(self.db, sqlTypeFie, NULL, NULL, &errorMsg);
        
        for (int i = 0; i < typefields.count; i++) {
            NSDictionary *typeFieldDic = typefields[i];
            
            TypeFields *typeField = [[TypeFields alloc] initWithDictionary:typeFieldDic];
            NSString *sqlstring = [NSString stringWithFormat:@"insert into typefields (username,id,typeid,orderno,fieldname,fieldtype,groupname,customname,isedit,deleteflag) values ('%@','%ld','%ld','%ld','%@','%@','%@','%@','%ld','%ld')",[[collectshare sharedInstanceMethod] username],typeField.id,typeField.typeid,typeField.orderno,typeField.fieldname,typeField.fieldtype,typeField.groupname,typeField.customname,typeField.isedit,typeField.deleteflag];
            const char *sqlStatement = [sqlstring cStringUsingEncoding:NSUTF8StringEncoding];
            
            sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        }
        
        
        //sqlite3_exec(self.db, "COMMIT;", 0, 0, &errorMsg);
        sqlite3_close(self.db);
        
        [self InitSuccess:timeStr];
        
    }
    
    
}

- (void)syncData:(NSDictionary *)initData serviceTime:(NSString *)timeStr {
    NSArray* typeinfos = [initData objectForKey:@"typeinfos"];
    NSArray* typefields = [initData objectForKey:@"typefields"];
    
    
    if ([self OpenDB])
    {
        
        //进行批量处理
        
        //const char *sqlStatement = [strsql cStringUsingEncoding:NSUTF8StringEncoding];
        
        char *errorMsg;
        //sqlite3_exec(self.db, "BEGIN;", 0, 0, &errorMsg);
        
        //        NSString *sqldelete = [NSString stringWithFormat:@"delete from areacodes where username = '%@'",[[collectshare sharedInstanceMethod] username]];
        //        const char *sqlDeleteStatement = [sqldelete cStringUsingEncoding:NSUTF8StringEncoding];
        //        sqlite3_exec(self.db, sqlDeleteStatement, NULL, NULL, &errorMsg);
        
        
        
        for (int i = 0; i < typeinfos.count; i++) {
            NSDictionary *typeInfoDic = typeinfos[i];
            
            TypeInFos *typeInFos = [[TypeInFos alloc] initWithDictionary:typeInfoDic];
            NSString *sqldelete = [NSString stringWithFormat:@"delete from typeinfos where username = '%@' and typeid = %ld",[[collectshare sharedInstanceMethod] username], typeInFos.typeid];
            const char *sqlDeleteStatement = [sqldelete cStringUsingEncoding:NSUTF8StringEncoding];
            sqlite3_exec(self.db, sqlDeleteStatement, NULL, NULL, &errorMsg);
            
            NSString *sqlstring = [NSString stringWithFormat:@"insert into typeinfos (username,typeid,pid,orderno,typename,mobilememo,ptypeid,existschild,existsroom,existsscenic,deleteflag) values ('%@','%ld','%ld','%ld','%@','%@','%ld','%ld','%ld','%ld','%ld')",[[collectshare sharedInstanceMethod] username],typeInFos.typeid,typeInFos.pid,typeInFos.orderno,typeInFos.typename,typeInFos.mobilememo,typeInFos.ptypeid,typeInFos.existschild,typeInFos.existsroom,typeInFos.existsscenic,typeInFos.deleteflag];
            const char *sqlStatement = [sqlstring cStringUsingEncoding:NSUTF8StringEncoding];
            
            sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        }
        
        
        for (int i = 0; i < typefields.count; i++) {
            NSDictionary *typeFieldDic = typefields[i];
            
            TypeFields *typeField = [[TypeFields alloc] initWithDictionary:typeFieldDic];
            NSString *sqldelete = [NSString stringWithFormat:@"delete from typefields where username = '%@' and id = %ld",[[collectshare sharedInstanceMethod] username], typeField.id];
            const char *sqlDeleteStatement = [sqldelete cStringUsingEncoding:NSUTF8StringEncoding];
            sqlite3_exec(self.db, sqlDeleteStatement, NULL, NULL, &errorMsg);
            
            NSString *sqlstring = [NSString stringWithFormat:@"insert into typefields (username,id,typeid,orderno,fieldname,fieldtype,groupname,customname,isedit,deleteflag) values ('%@','%ld','%ld','%ld','%@','%@','%@','%@','%ld','%ld')",[[collectshare sharedInstanceMethod] username],typeField.id,typeField.typeid,typeField.orderno,typeField.fieldname,typeField.fieldtype,typeField.groupname,typeField.customname,typeField.isedit,typeField.deleteflag];
            const char *sqlStatement = [sqlstring cStringUsingEncoding:NSUTF8StringEncoding];
            
            sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        }
        
        
        //sqlite3_exec(self.db, "COMMIT;", 0, 0, &errorMsg);
        sqlite3_close(self.db);
        
        [self InitSuccess:timeStr];
    }
}


@end



