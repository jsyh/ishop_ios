//
//  GoodRightCell.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/31.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsModel.h"
@interface GoodRightCell : UICollectionViewCell
@property (nonatomic,strong)UIButton *cellBtn;
@property (nonatomic,strong)goodsModel *model;
@property (nonatomic,strong)NSString *attrName;
@property (nonatomic,strong)NSString *attrPrice;//选择商品后的价格
@property (nonatomic,strong)NSString *attrID;//选择商品后的id
@property (nonatomic,strong)NSString *goodsAttrID;
@property (nonatomic,strong)NSMutableDictionary *dic;
@end
