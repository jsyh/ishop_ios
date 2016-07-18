//
//  integralExchangeViewController.m
//  ecshop
//
//  Created by Jin on 16/5/31.
//  Copyright © 2016年 jsyh. All rights reserved.
//积分兑换

#import "integralExchangeViewController.h"
#import "MJRefresh.h"
#import "RequestModel.h"
#import "UIImageView+AFNetworking.h"
#import "goodDeailView.h"
#import "GXCustomButton.h"
#import "SearchViewController.h"
#import "firstViewController.h"
#import "UMSocial.h"
#import "QRCodeGenerator.h"
#import "GoodBaseCell.h"
#import "AFHTTPSessionManager.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#import "UIColor+Hex.h"
#import "MyTabBarViewController.h"
#import "SettingViewCell.h"
#import "EvaluateTableViewCell.h"
#import "ShopTableViewCell.h"
#import "CommentModel.h"
#import "EvaluateViewController.h"
#import "GoShopViewController.h"
#import "SureOrderIntegralViewController.h"
#import "GoodsCarViewController.h"
#import "GoodsDetailTableViewCell.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define H(b) Height * b / 667.0
#define W(a) Width * a / 375.0
#define toolHeight 49
#define topHeight 70
#define cellHeight 120

@interface integralExchangeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIWebViewDelegate,sendRequestInfo,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    
    
    /**
     *  商品价格
     */
    NSString *shopPrice;
    /**
     *  商品编号
     */
    NSString *goodsSn;
    /**
     *  商品名称
     */
    NSString *goodsName;
    /**
     *  商品ID
     */
    NSString *goodsID;
    /**
     *  商品可选属性（属性不同价格不同）
     */
    NSMutableArray *attribute;
    NSString *goodsIntegral;//商品的积分
    /**
     *  剩余库存
     */
    int repertory;
    /**
     *  图文信息
     */
    NSString *goodsContent;
    /**
     *  基本参数
     */
    NSMutableArray *param;
    /**
     *  轮播图图片
     */
    NSArray * myImage;
    /**
     *  已销售的数量
     */
    int sales;
    /**
     *  商品是否关注1是0否 登录之后返回
     */
    NSNumber *isAttention;
    /**
     *  店铺logo
     *  店铺url
     */
    NSString *shoplogo;
    NSString *shopUrl;
    /**
     *  店铺名称
     */
    NSString *shopname;
    /**
     *  地址
     */
    NSString *shopAddress;
    /**
     *  商家id id为0则不显示商家信息
     */
    NSString *supplierID;
    /**
     *  商家等级
     */
    NSString *shopRank;
    NSString *shopID;//商店id
    /**
     *  新上商品数
     */
    int newGoods;
    /**
     *  店铺是否关注 0 未关注 1 关注 2是未登录
     */
    int attention;
    /**
     *  商家全部商品
     */
    int allGoods;
    int supplierSum;//关注商品人数
    /**
     *  手机号
     */
    NSString *servicephone;
    /**
     *  商品评论(用户名，内容，星级，时间和回复数)
     */
    NSMutableDictionary *comments;
    
    /**
     *  发货地址
     */
    NSString *address;
    /**
     * 评论等级
     */
    NSString *commentsRank;
    NSString *goodConment;
    NSString *badConment;
    NSString *mediumConment;
    
    NSString *changeColor;//选择尺码颜色等
    
    
    NSTimer * timer;//定时器
    BOOL careGood;//是否收藏
    BOOL changeWebColl;
    NSString * receNss;//接受key值的
    NSString * valueID;//加入购物车的id

    UIView * toolView;//加入购物车
    UIView *goodsDetailsDownView;//从底部弹出的选择商品信息的视图
    int tagg;
    UIView *downView1;
    
    /**
     * 加入购物车
     * buySum      购买的数量
     * allProperty 购买的属性
     * notChange   未选择的属性
     */
    NSString *buySum;
    NSString *allProperty;
    NSString *notChange;
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
@property (nonatomic, strong) NSString * shuliang;
@property (nonatomic, strong) UIView *navView;//导航栏
@property(nonatomic,strong)NSMutableArray *commentArray;//评论数组
@property(nonatomic,strong)UIView *backView;//左上角返回按钮背景
@property(nonatomic,strong)UIView *buyCarView;//右上角购物车背景
@property(nonatomic,strong)UIButton *backBtn1;//返回按钮
@property(nonatomic,strong)UIButton *backBtn2;
@property(nonatomic,strong)UIButton *buyCarBtn1;//右上角购物车
@property(nonatomic,strong)UIButton *buyCarBtn2;
@property(nonatomic,strong)NSString *propertyID;//商品属性id
@property(nonatomic,strong)NSString *intetration;//拥有的积分
@end

