//
//  InfoUnit.m
//  旅游资源采集
//
//  Created by gz on 17/3/15.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "InfoUnit.h"
#import "DBFunCollect.h"
#import "MapTableViewCell.h"
#import "RemarksTableViewCell.h"
#import "PhotoImgTableViewCell.h"
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapTableViewCell.h"
#import "InfoUnitTableViewCell.h"
#import "DBFunUser.h"
#import "collectshare.h"
#import "AreaCodeTableViewCell.h"
#import "AreaCodeViewController.h"
#import "StreetTableViewController.h"
#import "CommunityTableViewController.h"
#import <objc/runtime.h>
#import "const.h"

@interface InfoUnit ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate, UITextFieldDelegate, UITextViewDelegate> {
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    NSString *currfieldname;
    InfoUnitTableViewCell *infoCell;
    NSString *customNameStr;
    UITextField *customTextField;
    NSString *areacodeStr;// 浙江省/杭州市/...
    AreaCodeTableViewCell *areacodeCell;
}

@end

@implementation InfoUnit {
    NSMutableArray *groupList;
    DBUserInfo* userinfo;
    NSMutableArray *areacodebuttons;

    DBAreaCode *c_areacodeinfo;
    DBFunCollect *dbopt;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    dbopt = [[DBFunCollect alloc] init];
    
    
    areacodebuttons = [NSMutableArray array];
    
    groupList = [[[DBFunCollect alloc] init] GetTypeFieldGroup:_TypeInfo.typeid];
    DBFieldGroup *groupmedia = [[DBFieldGroup alloc] initWithName:@"媒体资源" TypeID:_TypeInfo.typeid];
    
    DBTypeField *typefield = [[DBTypeField alloc] initWithName:@"mediainfo" FieldType:@"_media" CustomName:@"图片信息"];
    [groupmedia.typefields addObject:typefield];
    
    if (_TypeInfo.existsroom == 1)
    {
        DBTypeField *typefield = [[DBTypeField alloc] initWithName:@"room" FieldType:@"_child" CustomName:@"房型信息"];
        [groupmedia.typefields addObject:typefield];
    }
    
    if (_TypeInfo.existsroom == 1)
    {
        DBTypeField *typefield = [[DBTypeField alloc] initWithName:@"scenic" FieldType:@"_child" CustomName:@"景点设施"];
        [groupmedia.typefields addObject:typefield];
    }
    
    
    [groupList addObject:groupmedia];
    
    userinfo = [[[DBFunUser alloc] init] GetUserInfo:[[collectshare sharedInstanceMethod] username]];
    
    if (_requestinfounit == NULL)
    {
        _requestinfounit = [[RequestInfoUnit alloc] init];
        
        NSMutableArray *typefields = [dbopt GetTypeFields:_TypeInfo.typeid];
        
        //创建一个新的requestinfounit
        for (int i=0; i<typefields.count; i++) {
            DBTypeField *fieldinfo = (DBTypeField*)typefields[i];
                if ([fieldinfo.fieldtype isEqualToString:@"_int"] || [fieldinfo.fieldtype isEqualToString:@"_float"])
                {
                    [_requestinfounit setValue:@"0" forKey:fieldinfo.fieldname];
                }
                else
                {
                    [_requestinfounit setValue:@"" forKey:fieldinfo.fieldname];
                }
           
            }
        _requestinfounit.localunitid = [[collectshare sharedInstanceMethod] getUniqueStrByUUID];
        _requestinfounit.typeid =[NSString stringWithFormat:@"%ld",(long)_TypeInfo.typeid];
        _requestinfounit.pid = [NSString stringWithFormat:@"%ld",(long)[[collectshare sharedInstanceMethod] pid]];
        _requestinfounit.sourcefrom = @"1";
        _requestinfounit.username = userinfo.username;
        _requestinfounit.state = @"0";
        _requestinfounit.logourl = @"";
        _requestinfounit.flagurl = @"";
    }
    
    
    
    self.navigationController.navigationItem.rightBarButtonItem = self.saveButton;
    if ([_requestinfounit.state isEqualToString:@"1"])
    {
        _saveButton.enabled = false;
    }
    [self getAreaCode];
}

