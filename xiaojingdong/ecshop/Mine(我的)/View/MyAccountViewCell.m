//
//  MyAccountViewCell.m
//  ecshop
//
//  Created by Jin on 15/12/9.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "MyAccountViewCell.h"

@implementation MyAccountViewCell

- (void)awakeFromNib {
    self.imgView.layer.cornerRadius = 40;
    self.imgView.frame = CGRectMake(0, 0, 34, 34);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
