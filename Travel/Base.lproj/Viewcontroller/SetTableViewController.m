//
//  SetTableViewController.m
//  旅游资源采集
//
//  Created by gz on 17/3/21.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "SetTableViewController.h"
#import "const.h"
#import "AppDelegate.h"
#import "collectshare.h"

@interface SetTableViewController ()

@end

@implementation SetTableViewController
{
    NSMutableArray *setconfigarray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    setconfigarray = [[NSMutableArray alloc] init];
    [setconfigarray addObject:@"未上传"];
    [setconfigarray addObject:@"已上传"];
    [setconfigarray addObject:@"清除缓存"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return setconfigarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell" forIndexPath:indexPath];
    cell.textLabel.text = setconfigarray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            //跳转
            [self performSegueWithIdentifier:@"sgconfigtounitlist" sender:[NSNumber numberWithInteger:0]];
            break;
        case 1:
             [self performSegueWithIdentifier:@"sgconfigtounitlist" sender:[NSNumber numberWithInteger:1]];
            break;
            case 2:
            [self getCacheData];
            break;
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"sgconfigtounitlist"]) {
        UIViewController *view = segue.destinationViewController;
        [view setValue:sender forKey:@"State"];
    }
}


- (void)getCacheData {
    long long size = [self getUserPathData];
    NSString *path = [c_DocumentsDirectory stringByAppendingPathComponent:[[collectshare sharedInstanceMethod] username]];
    NSFileManager *manager = [NSFileManager defaultManager];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"共%lldM缓存,是否清除?", size] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *array = [manager subpathsAtPath:path];
        for (NSString *fileName in array) {
            NSString *subPath = [path stringByAppendingPathComponent:fileName];
            [manager removeItemAtPath:subPath error:nil];
        }
    }];
    
    [alert addAction:cancleAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (long long)sizeForUser:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        long long size = [manager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

- (long long)getUserPathData {
    NSString *userPath  = [c_DocumentsDirectory stringByAppendingPathComponent:[[collectshare sharedInstanceMethod] username]];
    NSFileManager *manager = [NSFileManager defaultManager];
    long long floadSize = 0;
    if ([manager fileExistsAtPath:userPath]) {
        // 计算大小
        NSArray *dataArray = [manager subpathsAtPath:userPath];
        for (NSString *fileName in dataArray) {
            NSString *pathStr = [userPath stringByAppendingPathComponent:fileName];
            long long size = [self sizeForUser:pathStr];
            floadSize = size++;
        }
        return floadSize / 1024.0 / 1024.0;
    }
    return 0;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
