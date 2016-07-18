//
//  CareShopTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/4/27.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CareShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopLogo;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIImageView *shopRank;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

@end
