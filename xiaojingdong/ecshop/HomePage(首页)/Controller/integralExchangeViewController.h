//
//  integralExchangeViewController.h
//  ecshop
//
//  Created by Jin on 16/5/31.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
typedef enum
{
    TopViewStateShow1, //出现
    TopViewStateHide1 //隐藏
}TopViewState1;//枚举的别名
typedef enum
{
    DownShow1,//出现
    DownHide1 //隐藏
}DownViewState1; //枚举的别名
typedef enum
{
    codeShow1,//出现
    codeHide1//隐藏
}codeState1;//枚举名字

@interface integralExchangeViewController : UIViewController

{
    CGPoint showPoint;//子视图出现时中心点的坐标
    CGPoint hidePoint;//子视图隐藏时的中心点的坐标
    CGPoint show2Point;//子视图2出现时中心点的坐标
    CGPoint hide2Point;//子视图2隐藏时的中心点的坐标
    /**
     *   底部弹出视图出现时中心点的坐标(选择商品信息)
     */
    CGPoint showDownPoint;
    /**
     *   底部弹出视图隐藏时中心点的坐标
     */
    CGPoint hideDownPoint;
    
    CGPoint showcodePoint;
    CGPoint hidecodePoint;
}
@property (nonatomic, strong) NSString * goodID;//商品id
@property (nonatomic, strong) UIView * downView;//底部视图
@property (nonatomic, strong) UIView * codeView;//二维码视图
//记录当前视图的状态
@property (nonatomic, assign) DownViewState1 state3;
@property (nonatomic, assign) TopViewState1 state;
@property (nonatomic, assign) codeState1 CState;
@property (nonatomic, strong) UILabel * numLab;
@property (nonatomic, strong) UILabel * colorLab;
@end
