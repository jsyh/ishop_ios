//
//  serDBModel.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/1.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface serDBModel : NSObject
+(serDBModel*)shareDBModel;
-(void)insertInfoDBModelWithName:(NSString*)titleName;
-(BOOL)isExistAppWithId:(NSString *)titleName;
-(void)deleteInfo:(NSString *)titleName;
-(NSMutableArray *)selectInfo;
//删除所有数据
-(void)deleteAll;
@end