-(void)GetButtonAreaCode:(NSInteger)count areaCode:(AreaCodeButton*)areacodebutton pAreaCode:(NSString*)paraecode {
    NSString *searchareacode ;
    switch (count) {
        case 2:
            searchareacode =[NSString stringWithFormat:@"%@00000000",[paraecode substringToIndex:4]];
            areacodebutton.areacodelike = [NSString stringWithFormat:@"%@%%000",[paraecode substringToIndex:6]];
            break;
        case 3:
            if ([[paraecode substringWithRange:NSMakeRange(4, 8)] isEqualToString:@"00000000"])
            {
                searchareacode = @"";
            }
            else
            {
                searchareacode =[NSString stringWithFormat:@"%@000000",[paraecode substringToIndex:6]];
            }
            areacodebutton.areacodelike = [NSString stringWithFormat:@"%@%%000000",[paraecode substringToIndex:4]];
            break;
        case 4:
            if ([[paraecode substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"000000"])
            {
                searchareacode = @"";
            }
            else
            {
                searchareacode =[NSString stringWithFormat:@"%@000",[paraecode substringToIndex:9]];
            }
             areacodebutton.areacodelike = [NSString stringWithFormat:@"%@%%000",[paraecode substringToIndex:6]];
            break;
        case 5:
            if ([[paraecode substringWithRange:NSMakeRange(9, 3)] isEqualToString:@"000"])
            {
                searchareacode = @"";
            }
            else
            {
                searchareacode =paraecode;
                areacodebutton.areacodelike = paraecode;
            }
            break;
        default:
            searchareacode =paraecode;
            areacodebutton.areacodelike = paraecode;
            break;
    } if (![[_requestinfounit areacode] isEqualToString:@""]) {
        if (![searchareacode isEqualToString:@""]) {
            areacodebutton.areacodeinfo =[dbopt GetAreaCodeInfo:searchareacode];
            [areacodebutton.button setTitle:areacodebutton.areacodeinfo.areaname forState:UIControlStateNormal];
        } else{
            areacodebutton.areacodelike = @"";
        }
    }
}

- (void)getAreaCode{
    NSInteger buttoncount =  6 - [userinfo.pareaname componentsSeparatedByString:@"|"].count;
    
    for (NSInteger i = 0; i < buttoncount; i++)
    {
        AreaCodeButton *areabtn = [[AreaCodeButton alloc] init];
        areabtn.areacodelike = @"";
        areabtn.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [areabtn.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        areabtn.button.titleLabel.font = [UIFont systemFontOfSize:12];
        areabtn.button.tag = i;
        
        [areabtn.button setTitle:@"请选择" forState:UIControlStateNormal];
        
        if (![_requestinfounit.areacode isEqualToString:@""]) {
            [self GetButtonAreaCode:buttoncount + i areaCode:areabtn pAreaCode:_requestinfounit.areacode];
        } else {
            if (i == 0) {
                [self GetButtonAreaCode:buttoncount + i areaCode:areabtn pAreaCode:[[collectshare sharedInstanceMethod] areacode]];
            }
        }
        if ([_requestinfounit.state isEqualToString:@"0"]) {
            //已经上传的数据,不能点击
            [areabtn.button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [areacodebuttons addObject:areabtn];
    }
    
}


- (void)getLocation {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return groupList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [(DBFieldGroup*)groupList[section] typefields].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBTypeField *fieldinfos =(DBTypeField*)[(DBFieldGroup*)groupList[indexPath.section] typefields][indexPath.row];
    
    if ([fieldinfos.fieldtype isEqualToString:@"_area"])
    {
        // 地图类型处理省市自治区
        [tableView registerClass:[AreaCodeTableViewCell class] forCellReuseIdentifier:@"areaCell"];
        
        areacodeCell = [tableView dequeueReusableCellWithIdentifier:@"areaCell" forIndexPath:indexPath];
        areacodeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        areacodeCell.areaCodeLabel.text = fieldinfos.customname;
        if (areacodeStr == nil) {
            areacodeCell.pareanamelabel.text = userinfo.pareaname;
            _requestinfounit.areaname = userinfo.pareaname;
        } else {
            areacodeCell.pareanamelabel.text = areacodeStr;
        }
        [areacodeCell CreateAreaCodeButton:areacodebuttons];
        return areacodeCell;
    }
    else if ([fieldinfos.fieldtype isEqualToString:@"_img"]){
        // 图片类型
        [tableView registerNib:[UINib nibWithNibName:@"PhotoImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"imgCell"];
        PhotoImgTableViewCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"imgCell" forIndexPath:indexPath];
        photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        photoCell.imgLabel.text = fieldinfos.customname;
        if ([fieldinfos.fieldname isEqualToString:@"logopic"])
        {
            photoCell.imgButton.tag = 0;
        }
        else
        {
            photoCell.imgButton.tag = 1;
        }
        
        [photoCell.imgButton addTarget:self action:@selector(checkImg:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString* imgfile = [_requestinfounit valueForKey:fieldinfos.fieldname];
        if (imgfile != nil || [imgfile isEqualToString:@""])
        {
            NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:userinfo.username];
            
            [photoCell.imgButton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",userpath,imgfile]]
                                 forState:UIControlStateNormal];
        }
        
        return photoCell;
    } else if ([fieldinfos.fieldtype isEqualToString:@"_longstring"]){
        // 备注类型
        [tableView registerNib:[UINib nibWithNibName:@"RemarksTableViewCell" bundle:nil] forCellReuseIdentifier:@"remarkCell"];
        
        RemarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remarkCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.remarkTextView.delegate = self;
        cell.remarkTextView.text = [_requestinfounit valueForKey:fieldinfos.fieldname];
        cell.remarkLabel.text = fieldinfos.customname;
        cell.fieldname = fieldinfos.fieldname;
        
        return cell;
    } else if([fieldinfos.fieldtype isEqualToString:@"_map"]) {
        // 经纬度
        [tableView registerNib:[UINib nibWithNibName:@"MapTableViewCell" bundle:nil] forCellReuseIdentifier:@"mapCell"];
        MapTableViewCell *_Mapcell = [tableView dequeueReusableCellWithIdentifier:@"mapCell" forIndexPath:indexPath];
        _Mapcell.selectionStyle = UITableViewCellSelectionStyleNone;
        _Mapcell.titleLabel.text = fieldinfos.customname;
        _Mapcell.bmkLabel.userInteractionEnabled = NO;
        _Mapcell.bmkLabel.text = [_requestinfounit valueForKey:fieldinfos.fieldname];

        return _Mapcell;
    } else if ([fieldinfos.fieldtype isEqualToString:@"_media"] || [fieldinfos.fieldtype isEqualToString:@"_child"]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediacell"];
        cell.textLabel.text = fieldinfos.customname;
        cell.textLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return  cell;
    } else {
        infoCell = [tableView dequeueReusableCellWithIdentifier:@"fieldCell"];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        infoCell.infoUnitLabel.text = fieldinfos.customname;
        infoCell.infoUnitField.delegate = self;
        infoCell.infoUnitField.returnKeyType = UIReturnKeyDone;
        infoCell.infoUnitField.text = [_requestinfounit valueForKey:fieldinfos.fieldname];
        infoCell.fieldname = fieldinfos.fieldname;
        
        if ([fieldinfos.fieldtype isEqualToString:@"_string"]) {
            // 可编辑类型
            if ([fieldinfos.customname isEqualToString:@"单位名称"]) {
                customNameStr = fieldinfos.customname;
            }
            
        } else if ([fieldinfos.fieldtype isEqualToString:@"_int"]){
            // int 类型
            if ([infoCell.infoUnitField.text isEqualToString:@""])
            {
                infoCell.infoUnitField.text = @"0";
            }
            
        }  else if ([fieldinfos.fieldtype isEqualToString:@"_float"]){
            // 浮点型
            if ([infoCell.infoUnitField.text isEqualToString:@""])
            {
                infoCell.infoUnitField.text = @"0";
            }
            
        } else if ([fieldinfos.fieldtype isEqualToString:@"_readonly"])
        {
            //原生经纬度
        }else if ([fieldinfos.fieldtype isEqualToString:@"_scenic5a"]){
            // 5a景区
        }
        return infoCell;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBTypeField *fieldinfo =(DBTypeField*)[(DBFieldGroup*)groupList[indexPath.section] typefields][indexPath.row];
    if ([fieldinfo.fieldtype isEqualToString:@"_area"])  return C_ScreenSizeChange(162);
    if ([fieldinfo.fieldtype isEqualToString:@"_longstring"]) return C_ScreenSizeChange(80);
    if ([fieldinfo.fieldtype isEqualToString:@"_map"]) return C_ScreenSizeChange(44);
    if ([fieldinfo.fieldtype isEqualToString:@"_img"])  return C_ScreenSizeChange(100);
    else return C_ScreenSizeChange(44);
}

// 分区的名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [(DBFieldGroup*)groupList[section] groupname];
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBTypeField *fieldinfo =(DBTypeField*)[(DBFieldGroup*)groupList[indexPath.section] typefields][indexPath.row];
    
    if([fieldinfo.fieldtype isEqualToString:@"_map"])
    {
        MapViewController *mapVC = [[MapViewController alloc] init];
        mapVC.centerLocationBlock = ^(NSString *LocaString) {
            _requestinfounit.gpsbd = LocaString;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:mapVC animated:YES];
    }
    
    if ([fieldinfo.fieldtype isEqualToString:@"_media"])
    {
        [self performSegueWithIdentifier:@"sgunittomedia" sender:nil];
    }
}

// 区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *str = [(DBFieldGroup*)groupList[section] groupname];
    if ([str isEqualToString:@"经纬度"]) {
        UIView *sectionTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, C_ScreenSizeChange(44))];
        sectionTwoView.backgroundColor = RGB(220, 252, 255);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(C_ScreenSizeChange(10), C_ScreenSizeChange(10), C_ScreenSizeChange(80), C_ScreenSizeChange(24))];
        titleLabel.text = [(DBFieldGroup*)groupList[section] groupname];
        titleLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
        [sectionTwoView addSubview:titleLabel];
        
        UIButton *getLocationButton = [UIButton buttonWithType:UIButtonTypeSystem];
        getLocationButton.frame = CGRectMake(C_ScreenSizeChange([UIScreen mainScreen].bounds.size.width - 80), C_ScreenSizeChange(10), C_ScreenSizeChange(60), C_ScreenSizeChange(24));
        getLocationButton.titleLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
        [getLocationButton setTitle:@"自动获取" forState:UIControlStateNormal];
        [getLocationButton addTarget:self action:@selector(getLocationBut:) forControlEvents:UIControlEventTouchUpInside];
        [sectionTwoView addSubview:getLocationButton];
        
        UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cleanButton.frame = CGRectMake(CGRectGetMinX(getLocationButton.frame) -  C_ScreenSizeChange(100), C_ScreenSizeChange(10), C_ScreenSizeChange(60), C_ScreenSizeChange(24));
        cleanButton.titleLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
        [cleanButton setTitle:@"清除地址" forState:UIControlStateNormal];
        [cleanButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cleanButton addTarget:self action:@selector(cleanLocationBut:) forControlEvents:UIControlEventTouchUpInside];
        [sectionTwoView addSubview:cleanButton];
        return sectionTwoView;
    } else {
        UIView *sectionOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, C_ScreenSizeChange(44))];
        sectionOneView.backgroundColor = RGB(220, 252, 255);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(C_ScreenSizeChange(10), C_ScreenSizeChange(10), C_ScreenSizeChange(80), C_ScreenSizeChange(24))];
        titleLabel.text = [(DBFieldGroup*)groupList[section] groupname];
        titleLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
        [sectionOneView addSubview:titleLabel];
        return sectionOneView;
    }
}

