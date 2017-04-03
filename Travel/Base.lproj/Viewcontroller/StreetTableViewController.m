//
//  StreetTableViewController.m
//  旅游资源采集
//
//  Created by gz on 17/3/20.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "StreetTableViewController.h"
#import "collectshare.h"
#import "DBFunUser.h"
#import "DBFunCollect.h"

@interface StreetTableViewController () {
    DBUserInfo *userinfo;
}
@end

@implementation StreetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.streetArray = [NSMutableArray array];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"streetCell"];
    
    userinfo = [[[DBFunUser alloc] init] GetUserInfo:[[collectshare sharedInstanceMethod] username]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    NSString *areacode = [self.object areacode];
    NSLog(@"%@", areacode);
    if ([[areacode substringFromIndex:9] isEqualToString:@"000"]) {
        areacode =[NSString stringWithFormat:@"%@%%000",[areacode substringToIndex:6]];
    }
    if ([[areacode substringFromIndex:6] isEqualToString:@"000000"]) {
        areacode = [NSString stringWithFormat:@"%@%%000000",[areacode substringToIndex:4]];
    }
    if ([[areacode substringFromIndex:4] isEqualToString:@"00000000"]) {
        areacode = [NSString stringWithFormat:@"%@%%00000000",[areacode substringToIndex:2]];
    }
    if ([[areacode substringFromIndex:2] isEqualToString:@"0000000000"]) {
        areacode = [NSString stringWithFormat:@"%@%%00000000",[areacode substringToIndex:0]];
    }
    self.streetArray =[[[DBFunCollect alloc] init] GetAreaCodeLike: areacode];
    [self.streetArray removeObjectAtIndex:0];
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
    return self.streetArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"streetCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.streetArray[indexPath.row] areaname];
    
    return cell;
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *model = self.streetArray[indexPath.row];
    self.myBlock(model);
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 返回
- (void)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
