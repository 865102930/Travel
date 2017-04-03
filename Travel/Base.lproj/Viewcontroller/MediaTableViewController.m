//
//  MediaTableViewController.m
//  旅游资源采集
//
//  Created by gz on 17/3/23.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "MediaTableViewController.h"
#import "MediaEditViewController.h"
#import "const.h"

@interface MediaTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MediaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"新增"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(BtnAdd:)];
    self.navigationItem.rightBarButtonItem = rightbutton;
    self.tableView.tableFooterView = [[UIView alloc] init];
}


-(void)BtnAdd:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"sgmediaedit" sender:nil];
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

    return _InfoUnit.mediainfos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediacell" forIndexPath:indexPath];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    imageview.layer.masksToBounds = YES;
    NSString* userpath = [c_DocumentsDirectory stringByAppendingPathComponent:_InfoUnit.username];
    
    [imageview setImage:[UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/%@",userpath,[_InfoUnit.mediainfos[indexPath.row] filename]]]];

    //imageview
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame) + 5, 5, 200, 40)];
    label.font = [UIFont systemFontOfSize:13];
    label.text = [_InfoUnit.mediainfos[indexPath.row] medianame];
    
    [cell addSubview:imageview];
    [cell addSubview:label];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"sgmediaedit" sender:_InfoUnit.mediainfos[indexPath.row]];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sgmediaedit"])
    {
        MediaEditViewController *view = segue.destinationViewController;
        [view setValue:_InfoUnit.localunitid forKey:@"LocalUnitID"];
        
        if (sender != nil)
        {
            [view setValue:sender forKey:@"mediainfo"];
        }
        view.myBlock=^(id mediaedit) {
            if (mediaedit){
                [_InfoUnit.mediainfos addObject:mediaedit];
            } else {
                [_InfoUnit.mediainfos removeObject:sender];
            }
            [self.tableView reloadData];
        };
    }
}

#pragma mark - UITableViewDelegate

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
   return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_InfoUnit.mediainfos removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


@end
