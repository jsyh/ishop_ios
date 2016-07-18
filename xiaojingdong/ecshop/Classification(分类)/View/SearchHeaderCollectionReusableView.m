//
//  SearchHeaderCollectionReusableView.m
//  ecshop
//
//  Created by Jin on 16/4/11.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "SearchHeaderCollectionReusableView.h"

@implementation SearchHeaderCollectionReusableView
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
    float imgFloatH = 28.0/1334.0;
    float imgFloatW = 28.0/750.0;
    float aX = 24.0/750.0;
    float aY = 24.0/1334.0;
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(width*aX, aY*height, imgFloatW*width, imgFloatH*height)];
    [self addSubview:_imgView];
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.frame.size.width +_imgView.frame.origin.x+aX*width, aY*height, 300, imgFloatH*height)];
    self.title.font = [UIFont systemFontOfSize:14];
    self.title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.title];
    
    
}
@end
