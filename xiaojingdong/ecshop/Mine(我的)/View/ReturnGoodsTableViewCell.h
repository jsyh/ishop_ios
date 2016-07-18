//
//  ReturnGoodsTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/5/11.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *colorLab;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *qxMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *logisticsBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
