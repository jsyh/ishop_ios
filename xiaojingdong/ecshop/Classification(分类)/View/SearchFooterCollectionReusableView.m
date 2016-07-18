//
//  SearchFooterCollectionReusableView.m
//  ecshop
//
//  Created by Jin on 16/4/11.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "SearchFooterCollectionReusableView.h"
#import "UIColor+Hex.h"
@implementation SearchFooterCollectionReusableView
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
    
    float centerX = width/2;
    float centerY = 100.0/1334.0;
    float btnX = 376.0/750.0;
    float btnY = 88.0/1334.0;
    
    float clearBtnFloat = 24.0/750.0;
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearBtn.frame = CGRectMake(centerX - width*btnX/2, centerY*height, btnX*width, btnY*height);
    _clearBtn.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    _clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_clearBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"search_clear_history"]] forState:UIControlStateNormal];
    [_clearBtn setTitleColor:[UIColor colorWithHexString:@"#656973"] forState:UIControlStateNormal];
    _clearBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-clearBtnFloat*width, 0, 0);
    [_clearBtn setTitle:@"清空历史搜索" forState:UIControlStateNormal];
    
    [self addSubview:_clearBtn];
}

@end
