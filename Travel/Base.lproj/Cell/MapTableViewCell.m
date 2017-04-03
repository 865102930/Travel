//
//  MapTableViewCell.m
//  旅游资源采集
//
//  Created by gz on 17/3/16.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "MapTableViewCell.h"
#import "const.h"

@implementation MapTableViewCell

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
    self.titleLabel.frame = CGRectMake(C_ScreenSizeChange(5), C_ScreenSizeChange(7), C_ScreenSizeChange(110), C_ScreenSizeChange(30));
    self.titleLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
    self.verticaleLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + C_ScreenSizeChange(5), 0,C_ScreenSizeChange(0.8), C_ScreenSizeChange(44));
    self.verticaleLabel.backgroundColor = C_ScreenLineColour;
    self.bmkLabel.frame = CGRectMake(CGRectGetMaxX(self.verticaleLabel.frame) + C_ScreenSizeChange(15), C_ScreenSizeChange(7), C_ScreenWidth - CGRectGetMaxX(self.verticaleLabel.frame) - C_ScreenSizeChange(70), C_ScreenSizeChange(30));
    self.bmkLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
    
    self.bmkImageView.frame = CGRectMake(CGRectGetMaxX(self.bmkLabel.frame) + C_ScreenSizeChange(10), CGRectGetMidY(self.bmkLabel.frame) - C_ScreenSizeChange(12), C_ScreenSizeChange(24), C_ScreenSizeChange(24));
    self.bmkImageView.image = [UIImage imageNamed:@"right@2x.png"];
}



@end
