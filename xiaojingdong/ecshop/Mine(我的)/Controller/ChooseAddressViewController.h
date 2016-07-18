//
//  ChooseAddressViewController.h
//  ecshop
//
//  Created by Jin on 15/12/22.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock)(NSString *province,NSString *city,NSString *area,NSString *proId,NSString *cityId,NSString *areaId);
@interface ChooseAddressViewController : UIViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end
