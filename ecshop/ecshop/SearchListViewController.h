//
//  SearchListViewController.h
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchListViewController : UIViewController

@property (nonatomic, copy) NSString *secondLab;//接受搜索内容
@property (nonatomic, copy) NSString * goodIDS;//商品id
@property (nonatomic, copy) NSString * gooddid;//从第二页面调过来的
@property (nonatomic, strong) NSMutableArray * secondArr;//接受filtrate
@property (nonatomic, copy) NSString * typeStay;//type的状态
@property (nonatomic, copy) NSString * goodType;
@end
