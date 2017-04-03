//
//  DBOption.m
//  addresslist
//
//  Created by 庄 严 on 14-8-5.
//  Copyright (c) 2014年 浙江省旅游信息中心. All rights reserved.
//

#import "DBOption.h"
#import "const.h"

@implementation DBOption
{
    NSString* dbfileName;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        dbfileName = [c_DocumentsDirectory stringByAppendingString:@"/zjwist.sqlite"];
//        NSFileManager *filemanager = [NSFileManager defaultManager];
//        BOOL isRemove = [filemanager removeItemAtPath:dbfileName error:nil];
        NSLog(@"%@",dbfileName);
    }
    return self;
}

- (void)dealloc
{
    sqlite3_close(_db);
    _db = nil;
}

-(BOOL)OpenDB
{
    BOOL success = NO;
    if(sqlite3_open([dbfileName UTF8String], &_db) == SQLITE_OK)
    {
        success = YES;
    }
    else
    {
        success = NO;
//        NSFileManager *filemanager = [NSFileManager defaultManager];
//        [filemanager removeItemAtPath:dbfileName error:nil];
    }
    return success;
}

@end
