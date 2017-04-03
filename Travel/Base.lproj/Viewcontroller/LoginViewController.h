//
//  LoginViewController.h
//  旅游资源采集
//
//  Created by Alonezzz on 2017/3/14.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

const NSString *constStr = @"hahah";

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tbusername;
@property (weak, nonatomic) IBOutlet UITextField *tbpwd;
@property (weak, nonatomic) IBOutlet UIButton *btnlogin;
- (IBAction)btnloginclick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *travleSourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPwdLabel;

@property (nonatomic, strong) MBProgressHUD *HUD;

- (void)showHUDWithString:(NSString *)string;

- (void)showHUD;

- (void)hideHUD;

@end
