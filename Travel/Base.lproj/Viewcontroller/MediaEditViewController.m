//
//  MediaEditViewController.m
//  旅游资源采集
//
//  Created by gz on 17/3/23.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "MediaEditViewController.h"
#import "collectshare.h"
#import "const.h"

@interface MediaEditViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@end

@implementation MediaEditViewController{
    Boolean ImgSelect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_mediainfo) {
        _imgTextField.text = _mediainfo.medianame;
        _remarkTextView.text = _mediainfo.memo;
        
        NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:[[collectshare sharedInstanceMethod] username]];
        _filename =_mediainfo.filename;
        [_selectImgButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",userpath,_filename]]
                          forState:UIControlStateNormal];
        ImgSelect = true;
    }else{
        ImgSelect = false;
    }
    
    self.imgTextField.delegate = self;
    [self creatUI];
}

- (void)creatUI {
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(SaveClick:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.nameLabel.frame = CGRectMake(C_ScreenSizeChange(20), C_ScreenSizeChange(94), C_ScreenSizeChange(50), C_ScreenSizeChange(30));
    self.imgTextField.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + C_ScreenSizeChange(15), CGRectGetMinY(self.nameLabel.frame),C_ScreenSizeChange(250), C_ScreenSizeChange(30));
    self.remarkLabel.frame= CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + C_ScreenSizeChange(20), CGRectGetWidth(self.nameLabel.frame), C_ScreenSizeChange(30));
    self.remarkTextView.frame = CGRectMake(CGRectGetMinX(self.imgTextField.frame), CGRectGetMinY(self.remarkLabel.frame), C_ScreenSizeChange(250), C_ScreenSizeChange(100));
    self.imgLabel.frame = CGRectMake(CGRectGetMinX(self.remarkLabel.frame), CGRectGetMaxY(self.remarkTextView.frame) + C_ScreenSizeChange(20), C_ScreenSizeChange(50), C_ScreenSizeChange(30));
    self.selectImgButton.frame =CGRectMake(C_ScreenWidth / 2 - C_ScreenSizeChange(75), CGRectGetMaxY(self.imgLabel.frame) + C_ScreenSizeChange(10), C_ScreenSizeChange(150), C_ScreenSizeChange(150));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 保存图片
- (IBAction)SaveClick:(id)sender {
    if (ImgSelect){
        BOOL add = false;
        if (!_mediainfo){
            _mediainfo = [[MediaInfo alloc]init];
            _mediainfo.mediaurl = @"";
            add = true;
        }
        _mediainfo.medianame = _imgTextField.text;
        _mediainfo.memo = _remarkTextView.text;
        _mediainfo.filename = _filename;
        _mediainfo.localunitid = _LocalUnitID;
        _mediainfo.username =[[collectshare sharedInstanceMethod] username];
        
        if (add){
            self.myBlock(_mediainfo);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选取照片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:doneAction];
        [alert addAction:cancleAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 照片的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *_photoImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        ImgSelect = true;
        NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:[[collectshare sharedInstanceMethod] username]];
        
        _filename = [NSString stringWithFormat:@"%@.jpg",[[collectshare sharedInstanceMethod] getUniqueStrByUUID]];
        
        [UIImageJPEGRepresentation(_photoImg, 1) writeToFile:[NSString stringWithFormat:@"%@/%@",userpath,_filename] atomically:YES];
        
        [_selectImgButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",userpath,_filename]] forState:UIControlStateNormal];
    }];
}


// 选择照片
- (IBAction)selectimgclick:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择类型" preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 调用相机
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertControl addAction:cameraAction];
    [alertControl addAction:libraryAction];
    [alertControl addAction:cancleAction];
    [self presentViewController:alertControl animated:YES completion:nil];
}


// s删除
- (IBAction)deleteclick:(id)sender {
    if (_mediainfo){
        self.myBlock(nil);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.remarkTextView endEditing:YES];
    [self.imgTextField endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.imgTextField endEditing:YES];
    return YES;
}


@end
