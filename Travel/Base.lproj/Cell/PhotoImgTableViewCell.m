//
//  PhotoImgTableViewCell.m
//  旅游资源采集
//
//  Created by gz on 17/3/16.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "PhotoImgTableViewCell.h"
#import "const.h"

@implementation PhotoImgTableViewCell

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
    self.imgLabel.frame = CGRectMake(C_ScreenSizeChange(5), C_ScreenSizeChange(25), C_ScreenSizeChange(110), C_ScreenSizeChange(30));
    self.imgLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
    self.imgLineLabel.backgroundColor = C_ScreenLineColour;
    self.imgLineLabel.frame = CGRectMake(CGRectGetMaxX(self.imgLabel.frame) + C_ScreenSizeChange(5), 0, C_ScreenSizeChange(0.8), self.bounds.size.height);
    self.imgButton.frame = CGRectMake(CGRectGetMaxX(self.imgLineLabel.frame) + C_ScreenSizeChange(60), C_ScreenSizeChange(10), C_ScreenSizeChange(80), C_ScreenSizeChange(80));
    
}

@end