#pragma mark - UIImagePickerControllerDelegate 选取照片的回调方法

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *_photoImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:userinfo.username];
        
        NSString* filename = [NSString stringWithFormat:@"%@.jpg",[[collectshare sharedInstanceMethod] getUniqueStrByUUID]];
        
        [UIImageJPEGRepresentation(_photoImg, 1) writeToFile:[NSString stringWithFormat:@"%@/%@",userpath,filename] atomically:YES];
        
        [_requestinfounit setValue:filename forKey:currfieldname];
        [self.tableView reloadData];
    }];
}

#pragma mark - 点击按钮方法
// 选择图片的按钮
- (void)checkImg:(UIButton*)sender
{
    if (sender.tag == 0) {
        currfieldname = @"logopic";
    } else {
        currfieldname = @"flagpic";
    }
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


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //停止位置更新
    [_locationManager stopUpdatingLocation];
    
    CLLocation *loc = [locations lastObject];
    CLLocationCoordinate2D theCoordinate;
    //位置更新后的经纬度
    theCoordinate.latitude = loc.coordinate.latitude;
    theCoordinate.longitude = loc.coordinate.longitude;
    
    _requestinfounit.gps = [NSString stringWithFormat:@"%f,%f",theCoordinate.latitude,theCoordinate.longitude];
    [self.tableView reloadData];
}

