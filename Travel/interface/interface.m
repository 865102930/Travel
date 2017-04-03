//
//  interface.m
//  旅游资源采集
//
//  Created by Alonezzz on 2017/3/14.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "interface.h"
#import "const.h"
#import "ZJWistJson.h"
#import "collectshare.h"
#import "DBFunUser.h"
#import <AFNetworking.h>
#import "DBFunCollect.h"
@implementation interface

+(void)login:(RequestLogin*)requestlogin LoginResult:(getResult)resultblock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",c_interfaceurl, @"Login"] parameters:[ZJWistJson getObjectData:requestlogin] progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Result *loginresult = [[Result alloc] initWithDictionary:responseObject];
        if (resultblock)
        {
            NSArray *results = (NSArray*)[responseObject objectForKey:@"results"];
            resultblock(loginresult,results,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (resultblock)
        {
            resultblock(nil,nil,NSLocalizedString(@"Interface.NetWorkError", @"Find Interface"));
        }
    }];
    
}

+(void)GetServiceTime:(getResult)resultblock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    NSLog(@"%@", manager.requestSerializer.HTTPRequestHeaders);
    [manager.requestSerializer setValue:[[collectshare sharedInstanceMethod] token]  forHTTPHeaderField:@"authorization"];
    [manager GET:[NSString stringWithFormat:@"%@%@",c_interfaceurl,@"GetServiceTime"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Result *initresult = [[Result alloc] initWithDictionary:responseObject];
        NSArray *results = (NSArray*)[responseObject objectForKey:@"results"];
        if (resultblock) {
            resultblock(initresult,results,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

+(void)InitData:(getResult)resultblock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager.requestSerializer setValue:[[collectshare sharedInstanceMethod] token]  forHTTPHeaderField:@"authorization"];
    [manager GET:[NSString stringWithFormat:@"%@%@?pid=%ld",c_interfaceurl,@"InitData",(long)[[collectshare sharedInstanceMethod] pid]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Result *initresult = [[Result alloc] initWithDictionary:responseObject];
        NSArray *results = (NSArray*)[responseObject objectForKey:@"results"];
        
        //导入数据
        if (resultblock) {
            resultblock(initresult,results,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}


+ (void)SyncData:(NSString *)lastSyncTime syncResult:(getResult)resultblock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager.requestSerializer setValue:[[collectshare sharedInstanceMethod] token]  forHTTPHeaderField:@"authorization"];
    
     NSString *result = [lastSyncTime stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:[NSString stringWithFormat:@"%@%@?pid=%ld&lastupdatetime=%@",c_interfaceurl,@"SyncData",(long)[[collectshare sharedInstanceMethod] pid], result] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Result *initresult = [[Result alloc] initWithDictionary:responseObject];
        NSArray *results = (NSArray*)[responseObject objectForKey:@"results"];
        
        //导入数据
        if (resultblock) {
            resultblock(initresult,results,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

}

+(void)UpLoadImage:(NSString*)imagefilename mediaResult:(UploadResult)resultblock;
{
    if ([imagefilename isEqualToString:@""])
    {
        Result *result = [[Result alloc] init];
        result.code = -1;
        result.message = @"";
        resultblock(result,nil,nil,nil);
    }
    else
    {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"https://mdapi.zjwist.com/MediaInfo/%@",@"Save"] parameters:@{@"mid":@0,@"sysid":@5} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:[[collectshare sharedInstanceMethod] username]];
        UIImage *imag = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/%@",userpath, imagefilename]];
        NSData *data = UIImageJPEGRepresentation(imag, 0.5);
        [formData appendPartWithFileData:data name:@"files" fileName:imagefilename mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (resultblock) {
            resultblock(nil,nil,nil,uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        
        Result *mediareult = [[Result alloc] initWithDictionary:responseObject];
        NSArray *results = (NSArray*)[responseObject objectForKey:@"results"];
        if (mediareult.code == 0)
        {
            resultblock(mediareult,results,nil,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (resultblock)
        {
            resultblock(nil,nil,NSLocalizedString(@"Interface.NetWorkError", @"Find Interface"),nil);
        }
        //NSLog(@"error:%@",error);
    }];
    }
}

+(void)UpLoadInfoUnit:(RequestInfoUnit*)requestinfounit UnitResult:(UploadResult)resultblock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    UpLoadData* uploaddata = [[UpLoadData alloc] init];
    uploaddata.infounit = requestinfounit;
    uploaddata.mediainfos = requestinfounit.mediainfos;
    uploaddata.childs = requestinfounit.childs;
    
    uploaddata.infounitpic = [[InfoUnitPic alloc] init];
    uploaddata.infounitpic.logourl = uploaddata.infounit.logourl;
    uploaddata.infounitpic.flagurl = uploaddata.infounit.flagurl;
    uploaddata.userinfo =[[UserInfo alloc] init];
    uploaddata.userinfo.username = [[collectshare sharedInstanceMethod] username];
    uploaddata.userinfo.truename = [[collectshare sharedInstanceMethod] truename];
    
    
    [manager.requestSerializer setValue:[[collectshare sharedInstanceMethod] token]  forHTTPHeaderField:@"authorization"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@%@",c_interfaceurl, @"UploadData"]
       parameters:[ZJWistJson getObjectData:uploaddata]
         progress:^(NSProgress * _Nonnull uploadProgress) {
             resultblock(nil,nil,nil,uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Result *loginresult = [[Result alloc] initWithDictionary:responseObject];
        if (resultblock)
        {
            NSArray *results = (NSArray*)[responseObject objectForKey:@"results"];
            resultblock(loginresult,results,nil,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (resultblock)
        {
            resultblock(nil,nil,NSLocalizedString(@"Interface.NetWorkError", @"Find Interface"),nil);
        }
    }];
}

@end
