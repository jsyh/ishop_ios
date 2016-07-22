//
//  SureOrderController.m
//  ecshop
//
//  Created by jsyh-mac on 16/1/6.
//  Copyright © 2016年 jsyh. All rights reserved.
//确认订单页

#import "SureOrderController.h"
#import "RequestModel.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "ExpressView.h"
#import "hongBaoView.h"
#import "AFHTTPSessionManager.h"
#import "CheckStandController.h"
#import "SureTableViewCell.h"
#import "goodsModel.h"
#import "MyTabBarViewController.h"
#import "AddressViewController.h"
#import "UIColor+Hex.h"
#define kColorOffButton [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
@interface SureOrderController ()<sendRequestInfo,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * tabble;//商品table
    NSMutableArray * goodDate;//商品信息数据源
    UILabel * totalPrice;
    
    UILabel * personLab;//人名
    UILabel * phoneLab;//电话号码
    UILabel * totalFen;//总积分
    UITextField * diyongFen;//可以抵用的
    UILabel * hongbaoLab;
    UILabel * mianzhiLab;//红包面值
    UITextView * textView;//textview
    UITextField * field;//留言
    float a;//初始价格
    float b;//运费价格
    float c;//积分抵扣
    float d;//本订单可用金额
    NSString * goodPathId;//商品id以及数量.
    UIView * vview;//红包view
    UIButton * buttonfen;//输入抵用现金的确定按钮
}
@property (nonatomic, strong) UIScrollView * myScroll;
#define TextHeight 100
#define cellHeight 50
#define jiange 10
@end

@implementation SureOrderController
-(void)viewWillAppear:(BOOL)animated
{
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    
    [tabbar hiddenTabbar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    self.view.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self createMain];
    [self reloadInfo];
    NSNotificationCenter *ncollect=[NSNotificationCenter defaultCenter];
    [ncollect addObserver:self selector:@selector(showHongbao:) name:@"MonInfo" object:nil];
    NSNotificationCenter *monInfo=[NSNotificationCenter defaultCenter];
    [monInfo addObserver:self selector:@selector(showYunfei:) name:@"yunfeiInfo" object:nil];
    
    NSNotificationCenter *addressI=[NSNotificationCenter defaultCenter];
    [addressI addObserver:self selector:@selector(address:) name:@"addressInfo" object:nil];
    
    goodDate=[[NSMutableArray alloc]init];
    [self createDown];
    
}
-(void)address:(NSNotification*)notifi
{
    NSDictionary * info=notifi.userInfo;
    if (info!=NULL) {
        self.userNamm=info[@"myaddress"][@"myName"];
        self.teleNum=info[@"myaddress"][@"myPhone"];
        self.messageee=info[@"myaddress"][@"mymessage"];
        self.addressId=info[@"myaddress"][@"myId"];
    }else if (info==NULL)
    {
        
    }
    
    [self createMain];
    [self createDown];
}
-(void)showHongbao:(NSNotification* )noti
{
    NSDictionary *info=noti.userInfo;
    _hongbaoNam=info[@"myMon"][@"monName"];
    _hongMuch=info[@"myMon"][@"monHow"];
    _hongDiyong=info[@"myMon"][@"kydiyong"];
    _hongId=info[@"myMon"][@"baoID"];//红包id
    _typeID=info[@"myMon"][@"typeIID"];
    if ([_hongbaoNam isEqualToString:@""]) {
        hongbaoLab.text=@"选择红包";
    }else{
        hongbaoLab.text=_hongbaoNam;
    }
    mianzhiLab.text=_hongMuch;
}
-(void)showYunfei:(NSNotification*)notify
{
    NSDictionary *info=notify.userInfo;
    _yunfeiID=info[@"myInfo"][@"myID"];
    _yunfei.text=info[@"myInfo"][@"myMoney"];
    _yunfeiNAme.text=info[@"myInfo"][@"myName"];
    b=[info[@"myInfo"][@"myMoney"] floatValue];
    a=a+b;
    totalPrice.text=[NSString stringWithFormat:@"%.2f",a];
    //[self createDown];
}

