//
//  CommentModel.m
//  ecshop
//
//  Created by Jin on 16/4/1.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
-(void)setModel:(CommentModel *)model{
    self.userID = model.userID;
    self.orderID = model.orderID;
    self.contentName = model.contentName;
    self.content = model.content;
    self.rank = model.rank;
    self.time = model.time;
    self.gmjl = model.gmjl;
    self.gmsl = model.gmsl;
    self.userRank = model.userRank;
    self.good = model.good;
    self.bad = model.bad;
    self.medium = model.medium;
}
@end
