//
//  goodDetailViewController.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/11.
//  Copyright © 2015年 jsyh. All rights reserved.
//商品详情页

#import "goodDetailViewController.h"
#import "DetailTableCell.h"
#import "MJRefresh.h"
#import "RequestModel.h"
#import "UIImageView+AFNetworking.h"
#import "goodDeailView.h"
#import "SearchViewController.h"
#import "firstViewController.h"
#import "UMSocial.h"
#import "QRCodeGenerator.h"
#import "GoodBaseCell.h"
#import "AFHTTPSessionManager.h"
#import "thirdViewController.h"
#import "SureOrderController.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#import "UIColor+Hex.h"
#import "MyTabBarViewController.h"
#import "AFNetworkReachabilityManager.h"
#define Width self.view.frame.size.width
#define Height self.view.frame.size.height
#define toolHeight 60
#define topHeight 70
#define cellHeight 100
@interface goodDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIWebViewDelegate,sendRequestInfo,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    NSString * Price; //价格
    NSArray * myImage;//图片
    NSString * myName; //商品名
    NSString *numHao;//商品编号
    NSTimer * timer;//定时器
    NSString * Str; //webview的内容  html
    UIView * firstView;//顶部弹出视图
    BOOL careGood;//是否收藏
    BOOL changeWebColl;
    NSString * receNss;//接受key值的
    NSNumber* attenStr;//接受是否关注
    NSString * sttt;//页面进去后的默认颜色
    NSString * valueID;//加入购物车的id
    UIView * toolView;//加入购物车
    UIButton * buttonJb;//购物车按钮
    UILabel * careLab;//关注的字
    UIView * viewww;
}

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, strong) UIView * footView;
@property (nonatomic, strong) UIScrollView *scroll;//最大的容器scroll
@property (nonatomic, strong) UIWebView *webV;
@property (nonatomic, strong) UIScrollView * headScroll;//滚动图
@property (nonatomic, strong) UIPageControl * pagecontrol;
@property (nonatomic, strong) goodDeailView * goodVC;
@property (nonatomic, strong) UICollectionView * baseColl;//创建基本参数
@property (nonatomic, strong) NSMutableArray * basedata;//基本参数的数据源
@property (nonatomic, strong) NSDictionary * secondc; //侧边传来的数据
@property (nonatomic, copy) NSString * shuliang;
@property (nonatomic, strong) UIView * codeSmallView;
@end

@implementation goodDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    if (app.tempDic != nil) {
        [self.table reloadData];
        
    }
    
    
    if (app.tempDic == nil) {
        //未登录
        
    }else{
        [self myAccount];
    }
}

- (void)viewDidLoad {
    self.view.opaque=YES;
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    
    [tabbar hiddenTabbar:YES];
    
    [self initNavigationBar];
    [super viewDidLoad];
    [self createNav];
    [self creatUI];
    [self creatWeb];
    [self creatToolBar];
    [self creatTop];//创建弹出顶部视图视图UI
    [self creatDown];//创建弹出底部视图UI
    [self creatCode];//生成二维码视图
    [self afn];
    [self reloadRequest];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    _basedata=[[NSMutableArray alloc]init];
    //初始化webcollect
    changeWebColl=YES;
    
    //初始化收藏
    careGood=NO;
    //添加移除弹出视图的手势
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView:)];
    [self.view addGestureRecognizer:tap];
    
    self.goodVC=[[goodDeailView alloc]init];
    _goodVC.recevieId=self.goodID;
    
    [self.navigationController.view addSubview:self.goodVC.view];
    self.goodVC.view.frame=self.view.bounds;
    //右边栏结束
