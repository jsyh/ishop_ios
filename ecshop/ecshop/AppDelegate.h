//
//  AppDelegate.h
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WIDTH (float)(self.window.frame.size.width)
#define HEIGHT (float)(self.window.frame.size.height)
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)NSDictionary *tempDic;
@property (strong, nonatomic)NSString *userName;
-(CGRect)createFrameWithX:(CGFloat)x andY:(CGFloat)y andWidth:(CGFloat)width andHeight:(CGFloat)height;
@end

