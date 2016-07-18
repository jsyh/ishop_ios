//
//  MyOrderTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/5/4.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgae;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsColor;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;

@end
