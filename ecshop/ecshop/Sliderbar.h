//
//  Sliderbar.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/4.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSliderbarWidth 250
@interface Sliderbar : UIViewController
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL isSlidebarShown;
-(void)panDetectedForBack:(UIPanGestureRecognizer *)reconginzer;
-(void)panGesture:(UIPanGestureRecognizer *)recoginzer;
-(void)showHideSlidebar;
-(void)sliderbarDidShown;
-(void)slideToLeftOccured;
@end
