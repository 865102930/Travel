//
//  TXLClass.h
//  addresslist
//
//  Created by 庄 严 on 14-8-8.
//  Copyright (c) 2014年 浙江省旅游信息中心. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBUserInfo : NSObject

@property (nonatomic,strong) NSString* username;
@property (nonatomic,strong) NSString* truename;
@property (nonatomic) NSInteger isinit;
@property (nonatomic,strong) NSString* pareaname;
@property (nonatomic, copy) NSString *SyncTime;

-(id)initWithName:(NSString*)userName
         TrueName:(NSString*)trueName
         IsInit:(NSInteger)isInit
        PAreaName:(NSString*)pareaName
     lastSyncTime:(NSString *)syncTime;

@end

@interface DBTypeInfo : NSObject

@property (nonatomic) NSInteger pid;
@property (nonatomic) NSInteger typeid;
@property (nonatomic) NSInteger ptypeid;
@property (nonatomic,strong) NSString* typename;
@property (nonatomic) NSInteger existschild;
@property (nonatomic) NSInteger existsroom;
@property (nonatomic) NSInteger existsscenic;

-(id)initWithName:(NSInteger)pID
          TypeID:(NSInteger)typeID
            PTypeID:(NSInteger)ptypeID
         TypeName:(NSString *)typeName
      ExistsChild:(NSInteger)existsChild
       ExistsRoom:(NSInteger)existsRoom
     ExistsScenic:(NSInteger)existsScenic;

@end

@interface DBFieldGroup : NSObject

@property (nonatomic,strong) NSString* groupname;
@property (nonatomic) NSInteger typeid;
@property (nonatomic,strong) NSMutableArray* typefields;

-(id)initWithName:(NSString*)groupName
           TypeID:(NSInteger)typeID;
@end

@interface DBTypeField:NSObject

@property (nonatomic,strong) NSString* fieldname;
@property (nonatomic,strong) NSString* fieldtype;
@property (nonatomic,strong) NSString* customname;

-(id)initWithName:(NSString*)fieldName
        FieldType:(NSString*)fieldType
       CustomName:(NSString*)customName;

@end

@interface DBAreaCode : NSObject
@property (nonatomic,strong) NSString* areacode;
@property (nonatomic,strong) NSString* areaname;
@property (nonatomic,strong) NSString* zonecode;
@property (nonatomic,strong) NSString* postcode;

-(id)initWithName:(NSString*)areaCode
         AreaName:(NSString*)areaName
         PostCode:(NSString*)postCode
         ZoneCode:(NSString*)zoneCode;
@end

@interface DBUnitInfo : NSObject
@property (nonatomic,strong) NSString* unitname;
@property (nonatomic,strong) NSString* localunitid;
@property (nonatomic) NSInteger typeid;

-(id)initWithName:(NSString*)unitName
      LocalUnitID:(NSString*)localUnitid
           TypeID:(NSInteger)typeId;

@end