#pragma mark - BMKMap 百度地图

- (void)locationStart {
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    [_locService startUserLocationService];
    
}

#pragma mark - BMKLocationServiceDelegate 百度地图代理方法

// 定位加获取地理位置
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    _mapView.centerCoordinate = userLocation.location.coordinate;//将当前用户的位置移动到中心点
    _userLocation = userLocation;
    _requestinfounit.gpsbd = [NSString stringWithFormat:@"%f,%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            if (placemark != nil) {
                NSDictionary *dic = placemark.addressDictionary;
                _requestinfounit.address =  [NSString stringWithFormat:@"%@%@", dic[@"SubLocality"],dic[@"Name"]];
            }
        }
    }];
    
    _searcher = [[BMKPoiSearch alloc] init];
    _searcher.delegate = self;
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    option.keyword = @"公交";
    BOOL flag = [_searcher poiSearchNearBy:option];
    if (flag) {
        NSLog(@"成功");
        [_locService stopUserLocationService];
    } else {
        NSLog(@"失败");
    }
}

#pragma mark - MapCell按钮点击事件

// 保存数据按钮
- (IBAction)savebutton:(id)sender {
    if ([customNameStr isEqualToString:@"单位名称"] && customTextField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@不能为空,请重新输入!", customNameStr] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancleAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定保存?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [dbopt SaveUnit:_requestinfounit];
            if (_infounitblock) {
                self.infounitblock(_requestinfounit.unitname);
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功!" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }];
        [alert addAction:cancleAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/// 自动获取
- (void)getLocationBut:(UIButton *)sender
{
    [self locationStart];
    [self getLocation];
}

// 清除地址
- (void)cleanLocationBut:(UIButton *)sender
{
    _requestinfounit.address = @"";
    _requestinfounit.publictrafic = @"";
    
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"sgunitselectarea"]) {
        
        AreaCodeViewController *view = segue.destinationViewController;
        NSInteger areacodeint =[sender intValue];
        AreaCodeButton *areacodebutton =areacodebuttons[areacodeint];
        
        NSString* areacodestring =@"";
        if (areacodebutton.areacodeinfo != nil)
        {
            areacodestring = areacodebutton.areacodeinfo.areacode;
        }
        [view setValue:areacodebutton  forKey:@"areacodebutton"];
        
        
        view.myBlock=^(){
            _requestinfounit.areacode = areacodebutton.areacodeinfo.areacode;
            _requestinfounit.zonecode = areacodebutton.areacodeinfo.zonecode;
            _requestinfounit.postcode = areacodebutton.areacodeinfo.postcode;
            if (areacodebutton.areacodeinfo != nil) {
                [areacodebutton.button setTitle:areacodebutton.areacodeinfo.areaname forState:UIControlStateNormal];
            } else {
                areacodeStr = nil;
                [areacodebutton.button setTitle:@"请选择" forState:UIControlStateNormal];
            }
            
            if (![areacodestring isEqualToString: areacodebutton.areacodeinfo.areacode])
            {
                for(NSInteger i= areacodeint + 1;i < areacodebuttons.count;i++)
                {
                    AreaCodeButton *ab  =  (AreaCodeButton*)areacodebuttons[i];
                    ab.areacodeinfo = NULL;
                    [ab.button setTitle:@"请选择" forState:UIControlStateNormal];
                    ab.areacodelike = @"";
                }
            }
            
            if (areacodeint != areacodebuttons.count - 1)
            {
                ((AreaCodeButton*)areacodebuttons[areacodeint + 1]).areacodelike = [self GetAreaCodeLike:areacodebutton.areacodeinfo.areacode];
            }
            _requestinfounit.areaname = userinfo.pareaname;
            for (int i=0; i<areacodebuttons.count; i++)
            {
                if ([areacodebuttons[i] areacodeinfo] != NULL)
                {
                    _requestinfounit.areaname = [NSString stringWithFormat:@"%@%@|",_requestinfounit.areaname,[[areacodebuttons[i] areacodeinfo] areaname]];
//                    areacodeStr = _requestinfounit.areaname;// 给地区赋值
                }
            }
//            areacodeCell.pareanamelabel.text = areacodeStr;
            [self.tableView reloadData];
        };
    }
    
    if ([segue.identifier isEqualToString:@"sgunittomedia"])
    {
        
        UIViewController *view = segue.destinationViewController;
        [view setValue:_requestinfounit  forKey:@"InfoUnit"];
    }
}

-(NSString*)GetAreaCodeLike:(NSString*)areacode {
    if ([[areacode substringWithRange:NSMakeRange(2, 10)] isEqualToString:@"0000000000"])
    {
        return [NSString stringWithFormat:@"%@%%00000000", [areacode substringToIndex:2]];
    }
    else if ([[areacode substringWithRange:NSMakeRange(4, 8)] isEqualToString:@"00000000"])
    {
        return [NSString stringWithFormat:@"%@%%000000", [areacode substringToIndex:4]];
    }
    else if ([[areacode substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"000000"])
    {
        return [NSString stringWithFormat:@"%@%%000", [areacode substringToIndex:6]];
    }
    else if ([[areacode substringWithRange:NSMakeRange(9, 3)] isEqualToString:@"000"])
    {
        return [NSString stringWithFormat:@"%@%%", [areacode substringToIndex:9]];
    }
    else
    {
        return  areacode;
    }
}

///  areaCode按钮选择
- (void)selectAction:(UIButton *)sender
{
    AreaCodeButton *areacodebutton = (AreaCodeButton*)areacodebuttons[sender.tag];
    if ([areacodebutton.areacodelike isEqualToString:@""]){
        return;
    }
    [self performSegueWithIdentifier:@"sgunitselectarea" sender:[NSNumber numberWithInteger:sender.tag]];
    
}

#pragma mark - BMKPoiSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        BMKPoiInfo *info = [poiResult.poiInfoList objectAtIndex:0];
        _requestinfounit.publictrafic = [NSString stringWithFormat:@"%@:%@", info.name,info.address];
        [self.tableView reloadData];
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    InfoUnitTableViewCell *cell = (InfoUnitTableViewCell *)textField.superview.superview;
    [_requestinfounit setValue:textField.text forKey:cell.fieldname];
    customTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    InfoUnitTableViewCell *cell = (InfoUnitTableViewCell *)textField.superview.superview;
    [_requestinfounit setValue:textField.text forKey:cell.fieldname];
    customTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    RemarksTableViewCell *cell = (RemarksTableViewCell *)textView.superview.superview;
    [_requestinfounit setValue:textView.text forKey:cell.fieldname];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
