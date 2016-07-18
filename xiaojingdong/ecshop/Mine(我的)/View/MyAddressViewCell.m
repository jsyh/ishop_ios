//
//  MyAddressViewCell.m
//  ecshop
//
//  Created by Jin on 15/12/22.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "MyAddressViewCell.h"
#import "UIColor+Hex.h"
@implementation MyAddressViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.editBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.editBtn.titleEdgeInsets=UIEdgeInsetsMake(0,6, 0, 0);
    [self.editBtn setImage:[UIImage imageNamed:@"mine_address_edit"] forState:UIControlStateNormal];
    [self.deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleBtn setImage:[UIImage imageNamed:@"mine_address_delete"] forState:UIControlStateNormal];
    self.deleBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.deleBtn.titleEdgeInsets=UIEdgeInsetsMake(0,6, 0, 0);
    self.deleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.viewLine.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setModel:(AddressModel *)model{
    self.nameLab.text = model.username;
    self.nameLab.font = [UIFont systemFontOfSize:16];
    self.addressLab.text = model.address;
    self.addressLab.font = [UIFont systemFontOfSize:14];
    self.telephoneLab.text = model.telnumber;
    self.telephoneLab.font = [UIFont systemFontOfSize:16];
    self.address_id = model.address_id;
    [self.checkBtn setTitle:@"默认地址" forState:UIControlStateNormal];
    self.checkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.checkBtn.titleEdgeInsets=UIEdgeInsetsMake(0,6, 0, 0);
    self.checkBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    //    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
//    self.checkBtn.imageEdgeInsets=UIEdgeInsetsMake(-10, 5, 10, -5);
    if ([model.is_default isEqualToString:@"0"]) {
        [self.checkBtn setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
    }else if ([model.is_default isEqualToString:@"1"]){
        [self.checkBtn setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
    }
}
@end
