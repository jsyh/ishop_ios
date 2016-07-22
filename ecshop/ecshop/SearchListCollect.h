//
//  SearchListCollect.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/7.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define collectHeight 150
@interface SearchListCollect : UICollectionViewCell
@property (nonatomic, strong) UIImageView *iconImage;//商品图片
@property (nonatomic, strong) UILabel *nameLab;//商品名
@property (nonatomic, strong)UILabel *moneySign;//人民币符号￥
@property (nonatomic, strong) UILabel *priceLab;//价格

@end
