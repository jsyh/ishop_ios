//
//  MyOrderViewCell.h
//  ecshop
//
//  Created by Jin on 15/12/7.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shangpinModel.h"
@interface MyOrderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *realPayLab;
@property (nonatomic,strong)NSString *orderid;
@property (nonatomic,strong)shangpinModel *model;

@property(nonatomic,strong)NSDictionary *tempDic;
@property (weak, nonatomic) IBOutlet UILabel *colorLab;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;//申请售后按钮

@end
