//
//  OrderDetailExpressTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/5/9.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailExpressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *shippingNameLab;
@property (weak, nonatomic) IBOutlet UILabel *shippingSnLab;
@property (weak, nonatomic) IBOutlet UILabel *statesLab;
@property (weak, nonatomic) IBOutlet UIButton *copyyBtn;

@end
