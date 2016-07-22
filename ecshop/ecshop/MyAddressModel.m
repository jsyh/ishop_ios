//
//  MyAddressModel.m
//  ecshop
//
//  Created by Jin on 15/12/22.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "MyAddressModel.h"

@implementation MyAddressModel
-(void)setModel:(MyAddressModel *)model{
    self.region_id = model.region_id;
    self.region_name = model.region_name;
}
@end
