//
//  AreaCodeTableViewCell.h
//  旅游资源采集
//
//  Created by gz on 17/3/18.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaCodeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *areaCodeLabel;
@property (nonatomic, strong) UILabel *areaCodeLineLabel;
@property (nonatomic, strong) UILabel *pareanamelabel;

-(void)CreateAreaCodeButton:(NSMutableArray*)seleclButtonArr;

@end
