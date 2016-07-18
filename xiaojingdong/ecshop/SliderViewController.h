//
//  SliderViewController.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/7.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "Sliderbar.h"
//#import "SearchListViewController.h"
@interface SliderViewController : Sliderbar
@property (nonatomic, copy) NSString * rightLab;//侧边栏接收搜索的关键字
@property (nonatomic, strong) NSMutableDictionary * myfiltrate;//筛选数组;
@property (nonatomic, copy) NSString *str1;
@property (nonatomic, copy) NSString *myType;
//+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
@end
