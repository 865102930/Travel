//
//  FirstPageDBOpt.m
//  addresslist
//
//  Created by 庄 严 on 14-8-8.
//  Copyright (c) 2014年 浙江省旅游信息中心. All rights reserved.
//

#import "DBObject.h"
#import "DBFunCollect.h"
#import "collectshare.h"

@implementation DBFunCollect

-(NSMutableArray*)GetTypeList:(NSInteger)ptypeid SpaceCount:(NSInteger)spaceCount;
{
    NSMutableArray *typeinfolist = [[NSMutableArray alloc] init];
    
    NSString *blankstring = @"          ";
    NSString *prestring = [blankstring substringToIndex:spaceCount*2];
    
    if ([self OpenDB])
    {
    NSString *strsql = [NSString stringWithFormat:@"Select pid,typeid,ptypeid,typename,existschild,existsroom,existsscenic FROM typeinfos Where pid = %ld and ptypeid= %ld and username = '%@' and deleteflag=0 order by orderno ",(long)[[collectshare sharedInstanceMethod] pid],ptypeid,[[collectshare sharedInstanceMethod] username]];

    const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(self.db, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            DBTypeInfo *typeinfo = [[DBTypeInfo alloc]initWithName:sqlite3_column_int(statement, 0)
                                                            TypeID:sqlite3_column_int(statement, 1)
                                                           PTypeID:sqlite3_column_int(statement, 2)
                                                          TypeName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]
                                                       ExistsChild:sqlite3_column_int(statement, 4)
                                                       ExistsRoom: sqlite3_column_int(statement, 5)
                                                      ExistsScenic:sqlite3_column_int(statement, 6)];
            
            typeinfo.typename = [prestring stringByAppendingString:typeinfo.typename];
            
            [typeinfolist addObject:typeinfo];
            if (typeinfo.existschild)
            {
                [typeinfolist addObjectsFromArray:[self GetTypeList:typeinfo.typeid SpaceCount:spaceCount + 1]];
            }
        }
    }
        sqlite3_finalize(statement);
    }
    
    return typeinfolist;
}

-(DBTypeInfo*)GetTypeInfo:(NSInteger)typeid
{
    DBTypeInfo *typeinfo ;
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"Select pid,typeid,ptypeid,typename,existschild,existsroom,existsscenic FROM typeinfos Where pid = %ld and typeid= %ld and username = '%@' order by orderno ",(long)[[collectshare sharedInstanceMethod] pid],typeid,[[collectshare sharedInstanceMethod] username]];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        
        if(sqlite3_prepare_v2(self.db, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                 typeinfo = [[DBTypeInfo alloc]initWithName:sqlite3_column_int(statement, 0)
                                                                TypeID:sqlite3_column_int(statement, 1)
                                                               PTypeID:sqlite3_column_int(statement, 2)
                                                              TypeName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]
                                                           ExistsChild:sqlite3_column_int(statement, 4)
                                                 ExistsRoom:sqlite3_column_int(statement, 5)
                                               ExistsScenic:sqlite3_column_int(statement, 6)];
            }
        }
        sqlite3_finalize(statement);
    }
    
    return typeinfo;
}

-(NSMutableArray *)GetTypeFieldGroup:(NSInteger)typeid
{
    NSMutableArray *grouplist = [[NSMutableArray alloc] init];

    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"Select distinct groupname,typeid From TypeFields Where typeid= %ld and username = '%@' and deleteflag=0 and isedit = 1 order by groupname ",typeid,[[collectshare sharedInstanceMethod] username]];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        
        if(sqlite3_prepare_v2(self.db, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                DBFieldGroup *groupinfo = [[DBFieldGroup alloc]initWithName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]
                                                                TypeID:sqlite3_column_int(statement, 1)];
                
                
                [self GetTypeField:groupinfo];
                
                [grouplist addObject:groupinfo];
            }
        }
        sqlite3_finalize(statement);
    }
    
    return grouplist;
}

-(void)GetTypeField:(DBFieldGroup*)group
{
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"Select fieldname,fieldtype,customname From TypeFields Where typeid= %ld and username = '%@' and deleteflag=0 and isedit = 1 and groupname = '%@' order by orderno ",group.typeid,[[collectshare sharedInstanceMethod] username],group.groupname];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        
        if(sqlite3_prepare_v2(self.db, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                DBTypeField *fieldinfo = [[DBTypeField alloc]initWithName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]
                                                                     FieldType:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]
                                                               CustomName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                
                
               
                
                [group.typefields addObject:fieldinfo];
            }
        }
        sqlite3_finalize(statement);
    }
}

