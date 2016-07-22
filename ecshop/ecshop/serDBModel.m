//
//  serDBModel.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/1.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "serDBModel.h"
#import "FMDatabase.h"
#import "shangpinModel.h"
@implementation serDBModel
{
    FMDatabase *fmdb;
}
+(serDBModel*)shareDBModel
{
    static serDBModel *dbModel=nil;
    if (dbModel==nil) {
        dbModel=[[serDBModel alloc]init];
    }
    return dbModel;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/SHANGPINDB.db"];
        fmdb=[[FMDatabase alloc]initWithPath:path];
        BOOL isOpen=[fmdb open];
        if (isOpen) {
            NSLog(@"数据库打开成功");
            NSString *sql=@"create table if not exists ShangpinTB(titleName varchar(256))";
            BOOL isSuccess=[fmdb executeUpdate:sql];
            if (isSuccess) {
                NSLog(@"表格创建成功");
            }else{
                NSLog(@"表格创建失败%@",fmdb.lastErrorMessage);
            }
        }else{
            NSLog(@"数据库打开失败%@",fmdb.lastErrorMessage);
        }
    }
    return self;
}
-(void)insertInfoDBModelWithName:(NSString *)titleName
{
        NSString *sql=@"insert into ShangpinTB(titleName) values (?)";
        BOOL isSuccess=[fmdb executeUpdate:sql,titleName];
        if (isSuccess) {
            NSLog(@"数据库插入成功");
        }else{
            NSLog(@"数据库插入失败%@",fmdb.lastErrorMessage);
        }
}
-(BOOL)isExistAppWithId:(NSString *)titleName{
    
    NSString *sql=@"select * from ShangpinTB where titilName = ?";
    FMResultSet *result=[fmdb executeQuery:sql,titleName];
    if ([result next]) {
        NSLog(@"查找成功");
        return YES;
    }else{
        return NO;
    }
}
-(void)deleteAll{
    NSString *sql=@"delete from ShangpinTB";
    BOOL isSuccess=[fmdb executeUpdate:sql];
    if (isSuccess) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}
-(void)deleteInfo:(NSString *)titleName{
    NSString *sql=@"delete from ShangpinTB where titleName = ?";
    BOOL isSuccess=[fmdb executeUpdate:sql,titleName];
    if (isSuccess) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败%@",fmdb.lastErrorMessage);
    }
}
-(NSMutableArray *)selectInfo{
    NSString *sql=@"select * from ShangpinTB";
    FMResultSet *result=[fmdb executeQuery:sql];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    while ([result next]) {
        shangpinModel *shangpin=[[shangpinModel alloc]init];
        shangpin.titleName=[result stringForColumn:@"titleName"];
        [array addObject:shangpin];
    }
    return array;
}
@end
