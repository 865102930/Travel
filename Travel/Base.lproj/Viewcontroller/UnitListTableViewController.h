//
//  UnitListTableViewController.h
//  旅游资源采集
//
//  Created by gz on 17/3/23.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Request.h"
#import <MBProgressHUD.h>

@interface UnitListTableViewController : UITableViewController

@property(nonatomic,strong) RequestInfoUnit *InfoUnit;

@property (nonatomic) NSInteger State;
@property (nonatomic, strong) NSProgress *logoProgress;
@property (nonatomic, strong) NSProgress *flagProgress;
@property (nonatomic, strong) NSProgress *mediaProgress;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
- (void)showHUDWithString:(NSString *)string;

- (void)showHUD;

- (void)hideHUD;

@end
