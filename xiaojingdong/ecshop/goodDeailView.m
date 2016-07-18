//
//  goodDeailView.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/15.
//  Copyright © 2015年 jsyh. All rights reserved.
//
static float const kCollectionViewToLeftMargin                = 16;
static float const kCollectionViewToTopMargin                 = 12;
static float const kCollectionViewToRightMargin               = 16;
static float const kCollectionViewToBottomtMargin             = 10;


#import "goodDeailView.h"
#import "goodDetailViewController.h"
#import "GoodRightCell.h"
#import "RequestModel.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#import "goodsModel.h"
#import "GoodsCollectionReusableView.h"
#import "FooterCollectionReusableView.h"
#import "NSString+Extension.h"
#import "Sliderbar.h"
#import "UIColor+Hex.h"
#import "SureOrderViewController.h"
#define imageH 75
#define fontSize 12
#define HorizontalMargin 14
#define margin 8
#define kWidth [UIScreen mainScreen].bounds.size.width
#define cellHeight 28

typedef void(^ISLimitWidth)(BOOL yesORNo, id data);
@interface goodDeailView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,sendRequestInfo,UIAlertViewDelegate,UITextFieldDelegate>
{
    NSString * valueId;//传入购物车内的id
    NSMutableString * countPrice;//折扣价格
    NSString * pprice;//价格
    NSString * rrepertory;//库存
    float c;
    NSMutableArray * arrAll;//
    NSMutableDictionary *dicAll;//商品所有的可选属性
    NSMutableArray *attrNumArr;//商品属性id对应的库存
    NSString *buySum;//购买的数量
    NSString *notChange;//没有选择的属性中的第一个
   
}
@property (nonatomic, strong) NSMutableArray * colorArr;//数据源
@property (nonatomic, strong) UICollectionView * goodColl;//collecion
@property(strong,nonatomic)UIButton *sureBtn;//选择属性时的确定按钮
@property(strong,nonatomic)NSMutableDictionary *propertyDic;//放入属性
@property (strong,nonatomic)NSMutableDictionary *propertyIDDic;//放入属性id
@property(strong,nonatomic)NSMutableArray *propertyArr;//存放请求下来的属性id的对象
@property (strong,nonatomic)NSString *allProperty;//选中的属性
@property (strong,nonatomic)FooterCollectionReusableView *footerView;
@property (strong,nonatomic)GoodsCollectionReusableView *headview;
@property (nonatomic,assign)float footerViewOffset;

@property(nonatomic,strong)UITextField *buySumText;
@property(nonatomic,strong)UIButton *subBtn;
@property(nonatomic,strong)UIButton *plusBtn;

@property(nonatomic,assign)int kucunNum;//库存 用来比较是否库存不足

@end

