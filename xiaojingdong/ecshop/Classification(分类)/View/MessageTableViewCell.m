//
//  MessageTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/5/3.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "UIColor+Hex.h"
@implementation MessageTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubview];
    }
    return self;
}
-(void)creatSubview{
    float aH92 = 92.0/1334.0;
    float aX24 = 24.0/750.0;
    float aY24 = 24.0/1334.0;
    //买家留言
    UIView *messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, aH92*Height)];
    UILabel *messageLab = [[UILabel alloc]initWithFrame:CGRectMake(aX24*Width, aY24*Height, 80, 15)];
    messageLab.font = [UIFont systemFontOfSize:15];
    messageLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    messageLab.text = @"买家留言：";
    [messageView addSubview:messageLab];
    _textField =[[UITextField alloc]initWithFrame:CGRectMake(messageLab.frame.size.width+messageLab.frame.origin.x, messageLab.frame.origin.y, Width-messageLab.frame.origin.x-messageLab.frame.size.width, 15)];
    _textField.placeholder = @"选填，可填写您和卖家达成一致的要求";
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.textColor = [UIColor colorWithHexString:@"#43464c"];
    [messageView addSubview:_textField];
    UIView *viewLine2 = [[UIView alloc]initWithFrame:CGRectMake(aX24*Width, messageView.frame.size.height-1, Width-aX24*Width, 1)];
    viewLine2.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [messageView addSubview:viewLine2];
    [self addSubview:messageView];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
