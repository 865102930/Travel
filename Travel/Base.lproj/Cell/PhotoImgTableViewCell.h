//
//  PhotoImgTableViewCell.h
//  旅游资源采集
//
//  Created by gz on 17/3/16.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoImgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *imgLabel;
@property (weak, nonatomic) IBOutlet UIButton *imgButton;
@property (weak, nonatomic) IBOutlet UILabel *imgLineLabel;

@end
