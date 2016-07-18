//
//  SearchListViewController.h
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchListViewController : UIViewController

@property (nonatomic, strong) NSString *secondLab;//接受搜索内容
@property (nonatomic, strong) NSString * goodIDS;//商品id
@property (nonatomic, strong) NSString * gooddid;//从第二页面调过来的
@property (nonatomic, strong) NSString * secondStr;//接受filtrate
@property (nonatomic, strong) NSString * typeStay;//type的状态
@property (nonatomic, strong) NSString * goodType;
@property (nonatomic, strong) NSString *brandID;//第二页传来的品牌
@end
