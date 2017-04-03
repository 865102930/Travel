//
//  LoginViewController.m
//  旅游资源采集
//
//  Created by Alonezzz on 2017/3/14.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "Request.h"
#import "collectshare.h"
#import "ZJWistJson.h"
#import "interface.h"
#import "CollectInit.h"
#import "DBFunUser.h"
#import "TypeInfoTableViewController.h"
#import "const.h"

@interface LoginViewController ()<UITextFieldDelegate> {
    UIActivityIndicatorView *activity;
    UILabel *textLabel;
}

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *btnoffline = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Login.OffLine", "Login.OffLine")
                                                                  style:UIBarButtonItemStyleDone target:self
                                                                 action:@selector(btnoffline:)];
    self.navigationItem.rightBarButtonItem = btnoffline;
    
    _tbusername.text = [[collectshare sharedInstanceMethod] username];
    _tbpwd.text = [[collectshare sharedInstanceMethod] pwd];
    _tbusername.delegate = self;
    _tbpwd.delegate = self;
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    [self creatUI];
    
}

- (void)creatUI {
    self.travleSourceLabel.frame = CGRectMake(C_ScreenSizeChange(20), C_ScreenSizeChange(120), C_ScreenWidth - C_ScreenSizeChange(40), C_ScreenSizeChange(50));
    self.travleSourceLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(25)];
    self.usernameLabel.frame = CGRectMake(C_ScreenSizeChange(40), CGRectGetMaxY(self.travleSourceLabel.frame) + C_ScreenSizeChange(30), C_ScreenSizeChange(80), C_ScreenSizeChange(30));
    self.usernameLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(17)];
    self.tbusername.frame = CGRectMake(CGRectGetMaxX(self.userPwdLabel.frame), CGRectGetMinY(self.usernameLabel.frame), C_ScreenSizeChange(200), C_ScreenSizeChange(30));
    self.tbusername.font = [UIFont systemFontOfSize:C_ScreenSizeChange(17)];
    self.userPwdLabel.frame = CGRectMake(CGRectGetMinX(self.usernameLabel.frame), CGRectGetMaxY(self.usernameLabel.frame) + C_ScreenSizeChange(15), C_ScreenSizeChange(80), C_ScreenSizeChange(30));
    self.userPwdLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(17)];
    self.tbpwd.frame = CGRectMake(CGRectGetMinX(self.tbusername.frame), CGRectGetMinY(self.userPwdLabel.frame), C_ScreenSizeChange(200), C_ScreenSizeChange(30));
    self.tbpwd.font = [UIFont systemFontOfSize:C_ScreenSizeChange(17)];
    self.btnlogin.frame = CGRectMake(C_ScreenSizeChange(100), CGRectGetMaxY(self.tbpwd.frame) + C_ScreenSizeChange(30), C_ScreenWidth - C_ScreenSizeChange(200), C_ScreenSizeChange(30));
    [self.btnlogin.titleLabel setFont:[UIFont systemFontOfSize:C_ScreenSizeChange(17)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)btnloginclick:(id)sender {
    [self.tbusername endEditing:YES];
    [self.tbpwd endEditing:YES];
    RequestLogin* requestlogin = [[RequestLogin alloc] init];
    requestlogin.username = _tbusername.text;
    requestlogin.pwd = _tbpwd.text;
    [self showHUDWithString:@"正在登录..."];
    
    [interface login:requestlogin LoginResult:^(Result *result,NSArray *results, NSString *errorstr) {
        
        NSString* errorstring = @"";
        if (errorstr != nil ) {
            errorstring = errorstr;
        } else if (result.code != 0){
            errorstring = result.message;
        }
        
        if (![errorstring isEqualToString:@""]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Common.AlterTitle", @"Find Common")
                                                                                     message:[NSString stringWithFormat:@"%@", errorstring]
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Common.AlterOK", @"Find Common")
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            [self hideHUD];
        }else {
//            [self showHUDWithString:@"登陆成功"];
            //登录成功
            NSDictionary *logindict =[results objectAtIndex:0];
            LoginInfo* logininfo =  [[LoginInfo alloc] initWithDictionary:logindict];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:logininfo.username forKey:@"username"];
            [userDefaults setValue:logininfo.truename forKey:@"truename"];
            [userDefaults setValue:requestlogin.pwd forKey:@"pwd"];
            [userDefaults setInteger:logininfo.unitid forKey:@"unitid"];
            [userDefaults setInteger:logininfo.pid forKey:@"pid"];
            [userDefaults setValue:logininfo.token forKey:@"token"];
            [userDefaults setValue:logininfo.areacode forKey:@"areacode"];
            [userDefaults synchronize];
            
            [[collectshare sharedInstanceMethod] getconfig];
            [[CollectInit alloc] CreateUserDir:logininfo.username];
            [self InitData];
        }
    }];
}

