//
//  SearchListTableCell.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/16.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#define tableHeight 130
@interface SearchListTableCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImage;//商品图片
@property (nonatomic, strong) UIImageView *saleImage;//促销图片
@property (nonatomic, strong) UILabel *nameLab;//商品名
@property (nonatomic, strong) UILabel *moneySign;//人民币符号￥
@property (nonatomic, strong) UILabel *priceLab;//价格
@property (nonatomic, strong) UILabel *num1Lab;//好评率
@property (nonatomic, strong) UILabel *num2Lab;//百分比

@end
