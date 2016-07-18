//
//  CommentModel.h
//  ecshop
//
//  Created by Jin on 16/4/1.
//  Copyright © 2016年 jsyh. All rights reserved.
//评论model

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
/**
 *  userID          用户id
 *  orderID         商品id
 *  contentName     用户名称
 *  content         评论内容
 *  rank            评价等级
 *  time            评论时间
 *  gmjl            购买记录
 *  gmsl            购买数量
 *  userRank        用户等级
 *  good            好评数
 *  bad             差评数
 *  medium          中评数
 */
@property(nonatomic,strong)NSString *userID;
@property(nonatomic,strong)NSString *orderID;
@property(nonatomic,strong)NSString *contentName;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *rank;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *gmjl;
@property(nonatomic,strong)NSString *gmsl;
@property(nonatomic,strong)NSString *userRank;
@property(nonatomic,strong)NSString *good;
@property(nonatomic,strong)NSString *bad;
@property(nonatomic,strong)NSString *medium;
@property(nonatomic,strong)CommentModel *model;

//我的评价列表用

@property(nonatomic,strong)NSString *goodsName;     //商品信息
@property(nonatomic,strong)NSString *arrt;          //商品属性
@property(nonatomic,strong)NSString *userName;      //用户名
@property(nonatomic,strong)NSString *goodsImage;    //商品图片
@end