#pragma mark-通知数量颜色
    NSNotificationCenter *ncollect=[NSNotificationCenter defaultCenter];
    [ncollect addObserver:self selector:@selector(showcollect:) name:@"collect" object:nil];
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    receNss= app.tempDic[@"data"][@"key"];
#pragma mark-接受购物车数量
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"123" object:nil];
}
-(void)notice:(NSNotification *)notif
{
    NSDictionary * info=notif.userInfo;
    _shuliang=info[@"1234"];
    
}
-(void)showcollect:(NSNotification*)notify
{
    NSDictionary *info=notify.userInfo;
    
    _secondc=info[@"mycode"];
    
    if ([_secondc[@"myColor"] isEqualToString:@"(null)"]) {
            }else if (_secondc[@"myColor"]){
        _colorLab.text=_secondc[@"myColor"];
        Price=_secondc[@"myPrice"];
        valueID=_secondc[@"myId"];
        
    }
    _numLab.text=_secondc[@"myNum"];
    NSLog(@"%@",_secondc);
    [_table reloadData];
    //[self creatToolBar];
}
-(void)afn
{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [self createNoNet];
                // NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [self createNoNet];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [viewww removeFromSuperview];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [viewww removeFromSuperview];
                //
                break;
            default:
                break;
        }
    }];
}
-(void)createNoNet
{
    viewww=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    viewww.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    UIImageView * notImgView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-47, viewww.frame.size.height/2-149,94, 75)];
    UIImage * notImg=[UIImage imageNamed:@"ic_network_error.png"];
    notImg=[notImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    notImgView.image=notImg;
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-75, viewww.frame.size.height/2-64, 150 , 20)];
    label.numberOfLines=0;
    label.text=@"网络请求失败!";
    label.font=[UIFont systemFontOfSize:17];
    label.textColor=[UIColor lightGrayColor];
    label.textAlignment=NSTextAlignmentCenter;
    UIButton * notBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    notBtn.frame=CGRectMake(self.view.frame.size.width/2-55, viewww.frame.size.height/2-34, 110, 50);
    notBtn.layer.cornerRadius = 10.0;
    [notBtn.layer setBorderWidth:1];
    notBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    notBtn.backgroundColor=[UIColor whiteColor];
    [notBtn setTitle:@"重新加载" forState:UIControlStateNormal ];
    notBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [notBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [notBtn addTarget:self action:@selector(reloadNotNet) forControlEvents:UIControlEventTouchUpInside];
    [viewww addSubview:notImgView];
    [viewww addSubview:notBtn];
    [viewww addSubview:label];
    [self.view addSubview:viewww];
}
-(void)reloadNotNet
{
}
#pragma mark-创建主页面
-(void)creatUI
{
#pragma mark-table的设计搭建
    //创建头视图
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, (Height-64)/2)];
    //滚动广告
    _headView.opaque=YES;
    _headScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, (Height-64)/2)];
    _headScroll.delegate=self;
    _headScroll.pagingEnabled=YES;
    _headScroll.directionalLockEnabled=YES;
    //创建尾视图
    _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width,(Height-64)/2-cellHeight)];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, Width, 40);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    NSArray * titleArr=@[@"已选:",@"件"];
    for (int i=0; i<2; i++) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(5+50*i, 12, 30, 12)];
        lab.font=[UIFont systemFontOfSize:12];
        lab.textColor=[UIColor blackColor];
        lab.text=titleArr[i];
        [button addSubview:lab];
    }
