//
//  MineTableViewCell.m
//  ecshop
//
//  Created by Jin on 15/12/3.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "MineTableViewCell.h"
#import "UIColor+Hex.h"
@implementation MineTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.lab.font = [UIFont systemFontOfSize:15];
    self.lab.textColor = [UIColor colorWithHexString:@"#43464c"];
    self.lab2.textAlignment = NSTextAlignmentRight;
    self.lab2.textColor = [UIColor colorWithHexString:@"#999999"];
    self.lab2.font = [UIFont systemFontOfSize:12];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
