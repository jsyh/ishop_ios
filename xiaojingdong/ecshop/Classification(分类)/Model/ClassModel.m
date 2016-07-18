//
//  ClassModel.m
//  ecshop
//
//  Created by Jin on 16/4/15.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel
-(void)setModel:(ClassModel *)model{
    self.className = model.className;
    self.classID = model.classID;
}
@end
