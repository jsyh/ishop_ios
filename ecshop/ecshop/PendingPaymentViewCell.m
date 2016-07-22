//
//  PendingPaymentViewCell.m
//  ecshop
//
//  Created by Jin on 15/12/7.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "PendingPaymentViewCell.h"
#import "UIImageView+WebCache.h"
#import "RequestModel.h"
@implementation PendingPaymentViewCell

- (void)awakeFromNib {
    self.payBtn.layer.borderWidth = 0.5f;
    self.payBtn.layer.borderColor = [[UIColor redColor]CGColor];
    self.payBtn.layer.cornerRadius = 5;
    // Initialization code
}
-(void)setModel:(shangpinModel *)model{
    self.goodsNameLab.text = model.goodsName;
    self.goodsPriceLab.text = [NSString stringWithFormat:@"￥%@",model.goodsPrice];
    
    self.goodsNumberLab.text = [NSString stringWithFormat:@"数量：%@",model.goodsNumber];
    self.realPayLab.text = [NSString stringWithFormat:@"￥%@",model.total];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *imgUrl = data[@"imgUrl"];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",imgUrl,model.goodsImage];
    NSURL *url = [NSURL URLWithString:urlstr];
    [self.imgView setImageWithURL:url];
    
    
    self.orderid = model.orderId;
    [self.payBtn addTarget:self action:@selector(received:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)received:(id)sender{
    NSLog(@"%@",self.orderid);
    NSString *api_token = [RequestModel model:@"user" action:@"received"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":self.tempDic[@"data"][@"key"],@"order_id":self.orderid};
    [RequestModel requestWithDictionary:dict model:@"user" action:@"received" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"获得的数据：%@",dic);
        
        
        
        
        //        [self.table reloadData];
    }];
}
@end
