//
//  CommentSendTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/5/4.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentSendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (nonatomic,strong)UILabel *commentText;
@property (nonatomic,strong)NSString *goodsID;
@property (nonatomic,strong)NSString *comment;//好评中评差评
@property (nonatomic,strong)NSString *commentStr;//评论内容
@end
