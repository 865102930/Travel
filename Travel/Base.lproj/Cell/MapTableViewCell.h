//
//  MapTableViewCell.h
//  旅游资源采集
//
//  Created by gz on 17/3/16.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *bmkLabel;
@property (weak, nonatomic) IBOutlet UILabel *verticaleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bmkImageView;
@end