@implementation goodDeailView
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    if (app.tempDic != nil) {
        [self netInfo];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self colorAndNumSelec];
    [self netInfo];//从接口请求的数据ui搭建
    [self Creatprice];
    [self reloadInfomation];
    _attDic=[[NSMutableDictionary alloc]init];
    _numuBer=@"1";
    _propertyDic = [NSMutableDictionary dictionary];
    _propertyIDDic = [NSMutableDictionary dictionary];
    
    
}
#pragma mark-请求数据
-(void)reloadInfomation{
     NSString *api_token = [RequestModel model:@"goods" action:@"goodsinfo"];
    NSDictionary *dict = @{@"api_token":api_token,@"goods_id":self.recevieId};
//    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"goodsinfo" block:^(id result) {
        [self sendMessage:result];
    }];
    
}
-(void)sendMessage:(id)message
{
    NSDictionary *dic=message[@"data"];
 
   
    arrAll=[[NSMutableArray alloc]init];
    dicAll = [[NSMutableDictionary alloc]init];
    _propertyArr = [NSMutableArray array];
    NSDictionary *dicGoods = dic[@"goods"];
    NSArray *arrAttribute = dicGoods[@"attribute"];

    for (NSMutableDictionary *dict in arrAttribute) {
        
        NSMutableArray *arrObejct = [[NSMutableArray alloc]init];

            NSMutableArray *arrr = dict[@"attr_key"];
           
            for (NSMutableDictionary *dictt in arrr) {
                goodsModel *goods = [[goodsModel alloc]init];
                goods.attrID = dictt[@"attr_id"];
                goods.attrValue = dictt[@"attr_value"];
                goods.attrPrice = dictt[@"attr_price"];
                goods.attrName = dictt[@"attr_name"];
                goods.goodsAttrID = dictt[@"goods_attr_id"];
                [arrObejct addObject:goods];
            }
        
        [dicAll setObject:arrObejct forKey:dict[@"attr_name"]];
        
        [arrAll addObject:dict[@"attr_name"]];
       
        
    }
    

    //存储商品属性id对应的库存
    NSArray *attrNumArray;
    attrNumArray = dicGoods[@"attr_number"];
    for (NSMutableDictionary *attrNumDic in attrNumArray) {
        goodsModel *model = [goodsModel new];
        model.inventoryNumber = attrNumDic[@"number"];
        model.inventoryArr = attrNumDic[@"goods_attr"];
        [_propertyArr addObject:model];
    }
    
    

    pprice=dic[@"goods"][@"shop_price"];
    
    rrepertory = dic[@"goods"][@"repertory"];
    _price.text= [NSString stringWithFormat:@"￥%@",pprice] ;
    _repertory.text = [NSString stringWithFormat:@"库存%@件",rrepertory];
    _kucunNum = [rrepertory intValue];
    [_iconImage setImageWithURL:dic[@"goods"][@"album"][0]];

    [_goodColl reloadData];
}
-(void)Creatprice
{
    
    _price=[[UILabel alloc]initWithFrame:CGRectMake(imageH+24, 12, imageH, 15)];
    _price.text=pprice;
    _price.font=[UIFont systemFontOfSize:15];
    _price.textColor=[UIColor colorWithHexString:@"#ff5000"];
    [self.contentView addSubview:_price];
    //关闭按钮
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kWidth - 44, 0, 42, 42);
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
//    closeBtn.backgroundColor = [UIColor blueColor];
    [closeBtn setImage:[UIImage imageNamed:@"goods_detail_close"] forState:UIControlStateNormal];
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.contentView addSubview:closeBtn];
    
    //购买颜色数量
    _colorNumLab = [[UILabel alloc]initWithFrame:CGRectMake(imageH + 24, _goodColl.frame.origin.y -26, kWidth - imageH - 24, 14)];
    _colorNumLab.font = [UIFont systemFontOfSize:14];
    _colorNumLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self.contentView addSubview:_colorNumLab];
    
    //库存
    _repertory = [[UILabel alloc]initWithFrame:CGRectMake(imageH+24 , _colorNumLab.frame.origin.y-26, kWidth - imageH - 24, 14)];
    _repertory.font = [UIFont systemFontOfSize:14];
    _repertory.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self.contentView addSubview:_repertory];
 
}
#pragma mark -- 关闭事件
-(void)closeAction{
    [self autoShowHideSlidebar];

}
//从接口请求的数据ui搭建
-(void)netInfo
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(12, 12, imageH, imageH)];
    _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconImage];

    
    UICollectionViewFlowLayout * flow=[[UICollectionViewFlowLayout alloc]init];
    //修改
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumLineSpacing = HorizontalMargin;
    
    flow.sectionInset = UIEdgeInsetsMake(HorizontalMargin, HorizontalMargin, HorizontalMargin, HorizontalMargin);
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    _goodColl=[[UICollectionView alloc]initWithFrame:CGRectMake(0, _iconImage.frame.origin.y+_iconImage.frame.size.height+12, kWidth, self.contentView.frame.size.height - imageH - 24 ) collectionViewLayout:flow];
    _goodColl.backgroundColor=[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    _goodColl.backgroundColor = [UIColor whiteColor];
    _goodColl.delegate=self;
    _goodColl.dataSource=self;
    _goodColl.allowsMultipleSelection = NO;
    
//    [self keyBoardBack];
    
    
    [self.contentView addSubview:_goodColl];
    [_goodColl registerClass:[GoodRightCell class] forCellWithReuseIdentifier:@"right"];
    [_goodColl registerClass:[GoodsCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [_goodColl registerClass:[FooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn.frame = CGRectMake(0, self.contentView.frame.size.height - 49, self.contentView.frame.size.width, 49);
    [self.sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#FF5000"];
    [self.contentView addSubview:self.sureBtn];
 

    
}
#pragma mark-collect的代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (dicAll.count == 0) {
        return 1;
    }else{
        return dicAll.count;
    }
    
}
//item的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (arrAll.count>0) {
        NSMutableArray *arr;
        
        NSString *key = arrAll[section];
        
        //    [arr addObject:dicAll[key]];
        arr = dicAll[key];
        
        return arr.count;
    }else{
        return 0;
    }
    
   
    
}
//cell
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * right=@"right";
    GoodRightCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:right forIndexPath:indexPath];
    

    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;

    
    NSMutableArray *arr;
    
    NSString *key = arrAll[indexPath.section];
    
  
    arr = dicAll[key];
    
    goodsModel *goods = arr[indexPath.row];
    cell.model = goods;
    [cell.cellBtn addTarget:self action:@selector(readCell:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_propertyDic allValues].count>0) {
        if ([[_propertyDic allValues] containsObject:cell.cellBtn.titleLabel.text]) {
            //未选中
            cell.cellBtn.backgroundColor = [UIColor colorWithHexString:@"#FF5000"];
            [cell.cellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }else{
            //选中
            cell.cellBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
            [cell.cellBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        }
    }else{
        cell.cellBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [cell.cellBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    }
 
    
    
//    [cell.cellBtn setTitle:goods.attrValue forState:UIControlStateNormal];
//    [cell.cellBtn addTarget:self action:@selector(readCell) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)readCell:(UIButton *)button{
    GoodRightCell * cell = (GoodRightCell *)button.superview.superview;
    if (_propertyDic!=nil) {
        [_propertyDic setObject:cell.cellBtn.titleLabel.text forKey:cell.attrName];
        [_propertyIDDic setObject:cell.attrID forKey:cell.attrName];
        cell.cellBtn.backgroundColor = [UIColor orangeColor];
    }
    
    _allProperty = nil;
    for (NSString *s in [_propertyDic allValues]) {
        if (_allProperty.length > 0) {
            _allProperty = [NSString stringWithFormat:@"%@,%@",_allProperty,s];
        }else{
            _allProperty = s;
        }
        
    }
    if ([[_propertyDic allValues] containsObject:cell.cellBtn.titleLabel.text]) {
        cell.cellBtn.backgroundColor = [UIColor colorWithHexString:@"#FF5000"];

        [cell.cellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      
    }else{
        cell.cellBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [cell.cellBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
      
    }
    _colorNumLab.text = _allProperty;
    
    NSMutableArray *arr;
    arr =[arrAll mutableCopy];
    
    if ([_propertyDic allKeys].count != arr.count) {
        NSLog(@"不全");
        for (NSString *s in [_propertyDic allKeys]) {
            [arr removeObject:s];
        }
        notChange = arr[0];
        _repertory.text = [NSString stringWithFormat:@"库存%@件",rrepertory];
    }else{
        NSLog(@"全了");
        notChange = nil;
        //tempArr 用来存放 属性id 去和后台比较 得出库存
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (int i = 0; i < arrAll.count; i++) {
            NSString *key = arrAll[i];
            NSString *a = _propertyIDDic[key];
            [tempArr addObject:a];
            
        }
        //库存
        NSString *tempNum = @"0";
        for (goodsModel *model in _propertyArr) {
            NSMutableArray *modelArr;
            modelArr = [model.inventoryArr mutableCopy];
            if ([self compareArrA:modelArr arrB:tempArr] ) {
                tempNum = model.inventoryNumber;
                break;
            }
        }
        _repertory.text = [NSString stringWithFormat:@"库存%@件",tempNum];
        _kucunNum = [tempNum intValue];
        NSLog(@"%@",_propertyIDDic);
    }
      [self.goodColl reloadData];
    
}
//判断两个数组包含相同的元素
-(BOOL)compareArrA:(NSMutableArray*)arrA arrB:(NSMutableArray *)arrB{
    NSMutableArray *arr1;
    arr1 = [arrA mutableCopy];
    NSMutableArray *arr2;
    arr2 = [arrB mutableCopy];
    for (int i = 0;i<arrA.count ; i++) {
        NSString *a = arr1[0];
        if ([arr2 containsObject:a]) {
            [arr2 removeObject:a];
            [arr1 removeObject:a];
        }
  
    }
    if (arr1.count == 0 && arr2.count == 0) {
        return YES;
    }else{
        return NO;
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kCollectionViewToTopMargin, kCollectionViewToLeftMargin, kCollectionViewToBottomtMargin, kCollectionViewToRightMargin);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    return CGSizeMake(60, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusable = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        _headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        if (arrAll.count>0) {
            _headview.title.text = [[NSString alloc] initWithFormat:@"%@",arrAll[indexPath.section]];
        }else{
            _headview.title.text = @"111";
        }
        
        UIView *viewLine = [[UIView alloc]init];
        if (indexPath.section == 0) {
            viewLine.frame=CGRectMake(0, 0,kWidth , 1);
        }else{
            viewLine.frame = CGRectMake(12, 0, kWidth-24, 1);
        }
        _headview.title.textColor = [UIColor colorWithHexString:@"#43464c"];
        viewLine.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [_headview addSubview:viewLine];
        
        reusable = _headview;
    }else if (kind == UICollectionElementKindSectionFooter){
        if (arrAll.count>0) {
            if (indexPath.section == arrAll.count-1) {
                _footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
                _footerViewOffset = _footerView.frame.origin.y;
                _footerView.backgroundColor = [UIColor whiteColor];
                
                
                _footerView.title.delegate = self;
                if (buySum.length>0) {
                    _footerView.title.text = buySum;
                    _buySumText.text = buySum;
                }else{
                    _buySumText.text = @"1";
                    _footerView.title.text = @"1";
                }
                
                _footerView.title.delegate = self;
                _footerView.title.keyboardType = UIKeyboardTypeNumberPad;
                [self.sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
                [_footerView.plusBtn addTarget:self action:@selector(plusActions) forControlEvents:UIControlEventTouchUpInside];
                [_footerView.subBtn addTarget:self action:@selector(subActions) forControlEvents:UIControlEventTouchUpInside ];
                buySum = _footerView.title.text;
                //画线
                UIView *viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(12, 0, kWidth-24, 1)];
                viewLine1.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
                [_footerView addSubview:viewLine1];
                
                UIView *viewLine2 = [[UIView alloc]initWithFrame:CGRectMake(12, 48, kWidth-24, 1)];
                viewLine2.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
                [_footerView addSubview:viewLine2];
                
                reusable = _footerView;
            }else{
                return nil;
            }
        }else{
            _footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
            _footerViewOffset = _footerView.frame.origin.y;
            _footerView.backgroundColor = [UIColor whiteColor];
            
            
            
            if (buySum.length>0) {
                _footerView.title.text = buySum;
                _buySumText.text = buySum;
            }else{
                _buySumText.text = @"1";
                _footerView.title.text = @"1";
            }
            
            _footerView.title.delegate = self;
            _footerView.title.keyboardType = UIKeyboardTypeNumberPad;
            [self.sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
            [_footerView.plusBtn addTarget:self action:@selector(plusActions) forControlEvents:UIControlEventTouchUpInside];
            [_footerView.subBtn addTarget:self action:@selector(subActions) forControlEvents:UIControlEventTouchUpInside ];
            buySum = _footerView.title.text;
            //画线
            UIView *viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(12, 0, kWidth-24, 1)];
            viewLine1.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
            [_footerView addSubview:viewLine1];
            
            UIView *viewLine2 = [[UIView alloc]initWithFrame:CGRectMake(12, 48, kWidth-24, 1)];
            viewLine2.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
            [_footerView addSubview:viewLine2];
            
            reusable = _footerView;
        }
        
        
    }
    return reusable;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    if ([self.type isEqualToString:@"3"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"兑换商品不可选择数量" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        _footerView.title.text = @"1";
    }else{
        buySum = textField.text;
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (arrAll.count>0) {
        float a = 76.0/1334.0;
        
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*a);
    }else{
        return CGSizeMake(0, 0);
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (arrAll.count>0) {
        if (section == arrAll.count - 1) {
            return CGSizeMake(self.view.frame.size.width, 60);
        }else{
            return CGSizeMake(0, 0);
        }
    }else{
        return CGSizeMake(self.view.frame.size.width, 60);
    }
    
    
}
#pragma mark --点击footer确认执行的事件
-(void)sureAction{
    int tempNum = [buySum intValue];
    if (tempNum<=_kucunNum) {
        NSString *propertyID ;
        for (NSString *a in [_propertyIDDic allValues]) {
            if (propertyID.length == 0) {
                propertyID = a;
            }else{
                propertyID = [NSString stringWithFormat:@"%@,%@",propertyID,a];
            }
        }
        NSDictionary *dict;
        if (_allProperty.length > 0) {
            if (notChange == nil) {
                //有属性
                dict = @{@"buySum":buySum,@"allProperty":_allProperty,@"propertyID":propertyID};
                NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"property" object:self userInfo:dict];
                
                UIApplication *appli=[UIApplication sharedApplication];
                AppDelegate *app=appli.delegate;
                NSString * receNss= app.tempDic[@"data"][@"key"];
                NSString *path1 = [NSString stringWithFormat:@"[%@]",propertyID];
                
                if ([self.type isEqualToString:@"1"]) {
                    //购物车
                    NSString *api_token = [RequestModel model:@"goods" action:@"addcart"];
                    // strr=@"0";
                    NSDictionary *dict;
                    dict= @{@"api_token":api_token,@"goods_id":self.goodID,@"key":receNss,@"num":buySum,@"attrvalue_id":path1};
                    [RequestModel requestWithDictionary:dict model:@"goods" action:@"addcart" block:^(id result) {
                        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"加入购物车成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }];
                }else if([self.type isEqualToString:@"2"]){
                    SureOrderViewController *sureVC = [SureOrderViewController new];
                    sureVC.type = @"2";
                    sureVC.goodsID = self.goodID;
                    sureVC.goodsNumber = buySum;
                    sureVC.propertyID = propertyID;
                    [self.navigationController pushViewController:sureVC animated:YES];
                }
               

            }else{
                dict = @{@"buySum":buySum,@"allProperty":_allProperty,@"notChange":notChange,@"propertyID":propertyID};
                NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"property" object:self userInfo:dict];
                
            }
            
        }else{
        //无属性
            
            dict = @{@"buySum":buySum};
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"property" object:self userInfo:dict];
            if (dicAll.count>0) {
                
            }else{
                //没有属性则直接加入购物车
                UIApplication *appli=[UIApplication sharedApplication];
                AppDelegate *app=appli.delegate;
                NSString * receNss= app.tempDic[@"data"][@"key"];
                if ([self.type isEqualToString:@"1"]) {
                    //购物车
                    NSString *api_token = [RequestModel model:@"goods" action:@"addcart"];
                    // strr=@"0";
                    NSDictionary *dict;
                    dict= @{@"api_token":api_token,@"goods_id":self.goodID,@"key":receNss,@"num":buySum,@"attrvalue_id":@""};
                    [RequestModel requestWithDictionary:dict model:@"goods" action:@"addcart" block:^(id result) {
                        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"加入购物车成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }];
                }else if([self.type isEqualToString:@"2"]){
                    //直接购买
                    SureOrderViewController *sureVC = [SureOrderViewController new];
                    sureVC.type = @"2";
                    sureVC.goodsID = self.goodID;
                    sureVC.goodsNumber = buySum;
                    [self.navigationController pushViewController:sureVC animated:YES];
                }

            }
           

            
        }
        
        [self autoShowHideSlidebar];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"库存不足" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}
-(void)subActions{
    if ([self.type isEqualToString:@"3"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"兑换商品不可选择数量" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        buySum = _footerView.title.text;
        int a = [buySum intValue];
        if (a <= 1) {
            _footerView.title.text = @"1";
            _buySumText.text = @"1";
        }else{
            a--;
            buySum = [NSString stringWithFormat:@"%d",a];
            _buySumText.text = buySum;
            _footerView.title.text = buySum;
        }
    }
    
    
}
-(void)plusActions{
    if ([self.type isEqualToString:@"3"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"兑换商品不可选择数量" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        buySum = _footerView.title.text;
        int a = [buySum intValue];
        if (a <= 1) {
            _buySumText.text = @"1";
            _footerView.title.text = @"1";
        }
        a++;
        buySum = [NSString stringWithFormat:@"%d",a];
        _buySumText.text = buySum;
        _footerView.title.text = buySum;
    }
   
}
#pragma mark-collection点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self changeSelectStateWithIndexPath:indexPath];
    if (_colorArr.count!=0) {
        _attrLab=[[UILabel alloc]init];
        _attrLab.text=_colorArr[indexPath.item][@"attr_value_name"];
        valueId=_colorArr[indexPath.item][@"attr_value_id"];
        countPrice=[NSMutableString stringWithFormat:@"%@",_colorArr[indexPath.item][@"attr_value_price"]];   ;
        //选择的属性不同价格不同
        if ([countPrice isEqualToString:@"0"]) {
            c=[pprice  floatValue];
            
        }//选择的属性不同价格增减
        else if([countPrice rangeOfString:@"-"].location !=NSNotFound)
        {
            [countPrice deleteCharactersInRange:NSMakeRange(0, 1)] ;
            float a= [ pprice floatValue];
            float d=[ countPrice floatValue];
            c=a-d;
        }
        else
        {
            float a= [ pprice floatValue];
            float b=  [countPrice floatValue];
            c=a+b;
        }
        _price.text=[NSString stringWithFormat:@"%.1f",c];
    }
    
}
/**
 * Cell根据Cell选中状态来改变Cell上Button按钮的状态
 */
- (void) changeSelectStateWithIndexPath: (NSIndexPath *) indexPath{
    //获取当前变化的Cell
    GoodRightCell *currentSelecteCell = (GoodRightCell *)[self.goodColl cellForItemAtIndexPath:indexPath];
    NSMutableArray *arr;
    arr = dicAll[arrAll[indexPath.section]];
    goodsModel *goods;
    goods = arr[indexPath.row];
//    currentSelecteCell.cellBtn.selected = currentSelecteCell.selected;
    
    if (currentSelecteCell.selected == YES){
        NSLog(@"第%ld个Section上第%ld个Cell被选中了",(long)indexPath.section ,(long)indexPath.row);
        NSLog(@"%@",goods.attrValue);
//        goods.modelSelected = YES;
//        [self.goodColl reloadData];
        return;
    }
    
    if (currentSelecteCell.selected == NO){
//        goods.modelSelected = NO;
//        [self.goodColl reloadData];
        //NSLog(@"第%ld个Section上第%ld个Cell取消选中",indexPath.section ,indexPath.row);
    }
    
}
#pragma mark-数量增减
-(void)btnadd:(id)sender
{
    NSInteger i;
    UITextField * field=(UITextField *)[self.contentView viewWithTag:1314];
    UIButton *btn=(UIButton *)sender;
    if (btn.tag==1111) {
        if ([field.text isEqualToString:@"0"]) {
            field.text=@"0";
            i=0;
        }else{
            i= [field.text integerValue];
            i--;
        }
    }else if(btn.tag==1112){
        i=[field.text integerValue];
        i++;
    }
    _numuBer=[NSString stringWithFormat:@"%ld",(long)i];
    field.text=_numuBer;
    if(_colorArr.count==0){
        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
        NSMutableDictionary *mydic=[[NSMutableDictionary alloc]init];
        [mydic setObject:[NSString stringWithFormat:@"%@",_numuBer]forKey:@"myNum"];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:mydic,@"mycode", nil];
        NSNotification *noficollect=[[NSNotification alloc]initWithName:@"collect" object:nil userInfo:dict];
        [nc postNotification:noficollect];
    }
    else if (_colorArr.count!=0)
    {
        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
        NSMutableDictionary *mydic=[[NSMutableDictionary alloc]init];
        [mydic setObject:[NSString stringWithFormat:@"%@",_attrLab.text] forKey:@"myColor"];//可能为空
        [mydic setObject:[NSString stringWithFormat:@"%@",_numuBer]forKey:@"myNum"];
        [mydic setObject:[NSString stringWithFormat:@"%@",valueId] forKey:@"myId"];//可能为空
        [mydic setObject:[NSString stringWithFormat:@"%@",_price.text] forKey:@"myPrice"];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:mydic,@"mycode", nil];
        NSNotification *noficollect=[[NSNotification alloc]initWithName:@"collect" object:nil userInfo:dict];
        [nc postNotification:noficollect];
        
    }
}

-(void)colorAndNumSelec
{
    //设置商品编号和￥符号
    NSArray *arr1=@[@"￥",@"商品编号:"];
    for (int i=0; i<2; i++) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(imageH+10, 64+i*30, 20+i*35, 20-i*10)];
        lab.text=arr1[i];
        lab.font=[UIFont systemFontOfSize:15-i*3];
        if (i==0) {
            lab.textColor=[UIColor redColor];
        }else
            lab.textColor=[UIColor blackColor];
//        [self.contentView addSubview:lab];
    }
   
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField *textField = (id)[self.view viewWithTag:1314];
    //放弃第一响应
    [textField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (float)collectionCellWidthText:(NSString *)text content:(NSDictionary *)content key:(NSString *)key{

    NSString *picture = text;
    CGSize maxSize = CGSizeMake((self.goodColl.frame.size.width - HorizontalMargin*2 - margin*2), MAXFLOAT);
    CGSize realSize = [[NSString alloc]sizeWithText:picture font:[UIFont systemFontOfSize:fontSize]maxSize:maxSize];
    
    return realSize.width;
}

- (float)cellLimitWidth:(float)cellWidth
            limitMargin:(CGFloat)limitMargin
           isLimitWidth:(ISLimitWidth)isLimitWidth {
    float limitWidth = (CGRectGetWidth(self.goodColl.frame) - kCollectionViewToLeftMargin - kCollectionViewToRightMargin - limitMargin);
    if (cellWidth >= limitWidth) {
        cellWidth = limitWidth;
        isLimitWidth ? isLimitWidth(YES, @(cellWidth)) : nil;
        return cellWidth;
    }
    isLimitWidth ? isLimitWidth(NO, @(cellWidth)) : nil;
    return cellWidth;
}




@end
