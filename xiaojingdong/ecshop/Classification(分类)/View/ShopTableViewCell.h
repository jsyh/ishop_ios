//
//  ShopTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/3/31.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *shopImage;  //商店的图标
@property(nonatomic,strong)UILabel *shopNameLab;    //商店的名字
@property(nonatomic,strong)UILabel *shopGradeLab;   //商店的等级
@property(nonatomic,strong)UILabel *allGoodsNumLab; //全部宝贝个数
@property(nonatomic,strong)UILabel *GoodsNewNumLab; //上新宝贝个数
@property(nonatomic,strong)UILabel *careNumLab;     //关注人数
@property(nonatomic,strong)UILabel *goodsDesLab;    //宝贝描述评分
@property(nonatomic,strong)UILabel *serviceDesLab;  //卖家服务评分
@property(nonatomic,strong)UILabel *logisticsDesLab;//物流服务评分
@property(nonatomic,strong)UIButton *customBtn;     //联系客服按钮
@property(nonatomic,strong)UIButton *shopBtn;       //进店逛逛按钮
@property(nonatomic,strong)UIButton *careBtn;       //店铺是否关注按钮
@end
