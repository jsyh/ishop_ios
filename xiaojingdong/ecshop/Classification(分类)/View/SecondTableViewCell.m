//
//  SecondTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/8.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "SecondTableViewCell.h"

@implementation SecondTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    float a = 150.0/750.0;
    float b = 112.0/1334.0;
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width*a, height*b)];
    
    [self.contentView addSubview:_label];
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
