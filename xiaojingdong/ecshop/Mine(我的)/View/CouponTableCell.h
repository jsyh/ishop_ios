//
//  CouponTableCell.h
//  ecshop
//
//  Created by jsyh-mac on 16/3/2.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottonView;

@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;

@property (strong, nonatomic) IBOutlet UILabel *moneyLab;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *requireLab;
@property (strong, nonatomic) IBOutlet UILabel *stateLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UIImageView *pictureStateImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIView *ritghtView;

@end
