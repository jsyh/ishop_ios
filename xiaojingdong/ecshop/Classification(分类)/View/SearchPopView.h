//
//  SearchPopView.h
//  ecshop
//
//  Created by Jin on 16/4/11.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPopView : UIView
-(id)initWithPoint:(CGPoint)point titles:(NSArray*)titles;
-(void)show;//出现
-(void)dismiss;//消失
-(void)dismiss:(BOOL)animated;//消失动画
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) void (^selectRowAtIndex)(NSInteger index); //选中的按钮
@end
