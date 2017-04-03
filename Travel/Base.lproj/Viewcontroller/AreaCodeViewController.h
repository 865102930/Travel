//
//  AreaCodeViewController.h
//  Travel
//
//  Created by gz on 17/3/30.
//  Copyright © 2017年 gz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaCodeButton.h"

typedef void(^AreaCodeBlock)();

@interface AreaCodeViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) AreaCodeBlock myBlock;

@property (nonatomic,strong) AreaCodeButton* areacodebutton;


@end
