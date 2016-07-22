//
//  SearchListViewController.m
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//搜索列表

#import "SearchListViewController.h"
#import "firstViewController.h"
#import "SearchListCollect.h"
#import "SearchListTableCell.h"
#import "SliderViewController.h"
#import "PopoveView.h"
#import "UIImageView+AFNetworking.h"
#import "RequestModel.h"
#import "SearchViewController.h"
#import "goodDetailViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "UIColor+Hex.h"
#import "MyTabBarViewController.h"
#define topHeight 50   //综合,销量,筛选栏的高度
@interface SearchListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,sendRequestInfo>{
    BOOL changeItem;//点击改变列表排布方式
    BOOL zonghe;//点击综合
    BOOL jiage;//点击价格
    NSString * ifsale;//是否促销
    UIButton * buttonall;
    UIImageView * sureImg;
}
@property (nonatomic, retain) SliderViewController* sidebarVC;
@property (nonatomic, strong) UICollectionView *collect;//collect排布
@property (nonatomic, strong) UITableView *table;//table排布
@property (nonatomic, strong) UIView *view1;//view1上方table
@property (nonatomic, strong) UIView *view2;//view2上放collect
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString * btnOrder;//排序的数字
@end

@implementation SearchListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    
    [tabbar hiddenTabbar:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createUI];
    [self initNavigationBar];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.hidden=NO;
    _secondArr=[[NSMutableArray alloc]init];
    //初始化数据源
    _datasource=[[NSMutableArray alloc]init];
    //初始化changeItem值
    changeItem=YES;
    //初始化综合按钮的值
    zonghe=YES;
    //初始化价格按钮的值
    jiage=YES;
    //初始化排序的初始状态
    _btnOrder=@"1";
    
    _view1=[[UIView alloc]initWithFrame:CGRectMake(0, 64+topHeight, self.view.frame.size.width, self.view.frame.size.height)];
    _view2=[[UIView alloc]initWithFrame:CGRectMake(0, 64+topHeight, self.view.frame.size.width, self.view.frame.size.height)];
    [self createTable];
    //请求数据
    [self reloadRequestInfo];
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(showtext:) name:@"text" object:nil];
}

