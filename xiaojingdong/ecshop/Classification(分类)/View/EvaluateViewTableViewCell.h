//
//  EvaluateViewTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/4/5.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateViewTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *userImage;//用户头像
@property(nonatomic,strong)UILabel *goodsPropertyLab;//商品属性
@property(nonatomic,strong)UILabel *userNameLab;//用户名
@property(nonatomic,strong)UILabel *contentLab;//评价内容
@property(nonatomic,strong)UILabel *timeLab;//评论时间
@end