#pragma mark-请求数据
-(void)reloadInfo
{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    
    // NSString *goodsId = nil;
    goodsModel *goodmodel1 = [goodsModel new];
    //从购物车进来
    if (_tempArr !=NULL) {
        
        for (int i = 0; i<_tempArr.count; i++) {
            if (i==0) {
                goodmodel1 = _tempArr[0];
                goodPathId = [NSString stringWithFormat:@"%@-%d",goodmodel1.goods_id,goodmodel1.number];
            }else{
                goodmodel1 = _tempArr[i];
                goodPathId = [NSString stringWithFormat:@"%@,%@-%d",goodPathId,goodmodel1.goods_id,goodmodel1.number];
            }
        }
        
        NSString *api_token = [RequestModel model:@"order" action:@"confirm"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"goods_id":goodPathId};
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"order" action:@"confirm" block:^(id result) {
            NSDictionary *dic = result;
            NSLog(@"获得的数据：%@",dic);
            [weakSelf sendMessage:result];
            
        }];
    }else if(_tempArr ==NULL){
        
        RequestModel * requ=[[RequestModel alloc]init];
        requ.delegate=self;
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString * receStr= app.tempDic[@"data"][@"key"];
        goodPathId=[NSString stringWithFormat:@"%@-%@",_sureId,_NumLab.text];
        NSString *path2=[goodPathId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSString *api_token = [RequestModel model:@"order" action:@"confirm"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":receStr,@"goods_id":path2,@"attrvalue_id":_smallId};
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"order" action:@"confirm" block:^(id result) {
            
            [weakSelf sendMessage:result];
        }];
    }
}
-(void)sendMessage:(id)message
{
    NSDictionary *dic=message[@"data"];
    if (dic[@"user_name"]==[NSNull null]) {
        personLab.text=@"";
    }else if (dic[@"mobile"]==[NSNull null])
    {
        phoneLab.text=@"";
    }else if(dic[@"user_name"]!= [NSNull null]){
        personLab.text=dic[@"user_name"];
    }else if (dic[@"mobile"]!=[NSNull null]){
        phoneLab.text=dic[@"mobile"];
    }
    if(dic[@"address_id"]==[NSNull null]){
        _addressId=@"";
    }else if (dic[@"address_id"]!=[NSNull null]){
        _addressId=dic[@"address_id"];
    }
    if (self.messageee==NULL) {
        if (dic[@"address"]==[NSNull null]) {
            textView.text=@"";
        }else if (dic[@"address"]!=[NSNull null]){
            textView.text=dic[@"address"];
        }
    }else if (self.messageee!=NULL)
    {
        
        textView.text=self.messageee;
    }
    [goodDate addObjectsFromArray:dic[@"goods"]];
    [tabble reloadData];
    if (_tempArr==NULL) {
        a=[dic[@"goods"][0][@"price"] floatValue];
        totalPrice.text=[NSString stringWithFormat:@"%.2f",a];
        _goodPrice.text=[NSString stringWithFormat:@"%.2f",a];
    }else if (_tempArr!=NULL)
    {
        a=[_priccc floatValue];
        _goodPrice.text=_priccc;
        totalPrice.text=_priccc;
    }
    
    NSString *str1=[NSString stringWithFormat:@"%@",dic[@"integral"]];
    NSString * str2=[NSString stringWithFormat:@"%@",dic[@"integrala"]];
    totalFen.text=[NSString stringWithFormat:@"%@可用",str1];;
    diyongFen.placeholder=[NSString stringWithFormat:@"本订单用%@",str2];
    d = [str2 floatValue];
}
-(void)createDown
{
#pragma mark-创建底层
    UIView * downView;
    downView.userInteractionEnabled=YES;
    if (_tempArr==NULL) {
        downView=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-cellHeight, self.view.frame.size.width, cellHeight)];
    }else if (_tempArr!=NULL){
        downView=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-cellHeight, self.view.frame.size.width, cellHeight)];
    }
    downView.backgroundColor = [UIColor redColor];
    //        downView.opaque=YES;
    
    downView.backgroundColor=[UIColor blackColor];
    UILabel * downLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, cellHeight)];
    downLab.opaque=YES;
    downLab.text=@"实付款: ￥";
    downLab.font=[UIFont systemFontOfSize:20];
    downLab.textColor=[UIColor whiteColor];
