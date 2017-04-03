//
//  AreaCodeViewController.m
//  Travel
//
//  Created by gz on 17/3/30.
//  Copyright © 2017年 gz. All rights reserved.
//

#import "AreaCodeViewController.h"

#import "collectshare.h"
#import "DBFunUser.h"
#import "DBFunCollect.h"
#import "const.h"

@interface AreaCodeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation AreaCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[[DBFunCollect alloc] init] GetAreaCodeLike:_areacodebutton.areacodelike];
    self.myTableView.tableFooterView = [[UIView alloc] init];
    self.myTableView.frame = CGRectMake(0, 64, C_ScreenWidth, C_ScreenHeight - 64);
    
    UIView *navigatonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, C_ScreenWidth, 64)];
    navigatonView.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(C_ScreenSizeChange(10), 64 - C_ScreenSizeChange(30), C_ScreenSizeChange(20), C_ScreenSizeChange(20))];
    imageView.image = [UIImage imageNamed:@"left@2x"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(CGRectGetMaxX(imageView.frame), CGRectGetMinY(imageView.frame) - C_ScreenSizeChange(5), C_ScreenSizeChange(50), C_ScreenSizeChange(30));
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.frame = CGRectMake(C_ScreenWidth - C_ScreenSizeChange(60), CGRectGetMinY(backButton.frame), C_ScreenSizeChange(50), C_ScreenSizeChange(30));
    [cancleButton addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navigatonView];
    [navigatonView addSubview:imageView];
    [navigatonView addSubview:backButton];
    [navigatonView addSubview:cancleButton];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"areanamecell" forIndexPath:indexPath];
    if ([[[self.dataSource objectAtIndex:indexPath.row] areacode] isEqualToString:_areacodebutton.areacodeinfo.areacode] )
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.row] areaname];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _areacodebutton.areacodeinfo = (DBAreaCode*)self.dataSource[indexPath.row];
    self.myBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 返回
- (void)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//  取消

- (void)cancleAction:(UIButton *)sender {
    _areacodebutton.areacodeinfo = nil;
    self.myBlock();
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

@end
