//
//  MediaEditViewController.h
//  旅游资源采集
//
//  Created by gz on 17/3/23.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Request.h"

typedef void(^MediaInfoBlock)(id mediainfo);

@interface MediaEditViewController : UIViewController

@property (nonatomic,strong) NSString* LocalUnitID;
@property (nonatomic,strong) MediaInfo* mediainfo;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *imgTextField;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *imgLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectImgButton;
@property (nonatomic,copy) MediaInfoBlock myBlock;
@property (nonatomic,strong) NSString* filename;

- (IBAction)selectimgclick:(id)sender;

@end