#pragma mark-总价格
    totalPrice=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 75, cellHeight)];
    totalPrice.font=[UIFont systemFontOfSize:14];
    totalPrice.text=[NSString stringWithFormat:@"%.2f",a];
    totalPrice.textColor=[UIColor whiteColor];
    [downView addSubview:downLab];
    [downView addSubview:totalPrice];
    UIButton * downBut=[UIButton buttonWithType:UIButtonTypeCustom];
    downBut.frame=CGRectMake(200, 0, self.view.frame.size.width-200, cellHeight);
    downBut.backgroundColor=[UIColor redColor];
    downBut.opaque=YES;
    [downBut setTitle:@"提交订单" forState:UIControlStateNormal];
    downBut.userInteractionEnabled=YES;
    downBut.titleLabel.font=[UIFont systemFontOfSize:20];
    [downBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downBut addTarget:self action:@selector(downButClick:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:downBut];
    
    [self.view addSubview:downView];
    
    
}
-(void)createMain
{
#pragma mark-收货地址
    UIView * firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TextHeight+20)];
    firstView.backgroundColor=[UIColor colorWithRed:254/255.0 green:248/255.0 blue:239/255.0 alpha:1.0];
    firstView.opaque=YES;
    textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, TextHeight-10)];
    if (self.messageee!=NULL) {
        textView.text=self.messageee;
    }
    textView.opaque=YES;
    textView.backgroundColor=[UIColor clearColor];
    textView.textColor=[UIColor lightGrayColor];
    textView.font =[UIFont systemFontOfSize:15];
    textView.tag=1888;
    
    UITapGestureRecognizer * tapp=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappClick:)];
    tapp.numberOfTapsRequired=1;
    tapp.numberOfTouchesRequired=1;
    [textView addGestureRecognizer:tapp];
    [firstView addSubview:textView];
    //创建背景图片
    for (int i=0; i<2; i++) {
        UIImage * imga=[UIImage imageNamed:@"我的订单 -去付款（等待付款）-装饰"];
        imga=[imga imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *imagev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0+(TextHeight+20-5)*i, self.view.frame.size.width, 5)];
        imagev.opaque=YES;
        imagev.image=imga;
        [firstView addSubview:imagev];
    }
    //创建人名和电话
    NSArray * imageArr=@[@"我的订单-去付款（等待付款）-人icon",@"我的订单-去付款（等待付款）-手机icon"];
    for (int i=0; i<2; i++) {
        UIImageView * smallImage=[[UIImageView alloc]initWithFrame:CGRectMake(10+120*i, 10, 15,15)];
        smallImage.opaque=YES;
        UIImage * imagee=[UIImage imageNamed:imageArr[i]];
        imagee=[imagee imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        smallImage.image=imagee;
        [firstView addSubview:smallImage];
    }
    //人名和电话
    personLab =[[UILabel alloc]initWithFrame:CGRectMake(28, 12, 100, 13)];
    if (self.userNamm!=NULL) {
        personLab.text=self.userNamm;
    }
    personLab.font=[UIFont systemFontOfSize:15];
    personLab.opaque=YES;
    phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(150, 12, 110, 13)];
    if (self.teleNum!=NULL) {
        phoneLab.text=self.teleNum;
    }
    phoneLab.font=[UIFont systemFontOfSize:14];
    phoneLab.opaque=YES;
    [firstView addSubview:personLab];
    [firstView addSubview:phoneLab];
    [firstView addSubview:textView];
#pragma mark-创建foot
    UIView * footview=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width ,5*cellHeight+2*TextHeight-10)];
