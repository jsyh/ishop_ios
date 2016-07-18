//
//  CommentSendTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/5/4.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "CommentSendTableViewCell.h"
#import "UIColor+Hex.h"
@interface CommentSendTableViewCell ()<UITextViewDelegate>
@end
@implementation CommentSendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.commentText.text = @"写下对宝贝的感受吧!";
    [self.text addSubview:_commentText];
    self.text.delegate = self;
    [self.btn1 addTarget:self action:@selector(haoping:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 addTarget:self action:@selector(haoping:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn3 addTarget:self action:@selector(haoping:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UILabel *)commentText{
    if (!_commentText) {
        _commentText = [[UILabel alloc]initWithFrame:CGRectMake(6, 10, 300, 14)];
        _commentText.textColor = [UIColor colorWithHexString:@"#999999"];
        _commentText.font = [UIFont systemFontOfSize:14];
    }
    return _commentText;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(![text isEqualToString:@""])
    {
        [_commentText setHidden:YES];
    }else{
        [_commentText setHighlighted:NO];
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
   
}
-(void)textViewDidEndEditing:(UITextView *)textView{
   NSLog(@"%@",textView.text);
    _commentStr = textView.text;
    NSString *score;
    if ([_comment isEqualToString:@"好评"]) {
        score = @"5";
    }else if([_comment isEqualToString:@"中评"]){
        score = @"3";
    }else if([_comment isEqualToString:@"差评"]){
        score = @"1";
    }else{
        score = @"5";
    }
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"goodsComment" object:nil userInfo:@{@"comments":textView.text,@"goods_id":self.goodsID,@"rank":score}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
-(void)haoping:(UIButton *)button{
 
    UIButton *btn1 = self.btn1;
    UIButton *btn2 = self.btn2;
    UIButton *btn3 = self.btn3;
    if (button == btn1) {
        [btn1 setImage:[UIImage imageNamed:@"comment_good_press"] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"comment_bad"] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"comment_mid"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        _comment = @"好评";
    }else if (button == btn2){
        [btn1 setImage:[UIImage imageNamed:@"comment_good"] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"comment_bad"] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"comment_mid_press"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
        _comment = @"中评";
    }else if(button == btn3){
        [btn1 setImage:[UIImage imageNamed:@"comment_good"] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"comment_bad_press"] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"comment_mid"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        _comment = @"差评";
    }
    NSString *score;
    if ([_comment isEqualToString:@"好评"]) {
        score = @"5";
    }else if([_comment isEqualToString:@"中评"]){
        score = @"3";
    }else if([_comment isEqualToString:@"差评"]){
        score = @"1";
    }else{
        score = @"5";
    }
    //创建一个消息对象
    if (_commentStr.length>0) {
        
    }else{
        _commentStr = @"";
    }
    NSNotification * notice = [NSNotification notificationWithName:@"goodsComment" object:nil userInfo:@{@"comments":_commentStr,@"goods_id":self.goodsID,@"rank":score}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
@end
