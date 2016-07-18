//
//  ShopScoreTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/5/12.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopScoreTableViewCell : UITableViewCell
@property(nonatomic,strong)NSMutableArray *descrebeStar;
@property(nonatomic,strong)NSMutableArray *speedStar;
@property(nonatomic,strong)NSMutableArray *serviceStar;
@property(nonatomic,strong)UIView *descrebeView;
@property(nonatomic,strong)NSString *descrebeStr;
@property(nonatomic,strong)UIView *speedView;
@property(nonatomic,strong)NSString *speedStr;
@property(nonatomic,strong)UIView *serviceView;
@property(nonatomic,strong)NSString *serviceStr;
@end