#pragma mark-已选的结果
    _numLab=[[UILabel alloc]initWithFrame:CGRectMake(36, 12, 18, 12)];
    _numLab.font=[UIFont systemFontOfSize:12];
    _numLab.textColor=[UIColor blackColor];
    [button addSubview:_numLab];
    _colorLab=[[UILabel alloc]initWithFrame:CGRectMake(75, 12, 30, 12)];
    _colorLab.font=[UIFont systemFontOfSize:12];
    _colorLab.textColor=[UIColor blackColor];
    [button addSubview:_colorLab];
    
    [self.footView addSubview:button];
    // 继续向上拖动查看商品详情
    UIImage * imagedown=[UIImage imageNamed:@"btndown.png"];
     imagedown=[imagedown imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView * imageviewDown=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-7, 40, 15, 15)];
    imageviewDown.image=imagedown;
    UILabel * labeDown=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-60, 60, 120, 15)];
    labeDown.text=@"继续上拖查看商品详情";
    labeDown.textAlignment=NSTextAlignmentCenter;
    labeDown.font=[UIFont systemFontOfSize:12];
    labeDown.textColor=[UIColor lightGrayColor];
    [self.footView addSubview:imageviewDown];
    [self.footView addSubview:labeDown];

    //创建table
    _table=[[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _table.tableHeaderView=_headView;
    _table.tableFooterView=_footView;
    _table.delegate=self;
    _table.dataSource=self;
    //    _table.showsVerticalScrollIndicator =NO;//滚动条消失
    //添加
    [_headView addSubview:_headScroll];
    // [self.view addSubview:_table];
    //最大的容器_scroll
    _scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64, Width,Height+64)];
    _scroll.contentSize=CGSizeMake(0, Height*2);
    _scroll.delegate=self;
    _scroll.userInteractionEnabled=YES;
    _scroll.showsVerticalScrollIndicator =NO;//滚动条消失
    //创建web上的按钮
    NSArray * secondArr=@[@"图文详情",@"基本参数"];
    for (int i=0; i<2; i++) {
        UIButton * buttonVc=[UIButton buttonWithType:UIButtonTypeCustom];
        buttonVc.backgroundColor=[UIColor redColor];
        buttonVc.frame=CGRectMake(i*Width/2, Height, Width/2, 40);
        [buttonVc setTitle:secondArr[i] forState:UIControlStateNormal];
        if(i==0){
          [buttonVc setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else if (i==1){
        [buttonVc setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [buttonVc addTarget:self action:@selector(buttonChange:) forControlEvents:UIControlEventTouchUpInside];
        buttonVc.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        buttonVc.tag=75+i;
        [self.scroll addSubview:buttonVc];
    }
    //添加
    [self.scroll addSubview:_table];
    [self.view addSubview:self.scroll];
#pragma mark-MJ刷新详情
    //上拉刷新
    
    _scroll.scrollEnabled = NO;
    self.table.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            _scroll.scrollEnabled = YES;
            self.scroll.contentOffset = CGPointMake(0,Height);
            
        } completion:^(BOOL finished) {
            //结束加载
            _scroll.scrollEnabled = NO;
            [_table.mj_footer endRefreshing];
        }];
    }];
    
}
#pragma mark-webView的设置
-(void)creatCollect
{
    UICollectionViewFlowLayout * flow=[[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    _baseColl=[[UICollectionView alloc]initWithFrame:CGRectMake(0, Height+60, Width, Height-60) collectionViewLayout:flow];
    _baseColl.delegate=self;
    _baseColl.dataSource=self;
    _baseColl.backgroundColor=[UIColor whiteColor];
    [self.scroll addSubview:_baseColl];
    [_baseColl registerClass:[GoodBaseCell class] forCellWithReuseIdentifier:@"good"];
    self.baseColl.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _scroll.scrollEnabled = YES;
        self.scroll.contentOffset = CGPointMake(0,0);
        _scroll.scrollEnabled = NO;
        [self.baseColl.mj_header endRefreshing];
    }];
    
}

