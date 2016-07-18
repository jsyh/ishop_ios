//
//  SelectView.h
//  ecshop
//
//  Created by Jin on 16/4/14.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectView : UIView
@property(nonatomic,strong)NSString *myType;
@property(nonatomic,strong)NSString *keyword;
@property(nonatomic,strong)NSString *classifyID;
@property(nonatomic,strong)NSString *brandID;
-(void)reloadInfoRequest;
@end
