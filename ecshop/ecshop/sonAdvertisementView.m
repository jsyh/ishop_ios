//
//  sonAdvertisementView.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/10.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "sonAdvertisementView.h"
@implementation sonAdvertisementView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;//设置代理UIscrollViewDelegate
        _scrollView.showsVerticalScrollIndicator = NO;//是否显示竖向滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;//是否显示横向滚动条
        _scrollView.pagingEnabled = YES;//是否设置分页
        [self addSubview:_scrollView];
        /*
         ***容器，装载
         */
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-20, CGRectGetWidth(self.frame), 20)];
        containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:containerView];
        UIView *alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame))];
        alphaView.backgroundColor = [UIColor grayColor];
        alphaView.alpha = 0.7;
        [containerView addSubview:alphaView];
        //分页控制
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(containerView.frame)-20, 20)];
        _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//貌似不起作用呢
        _pageControl.currentPage = 0; //初始页码为0
        //    _pageControl.backgroundColor  = [UIColor greenColor];
        [containerView addSubview:_pageControl];
        /*
         ***配置定时器，自动滚动广告栏
         */
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
    }
    return self;
}
//------------------------------------------------------------------------------------
-(void)timerAction:(NSTimer *)timer{
    if (_totalNum>1) {
        CGPoint newOffset = _scrollView.contentOffset;
        newOffset.x = newOffset.x + CGRectGetWidth(_scrollView.frame);
        //    NSLog(@"newOffset.x = %f",newOffset.x);
        if (newOffset.x > (CGRectGetWidth(_scrollView.frame) * (_totalNum-1))) {
            newOffset.x = 0 ;
        }
        int index = newOffset.x / CGRectGetWidth(_scrollView.frame);   //当前是第几个视图
        newOffset.x = index * CGRectGetWidth(_scrollView.frame);
        [_scrollView setContentOffset:newOffset animated:YES];
    }else{
        [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
    }
}

#pragma mark- PageControl绑定ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{//滚动就执行（会很多次）
    if ([scrollView isMemberOfClass:[UITableView class]]) {
        
    }else {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;   //当前是第几个视图
        _pageControl.currentPage = index;
        for (UIView *view in scrollView.subviews) {
            if(view.tag == index){
                
            }else{
                
            }
        }
    }
    //    NSLog(@"string%f",scrollView.contentOffset.x);
}
- (void)setArray:(NSArray *)imgArray{
    _totalNum = [imgArray count];
    if (_totalNum>0) {
        for (int i = 0; i<_totalNum; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.image = [UIImage imageNamed:imgArray[i]];
            //img.backgroundColor = imgArray[i];
            [img setTag:i];
            [_scrollView addSubview:img];
        }
        _pageControl.numberOfPages = _totalNum; //设置页数 //滚动范围 600=300*2，分2页
        CGRect frame;
        frame = _pageControl.frame;
        frame.size.width = 15*_totalNum;
        _pageControl.frame = frame;
    }else{
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        //💗可以放置一张等待加载时的图片
        img.userInteractionEnabled = YES;
        [_scrollView addSubview:img];
       
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame)*_totalNum,CGRectGetHeight(_scrollView.frame));//滚动范围 600=300*2，分2页
}
- (void)openTimer{
    [_timer setFireDate:[NSDate distantPast]];//开启定时器
}
- (void)closeTimer{
    [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
}
@end
