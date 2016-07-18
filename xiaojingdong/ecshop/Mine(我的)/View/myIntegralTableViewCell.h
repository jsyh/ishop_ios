//
//  myIntegralTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/6/21.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IntegralModel;
@interface myIntegralTableViewCell : UITableViewCell
@property (nonatomic,strong)IntegralModel *model;
@property (nonatomic,strong)UILabel *orderIDLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *integralLab;
@end