#pragma mark-配送方式,选择红包
    for (int i=0; i<2; i++)
    {
        vview=[[UIView alloc]initWithFrame:CGRectMake(0,i*(TextHeight+2*jiange+3*cellHeight+2), self.view.frame.size.width, cellHeight)];
        vview.backgroundColor=[UIColor whiteColor];
        vview.opaque=YES;
        
        
        if (i==0) {
            _yunfeiNAme=[[UILabel alloc]initWithFrame:CGRectMake(vview.frame.size.width-100, 16, 60, 20)];
            _yunfeiNAme.opaque=YES;
            _yunfeiNAme.font=[UIFont systemFontOfSize:15];
            _yunfeiNAme.text=@"请选择";
            _yunfeiNAme.textColor=[UIColor blackColor];
            _yunfeiNAme.textAlignment=NSTextAlignmentRight;
            [vview addSubview:_yunfeiNAme];
            UILabel * lll=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, cellHeight)];
            lll.text=@"配送方式";
            lll.opaque=YES;
            lll.font=[UIFont systemFontOfSize: 15];
            lll.textColor=[UIColor lightGrayColor];
            [vview addSubview:lll];
            
        }
        if (i==1) {
            hongbaoLab  =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, cellHeight)];
            hongbaoLab.opaque=YES;
            hongbaoLab.text=@"选择红包";
            hongbaoLab.textColor=[UIColor lightGrayColor];
            hongbaoLab.font=[UIFont systemFontOfSize:15];
            [vview addSubview:hongbaoLab];
            
            mianzhiLab=[[UILabel alloc]initWithFrame:CGRectMake(vview.frame.size.width-100, 16, 60, 20)];
            mianzhiLab.opaque=YES;
            mianzhiLab.font=[UIFont systemFontOfSize:15];
            mianzhiLab.textColor=[UIColor blackColor];
            mianzhiLab.textAlignment=NSTextAlignmentRight;
            [vview addSubview:mianzhiLab];
        }
        UIImageView * imagevvv=[[UIImageView alloc]initWithFrame:CGRectMake(vview.frame.size.width-30, 20, 13, 13)];
        UIImage * imagebutt=[UIImage imageNamed:@"xiangyou"];
        imagebutt=[imagebutt imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        imagevvv.image=imagebutt;
        
        UITapGestureRecognizer *tapv=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        tapv.numberOfTapsRequired=1;
        tapv.numberOfTouchesRequired=1;
        vview.tag=1990+i;
        [vview addGestureRecognizer:tapv];
        [vview addSubview:imagevvv];
        [footview addSubview:vview];
        
    }
#pragma mark-留言
    field=[[UITextField alloc]initWithFrame:CGRectMake(0, jiange +cellHeight   , self.view.frame.size.width, TextHeight)];
    field.placeholder=@"  给商家留言(字数在45个字以内)";
    field.delegate=self;
    field.textAlignment=NSTextAlignmentLeft;;
    field.textColor=[UIColor lightGrayColor];
    field.returnKeyType=UIReturnKeyDone;
    field.backgroundColor=[UIColor whiteColor];
    field.font=[UIFont systemFontOfSize:12];
    field.tag=1777;
    [footview addSubview:field];
#pragma mark-可抵用现金,商品金额,运费
    NSArray * viewArr=@[@"  拥有可抵用的现金",@"  输入抵用现金"];
    for (int i=0; i<2; i++) {
        UIView * vieew=[[UIView alloc]initWithFrame:CGRectMake(0, jiange*2+cellHeight+TextHeight +i*(cellHeight+1), self.view.frame.size.width,cellHeight)];
        vieew .backgroundColor=[UIColor whiteColor];
        vieew.opaque=YES;
        UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, cellHeight)];
        lab.text=viewArr[i];
        lab.textColor=[UIColor lightGrayColor];
        lab.font=[UIFont systemFontOfSize:15];
        [vieew addSubview:lab];
        if (i==0) {
            totalFen=[[UILabel alloc]initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-150, cellHeight)];
            totalFen.font=[UIFont systemFontOfSize:15];
            totalFen.textColor=[UIColor blackColor];
            totalFen.textAlignment=NSTextAlignmentLeft;
            [vieew addSubview:totalFen];
        }
        else if (i==1)
        {
            diyongFen =[[UITextField alloc]initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-215, cellHeight)];
            diyongFen.font=[UIFont systemFontOfSize:13];
            diyongFen.textColor=[UIColor lightGrayColor];
            diyongFen.delegate=self;
            diyongFen.returnKeyType=UIReturnKeyDone;
            diyongFen.tag=17777;
            [diyongFen addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            [vieew addSubview:diyongFen];
            buttonfen=[UIButton buttonWithType:UIButtonTypeCustom];
            buttonfen.frame=CGRectMake(self.view.frame.size.width-55, 7, 50, 35);
            buttonfen.backgroundColor = kColorOffButton;
            [buttonfen setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonfen setTitle:@"确定" forState:UIControlStateNormal];
            
            buttonfen.tag=2777;
            [buttonfen addTarget:self action:@selector(buttonfenBit:) forControlEvents:UIControlEventTouchUpInside];
            [vieew addSubview:buttonfen];
        }
        [footview addSubview:vieew];
    }
