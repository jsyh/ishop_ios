//
//  sonCollectCell.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/9.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "sonCollectCell.h"

@implementation sonCollectCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self creatSubview];
    }
    return self;
}
-(void)creatSubview
{
    _lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _lab.numberOfLines=0;
    _lab.font=[UIFont systemFontOfSize:12];
    _lab.textColor=[UIColor blackColor];
    _lab.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_lab];
}
@end
