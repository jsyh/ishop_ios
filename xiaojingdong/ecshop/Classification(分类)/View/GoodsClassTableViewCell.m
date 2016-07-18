//
//  GoodsClassTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/14.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "GoodsClassTableViewCell.h"

@implementation GoodsClassTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
