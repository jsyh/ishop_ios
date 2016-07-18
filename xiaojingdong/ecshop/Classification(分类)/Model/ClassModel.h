//
//  ClassModel.h
//  ecshop
//
//  Created by Jin on 16/4/15.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject
@property(nonatomic,strong)NSString *className;
@property(nonatomic,strong)NSString *classID;
@property(nonatomic,strong)ClassModel *model;
@end
