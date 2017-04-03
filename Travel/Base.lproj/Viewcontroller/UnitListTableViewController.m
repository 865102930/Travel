//
//  UnitListTableViewController.m
//  旅游资源采集
//
//  Created by gz on 17/3/23.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "UnitListTableViewController.h"
#import "DBFunCollect.h"
#import <AFNetworking.h>
#import "const.h"
#import "collectshare.h"
#import "InfoUnit.h"
#import "interface.h"
#import "ZJWistJson.h"

@interface UnitListTableViewController ()<UITableViewDataSource, UITableViewDelegate>

@end


@implementation UnitListTableViewController {
    NSMutableArray *unitlist;
    DBFunCollect *dbopt;
    UIButton *senders;
    NSMutableArray *imgArray;
    float i;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    i = 1;
    dbopt =[[DBFunCollect alloc] init];
    unitlist = [dbopt GetUnitList:_State];
    imgArray = [NSMutableArray array];
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.frame = CGRectMake(C_ScreenWidth / 2 - C_ScreenSizeChange(100), C_ScreenHeight / 2 - C_ScreenSizeChange(100), C_ScreenSizeChange(200), C_ScreenSizeChange(40));
    self.progressHUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return unitlist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unitcell" forIndexPath:indexPath];
    cell.textLabel.text = [unitlist[indexPath.row] unitname];
    cell.textLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(20)];
    if (_State == 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(C_ScreenWidth - C_ScreenSizeChange(80), cell.bounds.size.height / 2 - C_ScreenSizeChange(15), C_ScreenSizeChange(60), C_ScreenSizeChange(30));
        [btn addTarget:self action:@selector(stateButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor orangeColor].CGColor;
        btn.tag = indexPath.row;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:C_ScreenSizeChange(15)]];
        [btn setTitle:@"上传" forState:UIControlStateNormal];
        [cell addSubview:btn];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DBUnitInfo *deleteUnitInfo = unitlist[indexPath.row];
        [unitlist removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [dbopt deleteInfoUnits:deleteUnitInfo.unitname];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"sgunitlisttodetail" sender:[NSNumber numberWithInteger:indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"sgunitlisttodetail"]){
        InfoUnit *view = segue.destinationViewController;
        
        DBUnitInfo *unitinfo = (DBUnitInfo*)unitlist[[sender integerValue]];
        
        DBTypeInfo* typeinfo = [dbopt GetTypeInfo:unitinfo.typeid];
        
        [view setValue:typeinfo forKey:@"TypeInfo"];
        
        [view setValue:[dbopt GetRequestUnitInfo:unitinfo.localunitid] forKey:@"requestinfounit"];
        view.infounitblock=^(NSString* unitname) {
            unitinfo.unitname = unitname;
        };
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


/*********************************************************上传图片和数据****************************/

// 上传数据
-(void)UpLoadUnit:(RequestInfoUnit*)requestinfounit {
    //调用接口上传数据!
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    UpLoadData* uploaddata = [[UpLoadData alloc] init];
    uploaddata.infounit = requestinfounit;
    uploaddata.mediainfos = [NSMutableArray array];
    uploaddata.childs = [NSMutableArray array];
    
    uploaddata.infounitpic = [[InfoUnitPic alloc] init];
    uploaddata.infounitpic.logourl = uploaddata.infounit.logourl;
    uploaddata.infounitpic.flagurl = uploaddata.infounit.flagurl;
    uploaddata.mediainfos = requestinfounit.mediainfos;
    uploaddata.childs = requestinfounit.childs;
    
    uploaddata.userinfo = [[UserInfo alloc] init];
    uploaddata.userinfo.username = [[collectshare sharedInstanceMethod] username];
    uploaddata.userinfo.truename = [[collectshare sharedInstanceMethod] truename];
    
    [manager.requestSerializer setValue:[[collectshare sharedInstanceMethod] token]  forHTTPHeaderField:@"authorization"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",c_interfaceurl, @"UploadData"]
       parameters:[ZJWistJson getObjectData:uploaddata]
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self hideHUD];
             [dbopt UpLoadUnitSuccess:requestinfounit.localunitid UnitID:responseObject[@"message"]];
             unitlist = [dbopt GetUnitList:_State];
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传成功" preferredStyle:UIAlertControllerStyleAlert];
             [self presentViewController:alert animated:YES completion:nil];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self dismissViewControllerAnimated:YES completion:nil];
             });
             [[self tableView] reloadData];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传错误,请重新上传" preferredStyle:UIAlertControllerStyleAlert];
             [self presentViewController:alert animated:YES completion:nil];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self dismissViewControllerAnimated:YES completion:nil];
             });
         }];
}


