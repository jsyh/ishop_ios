//
//  GoodsCarTableViewCell.h
//  ecshop
//
//  Created by Jin on 16/4/28.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCarTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numLab;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsArrtLab;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (nonatomic,strong)NSString *recID;//购物车列表唯一标识
@property (nonatomic,assign)BOOL checked;

-(void)setImage:(BOOL)checked;
@end