-(NSMutableArray*)GetAreaCodeLike:(NSString *)areacode
{
    NSMutableArray *areacodes = [[NSMutableArray alloc] init];
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"Select AreaCode,AreaName,PostCode,ZoneCode From AreaCodes where username='%@'and areacode like '%@'",[[collectshare sharedInstanceMethod] username],areacode];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        
        if(sqlite3_prepare_v2(self.db, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                DBAreaCode *areainfo = [[DBAreaCode alloc]initWithName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]
                                                                AreaName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]
                                                              PostCode:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]
                                                              ZoneCode:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]
                                        ];
                
                
                
                
                [areacodes addObject:areainfo];
            }
        }
        sqlite3_finalize(statement);
    }
    return  areacodes;
}

-(DBAreaCode*)GetAreaCodeInfo:(NSString *)areaCode
{
    DBAreaCode *areacodeinfo ;
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"Select AreaCode,AreaName,postcode,zonecode From AreaCodes where username='%@'and areacode ='%@'",[[collectshare sharedInstanceMethod] username],areaCode];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        
        if(sqlite3_prepare_v2(self.db, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW){
                 areacodeinfo = [[DBAreaCode alloc]initWithName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]
                                                       AreaName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]
                                                       PostCode:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]
                                                       ZoneCode:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                
                
               
            }
        }
        sqlite3_finalize(statement);
    }
    return  areacodeinfo;
}

-(void)SaveUnit:(RequestInfoUnit*)infoUnit
{
    if ([self OpenDB])
    {
        //删除掉以前的数据
        NSString *strsql = [NSString stringWithFormat:@"delete from infounits where localunitid='%@'",infoUnit.localunitid];
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        char *errorMsg;
        sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        strsql = [NSString stringWithFormat:@"delete from mediainfos where localunitid='%@'",infoUnit.localunitid];
        sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        //增加新数据
        for (MediaInfo *mediainfo in infoUnit.mediainfos)
        {
            strsql = [NSString stringWithFormat:@"insert into mediainfos (username,mediaurl,filename,medianame,memo,localunitid) values ('%@','','%@','%@','%@','%@')",mediainfo.username,mediainfo.filename,mediainfo.medianame,mediainfo.memo,mediainfo.localunitid];
           sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
            sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        }
        strsql = [NSString stringWithFormat:@"insert into infounits (unitid,pid,typeid,areacode,unitname,shortname,orderno,address,postcode,zonecode,telephone,infotel,booktel,complainttel,fax,url,url360,logopic,flagpic,publictrafic,desc,manager,managertel,businesslicense,businesstime,level,sourcefrom,state,opentime,decorationtime,tips,favouredpolicy,innertrafic,maxcapacity,ticketprice,pricedesc,id5a,name5a,roomcount,bedcount,roomprice,boxcount,seatcount,personprice,licenseno,mainline,poitypename,poitypetag,detailurl,overallrating,servicerating,environmentrating,facilityrating,hygienerating,imgnum,commentnum,reservefield1,reservefield2,reservefield3,reservefield4,reservefield5,reservefield6,reservefield7,reservefield8,reservefield9,memo,gpsbd,gps,gpsgd,areaname,localunitid,logourl,flagurl,username) Values (0,%@,%@,'%@','%@','%@',%@,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%@,%@,%@,'%@','%@','%@','%@','%@',%@,%@,'%@',0,'',%@,%@,%@,%@,%@,%@,'','','','','','','','','','',0,0,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','','','%@')",
                  infoUnit.pid,infoUnit.typeid,infoUnit.areacode,infoUnit.unitname,infoUnit.shortname,infoUnit.orderno,infoUnit.address,infoUnit.postcode,infoUnit.zonecode,
                  infoUnit.telephone,infoUnit.infotel,infoUnit.booktel,infoUnit.complainttel,infoUnit.fax,infoUnit.url,infoUnit.url360,infoUnit.logopic,infoUnit.flagpic,infoUnit.publictrafic,
                  infoUnit.desc,infoUnit.manager,infoUnit.managertel,infoUnit.businesslicense,infoUnit.businesstime,infoUnit.level,infoUnit.sourcefrom,infoUnit.state,infoUnit.opentime,infoUnit.decorationtime,
                  infoUnit.tips,infoUnit.favouredpolicy,infoUnit.innertrafic,infoUnit.maxcapacity,infoUnit.ticketprice,infoUnit.pricedesc,infoUnit.roomcount,infoUnit.bedcount,
                  infoUnit.roomprice,infoUnit.boxcount,infoUnit.seatcount,infoUnit.personprice,
                  infoUnit.reservefield1,infoUnit.reservefield2,infoUnit.reservefield3,infoUnit.reservefield4,
                  infoUnit.reservefield5,infoUnit.reservefield6,infoUnit.reservefield7,infoUnit.reservefield8,infoUnit.reservefield9,infoUnit.memo,infoUnit.gpsbd,infoUnit.gps,infoUnit.gpsgd,infoUnit.areaname,
                  infoUnit.localunitid,infoUnit.username];
        
        sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        sqlite3_close(self.db);
    }
}

