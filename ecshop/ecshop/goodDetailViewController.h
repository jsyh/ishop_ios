//
//  goodDetailViewController.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/11.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
typedef enum
{
    TopViewStateShow, //出现
    TopViewStateHide //隐藏
}TopViewState;//枚举的别名
typedef enum
{
    DownShow,//出现
    DownHide //隐藏
}DownViewState; //枚举的别名
typedef enum
{
    codeShow,//出现
    codeHide//隐藏
}codeState;//枚举名字
@interface goodDetailViewController : UIViewController
{
    CGPoint showPoint;//子视图出现时中心点的坐标
    CGPoint hidePoint;//子视图隐藏时的中心点的坐标
    CGPoint show2Point;//子视图2出现时中心点的坐标
    CGPoint hide2Point;//子视图2隐藏时的中心点的坐标
    CGPoint showcodePoint;
    CGPoint hidecodePoint;
}
@property (nonatomic, copy) NSString * goodID;//商品id
@property (nonatomic, strong) UIView * topView;//顶端视图
@property (nonatomic, strong) UIView * downView;//底部视图
@property (nonatomic, strong) UIView * codeView;//二维码视图
//记录当前视图的状态
@property (nonatomic, assign) DownViewState state3;
@property (nonatomic, assign) TopViewState state;
@property (nonatomic, assign) codeState CState;
@property (nonatomic, strong) UILabel * numLab;
@property (nonatomic, strong) UILabel * colorLab;
@end
