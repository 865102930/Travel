//
//  RemarksTableViewCell.m
//  旅游资源采集
//
//  Created by gz on 17/3/16.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "RemarksTableViewCell.h"
#import "const.h"

@implementation RemarksTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.remarkLabel.frame = CGRectMake(C_ScreenSizeChange(5), C_ScreenSizeChange(25), C_ScreenSizeChange(110), C_ScreenSizeChange(30));
    self.remarkLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
    self.remarkLineLabel.frame = CGRectMake(CGRectGetMaxX(self.remarkLabel.frame) + C_ScreenSizeChange(5), 0, C_ScreenSizeChange(0.8), self.bounds.size.height);
    self.remarkLineLabel.backgroundColor = C_ScreenLineColour;
    
    self.remarkTextView.frame = CGRectMake(CGRectGetMaxX(self.remarkLineLabel.frame) + C_ScreenSizeChange(15), C_ScreenSizeChange(10), C_ScreenWidth - CGRectGetMaxX(self.remarkLineLabel.frame) - C_ScreenSizeChange(30), C_ScreenSizeChange(60));
    self.remarkTextView.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
}

@end
