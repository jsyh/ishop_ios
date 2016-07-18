//
//  GoodsCarTableViewCell.m
//  ecshop
//
//  Created by Jin on 16/4/28.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "GoodsCarTableViewCell.h"
#import "UIColor+Hex.h"
#import "RequestModel.h"
#import "AppDelegate.h"
@implementation GoodsCarTableViewCell

- (void)awakeFromNib {
    self.numLab.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setImage:(BOOL)checked{
    if (checked) {
        [self.checkBtn setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
    }else{
        [self.checkBtn setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
    }
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField{
   //ssaf
    //faf
    NSString *a = textField.text;
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"goods" action:@"charnum"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"rec_id":self.recID,@"num":a};
  
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"charnum" block:^(id result) {
       
   
        
    }];
}
@end