-(void)showtext:(NSNotification *)notify{
    NSDictionary *info=notify.userInfo;
    _secondArr=info[@"lis"];
    [self reloadRequestInfo];
    
}
#pragma mark-请求数据
-(void)reloadRequestInfo
{
    
    RequestModel *rev=[[RequestModel alloc]init];
    rev.delegate=self;
    
    NSString * path2=[NSString stringWithFormat:@"%@",_secondArr];
    NSString * path3=[path2 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (self.typeStay==NULL) {
        self.typeStay=@"";
    }if (self.gooddid==NULL) {
        self.gooddid=@"";
    }if (self.secondLab==NULL) {
        self.secondLab=@"";
    }
    NSString *api_token = [RequestModel model:@"first" action:@"index"];
    NSDictionary *dict = @{@"api_token":api_token,@"keyword":self.secondLab,@"cat_id":self.gooddid,@"type":@"search",@"order":_btnOrder,@"page":@1,@"filtrate":path3,@"maintype":@"",@"c":self.typeStay};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"first" action:@"index" block:^(id result) {
        [weakSelf sendMessage:result];
        
    }];
    
}
-(void)sendMessage:(id)message{
    if (![message[@"code"] isEqual:@"0"]) {
        
        NSMutableDictionary *dic=message[@"data"];
        NSMutableArray *arr=dic[@"goods"];
        [_datasource removeAllObjects];
        [_datasource addObjectsFromArray:arr];
        [_table reloadData];
        [_collect reloadData];
        _goodType=dic[@"goods_type"];
    }
}
#pragma mark-创建导航条
-(void)createNav
{
    //导航条
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtn)];
    //右侧
    buttonall=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonall.frame=CGRectMake(self.view.frame.size.width-50,30 , 30, 30);
    UIImage * image2=[UIImage imageNamed:@"tab-qiehuan(liebiaoxingshi)"];
    image2=[image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [buttonall setImage:image2 forState:UIControlStateNormal];
    [buttonall addTarget:self action:@selector(bitright:) forControlEvents:UIControlEventTouchUpInside];
    buttonall.tag=80;
    UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithCustomView:buttonall];
    self.navigationItem.rightBarButtonItem=right;
    [self.view addSubview:buttonall];
    //(3)中间 搜索框
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(0, 0, 250, 35);
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.layer.borderWidth=1;
    searchBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    searchBtn.layer.cornerRadius = 8;
    searchBtn.layer.masksToBounds=YES;
    [searchBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    UIImage * imagebtn=[UIImage imageNamed:@"search"];
    //imagebtn=[imagebtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [searchBtn setImage:imagebtn forState:UIControlStateNormal];
    [searchBtn setTitle:_secondLab forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    searchBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0,searchBtn.frame.size.width-50);
    searchBtn.titleEdgeInsets=UIEdgeInsetsMake(5, 60, 5,searchBtn.frame.size.width-110 );
    self.navigationItem.titleView=searchBtn;
}
#pragma mark-创建table布局
-(void)createTable
{
    [self.view addSubview:_view1];
    _table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height-64-topHeight)];
    _table.delegate=self;
    _table.dataSource=self;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_table setTableFooterView:view];
    _table.showsVerticalScrollIndicator=NO;
    [_view1 addSubview:_table];
}
#pragma mark-创建collect布局
-(void)creatCollect
{
    [self.view addSubview:_view2];
    UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    _collect=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-topHeight) collectionViewLayout:flow];
    _collect.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    _collect.delegate=self;
    _collect.dataSource=self;
    _collect.showsHorizontalScrollIndicator=NO;
    _collect.showsVerticalScrollIndicator=NO;
    [_view2 addSubview:_collect];
    [_collect registerClass:[SearchListCollect class] forCellWithReuseIdentifier:@"string"];
}
#pragma mark-创建Top四栏
-(void)createUI
{
    _datasource=[[NSMutableArray alloc]init];
    NSArray *titleArr=@[@"综合",@"销量",@"价格",@"筛选"];
    NSArray*imageArr=@[@"zonghe(weixuanzhong)",@"",
                       @"fenlei(youdidaogao(weixuanzhong))",@"tiaojianshaixuan(weixuanzhong)"];
    
    for (int i=0; i<4; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(i*self.view.frame.size.width/4, 64, self.view.frame.size.width/4, topHeight);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        if (i==1) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonlist1:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image2=[UIImage imageNamed:imageArr[i]];
        image2=[image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:image2 forState:UIControlStateNormal];
        button.titleLabel.textAlignment=NSTextAlignmentLeft;
        button.titleEdgeInsets=UIEdgeInsetsMake(5, 5, 10, 20);
        button.imageEdgeInsets=UIEdgeInsetsMake(5, 65, 10, 0);
        button.tag=i+10;
        [self.view addSubview:button];
    }
}
#pragma mark-Top四栏点击效果
-(void)buttonlist1:(UIButton *)sender
{
    UIButton *btn1=(UIButton *)[self.view viewWithTag:10];
    UIButton *btn2=(UIButton *)[self.view viewWithTag:11];
    UIButton *btn3=(UIButton *)[self.view viewWithTag:12];
    UIButton *btn4=(UIButton *)[self.view viewWithTag:13];
    
    UIButton * btn=(UIButton *)sender;
    if (btn.tag==10)
    {
        [btn setImage:[UIImage imageNamed:@"zonghe(yixuanzhong)"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"fenlei(youdidaogao(weixuanzhong))"] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"tiaojianshaixuan(weixuanzhong)"] forState:UIControlStateNormal];
        CGPoint point=CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
        NSArray *titles=@[@"综合",@"人气"];
        PopoveView *pop=[[PopoveView alloc]initWithPoint:point titles:titles];
        pop.selectRowAtIndex=^(NSInteger index)
        {
            if (index==0)
            {
                [btn setTitle:@"综合" forState:UIControlStateNormal];
                _btnOrder=@"0";
                [self reloadRequestInfo];
            }
            else if (index==1)
            {
                [btn setTitle:@"人气" forState:UIControlStateNormal];
                _btnOrder=@"4";
                [self reloadRequestInfo];
            }
        };
        [pop show];
    }
    else if (btn.tag==11)
    {
        
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"zonghe(weixuanzhong)"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"fenlei(youdidaogao(weixuanzhong))"] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"tiaojianshaixuan(weixuanzhong)"] forState:UIControlStateNormal];
        _btnOrder=@"1";
        [self reloadRequestInfo];
        
    }
    else if (btn.tag==12)
    {
        if (jiage)
        {
            
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"fenlei(youdidaogao)"] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@"zonghe(weixuanzhong)"] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn4 setImage:[UIImage imageNamed:@"tiaojianshaixuan(weixuanzhong)"] forState:UIControlStateNormal];
            jiage=NO;
            _btnOrder=@"2";
            [self reloadRequestInfo];
            
        }else if (jiage==NO)
        {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"fenlei(yougaodaodi)"] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@"zonghe(weixuanzhong)"] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn4 setImage:[UIImage imageNamed:@"tiaojianshaixuan(weixuanzhong)"] forState:UIControlStateNormal];
            jiage=YES;
            _btnOrder=@"3";
            [self reloadRequestInfo];
        }
    }
    else if(btn.tag==13)
    {
        //右边栏开始
        UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
        [panGesture delaysTouchesBegan];
        [self.view addGestureRecognizer:panGesture];
        self.sidebarVC=[[SliderViewController alloc]init];
        self.sidebarVC.rightLab=self.secondLab;
        self.sidebarVC.myType=self.goodType;
        [self.navigationController.view addSubview:self.sidebarVC.view];
        self.sidebarVC.view.frame=self.view.bounds;
        
        [self.sidebarVC showHideSlidebar];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tiaojianshaixuan(yixuanzhong)"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"zonghe(weixuanzhong)"] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"fenlei(youdidaogao(weixuanzhong))"] forState:UIControlStateNormal];
    }
    
    
}
#pragma mark-table代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid=@"cellid";
    SearchListTableCell * cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[SearchListTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.backgroundColor=[UIColor whiteColor];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *imgUrl = data[@"imgUrl"];
    
    NSString * str=[NSString stringWithFormat:@"%@/",imgUrl];
    NSString *str2=_datasource[indexPath.row][@"image"];
    NSString *str3=[str stringByAppendingString:str2];
    NSURL *url =[NSURL URLWithString:str3];
    [cell.iconImage setImageWithURL:url];
    cell.nameLab.text=_datasource[indexPath.row][@"title"];
    cell.priceLab.text=_datasource[indexPath.row][@"price"];
    ifsale=_datasource[indexPath.row][@"sell_num"];
    if ([ifsale isEqual:@"1"]) {
        cell.saleImage.image=[UIImage imageNamed:@"sale"];
        cell.saleImage.contentMode = UIViewContentModeScaleAspectFit;
    }
   cell.moneySign.text=@"￥";
//    cell.haoPinLab.text=@"好评";
//    cell.perSian.text=@"%";
//    cell.renLab.text=@"人";
    
    //购买人数为空则赋值0
    NSString *string2=[NSString stringWithFormat:@"%@",_datasource[indexPath.row][@"sell_num"]];
    if ([string2  isEqualToString:@"<null>"]) {
        cell.num2Lab.text=@"0人";
    }else{
        cell.num2Lab.text=[NSString stringWithFormat:@"%@人",string2];
    }
    //判断如果好评人数为空则赋值0
    //将nsnumber类型的数据转化成nsstring
    NSString *string1=[NSString stringWithFormat:@"%@",_datasource[indexPath.row][@"good"]];
    if(_datasource[indexPath.row][@"good"]==NULL){
        cell.num1Lab.text=@"好评100%";
    }
    else{
        cell.num1Lab.text=[NSString stringWithFormat:@"好评%@%",string1];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.goodIDS=_datasource[indexPath.item][@"goods_id"];
    goodDetailViewController *good=[[goodDetailViewController alloc]init];
    good.goodID=_goodIDS;
    [self.navigationController pushViewController:good animated:YES];
}
#pragma mark-collectview代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _datasource.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string=@"string";
    SearchListCollect * cell=[collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *imgUrl = data[@"imgUrl"];
    
    NSString * str=[NSString stringWithFormat:@"%@/",imgUrl];
    NSString *str2=_datasource[indexPath.item][@"image"];
    NSString *str3=[str stringByAppendingString:str2];
    NSURL *url =[NSURL URLWithString:str3];
    [cell.iconImage setImageWithURL:url];
    cell.nameLab.text=_datasource[indexPath.item][@"title"];
    cell.priceLab.text=_datasource[indexPath.item][@"price"];
    cell.moneySign.text=@"￥";
    return cell;
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5,5, 5, 5);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width/2-10, self.view.frame.size.width/2+20);
    
}
#pragma mark-collection选中事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.goodIDS=_datasource[indexPath.item][@"goods_id"];
    goodDetailViewController *good=[[goodDetailViewController alloc]init];
    good.goodID=_goodIDS;
    [self.navigationController pushViewController:good animated:NO];
    NSDictionary *dict1=[NSDictionary dictionaryWithObjectsAndKeys:_datasource[indexPath.item][@"goods_id"],@"list", nil];
    NSNotificationCenter *goodnc=[NSNotificationCenter defaultCenter];
    NSNotification *goodty=[[NSNotification alloc]initWithName:@"textt" object:nil userInfo:dict1];
    [goodnc postNotification:goodty];
}
#pragma mark-跳转到下一个页面
-(void)buttonClick
{
    SearchViewController *search=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:NO];
}
#pragma mark-点击改变列表的排列方式
-(void)bitright:(id)sender
{
    // UIButton * btn=(UIButton*)[self.view viewWithTag:80];
    if (changeItem) {
        changeItem=NO;
        UIImage * image12=[UIImage imageNamed:@"tab-qiehuan(pubuliu)"];
        image12=[image12  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [buttonall setImage:image12 forState:UIControlStateNormal];
        [_table removeFromSuperview];
        [self creatCollect];
    }
    else{
        UIImage * image12=[UIImage imageNamed:@"tab-qiehuan(liebiaoxingshi)"];
        image12=[image12  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [buttonall setImage:image12 forState:UIControlStateNormal];
        changeItem=YES ;
        [_collect removeFromSuperview];
        [self createTable];
    }
}
#pragma mark-返回
-(void)backBtn{
    [self.navigationController  popViewControllerAnimated:YES];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ --%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
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
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    
    buttonall=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonall.frame=CGRectMake(self.view.frame.size.width-60,22 , 60, 40);
    UIImage * image2=[UIImage imageNamed:@"tab-qiehuan(liebiaoxingshi)"];
    image2=[image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [buttonall setImage:image2 forState:UIControlStateNormal];
    [buttonall addTarget:self action:@selector(bitright:) forControlEvents:UIControlEventTouchUpInside];
    buttonall.tag=80;
    [view addSubview:buttonall];
    
    
    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    [btn addSubview:imgView];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    //(3)中间 搜索框
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(btn.frame.size.width , 25, self.view.frame.size.width - btn.frame.size.width - 60, 35);
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.layer.borderWidth=1;
    searchBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    searchBtn.layer.cornerRadius = 8;
    searchBtn.layer.masksToBounds=YES;
    [searchBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    UIImage * imagebtn=[UIImage imageNamed:@"search"];
    imagebtn=[imagebtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [searchBtn setImage:imagebtn forState:UIControlStateNormal];
    [searchBtn setTitle:_secondLab forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    searchBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 180);
    searchBtn.titleEdgeInsets=UIEdgeInsetsMake(5, -5, 5, 5);
    [view addSubview:searchBtn];
    
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
