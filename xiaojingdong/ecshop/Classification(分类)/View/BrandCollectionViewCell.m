//
//  BrandCollectionViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/8.
//  Copyright © 2016年 jsyh. All rights reserved.
//分类页面的collection品牌的cell

#import "BrandCollectionViewCell.h"

@implementation BrandCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    float a = 184.0/750.0;
    float b = 90.0/1334.0;
    _brandImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width*a, height*b)];

    [self addSubview:_brandImgView];
    
    
}
@end
