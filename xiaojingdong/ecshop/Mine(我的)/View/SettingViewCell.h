//
//  SettingViewCell.h
//  ecshop
//
//  Created by Jin on 15/12/7.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *propertyBtn;

@end
