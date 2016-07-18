//
//  DetailTableCell.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/11.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableCell : UITableViewCell
@property (nonatomic, strong) UILabel  * lab1;            //商品名称
@property (nonatomic, strong) UILabel  * lab2;            //商品价格
@property (nonatomic, strong) UILabel  * monSign;         //钱的符号
@property (nonatomic, strong) UILabel  * evaluateNumLab;  //评价个数
@property (nonatomic, strong) UILabel  * saleNumLab;      //销量个数
@property (nonatomic, strong) UILabel  * addressLab;      //地址
@property (nonatomic, strong) UIButton * shareBtn;        //分享

@end