-(NSMutableArray*)GetTypeFields:(NSInteger)typeid
{
    NSMutableArray *typefields = [[NSMutableArray alloc] init];
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"Select fieldname,fieldtype,customname From TypeFields Where typeid= %ld and username = '%@' and deleteflag=0 ",typeid,[[collectshare sharedInstanceMethod] username]];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        
        if(sqlite3_prepare_v2(self.db, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                DBTypeField *fieldinfo = [[DBTypeField alloc]initWithName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]
                                                                FieldType:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]
                                                               CustomName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                
                
                
                
                [typefields addObject:fieldinfo];
            }
        }
        sqlite3_finalize(statement);
    }
    return typefields;
}

-(NSMutableArray*)GetUnitList:(NSInteger)staTe
{
    NSMutableArray *unitlist = [[NSMutableArray alloc] init];
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"Select unitname,localunitid,typeid from infounits where state=%ld and username='%@'",staTe,[[collectshare sharedInstanceMethod] username]];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        
        if(sqlite3_prepare_v2(self.db, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                DBUnitInfo *unitinfo = [[DBUnitInfo alloc]initWithName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]
                                                           LocalUnitID:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]
                                                               TypeID:sqlite3_column_int(statement, 2)];
                
                
                
                
                [unitlist addObject:unitinfo];
            }
        }
        sqlite3_finalize(statement);
    }
    return unitlist;
}

-(NSMutableArray*)GetMediaInfos:(NSString*)localunitid
{
    NSMutableArray * medialist = [[NSMutableArray alloc] init];
    
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"Select mid,mediaurl,filename,medianame,memo from mediainfos where localunitid='%@'",localunitid];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        
        if(sqlite3_prepare_v2(self.db, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                MediaInfo *mediainfo = [[MediaInfo alloc] init];
                mediainfo.mid =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                mediainfo.username = [[collectshare sharedInstanceMethod] username];
                mediainfo.localunitid = localunitid;
                mediainfo.mediaurl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                mediainfo.filename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                mediainfo.medianame = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                mediainfo.memo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                [medialist addObject:mediainfo];
            }
        }
        sqlite3_finalize(statement);
    }
    return medialist;
}


