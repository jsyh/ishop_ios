//
//  GoodsCollectionReusableView.m
//  ecshop
//
//  Created by Jin on 16/3/30.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "GoodsCollectionReusableView.h"
#import "UIColor+Hex.h"
@implementation GoodsCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 300, 14)];
    self.title.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.title];
    
}
@end
