//
//  HorizontalMenuView.m
//  test222
//
//  Created by Jin on 16/5/13.
//  Copyright © 2016年 yt. All rights reserved.
//

#import "HorizontalMenuView.h"
#import "UIColor+Hex.h"
@implementation HorizontalMenuView
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//    }
//    return self;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setNameWithArray:(NSArray *)menuArray{
    _menuArray = menuArray;
    
    CGFloat SPACE = (self.frame.size.width)/[_menuArray count];
    for (int i = 0; i < [menuArray count]; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SPACE*i, 0, SPACE, self.frame.size.height);
        
        btn.tag = i;
        if(btn.tag == _index){
            btn.enabled = NO;
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[menuArray objectAtIndex:i]];
        [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#43464c"]} range:NSMakeRange(0, [str length])];
        [btn setAttributedTitle:str forState:UIControlStateNormal];
        
        NSMutableAttributedString *selStr = [[NSMutableAttributedString alloc]initWithString:[menuArray objectAtIndex:i]];
        [selStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ff5000"]} range:NSMakeRange(0, [selStr length])];
        
        [btn setAttributedTitle:selStr forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        
    }
    //底部划线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-2.5, self.frame.size.width, 1.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [self addSubview:line];
    
    //标识当选被选中下划线
    UIView *markLine = [[UIView alloc]initWithFrame:CGRectMake(SPACE*_index, self.frame.size.height-4, SPACE+1, 2)];
    markLine.tag = 999;
    markLine.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
    [self addSubview:markLine];
}
#pragma mark - 菜单按钮点击事件
-(void)btnClick:(UIButton *)sender{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            if (subBtn.tag == sender.tag) {
                [subBtn setEnabled:NO];
                
            }else{
                [subBtn setEnabled:YES];
            }
        }
    }
    //计算每个按钮间隔
    CGFloat SPACE = (self.frame.size.width)/[_menuArray count];
    UIView *markView = [self viewWithTag:999];
    [UIView animateWithDuration:0.2f animations:^{
        CGRect markFrame = markView.frame;
        markFrame.origin.x = sender.tag*SPACE;
        markView.frame = markFrame;
    }];
    if ([self.myDelegate respondsToSelector:@selector(getTag:)]) {
        [self.myDelegate getTag:sender.tag];
    }
}
@end