// 离线按钮
- (IBAction)btnoffline:(id)sender {
    [self performSegueWithIdentifier:@"toTypeInfoList" sender:[NSNumber numberWithInt:0]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toTypeInfoList"])
    {
        UIViewController *view = segue.destinationViewController;
        [view setValue:sender  forKey:@"onLineStatus"];
    }
}



-(void)InitData {
    //初始化数据！
    DBFunUser *db = [[DBFunUser alloc]init];
    DBUserInfo *userinfo = [db GetUserInfo:[[collectshare sharedInstanceMethod] username]];
    if (userinfo == NULL)
    {
        userinfo = [[DBUserInfo alloc] initWithName:[[collectshare sharedInstanceMethod] username]
                                           TrueName:[[collectshare sharedInstanceMethod] truename]
                                             IsInit:0
                                          PAreaName:[[collectshare sharedInstanceMethod] areacode]
                                       lastSyncTime:@""];
        [db SaveUserInfo:userinfo];
    }
    
    
    [interface GetServiceTime:^(Result *result, NSArray *results, NSString *errorstr) {
        [self showHUDWithString:@"正在初始化数据..."];
        NSString* errorstring = @"";
        if (errorstr != nil ){
            errorstring = errorstr;
        }
        else if (result.code != 0) {
            errorstring = result.message;
        }
        
        if (![errorstring isEqualToString:(@"")]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Common.AlterTitle", @"Find Common")
                                                                                     message:[NSString stringWithFormat:@"%@", errorstring]
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Common.AlterOK", @"Find Common")
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            NSDictionary *timeDic = [results objectAtIndex:0];
            NSString *timeStr = [timeDic objectForKey:@"servicetime"];
            
            if (userinfo.isinit == 0) {
                //进行初始化操作
                [interface InitData:^(Result *result, NSArray *results, NSString *errorstr) {
                    
                    NSString* errorstring = @"";
                    if (errorstr != nil ){
                        errorstring = errorstr;
                    } else if (result.code != 0) {
                        errorstring = result.message;
                    }
                    
                    if (![errorstring isEqualToString:(@"")]) {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Common.AlterTitle", @"Find Common")
                                                                                                 message:[NSString stringWithFormat:@"%@", errorstring]
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Common.AlterOK", @"Find Common")
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:nil];
                        
                        [alertController addAction:okAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    } else{
                        // 数据库初始化
                        [self showHUDWithString:@"正在初始化数据库..."];
                        [[[DBFunUser alloc] init] InitData:[results objectAtIndex:0] serviceTime:timeStr];
                        [self hideHUD];
                        [self performSegueWithIdentifier:@"toTypeInfoList" sender:[NSNumber numberWithInt:1]];
                    }
                    
                }];
            } else {
                [interface SyncData:userinfo.SyncTime syncResult:^(Result *result, NSArray *results, NSString *errorstr) {
                    NSString* errorstring = @"";
                    if (errorstr != nil ) {
                        errorstring = errorstr;
                    }else if (result.code != 0) {
                        errorstring = result.message;
                    }
                    
                    if (![errorstring isEqualToString:(@"")])
                    {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Common.AlterTitle", @"Find Common")
                                                                                                 message:[NSString stringWithFormat:@"%@", errorstring]
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Common.AlterOK", @"Find Common")
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:nil];
                        
                        [alertController addAction:okAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    } else{
                        [self showHUDWithString:@"正在初始化数据..."];
                        // 数据库初始化
                        [[[DBFunUser alloc] init] syncData:[results objectAtIndex:0] serviceTime:timeStr];
                        [self hideHUD];
                        [self performSegueWithIdentifier:@"toTypeInfoList" sender:[NSNumber numberWithInt:1]];
                        
                    }
                    
                }];
            }
        }
    }];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_tbusername resignFirstResponder];
    [_tbpwd resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_tbusername resignFirstResponder];
    [_tbpwd resignFirstResponder];
    return YES;
}

#pragma mark - HUD 小菊花

- (void)showHUDWithString:(NSString *)string {
    if (string.length == 0) {
        self.HUD.label.text = nil;
    } else {
        self.HUD.label.text = string;
    }
    [self.HUD showAnimated:YES];
}

- (void)showHUD {
    [self showHUDWithString:nil];
}

- (void)hideHUD {
    if (self.HUD != nil) {
        [self.HUD removeFromSuperview];
    }
}





@end