-(void)creatWeb{
    _webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, Height+64, Width, Height)];
    _webV.delegate=self;
    _webV.scalesPageToFit=YES;
    _webV.backgroundColor=[UIColor whiteColor];
    [self.scroll addSubview:_webV];
    self.webV.scrollView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _scroll.scrollEnabled = YES;
        self.scroll.contentOffset=CGPointMake(0, 0);
        _scroll.scrollEnabled = NO;
        [self.webV.scrollView.mj_header endRefreshing];
    }];
    
}
#pragma mark-code 二维码视图
-(void)creatCode
{
    _codeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, self.view.frame.size.height)];
    _codeView.backgroundColor= [UIColor colorWithWhite:0 alpha:0.5];
    _codeSmallView=[[UIView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height/2-self.view.frame.size.width/2+20, self.view.frame.size.width-40, self.view.frame.size.width-40)];
    _codeSmallView.backgroundColor=[UIColor whiteColor];
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(_codeSmallView.frame.size.width-50, 0, 40, 40);
    UIImage *image=[UIImage imageNamed:@"del"];
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(codeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_codeSmallView addSubview:button];
    showcodePoint=CGPointMake(Width/2, Height/2);
    hidecodePoint=CGPointMake(Width/2,2*self.view.frame.size.height);
    //设置子视图初始状态显示的位置
    _codeView.center=hidecodePoint;
    //设置初始状态子视图的状态;
    self.CState=DownHide;
    [_codeView addSubview:_codeSmallView];
    [self.view addSubview:_codeView];
}
#pragma mark-top弹出气泡设计
-(void)creatDown
{
    _downView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, self.view.frame.size.height)];
    _downView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    NSArray * titleArr=@[@"分享给好友",@"二维码"];
    NSArray * imageArr=@[@"share_friend",@"share_erweima"];
    UIView *myDownView=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-73, Width, 73)];
    myDownView.backgroundColor=[UIColor whiteColor];
    
    for (int i=0; i<2; i++) {
       
        
        UILabel * labb=[[UILabel alloc]initWithFrame:CGRectMake(7+i*(40+18), 52,50, 9)];
        labb.backgroundColor=[UIColor whiteColor];
        labb.font=[UIFont systemFontOfSize:9];
        labb.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        labb.text=titleArr[i];
        labb.textAlignment=NSTextAlignmentCenter;
        
        UIImage * image=[UIImage imageNamed:imageArr[i]];
        image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(12+i*(40+18), 10, 40, 40);
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=100000+i;
        [myDownView addSubview:button];
        [myDownView addSubview:labb];
            }
    [_downView addSubview:myDownView];

    show2Point=CGPointMake(Width/2,self.view.frame.size.height/2);
    hide2Point=CGPointMake(Width/2,2*self.view.frame.size.height);
    //设置子视图初始状态显示的位置
    _downView.center=hide2Point;
    //设置初始状态子视图的状态;
    self.state3=DownHide;
    //[toolView insertSubview:_downView aboveSubview:toolView];
    // [self.view addSubview:_downView];
    [self.view addSubview:_downView];
}
#pragma mark-创建分享搜索首页这三个按钮
-(void)creatTop
{
    _topView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, Width,self.view.frame.size.height-64)];
    _topView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    NSArray * titleArr=@[@"分享",@"搜索",@"首页"];
    NSArray * imageArr=@[@"fenxiang",@"detailsuo",@"shouye"];
    for (int i=0; i<3; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(i*Width/3, 0, Width/3, topHeight);
        button.backgroundColor=[UIColor whiteColor];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        button.titleEdgeInsets=UIEdgeInsetsMake(30,-18, 10, 40);
        button.imageEdgeInsets=UIEdgeInsetsMake(0, 20, 25, 20);
        [button addTarget:self action:@selector(topClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=10000+i;
        [_topView addSubview:button];
    }
    showPoint=CGPointMake(Width/2,(self.view.frame.size.height+64)/2);
    hidePoint=CGPointMake(Width/2,-self.view.frame.size.height/2);
    //设置子视图初始状态显示的位置
    _topView.center=hidePoint;
    //设置初始状态子视图的状态;
    self.state=TopViewStateHide;
    //    [self.navigationController.view insertSubview:_topView aboveSubview:self.navigationController.navigationBar];
    [self.view addSubview:_topView];
}
#pragma mark-关注,购物车,加入购物车,立刻购买;toolBar的设计
-(void)creatToolBar
{
    toolView=[[UIView alloc]initWithFrame:CGRectMake(0, Height-toolHeight, Width, toolHeight)];
    toolView.backgroundColor=[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0];
    CGFloat size=self.view.frame.size.width/6;
    NSArray * arr=@[@"关注",@"购物车",@"加入购物车",@"立刻购买"];
    UIImage * imagerr;
    
    NSString * strrr;
    strrr=[attenStr stringValue];
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, size, 40);
    imagerr=[UIImage imageNamed:@"关注icon"];
    imagerr=[imagerr imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:imagerr forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonNext:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=1500;
    careLab=[[UILabel alloc]initWithFrame:CGRectMake(0, toolHeight-25, size, 15)];
    careLab.text=@"关注";
    careLab.textAlignment=NSTextAlignmentCenter;
    careLab.font=[UIFont systemFontOfSize:12];
    careLab.textColor=[UIColor whiteColor];
    if ([strrr isEqualToString:@"0"]) {
        imagerr=[UIImage imageNamed:@"关注icon"];
        imagerr=[imagerr imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:imagerr forState:UIControlStateNormal];
        careLab.text=@"关注";
    }
    else if ([strrr isEqualToString:@"1"])
    {
        imagerr=[UIImage imageNamed:@"已关注icon"];
        imagerr=[imagerr imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:imagerr forState:UIControlStateNormal];
        //careLab.frame=CGRectMake(10, toolHeight-25, 40, 15);
        careLab.text=@"已关注";
    }
    [toolView addSubview:button];
    [toolView addSubview:careLab];
    
    buttonJb=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonJb.frame=CGRectMake(size, 0, size, 40);
    [buttonJb addTarget:self action:@selector(buttonNext:) forControlEvents:UIControlEventTouchUpInside];
    buttonJb.tag=1501;
    imagerr=[UIImage imageNamed:@"tab2"];
    imagerr=[imagerr imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [buttonJb setImage:imagerr forState:UIControlStateNormal];
    UILabel * labe2=[[UILabel alloc]initWithFrame:CGRectMake(size, toolHeight-25, size, 15)];
    labe2.text=@"购物车";
    labe2.font=[UIFont systemFontOfSize:12];
    labe2.textAlignment=NSTextAlignmentCenter;
    labe2.textColor=[UIColor whiteColor];
    [toolView addSubview:labe2];
    [toolView addSubview:buttonJb];
    
    
    
    for (int i=2; i<4; i++)
    {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(2*size+2*(i-2)*size,  0, 2*size, toolHeight);
        [button setTitle:arr[i] forState:UIControlStateNormal];
        if(i==2)
        {
            button.backgroundColor=[UIColor colorWithRed:52/255.0 green:151/255.0 blue:233/255.0 alpha:1.0];
        }else{
            button.backgroundColor=[UIColor colorWithRed:231/255.0 green:37/255.0 blue:73/255.0 alpha:1.0];
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag=1500+i;
        [button addTarget:self action:@selector(buttonNext2:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:button];
    }
    [self.view addSubview:toolView];
}
#pragma mark-tableview请求数据
-(void)reloadRequest
{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    receNss= app.tempDic[@"data"][@"key"];
    NSDictionary *dict;
    NSString *api_token = [RequestModel model:@"goods" action:@"goodsinfo"];
    if (receNss==NULL) {
        dict = @{@"api_token":api_token,@"goods_id":self.goodID};
    }else if (receNss!=NULL){
        dict = @{@"api_token":api_token,@"goods_id":self.goodID,@"key":receNss};
    }
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"goodsinfo" block:^(id result) {
        [weakSelf sendMessage:result];
    }];
}
#pragma mark-请求数据
-(void)sendMessage:(id)message
{
    NSDictionary *dic=message[@"data"];
    NSDictionary * dddd=[[NSDictionary alloc]init];
    if (dic[@"attribute"] != nil) {
        dddd=dic[@"attribute"];
        if (dddd.count!=0) {
            sttt=dic[@"attribute"][0][@"attr_value"][0][@"attr_value_name"];
            valueID=dic[@"attribute"][0][@"attr_value"][0][@"attr_value_id"];
            _colorLab.text=sttt;
        }
    }
    
    NSDictionary * eeee=[[NSDictionary alloc]init];
    eeee=dic[@"param"];
    if (eeee.count!=0) {
        _basedata=dic[@"param"];
    }
    
    //拿到页面进去后的
    _numLab.text=@"1";
    Price=dic[@"shop_price"];
    myName=dic[@"goods_name"];
    myImage=dic[@"album"];
    attenStr=dic[@"is_attention"];
   //
    [self creatToolBar];
    Str=dic[@"content"];
    NSString *strHTML=Str;
    [_webV loadHTMLString:strHTML baseURL:nil];
    [self addImage];
    if ( myImage.count!=1) {
        [self addTimer];
        [self addPageController];
    }
    [_webV reload];
    [_table reloadData];
    [_baseColl reloadData];
    NSLog(@"%@",Price);
}
#pragma mark-图文详情,基本参数
-(void)buttonChange:(UIButton*)sender
{
    UIButton * btn1=(UIButton *)[self.scroll viewWithTag:75];
    UIButton * btn2=(UIButton *)[self.scroll viewWithTag:76];
    UIButton * btn=(UIButton *)sender;
    if (btn.tag==75)
    {
        [self.baseColl removeFromSuperview];
        [self creatWeb];
        NSString *strHTML=Str;
        [_webV loadHTMLString:strHTML baseURL:nil];
        [_webV reload];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else if (btn.tag==76)
    {
        [_webV removeFromSuperview];
        [self creatCollect];
        
        [_baseColl reloadData];
        [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}
#pragma mark-collect基本参数代理实现
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_basedata.count!=0) {
        return _basedata.count;
    }else
        return 1;
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * good=@"good";
    GoodBaseCell * cell=[collectionView  dequeueReusableCellWithReuseIdentifier:good forIndexPath:indexPath];
    cell.layer.borderColor=[UIColor darkGrayColor].CGColor;
    cell.layer.borderWidth=0.3;
    if (_basedata.count!=0) {
        cell.baseLab.text=_basedata[indexPath.item][@"attr_name"];
        cell.valueLab.text=_basedata[indexPath.item][@"attr_value"];
        return cell;
    }else
        
        return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Width, 30);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark-广告轮播实现
//滚动的图片
-(void)addImage
{
    UIImageView *iconImage;
    if (myImage.count>=1)
    {
        for (int i=0; i<myImage.count+2; i++) {
            if (i==0) {
                iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, _headScroll.frame.size.height)];
                iconImage.contentMode = UIViewContentModeScaleAspectFit;
                [iconImage setImageWithURL:[NSURL URLWithString:myImage[0]]];
            }else if(i==myImage.count+1){
                iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*Width, 0, Width, _headScroll.frame.size.height)];
                iconImage.contentMode = UIViewContentModeScaleAspectFit;
                [iconImage setImageWithURL:[NSURL URLWithString:myImage[0]]];
            }else{
                iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*Width, 0, Width, _headScroll.frame.size.height)];
                iconImage.contentMode = UIViewContentModeScaleAspectFit;
                [iconImage setImageWithURL:[NSURL URLWithString:myImage[i-1]]];
            }
            [_headScroll addSubview:iconImage];
        }
        _headScroll.contentSize=CGSizeMake(Width*(myImage.count+2), _headScroll.frame.size.height);
        _headScroll.contentOffset=CGPointMake(Width,0);
    }
    else
    {
        _headScroll.contentSize=CGSizeMake(Width, _headScroll.frame.size.height);
        _headScroll.contentOffset=CGPointMake(Width,0);
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView== _headScroll) {
        if (timer) {
            [timer invalidate];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (myImage.count>=1)
    {
        if (scrollView== _headScroll) {
            if (scrollView.contentOffset.x/ _headScroll.frame.size.width==(myImage.count+1)) {
                scrollView.contentOffset=CGPointMake( _headScroll.frame.size.width,0);
                _pagecontrol.currentPage=0;
            }else if(scrollView.contentOffset.x==0){
                scrollView.contentOffset=CGPointMake(myImage.count* _headScroll.frame.size.width, 0);
                _pagecontrol.currentPage=myImage.count;
              //  [self creatToolBar];
            }else
            {
                _pagecontrol.currentPage=scrollView.contentOffset.x/_headScroll.frame.size.width-1;
            }
        }
    }
    else
    {
        _pagecontrol.currentPage=1;;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
#pragma mark-pagecontroller
-(void)addPageController
{
    _pagecontrol = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _headScroll  .frame.size.height-20, Width, 20)];
    //需要显示多少白点
    _pagecontrol.numberOfPages = 5;
    _pagecontrol.backgroundColor = [UIColor blackColor];
    _pagecontrol.pageIndicatorTintColor = [UIColor whiteColor];
    _pagecontrol.currentPageIndicatorTintColor = [UIColor blueColor];
    [_headScroll addSubview:_pagecontrol];
}
#pragma mark-定时器2秒
-(void)addTimer
{
    if (timer!=nil) {
        [timer invalidate];
    }
    timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
}
-(void)timeAction:(NSTimer*)timer
{
    if (_headScroll.contentOffset.x/_scroll.frame.size.width==(myImage.count+1)) {
        [_headScroll setContentOffset:CGPointMake(_headScroll.frame.size.width, 0)animated:NO ];
        _pagecontrol.currentPage=0;
    }else if (_headScroll.contentOffset.x == 0){
        [_headScroll setContentOffset:CGPointMake(5*_headScroll.frame.size.width, 0) animated:NO];
        _pagecontrol.currentPage = 5;
    }else{
        [_headScroll setContentOffset:CGPointMake(_headScroll.contentOffset.x+_headScroll.frame.size.width, 0) animated:YES];
    }
}
#pragma mark-tableview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string=@"string";
    DetailTableCell *cell=[tableView dequeueReusableCellWithIdentifier:string];
    if (cell==nil) {
        cell=[[DetailTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.layer.borderWidth=0.3;
    cell.lab1.text=myName;
    cell.lab2.text=Price;
    cell.monSign.text=@"￥";
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
#pragma mark-创建导航条
-(void)createNav
{
    
    self.navigationItem.title=@"商品详情";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(bitBtn)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gengduo"] style:UIBarButtonItemStyleDone target:self action:@selector(sendBbtn:)];
    
    
}

#pragma mark-继续向上拖动查看商品详情
-(void)btndown:(id)sender
{
    
}
#pragma mark-关注,查看购物车点击事件
-(void)buttonNext:(UIButton*)sender
{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    receNss= app.tempDic[@"data"][@"key"];
    UIButton * button=(UIButton *)sender;
    NSString *strrr;
    strrr=[attenStr stringValue];
    if (button.tag==1500) {
        //关注
        if (receNss!=NULL)
        {
            if (careGood==NO)
            {
                UIImage * imagerr=[UIImage imageNamed:@"已关注icon"];
                //                careLab.frame=CGRectMake(10, toolHeight-25, 40, 15);
                careLab.text=@"已关注";
                imagerr=[imagerr imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [button setImage:imagerr forState:UIControlStateNormal];
                
                NSString *api_token = [RequestModel model:@"goods" action:@"collect"];
                // strr=@"0";
                NSDictionary *dict = @{@"api_token":api_token,@"goods_id":self.goodID,@"key":receNss};
                [RequestModel requestWithDictionary:dict model:@"goods" action:@"collect" block:^(id result) {
                    
                }];
                careGood=YES;
                
            }
            else if (careGood==YES)
            {
                UIImage * imagerr=[UIImage imageNamed:@"关注icon"];
                //                careLab.frame=CGRectMake(15, toolHeight-25, 40, 15);
                careLab.text=@"关注";
                imagerr=[imagerr imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [button setImage:imagerr forState:UIControlStateNormal];
                
                NSString *api_token = [RequestModel model:@"goods" action:@"qcollect"];
                // strr=@"0";
                NSDictionary *dict = @{@"api_token":api_token,@"goods_id":self.goodID,@"key":receNss};
                [RequestModel requestWithDictionary:dict model:@"goods" action:@"qcollect" block:^(id result) {
                    
                }];
                
                careGood=NO;
            }
        }
        else if (receNss==NULL)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,登录之后才能关注哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    else if(button.tag==1501)
    {
        thirdViewController * third=[[thirdViewController alloc]init];
        third.temp = @"1";
        [self.navigationController pushViewController:third animated:NO];
        
    }
    
}
#pragma mark-加入购物车,立刻购买点击事件
-(void)buttonNext2:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString * receNs= app.tempDic[@"data"][@"key"];
    //加入购物车
    if (btn.tag==1502)
    {
        if (receNs!=NULL) {
            //            NSMutableDictionary * valueDic=[[NSMutableDictionary alloc]init];
            //            NSString * strr;
            NSString * path1;
            if (valueID!=NULL) {
                //                [valueDic setObject:[NSString stringWithFormat:@"%@",valueID]forKey:@"attr_value_id"];
                //                strr=[valueDic JSONString];
                //                path1=[strr  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                path1 = [NSString stringWithFormat:@"[%@]",valueID];
            }else if (valueID==NULL)
            {
                path1=[NSString stringWithFormat:@""];
            }
            
            
            //  NSString * path2=[receNs stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            
            NSString *api_token = [RequestModel model:@"goods" action:@"addcart"];
            // strr=@"0";
            NSDictionary *dict;
            dict= @{@"api_token":api_token,@"goods_id":self.goodID,@"key":receNss,@"num":_numLab.text,@"attrvalue_id":path1};
            [RequestModel requestWithDictionary:dict model:@"goods" action:@"addcart" block:^(id result) {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"加入购物车成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }];
            
        }
        else if (receNs==NULL)
        {
            LoginViewController *login=[[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
    //立刻购买
    else if (btn.tag==1503)
    {
        if (receNs!=NULL) {
            SureOrderController * sure=[[SureOrderController alloc]init];
            sure.sureId=self.goodID;
            if (valueID!=NULL) {
                sure.smallId=valueID;
            }else if (valueID==NULL)
            {
                sure.smallId=[NSString stringWithFormat:@""];
            }
            
            sure.shopNum=self.numLab.text;
            [self.navigationController pushViewController:sure animated:YES];
        }else if (receNs==NULL)
        {
            LoginViewController *login=[[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }
        
    }
}
//返回上一页的点击事件
-(void)bitBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-侧边栏出现
-(void)buttonClick:(id)sender
{
    // self.goodVC.recevieId=@"9";
    [self.goodVC showHideSlidebar];
    
}
#pragma mark-跳转出分享,二维码
-(void)downClick:(id)sender
{
    self.state3=DownHide;
    self.downView.center=hide2Point;
    UIButton *btn=(UIButton*)sender;
    if (btn.tag==100000)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSString *url = data[@"shareurl"];
        NSString *UMSharekey = data[@"UMSharekey"];
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMSharekey
                                          shareText:myName
                                         shareImage:[UIImage imageNamed:@"null_head"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ,UMShareToTencent,nil]
                                           delegate:nil];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url=url;
        [UMSocialData defaultData].extConfig.qzoneData.url=url;
        [UMSocialData defaultData].extConfig.qqData.url=url;
    }
    else if(btn.tag==100001)
    {
        self.CState=codeShow;
        self.codeView.center=showcodePoint;
        UIImageView * myimageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, _codeSmallView.frame.size.width-20, _codeSmallView.frame.size.width-20)];
        myimageview.image=[QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"goods_id:%@", _goodID] imageSize:_codeSmallView.frame.size.width-20];
        [_codeSmallView addSubview: myimageview];

    }
}
#pragma mark-关闭二维码
-(void)codeClick:(id)sender
{
    self.CState=codeHide;
    self.codeView.center=hidecodePoint;
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
#pragma mark-分享,搜索,首页的点击事件
-(void)topClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    if (btn.tag==10000) {
        self.state=TopViewStateHide;
        self.topView.center=hidePoint;
        self.state3=DownShow;
        self.downView.center=show2Point;
        [toolView removeFromSuperview];
    }else if (btn.tag==10001)
    {
        SearchViewController * search=[[SearchViewController alloc]init];
        [self.navigationController pushViewController:search animated:YES];
    }else if (btn.tag==10002)
    {
        
        MyTabBarViewController * tabBarViewController = (MyTabBarViewController * )self.tabBarController;
        UINavigationController * nav = [tabBarViewController.viewControllers objectAtIndex:0];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [nav popToRootViewControllerAnimated:YES];
        
        UIButton * button = [[UIButton alloc]init];
        button.tag = 100;
        [tabBarViewController buttonClicked:button];
    }
}
-(void)buttonclik:(id)sender
{
    
    
}
#pragma mark-导航栏右item点击事件
-(void)sendBbtn:(id)sender
{
    self.state=TopViewStateShow;
    self.topView.center=showPoint;
}
#pragma mark-移除视图
-(void)removeView:(UITapGestureRecognizer*)tap
{
    self.topView.center = hidePoint;
    self.state=TopViewStateHide;
    self.downView.center=hide2Point;
    self.state3=DownHide;
    self.codeView.center=hidecodePoint;
    self.CState=codeHide;
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
#pragma mark--我的资料数据请求
-(void)myAccount{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"user" action:@"userinfo"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"]};
    [RequestModel requestWithDictionary:dict model:@"user" action:@"userinfo" block:^(id result) {
        NSDictionary *dic = result;
        
        for (NSMutableDictionary *dict in dic[@"data"]) {
            
            
#pragma mark-购物车气泡
            
            UIView *smallView1 = [[UIView alloc]initWithFrame:CGRectMake(buttonJb.frame.size.width - 35, 3, 12, 12)];
            smallView1.backgroundColor = [UIColor redColor];
            [smallView1.layer setCornerRadius:6];
            UILabel *smallLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
            smallLab1.font = [UIFont systemFontOfSize:8];
            NSString *numStr = [NSString stringWithFormat:@"%@",dict[@"cart_num"]];
            smallLab1.text = numStr;
            smallLab1.textAlignment = NSTextAlignmentCenter;
            smallLab1.textColor = [UIColor whiteColor];
            [smallView1 addSubview:smallLab1];
            [buttonJb addSubview:smallView1];
            
        }
        
        
    }];
}

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
    label.text = @"商品详情";
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
    
    UIImage *img1 = [UIImage imageNamed:@"gengduo"];
    img1=[img1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 25, 40, 40)];
    [btn1 addTarget:self action:@selector(sendBbtn:) forControlEvents:UIControlEventTouchUpInside];
   
    [btn1 setImage:img1 forState:UIControlStateNormal];
    [view addSubview:btn1];
    
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
