//
//  sonAdvertisementView.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/10.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sonAdvertisementView : UIView<UIScrollViewDelegate>
{
    NSTimer *_timer;
}
//广告栏
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UILabel *imageNum;
@property (nonatomic) NSInteger totalNum;

- (void)setArray:(NSArray *)imgArray;

- (void)openTimer;
- (void)closeTimer;

@end
