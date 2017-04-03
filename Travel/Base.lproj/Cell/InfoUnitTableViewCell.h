//
//  InfoUnitTableViewCell.h
//  旅游资源采集
//
//  Created by gz on 17/3/17.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnBlock)(NSString *string);

@interface InfoUnitTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infoUnitLabel;
@property (weak, nonatomic) IBOutlet UITextField *infoUnitField;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (nonatomic, copy) ReturnBlock myBlock;
@property (nonatomic,strong) NSString* fieldname;
@end