-(RequestInfoUnit*)GetRequestUnitInfo:(NSString*)localunitid
{
    RequestInfoUnit *requestunit = [[RequestInfoUnit alloc] init];
    if ([self OpenDB])
    {
        NSString *strsql = [NSString stringWithFormat:@"Select localunitid,username,unitid,pid,typeid,areacode,areaname,unitname,shortname,orderno,address,postcode,zonecode,telephone,infotel,booktel,complainttel,fax,url,url360,logopic,flagpic,publictrafic,desc,manager,managertel,businesslicense,businesstime,level,sourcefrom,state,opentime,decorationtime,tips,favouredpolicy,innertrafic,maxcapacity,ticketprice,pricedesc,id5a,name5a,roomcount,bedcount,roomprice,boxcount,seatcount,personprice,licenseno,mainline,poitypename,poitypetag,detailurl,overallrating,servicerating,environmentrating,facilityrating,hygienerating,imgnum,commentnum,reservefield1,reservefield2,reservefield3,reservefield4,reservefield5,reservefield6,reservefield7,reservefield8,reservefield9,memo,gpsbd,gps,gpsgd,logourl,flagurl from infounits where localunitid='%@'",localunitid];
        
        const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        
        if(sqlite3_prepare_v2(self.db, sqlStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                requestunit.localunitid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                requestunit.username = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                requestunit.unitid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                requestunit.pid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                requestunit.typeid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                requestunit.areacode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                requestunit.areaname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                requestunit.unitname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                requestunit.shortname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                requestunit.orderno = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                requestunit.address	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                requestunit.postcode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                requestunit.zonecode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                requestunit.telephone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                requestunit.infotel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                requestunit.booktel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                requestunit.complainttel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                requestunit.fax = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                requestunit.url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                requestunit.url360 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                requestunit.logopic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                
                requestunit.flagpic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                requestunit.publictrafic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                requestunit.desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                requestunit.manager = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                requestunit.managertel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];
                requestunit.businesslicense	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
                requestunit.businesstime	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)];
                requestunit.level = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
                requestunit.sourcefrom = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)]; //默认为 1
                requestunit.state = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 30)];//默认为0
                requestunit.opentime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)];
                requestunit.decorationtime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,32)];
                requestunit.tips = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 33)];
                requestunit.favouredpolicy = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 34)];
                requestunit.innertrafic	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 35)];
                requestunit.maxcapacity	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 36)];
                requestunit.ticketprice = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 37)];
                requestunit.pricedesc	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 38)];
                requestunit.id5a = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 39)];
                requestunit.name5a = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 40)];
                
                requestunit.roomcount	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 41)];
                requestunit.bedcount	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 42)];
                requestunit.roomprice	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 43)];
                requestunit.boxcount	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 44)];
                requestunit.seatcount	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 45)];
                requestunit.personprice = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 46)];
                
                requestunit.licenseno = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 47)];
                requestunit.mainline = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 48)];
                requestunit.poitypename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 49)];
                requestunit.poitypetag = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 50)];
                requestunit.detailurl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 51)];
                requestunit.overallrating = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 52)];
                requestunit.servicerating = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 53)];
                requestunit.environmentrating = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 54)];
                requestunit.facilityrating = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 55)];
                requestunit.hygienerating = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 56)];
                requestunit.imgnum = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 57)];
                requestunit.commentnum = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 58)];
                
                requestunit.reservefield1	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 59)];
                requestunit.reservefield2	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 60)];
                requestunit.reservefield3	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 61)];
                requestunit.reservefield4	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 62)];
                requestunit.reservefield5	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 63)];
                requestunit.reservefield6	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 64)];
                requestunit.reservefield7	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 65)];
                requestunit.reservefield8	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 66)];
                requestunit.reservefield9	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 67)];
                requestunit.memo	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 68)];
                requestunit.gpsbd	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 69)];
                requestunit.gps	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 70)];
                requestunit.gpsgd	 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 71)];
                requestunit.logourl =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 72)];
                requestunit.flagurl =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 73)];
            }
        }
        sqlite3_finalize(statement);
    }
    requestunit.mediainfos = [self GetMediaInfos:localunitid];
    return requestunit;
}

-(void)SaveUnitImageURL:(NSString*)localunitid FieldName:(NSString*)fieldName URL:(NSString*)mediaurl
{
    if ([self OpenDB])
    {
    NSString *strsql = [NSString stringWithFormat:@"update infounits set %@ = '%@' where localunitid='%@'",fieldName,mediaurl,localunitid];
    const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
    char *errorMsg;
    sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
    sqlite3_close(self.db);
    }
}

-(void)SaveMediaURL:(NSString*)mid URL:(NSString*)mediaurl
{
    if ([self OpenDB])
    {
    NSString *strsql = [NSString stringWithFormat:@"update mediainfos set mediaurl = '%@' where mid = %@", mediaurl,mid];
    const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
    char *errorMsg;
    sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        sqlite3_close(self.db);
    }
    
}

-(void)UpLoadUnitSuccess:(NSString*)localunitid  UnitID:(NSString*)unitId
{
    if ([self OpenDB]) {
    NSString *strsql = [NSString stringWithFormat:@"update infounits set state = 1 ,unitid = %@ where localunitid = '%@'", unitId,localunitid];
    const char *sqlStatement =[strsql cStringUsingEncoding:NSUTF8StringEncoding];
    char *errorMsg;
    sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
    sqlite3_close(self.db);
    }
    
}

- (void)deleteInfoUnits:(NSString *)filename {
    if ([self OpenDB]) {
        NSString *sqlStr = [NSString stringWithFormat:@"delete from infoUnits where unitname = '%@'", filename];
        const char *sqlStatement = [sqlStr cStringUsingEncoding:NSUTF8StringEncoding];
        char *errorMsg;
        sqlite3_exec(self.db, sqlStatement, NULL, NULL, &errorMsg);
        sqlite3_close(self.db);
    }
}



@end



