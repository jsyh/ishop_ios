//
//  RequestModel.m
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "RequestModel.h"
#import "AFHTTPSessionManager.h"
#import "NSString+Hashing.h"
#import "MBProgressHUD+MJ.h"
@implementation RequestModel

//-(void)startRequestInfo{
//    
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
////    __weak typeof(self) weakSelf = self;
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//    
//    [manager GET:self.path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        if([self.delegate respondsToSelector:@selector(sendMessage:)])
//        {
//            [self.delegate sendMessage:responseObject];
//        }
//        if ([responseObject[@"datas"] isKindOfClass:[NSDictionary class]]) {
//            
//            NSDictionary *responseDatas = responseObject[@"datas"];
//            
//            NSString *keyStr = [[responseDatas allKeys] firstObject];
//            
//            //如果有错误信息,处理并返回
//            if([keyStr isEqualToString:@"error"])
//            {
//                
//                NSString *errorMessage = responseDatas[@"error"];
//                
//                [MBProgressHUD showError:errorMessage];
//                
//                return ;
//            }
//        }
//
//       
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error.description);
//    }];
//    
//}
- (AFHTTPSessionManager *)manager

{
    
    if (_manager == nil) {
        
        _manager  = [AFHTTPSessionManager manager];
        
    }
    
    return _manager;
    
}
+(void)requestWithDictionary:(NSDictionary *)dict model:(NSString *)model action:(NSString *)action block:(Block)myBlock{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url1 = data[@"url"];
    

    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];

    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"json/text", @"text/json",@"application/json",@"text/javascript",nil];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",url1,model,action];
    
    [manager POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"POST-->%@,%@",responseObject,[NSThread currentThread]);
        //自动返回主线程
        //responseObject[@"msg"]
        if ([responseObject[@"datas"] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *responseDatas = responseObject[@"datas"];
            
            NSString *keyStr = [[responseDatas allKeys] firstObject];
            
            //3.如果有错误信息,处理并返回
            if([keyStr isEqualToString:@"error"])
            {
                
                NSString *errorMessage = responseDatas[@"error"];
                
                [MBProgressHUD showError:errorMessage];
                
                return ;
            }
        }

        id result = responseObject;
        myBlock(result);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.description);
        
        //登陆提示消失,timer取消
        [MBProgressHUD hideHUD];
        //提示网络错误
        [MBProgressHUD showError:@"网络错误"];
        }];
    
}
//
+(NSString *)model:(NSString *)model action:(NSString *)action{
    
    NSDate *localDate = [NSDate date]; //获取当前时间
    //转换成年月日
    NSDateFormatter *fm = [[NSDateFormatter alloc]init];
    fm.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CH"];
    fm.dateFormat = @"yyyyMMdd";
    NSString *temp = [fm stringFromDate:localDate];
    //    NSDate *now = [fm dateFromString:temp];
    //
    //    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];  //转化为UNIX时间戳
    //    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    NSString *string = [NSString stringWithFormat:@"%@%@%@99-k",model,action,temp];
    NSString *md5_str = [string MD5Hash];
    return md5_str;
}


@end
