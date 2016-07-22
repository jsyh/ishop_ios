//
//  goodDeailView.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/15.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "goodDeailView.h"
#import "goodDetailViewController.h"
#import "GoodRightCell.h"
#import "RequestModel.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#define imageH 100
@interface goodDeailView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,sendRequestInfo,UIAlertViewDelegate>
{
    NSString * valueId;//传入购物车内的id
    NSMutableString * countPrice;//折扣价格
    NSString * pprice;//价格
    float c;
    NSMutableArray * arrar;
}
@property (nonatomic, strong) NSMutableArray * colorArr;//数据源
@property (nonatomic, strong) UICollectionView * goodColl;//collecion
@end

@implementation goodDeailView
-(void)viewWillAppear:(BOOL)animated{
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
    arrar=[[NSMutableArray alloc]init];
    arrar =dic[@"attribute"];//如果没有颜色,则arrar为空
    if (arrar.count!=0) {
        NSDictionary * dic1=[[NSDictionary alloc]init];
        dic1=arrar[0];
        NSString * key = @"attr_value";
        NSString * key2= @"attr_name";
        _yanse.text=dic1[key2];
        _colorArr=dic1[key];
        valueId=_colorArr[0][@"attr_value_id"];
    }
    
    pprice=dic[@"shop_price"];
    _price.text=pprice;
    [_iconImage setImageWithURL:dic[@"album"][0]];
    _bianHao.text=dic[@"goods_sn"];
    [_goodColl reloadData];
}
-(void)Creatprice
{
    _price=[[UILabel alloc]initWithFrame:CGRectMake(imageH+30, 64, imageH, 20)];
    _price.text=pprice;
    _price.font=[UIFont systemFontOfSize:15];
    _price.textColor=[UIColor redColor];
    [self.contentView addSubview:_price];
}
//从接口请求的数据ui搭建
-(void)netInfo
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, imageH, imageH)];
    _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconImage];
    
    _bianHao=[[UILabel alloc]initWithFrame:CGRectMake(imageH+65, 94, imageH, 10)];
    _bianHao.font=[UIFont systemFontOfSize:12];
    _bianHao.textColor=[UIColor blackColor];
    [self.contentView addSubview:_bianHao];
    
    _yanse=[[UILabel alloc]initWithFrame:CGRectMake(5, imageH+50, 30, 20)];
    _yanse.textColor=[UIColor blackColor];
    _yanse.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:_yanse];
    
    _shuliang=[[UILabel alloc]initWithFrame:CGRectMake(5, imageH+100, 30, 20)];
    _shuliang.textColor=[UIColor blackColor];
    _shuliang.text=@"数量";
    _shuliang.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:_shuliang];
    
    
    UICollectionViewFlowLayout * flow=[[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    _goodColl=[[UICollectionView alloc]initWithFrame:CGRectMake(50, imageH+40, kSliderbarWidth-50, 55) collectionViewLayout:flow];
    _goodColl.backgroundColor=[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    _goodColl.delegate=self;
    _goodColl.dataSource=self;
    [self.contentView addSubview:_goodColl];
    [_goodColl registerClass:[GoodRightCell class] forCellWithReuseIdentifier:@"right"];
    
}
#pragma mark-collect的代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_colorArr.count!=0) {
        return _colorArr.count;
    }else
        return 1;
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * right=@"right";
    GoodRightCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:right forIndexPath:indexPath];
    cell.layer.borderColor=[UIColor grayColor].CGColor;
    cell.layer.borderWidth=0.3;
    UIView* selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = selectedBGView;
    if (_colorArr.count!=0) {
        cell.cellLab.text=_colorArr[indexPath.row][@"attr_value_name"];
        return cell;
    }else
        
        return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5,5,5,5);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(30, 30);
}
#pragma mark-collection点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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
        [self.contentView addSubview:lab];
    }
    for (int i=0; i<2; i++) {
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(50+70*i, imageH+95, 30, 30);
        btn.backgroundColor=[UIColor whiteColor];
        if (i==0) {
            [btn setTitle:@"-" forState:UIControlStateNormal];
        }
        else if (i==1)
        {
            [btn setTitle:@"+" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag=1111+i;
        [btn addTarget:self action:@selector(btnadd:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(85, imageH+95, 30, 30)];
    field.text=@"1";
    field.tag=1314;
    [self.contentView addSubview:field];
    //       //设置数量增加button
    //    HJCAjustNumButton * btn=[[HJCAjustNumButton alloc]init];
    //    //设置frame
    //    btn.frame=CGRectMake(50, imageH+95,100 , 30);
    //    //内容更改的block回调
    //    btn.callBack=^(NSString * currentNum){
    //        _numuBer=currentNum;
    //        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    //        NSNotification *nofity=[[NSNotification alloc]initWithName:@"buttonc" object:_numuBer userInfo:nil];
    //        [nc postNotification:nofity];
    //    };
    //    //加到附件上
    //    [self.contentView addSubview:btn];
    //创建购物车按钮
    UIButton * butt=[UIButton buttonWithType:UIButtonTypeCustom];
    butt.frame=CGRectMake(0, self.view.frame.size.height-40,kSliderbarWidth, 40);
    butt.backgroundColor=[UIColor redColor];
    [butt addTarget:self action:@selector(buttclick:) forControlEvents:UIControlEventTouchUpInside];
    [butt  setTitle:@"加入购物车" forState:UIControlStateNormal];
    butt.titleLabel.textAlignment=NSTextAlignmentLeft;
    [butt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:butt];
    
}

#pragma mark-加入购物车
-(void)buttclick:(id)sender
{
    
    
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString * receNss= app.tempDic[@"data"][@"key"];
    if (receNss!=NULL) {
        
        NSMutableDictionary * valueDic=[[NSMutableDictionary alloc]init];
        NSString * path1;
        if (valueId!=NULL) {
            [valueDic setObject:[NSString stringWithFormat:@"%@",valueId]forKey:@"attr_value_id"];
            path1=[valueDic JSONString];
            //NSString * strr=[valueDic JSONString];
            //        path1=[strr  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else if (valueId==NULL)
        {
            path1=[NSString stringWithFormat:@""];
        }
        
        
        NSString * path2=[receNss stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        NSString *api_token = [RequestModel model:@"goods" action:@"addcart"];
        // strr=@"0";
        NSDictionary *dict = @{@"api_token":api_token,@"key":path2,@"num":_numuBer,@"goods_id":self.recevieId,@"attrvalue_id":path1};
        [RequestModel requestWithDictionary:dict model:@"goods" action:@"addcart" block:^(id result) {
            NSLog(@"侧边栏加入购物车成功%@",result);
        }];
    }
    else if (receNss==nil)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,还没登录哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
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

@end
