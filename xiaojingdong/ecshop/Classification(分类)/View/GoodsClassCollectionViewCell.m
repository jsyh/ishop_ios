//
//  GoodsClassCollectionViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/14.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "GoodsClassCollectionViewCell.h"
#import "UIColor+Hex.h"
@implementation GoodsClassCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self creatCell];
    }
    return self;
}
-(void)creatCell{
    float width = [UIScreen mainScreen].bounds.size.width;
    float a = 214.0/750.0;
    self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    self.titleBtn.frame = CGRectMake(0, 0, a*width, 21);
    self.titleBtn.selected = NO;
    self.titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    self.titleBtn.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
//    [self.titleBtn addTarget:self action:@selector(readCell) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.titleBtn];
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, a*width, 21)];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.titleLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.titleLab];
}
@end
