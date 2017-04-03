//
//  AreaCodeTableViewCell.m
//  旅游资源采集
//
//  Created by gz on 17/3/18.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import "AreaCodeTableViewCell.h"
#import "AreaCodeButton.h"
#import "const.h"
@implementation AreaCodeTableViewCell
{
    UIPickerView *_pickerView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)CreateAreaCodeButton:(NSMutableArray *)seleclButtonArr
{
    for (int i = 0; i < seleclButtonArr.count; i++)
    {
        UIButton *selectButton = [(AreaCodeButton*)seleclButtonArr[i] button];
        selectButton.frame = CGRectMake(C_ScreenSizeChange(135.5), C_ScreenSizeChange(40) * i + C_ScreenSizeChange(45), C_ScreenWidth - C_ScreenSizeChange(150.5), C_ScreenSizeChange(30));
        selectButton.layer.masksToBounds = YES;
        selectButton.layer.borderWidth = 0.5;
        selectButton.layer.cornerRadius = 5;
        selectButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:selectButton];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.areaCodeLabel = [[UILabel alloc] init];
        self.areaCodeLabel.textAlignment = NSTextAlignmentCenter;
        self.areaCodeLabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
        [self addSubview:self.areaCodeLabel];
        
        self.areaCodeLineLabel = [[UILabel alloc] init];
        self.areaCodeLineLabel.backgroundColor = C_ScreenLineColour;
        [self addSubview:self.areaCodeLineLabel];
        
        self.pareanamelabel = [[UILabel alloc] init];
        self.pareanamelabel.layer.masksToBounds = YES;
        self.pareanamelabel.layer.borderWidth = 0.5;
        self.pareanamelabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.pareanamelabel.layer.cornerRadius = C_ScreenSizeChange(5);
        self.pareanamelabel.textAlignment = NSTextAlignmentCenter;
        self.pareanamelabel.font = [UIFont systemFontOfSize:C_ScreenSizeChange(12)];
        [self addSubview:self.pareanamelabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.areaCodeLabel.frame = CGRectMake(C_ScreenSizeChange(5), C_ScreenSizeChange(66), C_ScreenSizeChange(110), C_ScreenSizeChange(30));
    self.areaCodeLineLabel.frame = CGRectMake(CGRectGetMaxX(self.areaCodeLabel.frame) + C_ScreenSizeChange(5), 0,C_ScreenSizeChange(0.8), C_ScreenSizeChange(160));
    self.pareanamelabel.frame = CGRectMake(CGRectGetMaxX(self.areaCodeLineLabel.frame) + C_ScreenSizeChange(15), C_ScreenSizeChange(7), C_ScreenWidth - CGRectGetMaxX(self.areaCodeLineLabel.frame) - C_ScreenSizeChange(30), C_ScreenSizeChange(30));
}



@end
