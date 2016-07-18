//
//  MyOrderFooterTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/5/17.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderFooterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *qxOrderBtn;//取消订单
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;//联系卖家

@end
