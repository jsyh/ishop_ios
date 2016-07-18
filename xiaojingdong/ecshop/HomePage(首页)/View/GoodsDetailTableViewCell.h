//
//  GoodsDetailTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/5/31.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel  * lab1;            //商品名称
@property (nonatomic, strong) UILabel  * lab2;            //商品价格
@property (nonatomic, strong) UILabel  * evaluateNumLab;  //评价个数
@property (nonatomic, strong) UILabel  * saleNumLab;      //销量个数
@property (nonatomic, strong) UILabel  * addressLab;      //地址
@property (nonatomic, strong) UIButton * shareBtn;        //分享
@end
