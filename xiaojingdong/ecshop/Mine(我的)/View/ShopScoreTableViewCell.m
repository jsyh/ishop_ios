//
//  ShopScoreTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/5/12.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "ShopScoreTableViewCell.h"
#import "UIColor+Hex.h"
@implementation ShopScoreTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubview];
    }
    return self;
}
-(void)creatSubview{
 
    //店铺评分
    UILabel *shopScoreLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 100, 16)];
    shopScoreLab.text = @"店铺评分";
    shopScoreLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    shopScoreLab.font = [UIFont systemFontOfSize:16];
    [self addSubview:shopScoreLab];
    //描述相符
    UILabel *describeLab = [[UILabel alloc]initWithFrame:CGRectMake(12, shopScoreLab.frame.origin.y+shopScoreLab.frame.size.height+12, 60, 14)];
    describeLab.text = @"描述相符";
    describeLab.font = [UIFont systemFontOfSize:14];
    describeLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self addSubview:describeLab];
    
    _descrebeView = [[UIView alloc]initWithFrame:CGRectMake(describeLab.frame.origin.x+describeLab.frame.size.width+12, describeLab.frame.origin.y, 200, 16)];
//    _descrebeView.backgroundColor = [UIColor redColor];
    UIImageView *imageView;
    for (int i = 0; i < 5; i++) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_star"]];
        imageView.frame = CGRectMake(_descrebeView.bounds.origin.x+((i+1)*16), _descrebeView.bounds.origin.y, 16, 16);
        [_descrebeView addSubview:imageView];
        [self.descrebeStar addObject:imageView];
    }
    
    
    [self addSubview:_descrebeView];
    //发货速度
    UILabel *speedLab = [[UILabel alloc]initWithFrame:CGRectMake(12, describeLab.frame.origin.y+describeLab.frame.size.height+12, 60, 14)];
    speedLab.text = @"发货速度";
    speedLab.font = [UIFont systemFontOfSize:14];
    speedLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self addSubview:speedLab];
    
    _speedView = [[UIView alloc]initWithFrame:CGRectMake(speedLab.frame.origin.x+speedLab.frame.size.width+12, speedLab.frame.origin.y, 200, 16)];
//    speedView.backgroundColor = [UIColor redColor];
    UIImageView *speedImageView;
    for (int i = 0; i < 5; i++) {
        speedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_star"]];
        speedImageView.frame = CGRectMake(_speedView.bounds.origin.x+((i+1)*16), _speedView.bounds.origin.y, 16, 16);
        [_speedView addSubview:speedImageView];
        [self.speedStar addObject:speedImageView];
    }
    [self addSubview:_speedView];
    
    //服务态度
    UILabel *serviceLab = [[UILabel alloc]initWithFrame:CGRectMake(12, speedLab.frame.origin.y+speedLab.frame.size.height+12, 60, 14)];
    serviceLab.text = @"服务态度";
    serviceLab.font = [UIFont systemFontOfSize:14];
    serviceLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self addSubview:serviceLab];
    
    _serviceView = [[UIView alloc]initWithFrame:CGRectMake(serviceLab.frame.origin.x+serviceLab.frame.size.width+12, serviceLab.frame.origin.y, 200, 16)];
    UIImageView *serviceImageView;
    for (int i = 0; i < 5; i++) {
        serviceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_star"]];
        serviceImageView.frame = CGRectMake(_serviceView.bounds.origin.x+((i+1)*16), _serviceView.bounds.origin.y, 16, 16);
        [_serviceView addSubview:serviceImageView];
        [self.serviceStar addObject:serviceImageView];
    }
    [self addSubview:_serviceView];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 点击的坐标
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:_descrebeView];
    CGPoint touchPoint2 = [touch locationInView:_speedView];
    CGPoint touchPoint3 = [touch locationInView:_serviceView];
    UIImageView *im ;
    for(int i = 0;i < 5 ; i++){
        im = _descrebeStar[i];
//        NSLog(@"_all[%i] = (%f,%f)",i,im.frame.origin.x,im.frame.origin.y);
        if ((touchPoint.x > 0)&&(touchPoint.x < 96)&&(touchPoint.y > 0)&&(touchPoint.y < 16)) {
            NSString *myscore = [NSString stringWithFormat:@"%i",((int)touchPoint.x)/16];
            _descrebeStr = myscore;
            NSLog(@"%@",_descrebeStr);
            if (im.frame.origin.x > touchPoint.x) {
                im.image =[UIImage imageNamed:@"comment_star"];
            }else{
                im.image =[UIImage imageNamed:@"comment_star_press"];
            }
        }
    }
    
    UIImageView *im2 ;
    for(int i = 0;i < 5 ; i++){
        im2 = _speedStar[i];
//        NSLog(@"_all[%i] = (%f,%f)",i,im2.frame.origin.x,im2.frame.origin.y);
        if ((touchPoint2.x > 0)&&(touchPoint2.x < 96)&&(touchPoint2.y > 0)&&(touchPoint2.y < 16)) {
            NSString *myscore = [NSString stringWithFormat:@"%i",((int)touchPoint2.x)/16];
            _speedStr = myscore;
            NSLog(@"%@",_speedStr);
            if (im2.frame.origin.x > touchPoint2.x) {
                im2.image =[UIImage imageNamed:@"comment_star"];
            }else{
                im2.image =[UIImage imageNamed:@"comment_star_press"];
            }
        }
    }
    
    UIImageView *im3 ;
    for(int i = 0;i < 5 ; i++){
        im3 = _serviceStar[i];
//        NSLog(@"_all[%i] = (%f,%f)",i,im3.frame.origin.x,im3.frame.origin.y);
        if ((touchPoint3.x > 0)&&(touchPoint3.x < 96)&&(touchPoint3.y > 0)&&(touchPoint3.y < 16)) {
            NSString *myscore = [NSString stringWithFormat:@"%i",((int)touchPoint3.x)/16];
            _serviceStr = myscore;
            NSLog(@"%@",_serviceStr);
            if (im3.frame.origin.x > touchPoint3.x) {
                im3.image =[UIImage imageNamed:@"comment_star"];
            }else{
                im3.image =[UIImage imageNamed:@"comment_star_press"];
            }
        }
    }
    if (_descrebeStr == nil) {
        _descrebeStr = @"";
    }
    if (_speedStr == nil) {
        _speedStr = @"";
    }
    if (_serviceStr == nil) {
        _serviceStr = @"";
    }
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"shopScore" object:nil userInfo:@{@"descrebeStr":_descrebeStr,@"speedStr":_speedStr,@"serviceStr":_serviceStr}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
}
-(NSMutableArray *)descrebeStar{
    if (!_descrebeStar) {
        _descrebeStar = [[NSMutableArray alloc]init];
    }
    return _descrebeStar;
}
-(NSMutableArray *)speedStar{
    if (!_speedStar) {
        _speedStar = [[NSMutableArray alloc]init];
    }
    return _speedStar;
}
-(NSMutableArray *)serviceStar{
    if (!_serviceStar) {
        _serviceStar = [[NSMutableArray alloc]init];
    }
    return _serviceStar;
}
@end
