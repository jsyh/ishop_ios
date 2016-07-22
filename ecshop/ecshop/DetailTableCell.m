//
//  DetailTableCell.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/11.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "DetailTableCell.h"

@implementation DetailTableCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubview];
    }
    return self;
}
-(void)creatSubview
{
    _lab1=[[UILabel alloc]initWithFrame:CGRectMake(5,5, self.frame.size.width, 75)];
    _lab1.numberOfLines=0;
    _lab1.font=[UIFont systemFontOfSize:15];
    _lab1.textColor=[UIColor blackColor];
    _lab1.textAlignment=NSTextAlignmentNatural;
    [self.contentView addSubview:_lab1];
    _monSign=[[UILabel alloc]initWithFrame:CGRectMake(5, 77, 20, 15)];
    _monSign.textColor=[UIColor redColor];
    _monSign.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_monSign];
    _lab2=[[UILabel alloc]initWithFrame:CGRectMake(25, 77, 100, 15)];
    _lab2.font=[UIFont systemFontOfSize:15];
    _lab2.textColor=[UIColor redColor];
    [self.contentView addSubview:_lab2];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
