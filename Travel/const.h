//
//  const.h
//  旅游资源采集
//
//  Created by Alonezzz on 2017/3/14.
//  Copyright © 2017年 浙江智旅信息有限公司. All rights reserved.
//

#ifndef const_h
#define const_h


#define c_interfaceurl @"https://rapi.zjwist.com/app/"

#define c_DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]
#define RGB(R,G,B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]
#define C_ScreenLineColour [UIColor colorWithRed:189/255.0 green:251/255.0 blue:255/255.0 alpha:0.5]
#define C_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define C_ScreenHeight [UIScreen mainScreen].bounds.size.height
#define C_ScreenSizeChange(A) (A) * [UIScreen mainScreen].bounds.size.width/375.0

#endif /* const_h */
