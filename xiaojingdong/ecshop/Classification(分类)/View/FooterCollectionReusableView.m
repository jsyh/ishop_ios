//
//  FooterCollectionReusableView.m
//  ecshop
//
//  Created by Jin on 16/3/30.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "FooterCollectionReusableView.h"
#import "UIColor+Hex.h"
@interface FooterCollectionReusableView()<UITextFieldDelegate>
@end
@implementation FooterCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:frame];
    if (self) {
        float a44 = 44.0/1334.0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, a44*height, 300, 14)];
        label.text = @"购买数量";
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"#43464c"];
        [self addSubview:label];
        float a240 = 240.0/750.0;
        float a66 = 66.0/750.0;
        float a24 = 24.0/1334.0;
        float a132 = 132.0/750.0;
        self.title = [[UITextField alloc] initWithFrame:CGRectMake(width - a240*width, a24*height, a132*width, a66*width)];
        self.title.delegate = self;
        self.title.textColor = [UIColor colorWithHexString:@"#43464c"];
        self.title.font = [UIFont systemFontOfSize:15];
        self.title.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        float a324 = 324.0/750.0;
        self.subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.subBtn.frame = CGRectMake(width-a324*width, a24*height, a66*width, a66*width);
        [self.subBtn setTitle:@"-" forState:UIControlStateNormal];
        [self.subBtn setTitleColor:[UIColor colorWithHexString:@"#FF5000"] forState:UIControlStateNormal];
        self.subBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        self.subBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self addSubview:self.subBtn];
        float a90 = 90.0/750.0;
        self.plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.plusBtn.frame = CGRectMake(width-a90*width, a24*height, a66*width, a66*width);
        self.plusBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        self.plusBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self.plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [self.plusBtn setTitleColor:[UIColor colorWithHexString:@"#FF5000"] forState:UIControlStateNormal];
        [self addSubview:self.plusBtn];
        
        
       
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([_title isFirstResponder]) {
        [_title resignFirstResponder];
    }
    return YES;
}
@end
