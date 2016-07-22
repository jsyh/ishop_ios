//
//  SureTableViewCell.h
//  ecshop
//
//  Created by jsyh-mac on 16/1/12.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView * iconImage;//商品图片
@property (nonatomic, strong) UILabel * nameLab;//名字
@property (nonatomic, strong) UILabel * priceLab;//价格
@property (nonatomic, strong) UILabel* NumLab; //数量
@property (nonatomic, strong) UILabel * signname;//符号
@property (nonatomic, strong)  UILabel * shuliang;//数量汉字

@end