// 上传图片
-(void)UpLoadMediaInfo:(RequestInfoUnit*)requestinfounit {
    if (requestinfounit.mediainfos.count == 0) {
        [self UpLoadUnit:requestinfounit];
    } else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
        
        for (MediaInfo *mediaInfo in requestinfounit.mediainfos) {
            [manager POST:[NSString stringWithFormat:@"https://mdapi.zjwist.com/MediaInfo/Save"] parameters:@{@"mid":@0,@"sysid":@5} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:[[collectshare sharedInstanceMethod] username]];
                UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", userpath, mediaInfo.filename]];
                NSData *data = UIImageJPEGRepresentation(image, 1);
                [formData appendPartWithFileData:data name:@"files" fileName:mediaInfo.filename mimeType:@"image/jpg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                self.mediaProgress = uploadProgress;
                [uploadProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *medialurl = [responseObject[@"results"][0] objectForKey:@"fileurl"];
                mediaInfo.mediaurl = medialurl;
                [dbopt SaveMediaURL:mediaInfo.mid URL:medialurl];
                if (mediaInfo == requestinfounit.mediainfos.lastObject) {
                    [self UpLoadUnit:requestinfounit];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传错误,请重新上传" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }
}

// 点击按钮的方法
- (void)stateButton:(UIButton *)sender {
    senders = sender;
    UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否上传?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *uploadAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:alrt completion:nil];
        [self uploadImg];
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alrt addAction:uploadAction];
    [alrt addAction:cancleAction];
    [self presentViewController:alrt animated:YES completion:nil];
}

// 上传图片
- (void)uploadImg {
    [self.view addSubview:self.HUD];
    [self.view addSubview:self.progressHUD];
    RequestInfoUnit *requestinfounit = [dbopt GetRequestUnitInfo:[unitlist[senders.tag] localunitid]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:[[collectshare sharedInstanceMethod] username]];
    UIImage *logoImag = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/%@",userpath, requestinfounit.logopic]];
    UIImage *flagImag = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/%@",userpath, requestinfounit.flagpic]];
    [imgArray removeAllObjects];
    if (logoImag != nil) [imgArray addObject:logoImag];
    if (flagImag != nil) [imgArray addObject:flagImag];
    if (requestinfounit.mediainfos.count != 0)
        [imgArray addObjectsFromArray:requestinfounit.mediainfos];
    if (logoImag&&flagImag) {
        if ([requestinfounit.logourl isEqualToString:@""] || [requestinfounit.logourl isEqualToString:@"(null)"]) {
            if ([requestinfounit.flagurl isEqualToString:@""] || [requestinfounit.flagurl isEqualToString:@"(null)"]) {
                [manager POST:[NSString stringWithFormat:@"https://mdapi.zjwist.com/MediaInfo/Save"] parameters:@{@"mid":@0,@"sysid":@5} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:[[collectshare sharedInstanceMethod] username]];
                    UIImage *imag = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/%@",userpath, requestinfounit.logopic]];
                    NSData *data = UIImageJPEGRepresentation(imag, 1);
                    [formData appendPartWithFileData:data name:@"files" fileName:requestinfounit.logopic mimeType:@"image/jpg"];
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    self.logoProgress = uploadProgress;
                    [uploadProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSString *medialurl = [responseObject[@"results"][0] objectForKey:@"fileurl"];
                    requestinfounit.logourl = medialurl;
                    [dbopt SaveUnitImageURL:requestinfounit.localunitid FieldName:@"logourl" URL:medialurl];
                    
                    if ([requestinfounit.flagurl isEqualToString:@""] || [requestinfounit.flagurl isEqualToString:@"(null)"]) {
                        [manager POST:[NSString stringWithFormat:@"https://mdapi.zjwist.com/MediaInfo/%@",@"Save"] parameters:@{@"mid":@0,@"sysid":@5} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                            NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:[[collectshare sharedInstanceMethod] username]];
                            UIImage *imag = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/%@",userpath, requestinfounit.flagpic]];
                            NSData *data = UIImageJPEGRepresentation(imag, 1);
                            [formData appendPartWithFileData:data name:@"files" fileName:requestinfounit.logopic mimeType:@"image/jpg"];
                        } progress:^(NSProgress * _Nonnull uploadProgress) {
                            self.flagProgress = uploadProgress;
                            [uploadProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                            NSString *medialurl = [responseObject[@"results"][0] objectForKey:@"fileurl"];
                            requestinfounit.flagurl = medialurl;
                            [dbopt SaveUnitImageURL:requestinfounit.localunitid FieldName:@"flagurl" URL:medialurl];
                            [self UpLoadMediaInfo:requestinfounit];
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            NSLog(@"error:%@",error);
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传错误,请重新上传" preferredStyle:UIAlertControllerStyleAlert];
                            [self presentViewController:alert animated:YES completion:nil];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self dismissViewControllerAnimated:YES completion:nil];
                            });
                        }];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error:%@",error);
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传错误,请重新上传" preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }
        }
    } else if (flagImag) {
        [manager POST:[NSString stringWithFormat:@"https://mdapi.zjwist.com/MediaInfo/%@",@"Save"] parameters:@{@"mid":@0,@"sysid":@5} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:[[collectshare sharedInstanceMethod] username]];
            UIImage *imag = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/%@",userpath, requestinfounit.flagpic]];
            NSData *data = UIImageJPEGRepresentation(imag, 1);
            [formData appendPartWithFileData:data name:@"files" fileName:requestinfounit.logopic mimeType:@"image/jpg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            self.logoProgress = uploadProgress;
            [uploadProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            NSString *medialurl = [responseObject[@"results"][0] objectForKey:@"fileurl"];
            requestinfounit.flagurl = medialurl;
            [dbopt SaveUnitImageURL:requestinfounit.localunitid FieldName:@"flagurl" URL:medialurl];
            [self UpLoadMediaInfo:requestinfounit];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error:%@",error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传错误,请重新上传" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    } else if (logoImag) {
        if ([requestinfounit.flagurl isEqualToString:@""] || [requestinfounit.flagurl isEqualToString:@"(null)"]) {
            [manager POST:[NSString stringWithFormat:@"https://mdapi.zjwist.com/MediaInfo/Save"] parameters:@{@"mid":@0,@"sysid":@5} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:[[collectshare sharedInstanceMethod] username]];
                UIImage *imag = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/%@",userpath, requestinfounit.logopic]];
                NSData *data = UIImageJPEGRepresentation(imag, 1);
                [formData appendPartWithFileData:data name:@"files" fileName:requestinfounit.logopic mimeType:@"image/jpg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                self.logoProgress = uploadProgress;
                [uploadProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *medialurl = [responseObject[@"results"][0] objectForKey:@"fileurl"];
                requestinfounit.logourl = medialurl;
                [dbopt SaveUnitImageURL:requestinfounit.localunitid FieldName:@"logourl" URL:medialurl];
                [self UpLoadMediaInfo:requestinfounit];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传错误,请重新上传" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
                
            }];
        }
    } else {
        [self UpLoadMediaInfo:requestinfounit];
    }

}

// kvo观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.logoProgress == object) {
            self.HUD.progress = self.logoProgress.fractionCompleted;
            [self showHUDWithString:[NSString stringWithFormat:@"正在上传第一张%.f%%", self.logoProgress.fractionCompleted * 100]];
        } else if (self.flagProgress == object) {
            self.HUD.progress = self.flagProgress.fractionCompleted;
            [self showHUDWithString:[NSString stringWithFormat:@"正在上传第二张%.f%%", self.flagProgress.fractionCompleted * 100]];
        } else if (self.mediaProgress == object) {
            self.HUD.progress = self.mediaProgress.fractionCompleted;
            [self showHUDWithString:[NSString stringWithFormat:@"正在上传media图片%.f%%", self.mediaProgress.fractionCompleted * 100]];
        }
        if (imgArray.count == 1) {
            self.progressHUD.progress = ((NSProgress *)object).fractionCompleted / imgArray.count;
        } else {
            self.progressHUD.progress = (self.logoProgress.fractionCompleted + self.flagProgress.fractionCompleted)/ imgArray.count;
        }
        self.progressHUD.label.text = [NSString stringWithFormat:@"共%lu张图片", (unsigned long)imgArray.count];

    });
}

#pragma  mark - MBProgressHUD

- (void)showHUDWithString:(NSString *)string {
    if (string.length == 0) {
        self.HUD.label.text = nil;
    } else {
        self.HUD.label.text = string;
    }
    [self.HUD showAnimated:YES];
    [self.progressHUD showAnimated:YES];
}

- (void)showHUD {
    [self showHUDWithString:nil];
}

- (void)hideHUD {
    if (self.HUD != nil) {
        [self.HUD removeFromSuperview];
        [self.progressHUD removeFromSuperview];
    }
}

- (void)dealloc {
    [self.logoProgress removeObserver:self forKeyPath:@"fractionCompleted"];
    [self.flagProgress removeObserver:self forKeyPath:@"fractionCompleted"];
    [self.mediaProgress removeObserver:self forKeyPath:@"fractionCompleted"];
}


@end