@implementation integralExchangeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    if (app.tempDic != nil) {
        [self.table reloadData];
      
        [self myAccount];
    }
}
- (void)viewDidLoad {
    self.view.opaque=YES;
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [tabbar hiddenTabbar:YES];
    
    
    [super viewDidLoad];
    
    [self creatUI];
    [self initNavigationBar];
    [self reloadRequest];
    [self creatWeb];
    
    /**
     *   创建弹出底部视图UI
     */
    [self creatDown];
    /**
     *   生成二维码视图
     */
    [self creatCode];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    _basedata=[[NSMutableArray alloc]init];
    //_colorArr=[[NSMutableArray alloc]init];
    //初始化webcollect
    changeWebColl=YES;
    //右边栏结束
    //初始化收藏
    careGood=NO;
    
    self.goodVC=[[goodDeailView alloc]init];
    _goodVC.recevieId=self.goodID;
    _goodVC.type = @"3";
    [self.navigationController.view addSubview:self.goodVC.view];
    self.goodVC.view.frame=self.view.bounds;
    //右边栏结束
#pragma mark-通知数量颜色
    
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    receNss= app.tempDic[@"data"][@"key"];
#pragma mark-接受购物车数量
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个a观察者，name和object设置为nil，表示接收一切通知
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
        shopPrice = _secondc[@"myPrice"];
        valueID=_secondc[@"myId"];
        
    }
    _numLab.text=_secondc[@"myNum"];
    NSLog(@"%@",_secondc);
    [_table reloadData];
    
}

#pragma mark-创建主页面
-(void)creatUI
{
#pragma mark-table的设计搭建
    //创建头视图
    //    float a704 = 704.0/1334.0;
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 352)];
    //滚动广告
    _headView.opaque=YES;
    _headScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, 352)];
    _headScroll.showsVerticalScrollIndicator = FALSE;
    _headScroll.showsHorizontalScrollIndicator = FALSE;
    _headScroll.opaque=YES;
    _headScroll.delegate=self;
    _headScroll.pagingEnabled=YES;
    _headScroll.directionalLockEnabled=YES;
    //    [self addTimer];
    //创建尾视图
    _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width,100)];
    _footView.opaque=YES;
    float a = 176.0/750.0;
    // 继续向上拖动查看商品详情
    UIButton * btndown=[UIButton buttonWithType:UIButtonTypeCustom];
    btndown.opaque=YES;
    btndown.frame=CGRectMake(0, 0, self.view.frame.size.width, 40);
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(12, btndown.center.y, Width*a, 1)];
    leftView.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [btndown addSubview:leftView];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(Width-Width*a-12, btndown.center.y, Width*a, 1)];
    rightView.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [btndown addSubview:rightView];
    [btndown setTitle:@"继续拖动，查看图文详情" forState:UIControlStateNormal];
    // btndown.titleLabel.textAlignment=NSTextAlignmentCenter;
    btndown.titleLabel.font=[UIFont systemFontOfSize:12];
    btndown.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [btndown setTitleColor:[UIColor colorWithHexString:@"#43464C"] forState:UIControlStateNormal];
    btndown.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_footView addSubview:btndown];
    //创建table
    _table=[[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _table.allowsSelection = NO;
    _table.tableHeaderView=_headView;
    _table.tableFooterView=_footView;
    _table.delegate=self;
    _table.dataSource=self;
    [_table setShowsVerticalScrollIndicator:NO];
    [self.table addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew
                    context:nil];
    
    //    _table.showsVerticalScrollIndicator =NO;//滚动条消失
    //添加
    [_headView addSubview:_headScroll];
    // [self.view addSubview:_table];
    //最大的容器_scroll
    _scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, Width,Height+84)];
    _scroll.contentSize=CGSizeMake(0, Height*2);
    _scroll.delegate=self;
    _scroll.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    _scroll.userInteractionEnabled=YES;
    _scroll.showsVerticalScrollIndicator =NO;//滚动条消失
    
    //创建web上的按钮
    NSArray * secondArr=@[@"图文详情",@"基本参数"];
    for (int i=0; i<2; i++) {
        UIButton * buttonVc=[UIButton buttonWithType:UIButtonTypeCustom];
        buttonVc.frame=CGRectMake(i*Width/2, Height+64, Width/2, 40);
        [buttonVc setTitle:secondArr[i] forState:UIControlStateNormal];
        [buttonVc setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        
        [buttonVc addTarget:self action:@selector(buttonChange:) forControlEvents:UIControlEventTouchUpInside];
        buttonVc.backgroundColor=[UIColor whiteColor];
        buttonVc.tag=75+i;
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width/2, 1)];
        view1.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
        [buttonVc addSubview:view1];
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, Width/2, 1)];
        view2.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
        [buttonVc addSubview:view2];
        [self.scroll addSubview:buttonVc];
    }
    //添加
    [self.scroll addSubview:_table];
    
    [self.view addSubview:self.scroll];
#pragma mark-MJ刷新详情
    //上拉刷新
    
    _scroll.scrollEnabled = NO;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    footer.refreshingTitleHidden = YES;
    self.table.mj_footer = footer;
    
    
    //    self.table.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
    //            _scroll.scrollEnabled = YES;
    //            self.scroll.contentOffset = CGPointMake(0,Height);
    //
    //        } completion:^(BOOL finished) {
    //            //结束加载
    //            _scroll.scrollEnabled = NO;
    //            [_table.mj_footer endRefreshing];
    //        }];
    //    }];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateColor:) name:@"property" object:nil];
}
-(void)footerRefreshAction{
    self.scroll.contentOffset = CGPointMake(0,Height);
    _scroll.scrollEnabled = NO;
    [_table.mj_footer endRefreshing];
}
#pragma mark --观察者更新选择的颜色等信息
-(void)updateColor:(NSNotification *)sender{
    NSDictionary *dic = sender.userInfo;
    NSLog(@"%@",dic);
    buySum = dic[@"buySum"];
    allProperty = dic[@"allProperty"];
    notChange = dic[@"notChange"];
    _propertyID=dic[@"propertyID"];
    
    if (notChange == nil) {
        if (allProperty.length>0) {
            changeColor = [NSString stringWithFormat:@"已选“%@件%@”",buySum,allProperty];
        }
        
    }else{
        changeColor = [NSString stringWithFormat:@"已选“%@件%@,未选%@”",buySum,allProperty,notChange];
    }
    [_table reloadData];
}

