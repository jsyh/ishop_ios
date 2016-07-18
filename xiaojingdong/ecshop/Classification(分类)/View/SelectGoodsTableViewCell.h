//
//  SelectGoodsTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/4/20.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectGoodsTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imgView;//左侧图片
@property(nonatomic,strong)UILabel *nameLab;//名字
@property(nonatomic,strong)UILabel *priceLab;//价格
@property(nonatomic,strong)UILabel *attributeLab;//商品属性
@property(nonatomic,strong)UILabel *numLab;//数量
@end
