//
//  SearchShopTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/4/13.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchShopTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *shopImage;  //商店的图标
@property(nonatomic,strong)UILabel *shopNameLab;    //商店的名字
@property(nonatomic,strong)UILabel *shopGradeLab;   //商店的等级
@property(nonatomic,strong)UILabel *allGoodsNumLab; //全部宝贝个数
@property(nonatomic,strong)UILabel *salesNumLab;    //销量
@property(nonatomic,strong)UIButton *shopBtn;       //进店逛逛按钮
@property(nonatomic,strong)UIView *imgView;         //放商品图片的view
@end
