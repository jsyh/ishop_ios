//
//  RequestModel.h
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
typedef void(^Block)(id result);

@protocol sendRequestInfo <NSObject>
-(void)sendMessage:(id)message;
@end
@interface RequestModel : NSObject
@property (nonatomic,strong) NSString * path;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,weak)  id<sendRequestInfo> delegate;
//-(void)startRequestInfo;
//时间戳
+(NSString *)model:(NSString *)model action:(NSString *)action;
+(void)requestWithDictionary:(NSDictionary *)dict model:(NSString *)model action:(NSString *)action block:(Block)myBlock;
@end
