//
//  PopoveView.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/4.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoveView : UIView
-(id)initWithPoint:(CGPoint)point titles:(NSArray*)titles;
-(void)show;//出现
-(void)dismiss;//消失
-(void)dismiss:(BOOL)animated;//消失动画
@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index); //选中的按钮
@end
