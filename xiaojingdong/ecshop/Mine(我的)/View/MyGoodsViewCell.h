//
//  MyGoodsViewCell.h
//  ecshop
//
//  Created by Jin on 15/12/25.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsModel.h"
@interface MyGoodsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
//小计
@property (weak, nonatomic) IBOutlet UILabel *goods_sum;
//单价
@property (weak, nonatomic) IBOutlet UILabel *goods_price;
//图片
@property (weak, nonatomic) IBOutlet UIButton *goods_number;
@property (weak, nonatomic) IBOutlet UIImageView *goods_img;
//选择状态按钮
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
//增加数量
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
//减少数量
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;

@property (nonatomic,strong)goodsModel *model;
@property (nonatomic,assign)int taggg;
//购物车唯一标识
@property (nonatomic,strong)NSString *rec_id;
@property (nonatomic,strong)NSString *goods_id;
@property (nonatomic,strong)NSString *url;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end
