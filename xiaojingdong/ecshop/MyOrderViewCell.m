//
//  MyOrderViewCell.m
//  ecshop
//
//  Created by Jin on 15/12/7.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "MyOrderViewCell.h"
#import "RequestModel.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Hex.h"
@implementation MyOrderViewCell

- (void)awakeFromNib {
    self.payBtn.layer.borderWidth = 0.5f;
    self.payBtn.layer.borderColor = [[UIColor redColor]CGColor];
    self.payBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.borderWidth = 0.5f;
    self.cancelBtn.layer.borderColor = [[UIColor grayColor]CGColor];
    self.cancelBtn.layer.cornerRadius = 5;
    // Initialization code
}
-(void)setModel:(shangpinModel *)model{
    self.goodsNameLab.text = model.goodsName;
    self.goodsNameLab.font = [UIFont systemFontOfSize:12];
    self.goodsNameLab.numberOfLines = 2;
    self.goodsNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    
    self.goodsPriceLab.text = [NSString stringWithFormat:@"￥%@",model.goodsPrice];
    self.goodsPriceLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    self.goodsPriceLab.font = [UIFont boldSystemFontOfSize:12];
    
    self.goodsNumberLab.text = [NSString stringWithFormat:@"x%@",model.goodsNumber];
    self.goodsNumberLab.textColor =[UIColor colorWithHexString:@"#9b9b9b"];
    self.goodsNumberLab.font = [UIFont systemFontOfSize:12];
    self.realPayLab.text = [NSString stringWithFormat:@"￥%@",model.total];
    self.orderid = model.orderId;
    
    NSURL *url = [NSURL URLWithString:model.goodsImage];
    [self.imgView setImageWithURL:url];
    //申请售后按钮
    self.serviceBtn.layer.borderWidth = 0.5f;
    self.serviceBtn.layer.cornerRadius = 3;
    self.serviceBtn.layer.borderColor = [UIColor colorWithHexString:@"#43464c"].CGColor;
    [self.serviceBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.serviceBtn.layer.masksToBounds = YES;
    
    self.colorLab.text = model.attrStr;
    self.colorLab.textColor = [UIColor colorWithHexString:@"#999999"];
    self.colorLab.font = [UIFont systemFontOfSize:12];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)received:(id)sender orderid:(NSString *)orderid{
    NSLog(@"确认收货");
    NSString *api_token = [RequestModel model:@"user" action:@"received"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":self.tempDic[@"data"][@"key"],@"order_id":orderid};
    [RequestModel requestWithDictionary:dict model:@"user" action:@"received" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"获得的数据：%@",dic);
        
        
        
        
        //        [self.table reloadData];
    }];
}
@end
