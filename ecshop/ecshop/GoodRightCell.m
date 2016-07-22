//
//  GoodRightCell.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/31.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "GoodRightCell.h"

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
    self.cellLab=[[UILabel alloc]initWithFrame:CGRectMake(0,5, self.frame.size.width, 20)];
    self.cellLab.font=[UIFont systemFontOfSize:13];
    self.cellLab.textColor=[UIColor blackColor];
    self.cellLab.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.cellLab];
}
@end