#pragma mark-webView的设置
-(void)creatCollect
{
    UICollectionViewFlowLayout * flow=[[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    _baseColl=[[UICollectionView alloc]initWithFrame:CGRectMake(0, Height+104, Width, Height-104-toolHeight) collectionViewLayout:flow];
    _baseColl.delegate=self;
    _baseColl.dataSource=self;
    _baseColl.backgroundColor=[UIColor colorWithHexString:@"F2F2F2"];
    [self.scroll addSubview:_baseColl];
    [_baseColl registerClass:[GoodBaseCell class] forCellWithReuseIdentifier:@"good"];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshColl)];
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"释放回到商品详情" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    
    
    self.baseColl.mj_header=header;
    
}
-(void)refreshColl{
    _scroll.scrollEnabled = YES;
    self.scroll.contentOffset=CGPointMake(0, 0);
    _scroll.scrollEnabled = NO;
    [self.baseColl.mj_header endRefreshing];
}
-(void)creatWeb{
    _webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, Height+104, Width, Height-104-toolHeight)];
    _webV.delegate=self;
    _webV.scalesPageToFit=YES;
    _webV.backgroundColor=[UIColor clearColor];
    for (UIView *subView in [_webV subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            //            ((UIScrollView *)subView).bounces = NO;// 去掉uiwebview的底图
            [(UIScrollView *)subView setShowsHorizontalScrollIndicator:NO];
            [(UIScrollView *)subView setShowsVerticalScrollIndicator:NO];
            //            for (UIView *scrollview in subView.subviews) {
            //                if ([scrollview isKindOfClass:[UIImageView class]]) {
            //                    scrollview.hidden = YES;
            //                }
            //            }
        }
    }
    [self.scroll addSubview:_webV];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"释放回到商品详情" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    
    self.webV.scrollView.mj_header = header;
    
    
}
-(void)refreshAction{
    self.scroll.contentOffset=CGPointMake(0, 0);
    _scroll.scrollEnabled = NO;
    [self.webV.scrollView.mj_header endRefreshing];
}
#pragma mark-code 二维码视图
-(void)creatCode
{
    _codeView=[[UIView alloc]initWithFrame:CGRectMake(20, 140, Width-40, Width-20)];
    _codeView.backgroundColor= [UIColor colorWithWhite:0 alpha:0.5];
    self.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(Width-80, 12, 40, 40);
    UIImage *image=[UIImage imageNamed:@"goods_detail_close"];
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(codeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_codeView addSubview:button];
    showcodePoint=CGPointMake(Width/2, Height/2);
    hidecodePoint=CGPointMake(Width/2, Height+(Width+20)/2);
    //设置子视图初始状态显示的位置
    _codeView.center=hidecodePoint;
    //设置初始状态子视图的状态;
    self.CState=DownHide1;
    [self.view addSubview:_codeView];
}
#pragma mark-top弹出气泡设计
-(void)creatDown
{
    
    _downView=[[UIView alloc]initWithFrame:CGRectMake(0, Height-topHeight, Width, topHeight)];
    _downView.backgroundColor=[UIColor whiteColor];
    self.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    NSArray * titleArr=@[@"分享给好友",@"二维码"];
    NSArray * imageArr=@[@"share_friend",@"share_erweima"];
    for (int i=0; i<2; i++) {
        UILabel * labb=[[UILabel alloc]initWithFrame:CGRectMake(i*Width/4, topHeight-H(20), Width/4, H(15))];
        labb.font=[UIFont systemFontOfSize:W(12)];
        labb.textColor=[UIColor blackColor];
        labb.text=titleArr[i];
        labb.textAlignment=NSTextAlignmentCenter;
        
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(i*Width/4, H(0), Width/4, topHeight-H(20));
        button.backgroundColor=[UIColor clearColor];
        button.titleLabel.font=[UIFont systemFontOfSize:W(12)];
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=100000+i;
        [_downView addSubview:button];
        [_downView addSubview:labb];
    }
    show2Point=CGPointMake(Width/2, Height-topHeight/2);
    hide2Point=CGPointMake(Width/2, Height+topHeight/2);
    //设置子视图初始状态显示的位置
    _downView.center=hide2Point;
    //设置初始状态子视图的状态;
    self.state3=DownHide1;
    //[toolView insertSubview:_downView aboveSubview:toolView];
    // [self.view addSubview:_downView];
    downView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    downView1.backgroundColor = [UIColor blackColor];
    downView1.alpha = 0.1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downBack)];
    [downView1 addGestureRecognizer:tap];
    downView1.hidden = YES;
    [self.view addSubview:downView1];
    [self.view addSubview:_downView];
    
}

