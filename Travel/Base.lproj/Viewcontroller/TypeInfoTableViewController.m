//
//  MenuListTableViewController.m
//  旅游资源采集
//
//  Created by gz on 17/3/15.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "TypeInfoTableViewController.h"
#import "interface.h"
#import "collectshare.h"
#import "dbFunCollect.h"
#import "SetTableViewController.h"
@interface TypeInfoTableViewController ()

@end

@implementation TypeInfoTableViewController
{
    NSMutableArray *typeinfos;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIBarButtonItem *btnconfig = [[UIBarButtonItem alloc]initWithTitle:@"设置"
                                                                 style:UIBarButtonItemStyleDone target:self
                                                                action:@selector(btnconfigclick:)];
    self.navigationItem.rightBarButtonItem = btnconfig;
    
    typeinfos = [[[DBFunCollect alloc] init] GetTypeList:0 SpaceCount:0];
}

- (IBAction)btnconfigclick:(id)sender {
    [self performSegueWithIdentifier:@"sgtypetoset" sender:nil];
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
    return typeinfos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DBTypeInfo *typeinfo = (DBTypeInfo*)typeinfos[indexPath.row];
    cell.textLabel.text = typeinfo.typename;
    if (typeinfo.existschild == 1){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBTypeInfo *typeinfo = (DBTypeInfo*)typeinfos[indexPath.row];
    
    if (typeinfo.existschild == 0){
        
        [self performSegueWithIdentifier:@"SGToInfoUnit" sender:typeinfo];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SGToInfoUnit"])
    {
        UIViewController *view = segue.destinationViewController;
        [view setValue:sender  forKey:@"TypeInfo"];
    }
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
