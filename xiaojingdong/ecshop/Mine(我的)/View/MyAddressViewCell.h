//
//  MyAddressViewCell.h
//  ecshop
//
//  Created by Jin on 15/12/22.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface MyAddressViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
@property(nonatomic,strong)AddressModel *model;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

//判断是否设置为默认
@property (nonatomic,assign)int checkTag;
//是否默认收货地址0不是默认1是默认
@property(nonatomic,strong)NSString *is_default;
@property(nonatomic,strong)NSString *address_id;
@end
