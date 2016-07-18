//
//  Sliderbar.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/4.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "Sliderbar.h"

#define duration 0.3
#define Height [UIScreen mainScreen].bounds.size.height
#define kSliderbarHeight (float)(Height*2)/3
@interface Sliderbar ()<UIGestureRecognizerDelegate>
{
    CGPoint startTouchPoint;//手指按下的坐标
    CGFloat startContentOriginX;//移动前的窗口位置
    CGFloat startContentOriginY;
    BOOL isMoving;
}
@property(nonatomic,retain)UIView *blurView;
@end

@implementation Sliderbar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled=YES;
    self.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    self.blurView=[[UIView alloc]initWithFrame:self.view.bounds];
    self.blurView.userInteractionEnabled=NO;
    [self.view addSubview:self.blurView];
    self.blurView.alpha=0;
    UITapGestureRecognizer *recongnizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetected:)];
    recongnizer.delegate=self;
    [recongnizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recongnizer];
//    CGRect rect=CGRectMake(self.view.frame.size.width, 0,kSliderbarWidth , self.view.frame.size.height);
    CGRect rect = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kSliderbarHeight);
    self.contentView=[[UIView alloc]initWithFrame:rect];
    [self.view addSubview:self.contentView];
    self.view.hidden=YES;
}
-(BOOL)isSlidebarShown
{
    return self.contentView.frame.origin.y<self.view.frame.size.height ?YES :NO;
}
-(void)showHideSlidebar
{
//    CGFloat halfHeight = self.view.frame.size.height/2;
    CGFloat halfHeight = [UIScreen mainScreen].bounds.size.height/2;
    if (self.contentView.frame.origin.y == halfHeight) {
        NSLog(@"开始时在一点");
        [self beginShowSlidebar];
    }
    [self autoShowHideSlidebar];
}
-(void)slideToLeftOccured
{
    NSLog(@"触发事件,需要时在子类中调用");
}
-(void)sliderbarDidShown
{
    NSLog(@"已经出现,可以使用");
    self.contentView.backgroundColor=[UIColor  colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
}
-(void)autoShowHideSlidebar
{
    if (!self.isSlidebarShown) {
        NSLog(@"自动弹出");
        self.view.hidden=NO;
        [UIView animateWithDuration:duration animations:^{
//             [self setSidebarOriginX:self.view.frame.size.width-kSliderbarWidth];
            [self setSidebarOriginY:self.view.frame.size.height - kSliderbarHeight];
        } completion:^(BOOL finished) {
            isMoving = NO;
            [self sliderbarDidShown];
        }];
    }else
    {
        NSLog(@"自动缩回");
        [UIView animateWithDuration:duration animations:^{
//             [self setSidebarOriginX:self.view.frame.size.width];
            [self setSidebarOriginY:self.view.frame.size.height];
        } completion:^(BOOL finished) {
            isMoving = NO;
            self.view.hidden=YES;
        }];
    }
}
-(void)beginShowSlidebar
{
    NSLog(@"开始出现抽屉效果");
    CGFloat halfHeight = self.contentView.frame.origin.y;
    startContentOriginY= halfHeight;
}
#pragma mark-响应手势
-(void)tapDetected:(UITapGestureRecognizer *)recognizer
{
    [self autoShowHideSlidebar];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point=[touch locationInView:self.view];
    if (point.y>self.view.frame.size.height-kSliderbarHeight) {
        return NO;
    }
    return YES;
}
-(void)panDetectedForBack:(UIPanGestureRecognizer *)reconginzer
{
    NSLog(@"**slider Detected");
    CGPoint touchPoint=[reconginzer locationInView:self.view];
//    CGFloat offsetX=touchPoint.x-startTouchPoint.x;
    CGFloat offsetY = touchPoint.y - startTouchPoint.y;
    if (reconginzer.state==UIGestureRecognizerStateBegan) {
        NSLog(@"slider Begin point=%f",touchPoint.y);
        startTouchPoint=touchPoint;
    }else if (reconginzer.state==UIGestureRecognizerStateEnded){
        NSLog(@"slider End");
        if (offsetY>20) {
            [self slideToLeftOccured];
        }
        return;
    }
}
-(void)panGesture:(UIPanGestureRecognizer *)recoginzer
{
    NSLog(@" pan Detected");
    
    CGPoint touchPoint=[recoginzer locationInView:self.view];
    CGFloat offsetY = touchPoint.y - startTouchPoint.y;
    if (recoginzer.state==UIGestureRecognizerStateBegan) {
        NSLog(@"pan Begin Point=%f",touchPoint.y);
        isMoving =YES;
        startTouchPoint =touchPoint;
        self.view.hidden=NO;
        [self beginShowSlidebar];
    }else if (recoginzer.state==UIGestureRecognizerStateEnded){
        NSLog(@"pan end");
        if (offsetY<0||((int)startContentOriginY==(self.view.frame.size.height-kSliderbarHeight)&& offsetY>0 && offsetY>20)) {
            [self slideToLeftOccured];
            self.view.hidden=NO;
            [UIView animateWithDuration:0.5 animations:^{
                 [self setSidebarOriginY:self.view.frame.size.height-kSliderbarHeight];
            } completion:^(BOOL finished) {
                isMoving=NO;
                [self sliderbarDidShown];
            }];
        }
        else
        {
            NSLog(@"***隐藏到底");
            [UIView animateWithDuration:0.5 animations:^{
                 [self setSidebarOriginY:self.view.frame.size.height];            } completion:^(BOOL finished) {
                isMoving=NO;
                self.view.hidden=YES;
            }];
        }
        return;
    }else if (recoginzer.state==UIGestureRecognizerStateCancelled)
    {
        NSLog(@"pan cancelled");
        [UIView animateWithDuration:0.5 animations:^{
           [self setSidebarOriginY:self.view.frame.size.height];
        } completion:^(BOOL finished) {
            isMoving=NO;
            self.view.hidden=YES;
        }];
        return;
    }
    if (isMoving) {
        [self setSidebarOriginY:offsetY];
        NSLog(@"moving touch=%f,offset=%f",touchPoint.y,offsetY);
    }
}
#pragma mark 侧栏出来
-(void)setSidebarOriginY:(CGFloat)y{
    CGRect rect = self.contentView.frame;
    rect.origin.y = y;
    [self.contentView setFrame:rect];
    [self setBlurViewAlpha];
}
-(void)setSidebarOriginX:(CGFloat)x
{
    CGRect rect=self.contentView.frame;
    rect.origin.x=x;
    [self.contentView setFrame:rect];
    [self setBlurViewAlpha];
}
-(void)setSlidebarOffset:(CGFloat)offset
{
    NSLog(@"开始滑");
     CGRect rect = self.contentView.frame;
    if (offset >=0) { // 上滑
        // 如果不在最下
        if (rect.origin.y>self.view.frame.size.height-kSliderbarHeight) {
            rect.origin.y = startContentOriginY - offset; // 直接向上偏移这么多
            if (rect.origin.y <self.view.frame.size.height-kSliderbarHeight) {
                rect.origin.y = self.view.frame.size.height-kSliderbarHeight;
            }
        }
    } else { // 下滑
        // 如果不在最下
        if (rect.origin.y <self.view.frame.size.height) {
            rect.origin.y = startContentOriginY - offset;
            if (rect.origin.y < self.view.frame.size.height ) {
                rect.origin.y = self.view.frame.size.height;
            }
        }
    }
    [self.contentView setFrame:rect];
    [self setBlurViewAlpha];
}
//设置渐变颜色
-(void)setBlurViewAlpha
{
    CGRect rect=self.contentView.frame;
//    float precent=(kSliderbarWidth+rect.origin.x)/kSliderbarWidth;
    float precent = (kSliderbarHeight +rect.origin.y)/kSliderbarHeight;
    self.blurView.alpha=precent=0.2+(1-0.2)*(precent);
    NSLog(@"blur alpha=%f",precent);
//    precent=0.7+(0.1)*(precent);
    //self.contentView.backgroundColor=[UIColor whiteColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