#pragma mark-关注,购物车,加入购物车,立刻购买;toolBar的设计
-(void)creatToolBar
{
    toolView=[[UIView alloc]initWithFrame:CGRectMake(0, Height-toolHeight, Width, toolHeight)];
    toolView.backgroundColor=[UIColor whiteColor];
    float widthScreen = [UIScreen mainScreen].bounds.size.width;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, widthScreen, toolHeight);
    button.tag = 1506;
    [button setTitle:@"立即兑换" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonNext2:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
    [toolView addSubview:button];
    
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
        dict = @{@"api_token":api_token,@"goods_id":self.goodID,@"type":@"1"};
    }else if (receNss!=NULL){
        dict = @{@"api_token":api_token,@"goods_id":self.goodID,@"key":receNss,@"type":@"1"};
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
    NSDictionary * dddd;
    if (dic[@"attribute"] != nil) {
        dddd=dic[@"attribute"];
        if (dddd.count!=0) {
            
            valueID=dic[@"attribute"][0][@"attr_value"][0][@"attr_value_id"];
            
        }
    }
    
    
    
    NSMutableDictionary *dicGoods = dic[@"goods"];
    shopPrice = dicGoods[@"shop_price"];
    goodsSn = dicGoods[@"goods_sn"];
    goodsName = dicGoods[@"goods_name"];
    goodsID = dicGoods[@"goods_id"];
    goodsIntegral = dicGoods[@"exchange_integral"];
    goodsContent = dicGoods[@"content"];
    //    if ([goodsContent containsString:@"\\"]) {
    //
    //    }
    //    goodsContent = [goodsContent stringByReplacingOccurrencesOfString:@"\\\"" withString:@""];
    
    repertory = [dicGoods[@"repertory"] intValue];
    //轮播图图片
    myImage=dicGoods[@"album"];
    //商品可选属性
    attribute = dicGoods[@"attribute"];
    
    //基本参数
    param = dicGoods[@"param"];
    sales = [dicGoods[@"sales"] intValue];
    NSDictionary * eeee;
    eeee=dicGoods[@"param"];
    if (eeee.count!=0) {
        _basedata = dicGoods[@"param"];
    }
    
    shopID = dic[@"supplierid"];
    if (![shopID isEqualToString:@"0"]) {
        NSMutableDictionary *dicShop = dic[@"shop"];
        supplierID = dicShop[@"supplier_id"];
        shoplogo = dicShop[@"shoplogo"];
        shopUrl = dicShop[@"shop_url"];
        shopname = dicShop[@"shopname"];
        address = dicShop[@"address"];
        shopRank = dicShop[@"rank"];
        attention = [dicShop[@"attention"] intValue];
        allGoods = [dicShop[@"all_goods"] intValue];
        newGoods = [dicShop[@"new_goods"] intValue];
        supplierSum = [dicShop[@"supplier_sum"] intValue];
        servicephone = dicShop[@"servicephone"];
        commentsRank = dicShop[@"comments_rank"];
    }
    
    
    //评论
    comments = [[NSMutableDictionary alloc]init];
    comments = dic[@"comments"];
    
    
    _commentArray = [[NSMutableArray alloc]init];
    NSMutableArray *commentsArr;
    commentsArr = dic[@"comments"][@"comment"];
    for (NSMutableDictionary *commentsDic in commentsArr) {
        CommentModel *model = [CommentModel new];
        model.userID = commentsDic[@"user_id"];
        model.orderID = commentsDic[@"order_id"];
        model.contentName = commentsDic[@"content_name"];
        model.content = commentsDic[@"content"];
        model.rank = commentsDic[@"rank"];
        model.time = commentsDic[@"time"];
        model.gmsl = commentsDic[@"gmsl"];
        model.gmjl = commentsDic[@"gmjl"];
        model.userRank = commentsDic[@"user_rank"];
        [_commentArray addObject:model];
    }
    goodConment = dic[@"comments"][@"good"];
    badConment  = dic[@"comments"][@"bad"];
    mediumConment = dic[@"comments"][@"medium"];
    
    
    /**
     *   content: "阿斯顿发撒旦法师的 阿斯顿发撒旦法师的",
     content_name: "u755ZTJD3290",
     rank: "5",
     time: "1458675930"
     */
    
    
    //是否关注 登录后返回 是1否0
    if (receNss==NULL) {
        isAttention = [NSNumber numberWithInt:0];
    }else if (receNss!=NULL){
        isAttention=dic[@"goods"][@"is_attention"];
    }
    NSString * strHTML = [NSString stringWithFormat:@"%@%@",@"<style type=\"text/css\"> img{ width: 100%; height: auto; display: block; } </style>",goodsContent];
    //加载webview 图文详情
    [_webV loadHTMLString:strHTML baseURL:nil];
    [self addImage];
    if ( myImage.count!=1) {
        [self addTimer];
        [self addPageController];
    }
    [_webV reload];
    [_table reloadData];
    [_baseColl reloadData];
    NSLog(@"%@",shopPrice);
    [self creatToolBar];
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
        NSString * strHTML = [NSString stringWithFormat:@"%@%@",@"<style type=\"text/css\"> img{ width: 100%; height: auto; display: block; } </style>",goodsContent];
        //加载webview 图文详情
        [_webV loadHTMLString:strHTML baseURL:nil];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FF5000"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    }
    else if (btn.tag==76)
    {
        [_webV removeFromSuperview];
        [self creatCollect];
        
        [_baseColl reloadData];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FF5000"] forState:UIControlStateNormal];
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
    cell.layer.borderColor=[UIColor colorWithHexString:@"#e5e5e5"].CGColor;
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
    return CGSizeMake(Width, 46);
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
                iconImage.contentMode = UIViewContentModeScaleToFill;
                [iconImage setImageWithURL:[NSURL URLWithString:myImage[0]]];
            }else if(i==myImage.count+1){
                iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*Width, 0, Width, _headScroll.frame.size.height)];
                iconImage.contentMode = UIViewContentModeScaleToFill;
                [iconImage setImageWithURL:[NSURL URLWithString:myImage[0]]];
            }else{
                iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*Width, 0, Width, _headScroll.frame.size.height)];
                iconImage.contentMode = UIViewContentModeScaleToFill;
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
    
    //    if (scrollView== _headScroll) {
    //        if (timer) {
    //            [timer invalidate];
    //        }
    //        timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    //    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    if (myImage.count>=1)
    {
        if (scrollView== _headScroll) {
            if (scrollView.contentOffset.x/ Width==(myImage.count+1)) {
                scrollView.contentOffset=CGPointMake( Width,0);
                _pagecontrol.currentPage=0;
            }else if(scrollView.contentOffset.x==0){
                scrollView.contentOffset=CGPointMake(myImage.count* Width, 0);
                _pagecontrol.currentPage=myImage.count;
                [self creatToolBar];
            }else
            {
                _pagecontrol.currentPage=(scrollView.contentOffset.x/Width)-1;
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
    
    //    [self addTimer];
}
//改变导航栏颜色
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    UITableView *tableview = object;
    int offset = tableview.contentOffset.y;
    int offsettt = self.scroll.contentOffset.y;
    
    CGFloat widthHeadScroll = _headScroll.frame.size.height - 64;
    CGFloat alphaNav = 0;
    CGFloat alphaBack = 0;
    if (offsettt>widthHeadScroll) {
        _navView.alpha = 1;
        _backBtn2.alpha = 1;
        _buyCarBtn2.alpha = 1;
        return;
    }
    
    CGFloat aNav =  widthHeadScroll - offset;
    CGFloat bNav = aNav / widthHeadScroll;
    alphaNav=1-bNav;
    CGFloat widthHalf = (_headScroll.frame.size.height/5)*3;
    CGFloat widthHalf2 = (_headScroll.frame.size.height/5)*2;
    CGFloat aBack = widthHalf - offset;
    CGFloat bBack = aBack/(widthHalf)-0.4;
    alphaBack = bBack;
    
    if (bBack <= 0) {
        CGFloat cBack = offset - widthHalf + 64;
        CGFloat dBack = cBack/widthHalf2;
        _backBtn2.alpha = dBack;
        _buyCarBtn2.alpha = dBack;
    }
    if (alphaNav <= 1) {
        _navView.alpha = alphaNav;
        _backView.alpha = alphaBack;
        _buyCarView.alpha = alphaBack;
        _backBtn1.alpha = alphaBack;
        _buyCarBtn1.alpha = alphaBack;
        //        NSLog(@"%f - %f",scrollView.contentOffset.y,alpha);
        //        NSLog(@"a - %f",a);
        //        NSLog(@"b - %f",b);
    }
    
}
#pragma mark-pagecontroller
-(void)addPageController
{
    _pagecontrol = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _headScroll.frame.size.height-40, Width, 40)];
    //需要显示多少白点
    _pagecontrol.numberOfPages = myImage.count;
    _pagecontrol.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
    _pagecontrol.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#ff5000"];
    [_headView addSubview:_pagecontrol];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([shopID isEqualToString:@"0"]) {
        return 3;
    }else{
        return 4;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *string=@"string1";
        GoodsDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:string];
        
        if (cell==nil) {
            cell=[[GoodsDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        if (goodsName.length > 0) {
            NSString *attString = goodsName;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:attString];
            NSMutableParagraphStyle *paragraStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraStyle setLineSpacing:8];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraStyle range:NSMakeRange(0, [goodsName length])];
            cell.lab1.attributedText=attributedString;
        }
        
        cell.lab2.text = [NSString stringWithFormat:@"%@积分",goodsIntegral];
    
        
        int arrCount = (int)_commentArray.count;
        //评价个数
        cell.evaluateNumLab.text = [NSString stringWithFormat:@"评价%d条",arrCount];
        //销量个数
        cell.saleNumLab.text = [NSString stringWithFormat:@"销售%d件",sales];
        //地址
        cell.addressLab.text = address;
      
        //分享
        [cell.shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        cell.shareBtn.tag = 100000;
        return cell;
    }
    else if (indexPath.section == 1){
        static NSString *string=@"string2";
        SettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingViewCell" owner:self options:nil]lastObject];
        }
        cell.detailTextLabel.hidden = YES;
        if (changeColor.length==0) {
            changeColor = @"已选:“1件”";
        }
        cell.titleLab.text = changeColor;
        cell.titleLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        cell.titleLab.frame = CGRectMake(cell.titleLab.frame.origin.x, cell.titleLab.frame.origin.x, 300, cell.titleLab.frame.size.height);
        cell.titleLab.font = [UIFont systemFontOfSize:15];
        cell.detailLab.text = @"";
        [cell.propertyBtn addTarget:self action:@selector(changeProperty) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if(indexPath.section == 2){
        //宝贝评价
        static NSString *string=@"string3";
        EvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell==nil) {
            cell=[[EvaluateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        if (_commentArray.count>0) {
            CommentModel *model;
            model = _commentArray[0];
            cell.userNameLab.text = model.contentName;
            cell.contentLab.text = model.content;
            [cell.contentLab sizeToFit];
            NSString *string = [NSString stringWithFormat:@"%@",model.gmjl];
            string = [string stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
            cell.goodsPropertyLab.text = string;
            [cell.goodsPropertyLab sizeToFit];
            NSString *goodNum = [NSString stringWithFormat:@"好评(%@)",goodConment];
            NSString *badNum = [NSString stringWithFormat:@"差评(%@)",badConment];
            NSString *midNum = [NSString stringWithFormat:@"中评(%@)",mediumConment];
            
            cell.goodLab.text = goodNum;
            cell.badLab.text = badNum;
            cell.midLab.text = midNum;
            int arrCount = (int)_commentArray.count;
            cell.totleEvaluateLab.text = [NSString stringWithFormat:@"宝贝评价(%d)",arrCount];
            [cell.allCommentBtn addTarget:self action:@selector(allAvaluation) forControlEvents:UIControlEventTouchUpInside];
            cell.goodLab.hidden = NO;
            cell.badLab.hidden = NO;
            cell.midLab.hidden = NO;
            cell.allCommentBtn.hidden = NO;
            cell.userNameLab.hidden = NO;
            cell.userImage.hidden = NO;
            cell.contentLab.hidden = NO;
            cell.goodsPropertyLab.hidden = NO;
            
        }else{
            cell.totleEvaluateLab.text = @"宝贝评价(0)";
            cell.goodLab.hidden = YES;
            cell.badLab.hidden = YES;
            cell.midLab.hidden = YES;
            cell.allCommentBtn.hidden = YES;
            cell.userNameLab.hidden = YES;
            cell.userImage.hidden = YES;
            cell.contentLab.hidden = YES;
            cell.goodsPropertyLab.hidden = YES;
        }
        
        return cell;
    }else{
        //商店
        static NSString *string=@"string4";
        ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell==nil) {
            cell=[[ShopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        [cell.customBtn addTarget:self action:@selector(customAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.shopBtn addTarget:self action:@selector(goShopAction) forControlEvents:UIControlEventTouchUpInside];
        cell.shopNameLab.text = shopname;
        NSURL *imgUrl = [NSURL URLWithString:shoplogo];
        UIImage *imgFromUrl = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgUrl]];
        cell.shopImage.image = imgFromUrl;
        if ([shopRank isEqualToString:@"1"]) {
            cell.shopGradeLab.text = @"初级店铺";
        }else if([shopRank isEqualToString:@"2"]){
            cell.shopGradeLab.text = @"中级店铺";
        }else{
            cell.shopGradeLab.text = @"高级店铺";
        }
        
        cell.allGoodsNumLab.text = [NSString stringWithFormat:@"%d",allGoods];
        cell.GoodsNewNumLab.text = [NSString stringWithFormat:@"%d",newGoods];
        cell.careNumLab.text = [NSString stringWithFormat:@"%d",supplierSum];
        cell.goodsDesLab.text =[NSString stringWithFormat:@"%@",commentsRank];
        cell.serviceDesLab.text = [NSString stringWithFormat:@"%@",commentsRank];;
        cell.logisticsDesLab.text = [NSString stringWithFormat:@"%@",commentsRank];
        
        return cell;
    }
    
    
    
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
        return 170;
    }else if(indexPath.section == 1){
        return 44;
    }else if(indexPath.section == 3){
        //店铺
        return 180;
    }else{
        //宝贝评价
        
        if (_commentArray.count > 0) {
            CommentModel *model;
            model = _commentArray[0];
            CGSize size = [model.content boundingRectWithSize:CGSizeMake(100, 0) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:nil context:nil].size;
            return size.height + 180;
            
        }else{
            return 40;
        }
        
    }
    
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return CGFLOAT_MIN;
    }else{
        return 20;
    }
    
}
-(void)changeProperty{
    [self.goodVC showHideSlidebar];
    self.goodVC.type = @"3";
    [UIView animateWithDuration:0.5 animations:^{
        if (self.state3==DownHide1) {
            
            goodsDetailsDownView.center=showDownPoint;
            //            [toolView removeFromSuperview];
        }
    } completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark -tabviewcell上按钮的事件
//分享
-(void)shareAction{
    NSLog(@"分享");
    [UIView animateWithDuration:0.5 animations:^{
        if (self.state3==DownHide1) {
            self.state3=DownShow1;
            self.downView.center=show2Point;
            downView1.hidden = NO;
            self.state=TopViewStateHide1;
            
            [toolView removeFromSuperview];
        }
    } completion:nil];
}
//查看全部评论
-(void)allAvaluation{
    NSLog(@"查看全部评价");
    EvaluateViewController *evaluateVC = [[EvaluateViewController alloc]init];
    evaluateVC.allEvaluateArray = [_commentArray mutableCopy];
    evaluateVC.goodEvaluate = goodConment;
    evaluateVC.midEvaluate = mediumConment;
    evaluateVC.badEvaluate = badConment;
    [self.navigationController pushViewController:evaluateVC animated:YES];
}
//联系客服
-(void)customAction{
    NSLog(@"联系客服");
    NSLog(@"%@",servicephone);
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",servicephone ];
    UIWebView *callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
//进店逛逛
-(void)goShopAction{
    //shopUrl supplierID  attention
    GoShopViewController *goshop = [[GoShopViewController alloc]init];
    goshop.shopUrl = shopUrl;
    goshop.attention = attention;
    goshop.shopID = shopID;
    [self.navigationController pushViewController:goshop animated:YES];
    NSLog(@"进店逛逛");
}

#pragma mark-关注,查看购物车点击事件
-(void)buttonNext:(UIButton*)sender
{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    receNss= app.tempDic[@"data"][@"key"];
    UIButton * button=(UIButton *)sender;
    
    if (button.tag==1500) {
        //收藏
        if (receNss!=NULL)
        {
            if (careGood==NO)
            {
                UIImage * imagerr=[UIImage imageNamed:@"goods_detail_collect_press"];
                button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, -30, 0);
                button.imageEdgeInsets = UIEdgeInsetsMake(-10, 10, 5,  -25);
                imagerr=[imagerr imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [button setImage:imagerr forState:UIControlStateNormal];
                [button setTitle:@"已收藏" forState:UIControlStateNormal];
                NSString *api_token = [RequestModel model:@"goods" action:@"collect"];
                // strr=@"0";
                NSDictionary *dict = @{@"api_token":api_token,@"id_values":self.goodID,@"key":receNss,@"type":@"0"};
                [RequestModel requestWithDictionary:dict model:@"goods" action:@"collect" block:^(id result) {
                    NSString *str = result[@"msg"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:str message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }];
                careGood=YES;
                
            }
            else if (careGood==YES)
            {
                UIImage * imagerr=[UIImage imageNamed:@"goods_detail_collect"];
                button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, -30, 0);
                button.imageEdgeInsets = UIEdgeInsetsMake(-10, 15, 5,  -10);
                [button setTitle:@"收藏" forState:UIControlStateNormal];
                imagerr=[imagerr imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [button setImage:imagerr forState:UIControlStateNormal];
                
                NSString *api_token = [RequestModel model:@"goods" action:@"qcollect"];
                // strr=@"0";
                NSDictionary *dict = @{@"api_token":api_token,@"id_values":self.goodID,@"key":receNss,@"type":@"0"};
                [RequestModel requestWithDictionary:dict model:@"goods" action:@"qcollect" block:^(id result) {
                    NSString *str = result[@"msg"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:str message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
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
        GoodsCarViewController * third=[[GoodsCarViewController alloc]init];
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
    double intetrationNum = [_intetration doubleValue];
    double goodsIntegralNum = [goodsIntegral doubleValue];
    //立刻兑换
   if (btn.tag==1506)
    {
        if (receNs!=NULL) {
            if (buySum == nil) {
                [self.goodVC showHideSlidebar];
                self.goodVC.type = @"3";
                [UIView animateWithDuration:0.5 animations:^{
                    
                } completion:nil];
            }else{
                
                if (attribute.count == 0) {
                    //如果商品没有可选属性，则直接跳到确认订单页面
                    if (intetrationNum < goodsIntegralNum) {
                        NSLog(@"不可以支付");
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您的积分不够兑换，请看看其他商品。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }else{
                        SureOrderIntegralViewController *sureVC = [SureOrderIntegralViewController new];
                        sureVC.goodsID = goodsID;
                        sureVC.goodsNumber = buySum;
                        sureVC.type = @"1";
                        sureVC.points = goodsIntegral;
                        sureVC.propertyID = _propertyID;
                        [self.navigationController pushViewController:sureVC animated:YES];
                    }
                    
                }else{
                    //如果有可选属性，则判断allProperty（购买的属性）是否为空，不为空则判断是否有未选择的属性，如果都满足则跳到确认订单页面
                    if (allProperty.length>0) {
                        if (notChange.length>0) {
                            NSString *a = [NSString stringWithFormat:@"请选择%@",notChange];
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:a message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                            [alert show];
                        }else{
                            if (intetrationNum < goodsIntegralNum) {
                                NSLog(@"不可以支付");
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您的积分不够兑换，请看看其他商品。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                [alert show];
                            }else{
                                NSLog(@"可以支付");
                                SureOrderIntegralViewController *sureVC = [SureOrderIntegralViewController new];
                                sureVC.type = @"1";
                                sureVC.goodsID = goodsID;
                                sureVC.goodsNumber = buySum;
                                sureVC.points = goodsIntegral;
                                NSLog(@"商品属性id%@",_propertyID);
                                sureVC.propertyID = _propertyID;
                                [self.navigationController pushViewController:sureVC animated:YES];
                            }

                            
                        }
                        
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请选择商品属性" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                }
                
            }
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
    self.goodVC.recevieId=@"9";
    [self.goodVC showHideSlidebar];
    [UIView animateWithDuration:0.5 animations:^{
        if (self.state3==DownHide1) {
            
            //            goodsDetailsDownView.center=showDownPoint;
            //            [toolView removeFromSuperview];
        }
    } completion:nil];
    
}
#pragma mark-跳转出分享,二维码
-(void)downClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    if (btn.tag==100000)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSString *url = data[@"shareurl"];
        NSString *UMSharekey = data[@"UMSharekey"];
        NSString *umImage = myImage[0];
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMSharekey
                                          shareText:goodsName
                                         shareImage:[UIImage imageNamed:@"logo"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ,UMShareToTencent,nil]
                                           delegate:nil];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url=url;
        [UMSocialData defaultData].extConfig.qzoneData.url=url;
        [UMSocialData defaultData].extConfig.qqData.url=url;
        [[UMSocialData defaultData].extConfig.sinaData.urlResource setUrl:url];
        //        [UMSocialData defaultData].extConfig.qqData.urlResource = [NSURL URLWithString:umImage];
        [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:umImage];
        
        
        
        
    }
    else if(btn.tag==100001)
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            if (self.CState==codeHide1) {
                self.CState=codeShow1;
                self.codeView.center=showcodePoint;
                _codeView.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
                UIImageView * myimageview=[[UIImageView alloc]initWithFrame:CGRectMake(40, 60, Width-120, Width-120)];
                myimageview.image=[QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"goods_id:%@", _goodID] imageSize:100];
                //[NSString stringWithFormat:@"goods_id:%@", _goodID]
                [_codeView addSubview: myimageview];
                
            }
        } completion:nil];
    }
}
-(void)downBack{
    downView1.hidden = YES;
    _downView.center = hide2Point;
    self.state3=DownHide1;
    [self creatToolBar];
}
#pragma mark-关闭二维码
-(void)codeClick:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.CState==codeShow1) {
            self.CState=codeHide1;
            self.codeView.center=hidecodePoint;
        }} completion:nil];
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
    downView1.hidden = NO;
    UIButton *btn=(UIButton*)sender;
    if (btn.tag==10000) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.downView.center=show2Point;
            
            
        } completion:nil];
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
    
    if (tagg == 1) {
        //        self.topView.center=showPoint;
        
        self.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        tagg = 2;
    }else{
        //        self.topView.center=hidePoint;
        
        self.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        tagg = 1;
    }
}
#pragma mark-移除视图
-(void)removeView:(UITapGestureRecognizer*)tap
{
    tagg = 1;
    
    
}
-(void)dealloc{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"property" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"123" object:nil];
    [self.table removeObserver:self forKeyPath:@"contentOffset"];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"property" object:nil];
    //    NSLog(@"%@ --%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    
}
-(void) removeFromParentViewController {
    [super removeFromParentViewController];
    if(self.table!=nil) {
        self.table.delegate = nil;
        self.table.dataSource = nil;
        self.table = nil;
    }
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
      __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"userinfo" block:^(id result) {
        NSDictionary *dic = result;
      
        weakSelf.intetration = dic[@"data"][0][@"integration"];
    }];
}
#pragma mark -- 自定义导航栏
- (void)initNavigationBar{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *naviBGColor = data[@"navigationBGColor"];
    //    NSString *navigationTitleFont = data[@"navigationTitleFont"];
    //
    //    NSString *naiigationTitleColor = data[@"naiigationTitleColor"];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    _navView.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    _navView.alpha = 0;
    [self.view addSubview:_navView];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(12, 25, 30, 30)];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.6;
    _backView.layer.cornerRadius = 15;
    [self.view addSubview:_backView];
    
    
    
    
    UIImage *img = [UIImage imageNamed:@"goods_detail_back_white"];
    _backBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(12, 25, 30, 30)];
    
    [_backBtn1 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn1.alpha = 0.6;
    [_backBtn1 setImage:img forState:UIControlStateNormal];
    
    [self.view addSubview:_backBtn1];
    
    //商品详情－按钮－返回-灰色@2x goods_detail_back_black@2x 商品详情－按钮－返回-灰色@2x
    UIImage *img2 = [UIImage imageNamed:@"goods_detail_back_black"];
    _backBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(12, 25, 30, 30)];
    _backBtn2.alpha = 0;
    [_backBtn2 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [_backBtn2 setImage:img2 forState:UIControlStateNormal];
    [self.view addSubview:_backBtn2];
    
    
    _buyCarView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 25, 30, 30)];
    _buyCarView.backgroundColor = [UIColor blackColor];
    _buyCarView.alpha = 0.6;
    _buyCarView.layer.cornerRadius = 15;
    [self.view addSubview:_buyCarView];
    
    UIImage *img1 = [UIImage imageNamed:@"goods_detail_cart_white"];
    _buyCarBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 25, 30, 30)];
    
    [_buyCarBtn1 addTarget:self action:@selector(buttonNext:) forControlEvents:UIControlEventTouchUpInside];
    _buyCarBtn1.tag = 1501;
    _buyCarBtn1.alpha = 0.6;
    [_buyCarBtn1 setImage:img1 forState:UIControlStateNormal];
    
    [self.view addSubview:_buyCarBtn1];
    
    UIImage *img3 = [UIImage imageNamed:@"goods_detail_cart_black"];
    _buyCarBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 25, 30, 30)];
    _buyCarBtn2.alpha = 0;
    [_buyCarBtn2 addTarget:self action:@selector(buttonNext:) forControlEvents:UIControlEventTouchUpInside];
    _buyCarBtn2.tag = 1501;
    [_buyCarBtn2 setImage:img3 forState:UIControlStateNormal];
    
    [self.view addSubview:_buyCarBtn2];
    
    
}
-(void)back{
    if (timer) {
        [timer invalidate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
