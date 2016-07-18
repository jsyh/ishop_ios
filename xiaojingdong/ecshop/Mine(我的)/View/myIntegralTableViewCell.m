//
//  myIntegralTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/6/21.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "myIntegralTableViewCell.h"
#import "UIColor+Hex.h"
#import "IntegralModel.h"
@implementation myIntegralTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubview];
    }
    return self;
}
-(void)creatSubview{
    _orderIDLab = [[UILabel alloc]initWithFrame:CGRectMake(W(12), H(12), W(200), H(15))];
    _orderIDLab.textColor = [UIColor colorWithHexString:@"#43464d"];
    _orderIDLab.text = @"订单 448940";
    _orderIDLab.font = [UIFont systemFontOfSize:W(15)];
    [self.contentView addSubview:_orderIDLab];
    
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(_orderIDLab.frame.origin.x, _orderIDLab.frame.size.height+_orderIDLab.frame.origin.y+H(12), W(200), H(13))];
    _timeLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLab.text = @"2016.3.14 15:04:44";
    _timeLab.font = [UIFont systemFontOfSize:W(13)];
    [self.contentView addSubview:_timeLab];
    
    _integralLab = [[UILabel alloc]initWithFrame:CGRectMake(Width - W(112), H(27), W(100), H(15))];
    _integralLab.textColor = [UIColor colorWithHexString:@"#ff3b30"];
    _integralLab.text = @"+12";
    _integralLab.font = [UIFont systemFontOfSize:W(15)];
    _integralLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_integralLab];
    
}
-(void)setModel:(IntegralModel *)model{
    _orderIDLab.text = model.name;
    _integralLab.text = [NSString stringWithFormat:@"+%@",model.points];
    
    NSString * time = model.time;
    NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY.MM.dd HH:MM:ss"];
    NSString * startTime = [df stringFromDate:dt];

    _timeLab.text = [NSString stringWithFormat:@"%@",startTime];

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
