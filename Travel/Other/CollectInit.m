//
//  CollectInit.m
//  旅游资源采集
//
//  Created by Alonezzz on 2017/3/14.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "CollectInit.h"
#import "const.h"

@implementation CollectInit


-(void)InitData {
    NSString *dbfileName = [c_DocumentsDirectory stringByAppendingPathComponent:@"zjwist.sqlite"];
    
    
    NSFileManager *filemanage = [NSFileManager defaultManager];
    
    if (![filemanage fileExistsAtPath:dbfileName])
    {
        NSString *dbsource = [[NSBundle mainBundle] pathForResource:@"zjwist" ofType:@"sqlite"];
        
        [filemanage copyItemAtPath:dbsource toPath:dbfileName error:NULL];
    }
    //如果以后有升级的代码，可以写在这里
}

-(void)CreateUserDir:(NSString*)username {
    NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:username];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    
    // withIntermediateDirectories
    // YES 如果文件夹不存在，则创建， 如果存在表示可以覆盖
    // NO  如果文件夹不存在，则创建， 如果存在不可以覆盖
    
    [filemanage createDirectoryAtPath:userpath
          withIntermediateDirectories:NO
                           attributes:nil
                                error:nil];

}
@end
