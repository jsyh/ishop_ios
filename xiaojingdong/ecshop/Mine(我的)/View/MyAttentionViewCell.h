//
//  MyAttentionViewCell.h
//  ecshop
//
//  Created by Jin on 15/12/31.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shangpinModel.h"
@interface MyAttentionViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong)shangpinModel *model;
@end
