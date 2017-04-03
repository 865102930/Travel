//
//  Request.m
//  旅游资源采集
//
//  Created by Alonezzz on 2017/3/14.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "Request.h"

@implementation RequestLogin
@end

@implementation RequestInfoUnit
-(id)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    self.mediainfos = [[NSMutableArray alloc] init];
    self.childs = [[NSMutableArray alloc] init];
    return  self;
}


@end

@implementation MediaInfo

@end

@implementation InfounitChild

-(id)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    self.childmedias = [[NSMutableArray alloc] init];
    return  self;
}

@end

@implementation InfoUnitChildMedia

@end

@implementation UpLoadData

@end

@implementation UserInfo


@end

@implementation InfoUnitPic


@end

