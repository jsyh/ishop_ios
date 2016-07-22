//
//  MyAddressViewCell.m
//  ecshop
//
//  Created by Jin on 15/12/22.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "MyAddressViewCell.h"

@implementation MyAddressViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.editBtn setImage:[UIImage imageNamed:@"address_edit"] forState:UIControlStateNormal];
    [self.deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    self.deleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setModel:(AddressModel *)model{
    self.nameLab.text = model.username;
    self.nameLab.font = [UIFont systemFontOfSize:15];
    self.addressLab.text = model.address;
    self.addressLab.font = [UIFont systemFontOfSize:15];
    self.telephoneLab.text = model.telnumber;
    self.telephoneLab.font = [UIFont systemFontOfSize:15];
    self.address_id = model.address_id;
    [self.checkBtn setTitle:@"设置为默认" forState:UIControlStateNormal];
    self.checkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if ([model.is_default isEqualToString:@"0"]) {
        [self.checkBtn setImage:[UIImage imageNamed:@"select_cart_goods2.png"] forState:UIControlStateNormal];
    }else if ([model.is_default isEqualToString:@"1"]){
        [self.checkBtn setImage:[UIImage imageNamed:@"select_cart_goods1.png"] forState:UIControlStateNormal];
    }
}
@end
