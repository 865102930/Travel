//
//  CommunityTableViewController.h
//  旅游资源采集
//
//  Created by gz on 17/3/20.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturenBlock)(id subStr);

@interface CommunityTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *streetArray;
@property (nonatomic, strong) id object;
@property (nonatomic, copy) ReturenBlock myBlock;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
