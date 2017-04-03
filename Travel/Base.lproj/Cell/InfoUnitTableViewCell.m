//
//  InfoUnitTableViewCell.m
//  旅游资源采集
//
//  Created by gz on 17/3/17.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "InfoUnitTableViewCell.h"
#import "const.h"

@implementation InfoUnitTableViewCell


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
    self.infoUnitLabel.frame = CGRectMake(C_ScreenSizeChange(5), C_ScreenSizeChange(7), C_ScreenSizeChange(110), C_ScreenSizeChange(30));
    self.infoUnitLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
    self.lineLabel.frame = CGRectMake(CGRectGetMaxX(self.infoUnitLabel.frame) + C_ScreenSizeChange(5), 0,C_ScreenSizeChange(0.8), C_ScreenSizeChange(44));
    self.lineLabel.backgroundColor = C_ScreenLineColour;
    self.infoUnitField.frame = CGRectMake(CGRectGetMaxX(self.lineLabel.frame) + C_ScreenSizeChange(15), C_ScreenSizeChange(7), C_ScreenWidth - CGRectGetMaxX(self.lineLabel.frame) - C_ScreenSizeChange(30), C_ScreenSizeChange(30));
    self.infoUnitField.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
}


@end
