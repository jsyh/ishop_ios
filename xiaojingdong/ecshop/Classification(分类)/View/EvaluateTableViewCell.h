//
//  EvaluateTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/3/30.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *totleEvaluateLab;//宝贝评价
@property(nonatomic,strong)UILabel *userNameLab;//用户名
@property(nonatomic,strong)UILabel *contentLab;//评价内容
@property(nonatomic,strong)UIButton *allCommentBtn;//查看全部评论
@property(nonatomic,strong)UILabel *goodsPropertyLab;//商品属性
@property(nonatomic,strong)UIImageView *userImage;//用户头像
@property(nonatomic,strong)UILabel *badLab;//差评
@property(nonatomic,strong)UILabel *midLab;//中评
@property(nonatomic,strong)UILabel *goodLab;//好评
@end
