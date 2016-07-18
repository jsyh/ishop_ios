//
//  GoodRightCell.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/31.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "GoodRightCell.h"
#import "UIColor+Hex.h"
@implementation GoodRightCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self creatCell];
    }
    return self;
}
-(void)creatCell
{

    self.cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cellBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.cellBtn.selected = NO;
    [self.cellBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
 
    [self.cellBtn addTarget:self action:@selector(readCell) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cellBtn];
    

}
-(void)setModel:(goodsModel *)model{
    [self.cellBtn setTitle:model.attrValue forState:UIControlStateNormal];
    self.attrName = model.attrName;
    self.attrPrice = model.attrPrice;
    self.attrID = model.attrID;
    self.goodsAttrID = model.goodsAttrID;
   
}
-(void)readCell{
    NSLog(@"%@--%@",self.cellBtn.titleLabel.text,self.attrName);
    [self.dic setObject:self.cellBtn.titleLabel.text forKey:self.attrName];
    
    NSLog(@"%@",self.dic);
}
-(NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [[NSMutableDictionary alloc]init];
    }
    return _dic;
}
@end