#pragma mark-商品金额 运费
    NSArray * lalArr=@[@"  商品金额",@"  运费"];
    for (int i=0; i<2; i++) {
        UIView * vieww=[[UIView alloc]initWithFrame:CGRectMake(0, jiange*3+cellHeight*6+cellHeight*i+4, self.view.frame.size.width, cellHeight)];
        vieww.backgroundColor=[UIColor whiteColor];
        vieww.opaque=YES;
        UILabel * lal=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, cellHeight)];
        lal.textColor=[UIColor lightGrayColor];
        lal.text=lalArr[i];
        lal.opaque=YES;
        lal.font=[UIFont systemFontOfSize:15];
        [vieww addSubview:lal];
        if (i==0) {
            _goodPrice=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 10,90, 20)];
            
            _goodPrice.textColor=[UIColor redColor];
            _goodPrice.textAlignment=NSTextAlignmentRight;
            _goodPrice.font=[UIFont systemFontOfSize:15];
            [vieww addSubview:_goodPrice];
        }else if (i==1){
            _yunfei=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 10,90, 20)];
            _yunfei.textColor=[UIColor redColor];
            _yunfei.text=@"+0";
            _yunfei.textAlignment=NSTextAlignmentRight;
            _yunfei.font=[UIFont systemFontOfSize:15];
            [vieww addSubview:_yunfei];
        }
        [footview addSubview:vieww];
    }
#pragma mark-table商品详情
    if (_tempArr!=NULL) {
        tabble=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-cellHeight - 64) style:UITableViewStylePlain];
    }else if (_tempArr==NULL){
        tabble=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    }
    tabble.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    tabble.tableHeaderView=firstView;
    tabble.tableFooterView=footview;
    tabble.showsVerticalScrollIndicator=NO;
    tabble.delegate=self;
    tabble.dataSource=self;
    [self.view addSubview:tabble];
}

