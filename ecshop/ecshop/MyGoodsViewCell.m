//
//  MyGoodsViewCell.m
//  ecshop
//
//  Created by Jin on 15/12/25.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "MyGoodsViewCell.h"
#import "UIImageView+WebCache.h"
#import "RequestModel.h"
#import "AppDelegate.h"
#import "UIColor+Hex.h"
@implementation MyGoodsViewCell

- (void)awakeFromNib {
    [self.changeBtn setImage:[UIImage imageNamed:@"select_cart_goods2.png"] forState:UIControlStateNormal];
    self.taggg = 1;
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    [self.changeBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self.plusBtn addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
    [self.minusBtn addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setModel:(goodsModel *)model{
    self.rec_id = model.rec_id;
    self.goods_name.text = model.goods_name;
    self.goods_name.font = [UIFont systemFontOfSize:15];
    self.goods_id = model.goods_id;
    self.goods_price.text = model.goods_price;
    self.goods_price.font = [UIFont systemFontOfSize:15];
    [self.goods_number setTitle:[NSString stringWithFormat:@"%d",model.number] forState:UIControlStateNormal];
    self.goods_number.titleLabel.font = [UIFont systemFontOfSize:15];
    _url = model.goods_img;
    [self.goods_img setImageWithURL:[NSURL URLWithString:model.goods_img]];
    int a = [model.goods_price intValue];
    int b = a*model.number;
    NSString *sum = [NSString stringWithFormat:@"%d",b];
    self.goods_sum.text = [NSString stringWithFormat:@"小计：￥%@",sum];
    self.goods_sum.font = [UIFont systemFontOfSize:15];
    self.goods_sum.textColor = [UIColor redColor];
}
-(void)change:(id)sender{
    if (self.taggg == 1) {
        [self.changeBtn setImage:[UIImage imageNamed:@"select_cart_goods1.png"] forState:UIControlStateNormal];
        self.taggg = 2;
    }else{
        [self.changeBtn setImage:[UIImage imageNamed:@"select_cart_goods2.png"] forState:UIControlStateNormal];
        self.taggg = 1;
    }
}
#pragma mark-增加
-(void)plus:(id)sender{
    NSString *a = self.goods_number.titleLabel.text;
    int b = [a intValue];
    b++;
    [self.goods_number setTitle:[NSString stringWithFormat:@"%d",b] forState:UIControlStateNormal];
    NSString *c = self.goods_price.text;
    int d = [c intValue];
    int e = b*d;
    self.goods_sum.text = [NSString stringWithFormat:@"小计：￥%d",e];
    [self myGoodsNum:b];
}
#pragma mark-减
-(void)minus:(id)sender{
    NSString *a = self.goods_number.titleLabel.text;
    int b = [a intValue];
    if (b == 0) {
        return;
    }
    b--;
    [self.goods_number setTitle:[NSString stringWithFormat:@"%d",b] forState:UIControlStateNormal];
    NSString *c = self.goods_price.text;
    int d = [c intValue];
    int e = b*d;
    self.goods_sum.text = [NSString stringWithFormat:@"小计：￥%d",e];
    [self myGoodsNum:b];
}
-(void)myGoodsNum:(int)num{
    NSString *a = [NSString stringWithFormat:@"%d",num];
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"goods" action:@"charnum"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"rec_id":self.rec_id,@"num":a};
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"charnum" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"获得的数据：%@",dic);
        
    }];
}
@end
