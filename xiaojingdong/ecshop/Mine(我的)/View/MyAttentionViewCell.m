//
//  MyAttentionViewCell.m
//  ecshop
//
//  Created by Jin on 15/12/31.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "MyAttentionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation MyAttentionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(shangpinModel *)model{
    
    self.labName.text = model.goodsName;
    self.labName.font = [UIFont systemFontOfSize:15];
//    self.labPrice.text = model.goodsPrice;
    self.labPrice.text = [NSString stringWithFormat:@"￥%@",model.goodsPrice];
    self.labPrice.textColor = [UIColor redColor];
    self.labPrice.font = [UIFont systemFontOfSize:15];
    if ([model.goodsImage isEqualToString:@"nil"]) {
        [self.imgView setImage:[UIImage imageNamed:@"180.png"]];
    }else{
        [self.imgView setImageWithURL:[NSURL URLWithString:model.goodsImage]];
    }
}
@end
