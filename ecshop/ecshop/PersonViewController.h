//
//  PersonViewController.h
//  ecshop
//
//  Created by Jin on 16/1/19.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnBlock)(NSString *showText);
@interface PersonViewController : UIViewController
@property(nonatomic,copy)ReturnBlock returnTextBlock;
-(void)returnText:(ReturnBlock)block;
@end
