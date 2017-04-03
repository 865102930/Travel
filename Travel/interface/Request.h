//
//  Request.h
//  旅游资源采集
//
//  Created by Alonezzz on 2017/3/14.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestLogin : NSObject

@property (nonatomic,strong) NSString* username;
@property (nonatomic,strong) NSString* pwd;


@end

@interface RequestInfoUnit : NSObject 

@property (nonatomic, strong) NSString *localunitid;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString* unitid;
@property (nonatomic,strong) NSString* pid;
@property (nonatomic,strong) NSString* typeid;
@property (nonatomic, strong) NSString *areacode;
@property (nonatomic, strong) NSString *areaname;
@property (nonatomic, strong) NSString *unitname;
@property (nonatomic, strong) NSString *shortname;
@property (nonatomic,strong) NSString *orderno;
@property (nonatomic, strong) NSString *address	;
@property (nonatomic, strong) NSString *postcode;
@property (nonatomic, strong) NSString *zonecode;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *infotel;
@property (nonatomic, strong) NSString *booktel;
@property (nonatomic, strong) NSString *complainttel;
@property (nonatomic, strong) NSString *fax;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *url360;
@property (nonatomic, strong) NSString *logopic;

@property (nonatomic, strong) NSString *flagpic;
@property (nonatomic, strong) NSString *publictrafic;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *manager;
@property (nonatomic, strong) NSString *managertel;
@property (nonatomic, strong) NSString *businesslicense	;
@property (nonatomic, strong) NSString *businesstime	;
@property (nonatomic,strong) NSString* level;
@property (nonatomic,strong) NSString* sourcefrom; //默认为 1
@property (nonatomic,strong) NSString* state;//默认为0
@property (nonatomic, strong) NSString *opentime;
@property (nonatomic, strong) NSString *decorationtime;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, strong) NSString *favouredpolicy;
@property (nonatomic, strong) NSString *innertrafic	;
@property (nonatomic,strong) NSString* maxcapacity	;
@property (nonatomic,strong) NSString *ticketprice;
@property (nonatomic, strong) NSString *pricedesc	;
@property (nonatomic,strong) NSString *id5a;
@property (nonatomic,strong) NSString *name5a;

@property (nonatomic,strong) NSString* roomcount	;
@property (nonatomic,strong) NSString* bedcount	;
@property (nonatomic,strong) NSString* roomprice	;
@property (nonatomic,strong) NSString* boxcount	;
@property (nonatomic,strong) NSString* seatcount	;
@property (nonatomic,strong) NSString* personprice;

@property (nonatomic,strong) NSString* licenseno;
@property (nonatomic,strong) NSString* mainline;
@property (nonatomic,strong) NSString* poitypename;
@property (nonatomic,strong) NSString* poitypetag;
@property (nonatomic,strong) NSString* detailurl;
@property (nonatomic,strong) NSString* overallrating;
@property (nonatomic,strong) NSString* servicerating;
@property (nonatomic,strong) NSString* environmentrating;
@property (nonatomic,strong) NSString* facilityrating;
@property (nonatomic,strong) NSString* hygienerating;
@property (nonatomic,strong) NSString* imgnum;
@property (nonatomic,strong) NSString* commentnum;

@property (nonatomic, strong) NSString *reservefield1	;
@property (nonatomic, strong) NSString *reservefield2	;
@property (nonatomic, strong) NSString *reservefield3	;
@property (nonatomic, strong) NSString *reservefield4	;
@property (nonatomic, strong) NSString *reservefield5	;
@property (nonatomic, strong) NSString *reservefield6	;
@property (nonatomic, strong) NSString *reservefield7	;
@property (nonatomic, strong) NSString *reservefield8	;
@property (nonatomic, strong) NSString *reservefield9	;
@property (nonatomic, strong) NSString *memo	;
@property (nonatomic, strong) NSString *gpsbd	;
@property (nonatomic, strong) NSString *gps	;
@property (nonatomic, strong) NSString *gpsgd	;
@property (nonatomic, strong) NSString *logourl	;
@property (nonatomic, strong) NSString *flagurl	;

@property (nonatomic,strong) NSMutableArray* mediainfos;
@property (nonatomic,strong) NSMutableArray* childs;

@end

@interface MediaInfo :NSObject

@property (nonatomic,strong) NSString* mid;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *localunitid;
@property (nonatomic,strong) NSString *mediaurl;
@property (nonatomic,strong) NSString *filename;
@property (nonatomic,strong) NSString *medianame;
@property (nonatomic,strong) NSString *memo;


@end

@interface InfounitChild : NSObject

@property (nonatomic,strong) NSString* childid;
@property (nonatomic,strong) NSString * localchildid;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *localunitid;
@property (nonatomic,strong) NSString *filename;
@property (nonatomic,strong) NSString *childname;
@property (nonatomic,strong) NSString *gps;
@property (nonatomic,strong) NSString *gpsbd;
@property (nonatomic,strong) NSString *memo;

@property (nonatomic,strong) NSMutableArray* childmedias;
@property (nonatomic, strong) NSMutableArray *mediainfos;
@property (nonatomic, strong) NSMutableArray *childs;

@end

@interface InfoUnitChildMedia : NSObject

@property (nonatomic,strong) NSString* childmediaid;
@property (nonatomic,strong) NSString *localunitid;
@property (nonatomic,strong) NSString *localchildid;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *filename;
@property (nonatomic,strong) NSString *mediaurl;
@property (nonatomic,strong) NSString *childmedianame;

@end

@interface UserInfo : NSObject

@property (nonatomic,strong) NSString* username;
@property (nonatomic,strong) NSString* truename;

@end

@interface InfoUnitPic : NSObject

@property(nonatomic,strong) NSString* logourl;
@property(nonatomic,strong) NSString* flagurl;

@end

@interface UpLoadData :NSObject

@property (nonatomic,strong) RequestInfoUnit *infounit;
@property (nonatomic,strong) UserInfo *userinfo;
@property (nonatomic,strong) InfoUnitPic* infounitpic;
@property (nonatomic, strong) NSMutableArray *mediainfos;
@property (nonatomic, strong) NSMutableArray *childs;

@end


