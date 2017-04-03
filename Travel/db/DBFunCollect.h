//
//  FirstPageDBOpt.h
//  addresslist
//
//  Created by 庄 严 on 14-8-8.
//  Copyright (c) 2014年 浙江省旅游信息中心. All rights reserved.
//

#import "DBOption.h"
#import "DBObject.h"
#import "request.h"

@interface DBFunCollect : DBOption

-(NSMutableArray*)GetTypeList:(NSInteger)ptypeid SpaceCount:(NSInteger)spaceCount;

-(DBTypeInfo*)GetTypeInfo:(NSInteger)typeid;

-(NSMutableArray*)GetTypeFieldGroup:(NSInteger)typeid;

-(void)GetTypeField:(DBFieldGroup*)group;

-(NSMutableArray*)GetAreaCodeLike:(NSString*)areacode;

-(DBAreaCode*)GetAreaCodeInfo:(NSString*)areaCode;

-(void)SaveUnit:(RequestInfoUnit*)infoUnit;

-(NSMutableArray*)GetTypeFields:(NSInteger)typeid;

-(NSMutableArray*)GetUnitList:(NSInteger)staTe;

-(RequestInfoUnit*)GetRequestUnitInfo:(NSString*)localunitid;

-(void)SaveUnitImageURL:(NSString*)localunitid FieldName:(NSString*)fieldName URL:(NSString*)mediaurl;

-(void)SaveMediaURL:(NSString*)mid URL:(NSString*)mediaurl;

-(void)UpLoadUnitSuccess:(NSString*)localunitid UnitID:(NSString*)unitId;

- (void)deleteInfoUnits:(NSString *)filename;

@end
