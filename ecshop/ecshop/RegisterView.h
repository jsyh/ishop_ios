//
//  RegisterView.h
//  ecshop
//
//  Created by Jin on 15/12/3.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView
@property(nonatomic,strong)NSString *temp;
@property (nonatomic,strong)UITextField *txtField;
+(RegisterView *)lab:(NSString *)lab textFiled:(NSString *)file frameX:(CGFloat)frameX frameY:(CGFloat)frameY;
@end
