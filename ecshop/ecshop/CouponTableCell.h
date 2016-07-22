//
//  CouponTableCell.h
//  ecshop
//
//  Created by jsyh-mac on 16/3/2.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *moneyLab;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *requireLab;
@property (strong, nonatomic) IBOutlet UILabel *stateLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UIImageView *pictureStateImgView;

@end
