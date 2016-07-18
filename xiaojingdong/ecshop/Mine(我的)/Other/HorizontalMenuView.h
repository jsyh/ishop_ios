//
//  HorizontalMenuView.h
//  test222
//
//  Created by Jin on 16/5/13.
//  Copyright © 2016年 yt. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  自定义协议
 */
@protocol HorizontalMenuProtocol <NSObject>

@optional//可选方法
@required//必须实现的
-(void)getTag:(NSInteger)tag;//获取当前被选中下标值

@end
@interface HorizontalMenuView : UIView
{
    NSArray *_menuArray; //获取到菜单名数组
}
@property(nonatomic,assign)NSUInteger index;

-(void)setNameWithArray:(NSArray *)menuArray;//设置菜单名方法

//协议代理
@property(nonatomic,assign)id<HorizontalMenuProtocol>myDelegate;
@end
