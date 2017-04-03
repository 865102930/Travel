//
//  TXLClass.m
//  addresslist
//
//  Created by 庄 严 on 14-8-8.
//  Copyright (c) 2014年 浙江省旅游信息中心. All rights reserved.
//

#import "DBObject.h"

@implementation DBUserInfo

-(id)initWithName:(NSString *)userName
         TrueName:(NSString *)trueName
           IsInit:(NSInteger)isInit
        PAreaName:(NSString *)pareaName
     lastSyncTime:(NSString *)syncTime

{
    self = [super init];
    if (self)
    {
        self.username = userName;
        self.truename = trueName;
        self.isinit = isInit;
        self.pareaname = pareaName;
        self.SyncTime = syncTime;
    }
    return  self;
}

@end

@implementation DBTypeInfo

-(id)initWithName:(NSInteger )pID
           TypeID:(NSInteger )typeID
          PTypeID:(NSInteger)ptypeID
         TypeName:(NSString *)typeName
      ExistsChild:(NSInteger)existsChild
       ExistsRoom:(NSInteger)existsRoom
     ExistsScenic:(NSInteger)existsScenic
{
    self = [super init];
    if (self)
    {
        self.pid = pID;
        self.typeid = typeID;
        self.ptypeid = ptypeID;
        self.typename = typeName;
        self.existschild = existsChild;
        self.existsroom = existsRoom;
        self.existsscenic = existsScenic;
    }
    return  self;
}

@end

@implementation DBFieldGroup


-(id)initWithName:(NSString *)groupName TypeID:(NSInteger)typeID
{
    self = [super init];
    if (self)
    {
        self.groupname = groupName;
        self.typeid = typeID;
        self.typefields = [[NSMutableArray alloc] init];
    }
    return  self;
}

@end

@implementation DBTypeField

-(id)initWithName:(NSString *)fieldName
        FieldType:(NSString *)fieldType
       CustomName:(NSString *)customName
{
    self = [super init];
    if (self)
    {
        self.fieldname = fieldName;
        self.fieldtype = fieldType;
        self.customname = customName;
    }
    return  self;
}

@end

@implementation DBAreaCode

-(id)initWithName:(NSString *)areaCode
         AreaName:(NSString *)areaName
         PostCode:(NSString *)postCode
         ZoneCode:(NSString *)zoneCode

{
    self = [super init];
    if (self)
    {
        self.areacode = areaCode;
        self.areaname = areaName;
        self.zonecode = zoneCode;
        self.postcode = postCode;
    }
    return  self;
}

@end

@implementation DBUnitInfo


-(id)initWithName:(NSString *)unitName
      LocalUnitID:(NSString *)localUnitid
           TypeID:(NSInteger)typeId
{
    self = [super init];
    if (self)
    {
        self.unitname = unitName;
        self.localunitid = localUnitid;
        self.typeid = typeId;
    }
    return  self;
}

@end