#pragma mark-tabble的代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return goodDate.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * stringg=@"stringg";
    SureTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:stringg];
    if (cell==nil) {
        cell=[[SureTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringg];
        cell.layer.borderWidth=0.4;
    }
    [cell.iconImage setImageWithURL:goodDate[indexPath.row][@"goods_img"]];
    cell.priceLab.text=goodDate[indexPath.row][@"price"];
    cell.nameLab.text=goodDate[indexPath.row][@"title"];
    if (_tempArr==NULL) {
        cell.NumLab.text=self.shopNum;
    }else if(_tempArr!=NULL) {
        cell.NumLab.text=goodDate[indexPath.row][@"shop_num"];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
#pragma mark-跳转出新的界面呢
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    UIView * bitView1=[(UIView *)tap.view viewWithTag:1990];
    UIView * bitView2=[(UIView *)tap.view viewWithTag:1991];
    if (bitView1) {
        ExpressView * press=[[ExpressView alloc]init];
        [self.navigationController pushViewController:press animated:YES];
    }else if(bitView2){
        hongBaoView * hong=[[hongBaoView alloc]init];
        hong.money=[NSString stringWithFormat:@"%.2f",a];
        [self.navigationController pushViewController:hong animated:YES];
    }
    
}
#pragma mark-选择地址
-(void)tappClick:(UITapGestureRecognizer*)tap
{
    //    UITextView * vieww=[(UITextView*)tap.view viewWithTag:1888];
    AddressViewController * add=[[AddressViewController alloc]init];
    add.panduanid=self.sureId;
    [self.navigationController pushViewController:add animated:YES];
    
}
#pragma mark-确认红包
-(void)buttonfenBit:(UIButton*)sender
{
    //UIButton * bun=(UIButton*)[vview viewWithTag:2777];
    if (diyongFen.text!=NULL) {
        c=[diyongFen.text floatValue];
        if (c > d) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"不能超出抵用限额" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            float f=a-c;
            totalPrice.text=[NSString stringWithFormat:@"%.2f",f];
        }
        
    }
}
#pragma mark-提交订单
-(void)downButClick:(UIButton*)sender
{
    if (_yunfeiID ==NULL) {
        UIAlertView * aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,请选择运费" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [aler show];
    }else if (_yunfeiID !=NULL){
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString * receNs= app.tempDic[@"data"][@"key"];
        NSString * fieldPath=[field.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *path2=[goodPathId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString * PATH;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSString *url1 = data[@"url"];
        
        if(self.secondAddressId==NULL){
            PATH=[NSString stringWithFormat:@"%@/order/create?key=%@&goods_id=%@&address_id=%@&amount=%@&money_paid=%@&shipping_fee=%@&expressage_id=%@&redpacket=%@&goods_attr_id=%@&bonus_id=%@&bonus_type_id=%@&message=%@&integral=%@&type=1",url1,receNs,path2,_addressId,_NumLab.text,totalPrice.text,_yunfei.text,_yunfeiID,diyongFen.text,_smallId,_hongId,_typeID,fieldPath,diyongFen.text];}
        else if (self.secondAddressId!=NULL){
            PATH=[NSString stringWithFormat:@"%@/order/create?key=%@&goods_id=%@&address_id=%@&amount=%@&money_paid=%@&shipping_fee=%@&expressage_id=%@&redpacket=%@&goods_attr_id=%@&bonus_id=%@&bonus_type_id=%@&message=%@&integral=%@&type=1",url1,receNs,path2,_addressId,_NumLab.text,totalPrice.text,_yunfei.text,_yunfeiID,diyongFen.text,_smallId,_hongId,_typeID,fieldPath,diyongFen.text];
        }
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
        __weak typeof(self) weakSelf = self;
        [manager GET:PATH parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"提交成功%@",responseObject);
            
            CheckStandController * check=[[CheckStandController alloc]init];
            check.jiage=responseObject[@"data"][@"money_paid"];
            check.orderNs=responseObject[@"data"][@"order_sn"];
            [weakSelf.navigationController pushViewController:check animated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.description);
        }];
    }
    
    
}
#pragma mark-释放键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [field resignFirstResponder];
    [diyongFen becomeFirstResponder];
    [diyongFen resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (field==textField) {
        if (range.location >= 45) {
            return NO;
        }
    }
    else if (diyongFen==textField) {
        
    }
    return YES;
}
#pragma mark-键盘出现的视图动作
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up

{
    const int movementDistance = 140; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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

#pragma mark -- 自定义导航栏
- (void)initNavigationBar{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *naviBGColor = data[@"navigationBGColor"];
    NSString *navigationTitleFont = data[@"navigationTitleFont"];
    int titleFont = [navigationTitleFont intValue];
    NSString *naiigationTitleColor = data[@"naiigationTitleColor"];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    label.text = @"确认订单";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:titleFont];
    label.textColor = [UIColor colorWithHexString:naiigationTitleColor];
    [view addSubview:label];
    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    [btn addSubview:imgView];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textFieldChanged:(id)sender{
    if (diyongFen.text.length>0) {
        buttonfen.backgroundColor = [UIColor redColor];
        [buttonfen setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        buttonfen.userInteractionEnabled = YES;
    }else{
        buttonfen.backgroundColor = kColorOffButton;
        [buttonfen setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        buttonfen.userInteractionEnabled = YES;
    }
}

@end
