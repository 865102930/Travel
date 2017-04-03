//
//  Result.h
//  旅游资源采集
//
//  Created by Alonezzz on 2017/3/14.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Jastor.h"

@interface Result : Jastor

@property (nonatomic) NSInteger code;

@property (nonatomic,strong) NSString* message;

@end

@interface LoginInfo : Jastor

@property (nonatomic,strong) NSString* username;
@property (nonatomic,strong) NSString* truename;
@property (nonatomic) NSInteger unitid;
@property (nonatomic) NSInteger pid;
@property (nonatomic,strong) NSString* pname;
@property (nonatomic,strong) NSString* token;
@property (nonatomic,strong) NSString* areacode;

@end

@interface AreaCode : Jastor
@property (nonatomic, copy) NSString *areacode;
@property (nonatomic, copy) NSString *areaname;
@property (nonatomic, copy) NSString *zonecode;
@property (nonatomic, copy) NSString *postcode;

@end

@interface TypeInFos : Jastor
@property (nonatomic, assign) NSInteger typeid;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger orderno;
@property (nonatomic, copy) NSString *typename;
@property (nonatomic, copy) NSString *mobilememo;
@property (nonatomic, assign) NSInteger ptypeid;
@property (nonatomic, assign) NSInteger existschild;
@property (nonatomic, assign) NSInteger existsroom;
@property (nonatomic, assign) NSInteger existsscenic;
@property (nonatomic, assign) NSInteger deleteflag;

@end

@interface TypeFields : Jastor
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger typeid;
@property (nonatomic, assign) NSInteger orderno;
@property (nonatomic, copy) NSString *fieldname;
@property (nonatomic, copy) NSString *fieldtype;
@property (nonatomic, copy) NSString *groupname;
@property (nonatomic, copy) NSString *customname;
@property (nonatomic, assign) NSInteger isedit;
@property (nonatomic, assign) NSInteger deleteflag;
@end

typedef void (^getResult)(Result *result,NSArray *results,NSString *errorstr);

typedef void (^UploadResult)(Result *result, NSArray *results,NSString *errorsrt, NSProgress *progress);

