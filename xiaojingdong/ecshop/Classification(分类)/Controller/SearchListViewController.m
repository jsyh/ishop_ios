//
//  SearchListViewController.m
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//搜索列表

#import "SearchListViewController.h"

#import "SearchListCollect.h"
#import "SearchListTableCell.h"

#import "PopoveView.h"
#import "UIImageView+AFNetworking.h"
#import "RequestModel.h"

#import "goodDetailViewController.h"
#import "MJRefresh.h"
#import "UIColor+Hex.h"
#import "MyTabBarViewController.h"
#import "AccordionView.h"
#import "SelectView.h"
#import "SearchPopView.h"
#import "ShopSearchListViewController.h"

#import "serDBModel.h"
#import "shangpinModel.h"
#import "MBProgressHUD.h"

#define topHeight 50   //综合,销量,筛选栏的高度
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define H(b) Height * b / 667.0
#define W(a) Width * a / 375.0
@interface SearchListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,sendRequestInfo,UITextFieldDelegate>
{
    BOOL changeItem;//点击改变列表排布方式
    BOOL zonghe;//点击综合
    BOOL jiage;//点击价格
    NSString * ifsale;//是否促销
    UIButton * buttonall;
    UIImageView * sureImg;
    AccordionView *accordion;
    NSTimer *myTimer;
}

@property (nonatomic, strong) UICollectionView *collect;//collect排布
@property (nonatomic, strong) UITableView *table;//table排布
@property (nonatomic, strong) UIView *view1;//view1上方table
@property (nonatomic, strong) UIView *view2;//view2上放collect
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString * btnOrder;//排序的数字
@property (nonatomic, strong) UIButton *searchBtn;//切换店铺宝贝的按钮
@property (nonatomic, strong) NSString *goodsOrShopStr;//记录是宝贝还是店铺
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) SelectView *selectView;
@property (nonatomic,assign)  int page;
@property (nonatomic,strong)  NSString *pageTotalStr;
@property (nonatomic,strong)  UIView *searchResultView; //没有搜索结果显示的view
@end

@implementation SearchListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     _goodsOrShopStr = @"0";
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
//
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
//    [self createNav];
    self.page = 1;
    [self createUI];
    [self initNavigationBar];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.hidden=NO;
   
    //初始化数据源
    _datasource=[[NSMutableArray alloc]init];
    //初始化changeItem值
    changeItem=YES;
    //初始化综合按钮的值
    zonghe=YES;
    //初始化价格按钮的值
    jiage=YES;
    //初始化排序的初始状态
    _btnOrder=@"0";
    
    _view1=[[UIView alloc]initWithFrame:CGRectMake(0, 65+buttonall.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    _view2=[[UIView alloc]initWithFrame:CGRectMake(0, 65+buttonall.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self createTable];
    [self creatCollect];
    //请求数据
    [self reloadRequestInfo];
    
     NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(showtext:) name:@"text" object:nil];
    //没有搜索结果显示的view
    _searchResultView = [[UIView alloc]initWithFrame:CGRectMake(0,65+buttonall.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    //没有搜索结果
    
    float aY336 = 336.0/1334.0;
    float aW172 = 172.0/750.0;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - aW172*Width/2, aY336*Height, aW172*Width, aW172*Width)];
    imgView.image = [UIImage imageNamed:@"seachGoods_null"];
    [_searchResultView addSubview:imgView];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+18, Width, 16)];
    lab.text = @"列表是空的";
    lab.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textAlignment = NSTextAlignmentCenter;
    [_searchResultView addSubview:lab];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+12, Width, 13)];
    lab2.text = @"暂时没有相关数据";
    lab2.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab2.font = [UIFont systemFontOfSize:13];
    lab2.textAlignment = NSTextAlignmentCenter;
    [_searchResultView addSubview:lab2];
    UILabel *searchResultsLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 400, 100, 40)];
    searchResultsLab.text = @"";
    searchResultsLab.backgroundColor = [UIColor redColor];
//    [_searchResultView addSubview:searchResultsLab];
    //没有找到相关的店铺
    UILabel *searchShop = [[UILabel alloc]initWithFrame:CGRectMake(100, 300, 100, 40)];
    searchShop.text = @"";
    searchShop.backgroundColor = [UIColor redColor];
//    [_searchResultView addSubview:searchShop];
    
    _searchResultView.hidden = YES;
    [self.view addSubview:_searchResultView];
    //筛选的视图
    
    _selectView = [[SelectView alloc]initWithFrame:CGRectMake(0, _view1.frame.origin.y, Width, 0)];
    _selectView.clipsToBounds = YES;
    _selectView.myType = _typeStay;
    _selectView.keyword = _secondLab;
    _selectView.classifyID = _gooddid;
    _selectView.brandID = _brandID;
    [_selectView reloadInfoRequest];
    [self.view addSubview:_selectView];
    [self afn];
}

-(void)showtext:(NSNotification *)notify{
    NSDictionary *info=notify.userInfo;
    _secondStr=info[@"lis"];
    [self reloadRequestInfo];
    
}
-(void)afn
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    
    hud.labelText=@"loading";
    
    
    
}
#pragma mark-请求数据
-(void)reloadRequestInfo
{
    
    RequestModel *rev=[[RequestModel alloc]init];
    rev.delegate=self;
    
    NSString * path2=[NSString stringWithFormat:@"%@",_secondStr];
    if (self.typeStay==NULL) {
        self.typeStay=@"";
    }if (self.gooddid==NULL) {
        self.gooddid=@"";
    }if (self.secondLab==NULL) {
        self.secondLab=@"";
    }if (self.brandID == NULL) {
        self.brandID = @"";
    }
     NSString *a = [NSString stringWithFormat:@"%d",self.page];
    NSString *api_token = [RequestModel model:@"first" action:@"index"];
    if ([a isEqualToString:@"1"]) {
        [_datasource removeAllObjects];
    }
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *key = app.tempDic[@"data"][@"key"];
    if (key == nil) {
        key = @"";
    }
    NSDictionary *dict = @{@"api_token":api_token,@"keyword":self.secondLab,@"classify_id":self.gooddid,@"type":@"search",@"order":_btnOrder,@"page":a,@"filtrate":path2,@"maintype":@"",@"c":self.typeStay,@"brand_id":self.brandID,@"key":key};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"first" action:@"index" block:^(id result) {
        [weakSelf sendMessage:result];
        
    }];
    
}
-(void)sendMessage:(id)message{
    if (![message[@"code"] isEqual:@"0"]) {
        
        NSMutableDictionary *dic=message[@"data"];
        NSMutableArray *arr=dic[@"goods"];
        [_datasource addObjectsFromArray:arr];
        _pageTotalStr = dic[@"page_count"];
        [_table reloadData];
        [_collect reloadData];

    }else{
        [_table reloadData];
        [_collect reloadData];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self creat];
}
-(void)creat{
    if (_datasource.count == 0) {
        _searchResultView.hidden = NO;
    }else{
        _searchResultView.hidden = YES;
    }
}
#pragma mark-创建table布局
-(void)createTable
{
    _view1.hidden = NO;
    [self.view addSubview:_view1];
    _table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height-64-buttonall.frame.size.height)];
    _table.delegate=self;
    _table.dataSource=self;
//    _table.hidden = NO;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_table setTableFooterView:view];
    _table.showsVerticalScrollIndicator=NO;
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMore)];
    _table.mj_footer = footer;
    

    [_view1 addSubview:_table];
    
}
-(void)addMore
{
    self.page++;
    
    int b =[self.pageTotalStr intValue];
    if (self.page <= b) {
        
        
        [self reloadRequestInfo];
        [_table.mj_footer endRefreshing];
    }else{
        [_table.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma mark-创建collect布局
-(void)creatCollect
{
    _view2.hidden = YES;
    [self.view addSubview:_view2];
    UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc]init];
    flow.minimumInteritemSpacing = 0;
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    _collect=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-buttonall.frame.size.height) collectionViewLayout:flow];
//    _collect.hidden = YES;
//    _collect.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    _collect.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
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
    accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    
   
    
    _datasource=[[NSMutableArray alloc]init];
    NSArray *titleArr=@[@"综合排序",@"销量优先",@"筛选"];
    NSArray *imageArr=@[@"goods_list_arrow_checked",@"",
                       @"goods_list_arrow_normal"];
    
    float qihuanFloat = 88.0/750.0;
    float size = (Width- Width*qihuanFloat)/3;
    float heightBtnFloat = 80.0/1334.0;
    
    //最右侧改变样式的按钮
    buttonall=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonall.frame=CGRectMake(Width - Width*qihuanFloat, 64, qihuanFloat*Width, heightBtnFloat*Height);
    UIImage * image2=[UIImage imageNamed:@"goods_list"];
    image2=[image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [buttonall setImage:image2 forState:UIControlStateNormal];
    [buttonall addTarget:self action:@selector(bitright:) forControlEvents:UIControlEventTouchUpInside];
    buttonall.tag=80;
    //画线
    //顶部
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, buttonall.frame.size.width, 1)];
    view1.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [buttonall addSubview:view1];
    //底部
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, buttonall.frame.size.height, buttonall.frame.size.width, 1)];
    view2.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [buttonall addSubview:view2];
    //侧边
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, buttonall.frame.size.height)];
    view3.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [buttonall addSubview:view3];
    [self.view addSubview:buttonall];
   
   
    for (int i=0; i<3; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame=CGRectMake(i*size, 64, size, heightBtnFloat*Height);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        
        if (i==0) {
            [button setTitleColor:[UIColor colorWithHexString:@"#FF5000"] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonlist1:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image2=[UIImage imageNamed:imageArr[i]];
        image2=[image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:image2 forState:UIControlStateNormal];
        button.titleLabel.textAlignment=NSTextAlignmentLeft;
        //511529
        if (i == 0) {
            button.titleEdgeInsets=UIEdgeInsetsMake(5, -15, 10, 20);

            button.imageEdgeInsets=UIEdgeInsetsMake(5, 65, 10, 10);
        }else if(i == 2){
            button.titleEdgeInsets=UIEdgeInsetsMake(5, -15, 10, 20);

            button.imageEdgeInsets=UIEdgeInsetsMake(5, 45, 10, 0);
        }else{
            button.titleEdgeInsets=UIEdgeInsetsMake(5, -10, 10, 0);
        }
       
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag=i+10;
        //画线
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, button.frame.size.width, 1)];
        view1.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
        [button addSubview:view1];
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, button.frame.size.height, button.frame.size.width, 1)];
        view2.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
        [button addSubview:view2];
        [self.view addSubview:button];
    }
   
}
#pragma mark-Top四栏点击效果
-(void)buttonlist1:(UIButton *)sender
{
    UIButton *btn1=(UIButton *)[self.view viewWithTag:10];
    UIButton *btn2=(UIButton *)[self.view viewWithTag:11];
    UIButton *btn3=(UIButton *)[self.view viewWithTag:12];
    self.page = 1;
    UIButton * btn=(UIButton *)sender;
    if (btn.tag==10)
    {
        float a =_selectView.frame.size.height;
        if (a > 0) {
            [myTimer invalidate];
            _selectView.frame = CGRectMake(_selectView.frame.origin.x, _selectView.frame.origin.y, _selectView.frame.size.width, 0);
        }
        [btn setImage:[UIImage imageNamed:@"goods_list_arrow_checked"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FF5000"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"goods_list_arrow_normal"] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];

        CGPoint point=CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
        //排序的类型 0 综合排序 1 销量排序 2 价格由低 到高 3 价格由高到低,4 人气,(默认为 0)
        NSArray *titles=@[@"综合排序",@"价格从低到高",@"价格从高到低",@"人气排序"];
        PopoveView *pop=[[PopoveView alloc]initWithPoint:point titles:titles];
        pop.selectRowAtIndex=^(NSInteger index)
        {
            if (index==0)
            {
                [btn setTitle:@"综合排序" forState:UIControlStateNormal];
                _btnOrder=@"0";
                
                btn.titleEdgeInsets=UIEdgeInsetsMake(5, -15, 10, 20);
                
                btn.imageEdgeInsets=UIEdgeInsetsMake(5, 65, 10, 10);
                [self reloadRequestInfo];
            }
            else if (index==1)
            {
                [btn setTitle:@"价格从低到高" forState:UIControlStateNormal];
                _btnOrder=@"2";
                btn.titleEdgeInsets=UIEdgeInsetsMake(5, -5, 10, 20);
                
                btn.imageEdgeInsets=UIEdgeInsetsMake(5, 90, 10, 10);
                [self reloadRequestInfo];
            }else if (index==2)
            {
                [btn setTitle:@"价格从高到低" forState:UIControlStateNormal];
                _btnOrder=@"3";
                btn.titleEdgeInsets=UIEdgeInsetsMake(5, -5, 10, 20);
                
                btn.imageEdgeInsets=UIEdgeInsetsMake(5, 90, 10, 10);
                [self reloadRequestInfo];
            }else if (index==3)
            {
                [btn setTitle:@"人气排序" forState:UIControlStateNormal];
                _btnOrder=@"4";
                btn.titleEdgeInsets=UIEdgeInsetsMake(5, -15, 10, 20);
                
                btn.imageEdgeInsets=UIEdgeInsetsMake(5, 65, 10, 10);
                [self reloadRequestInfo];
            }
        };
        [pop show];
    }
    else if (btn.tag==11)
    {
        float a =_selectView.frame.size.height;
        if (a > 0) {
            [myTimer invalidate];
            _selectView.frame = CGRectMake(_selectView.frame.origin.x, _selectView.frame.origin.y, _selectView.frame.size.width, 0);
        }
        //销量优先
        
        [btn setTitleColor:[UIColor colorWithHexString:@"#FF5000"] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"goods_list_arrow_normal"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"goods_list_arrow_normal"] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];

        _btnOrder=@"1";
        [self reloadRequestInfo];
    }
    else if (btn.tag==12)
    {
        //筛选
        //右边栏开始
        float a =_selectView.frame.size.height;
        if (a > 0) {
            [myTimer invalidate];
            _selectView.frame = CGRectMake(_selectView.frame.origin.x, _selectView.frame.origin.y, _selectView.frame.size.width, 0);
        }else{
            myTimer = [NSTimer timerWithTimeInterval:0.01f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop]addTimer:myTimer forMode:NSDefaultRunLoopMode];
        }
//        UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
//        [panGesture delaysTouchesBegan];
//        [self.view addGestureRecognizer:panGesture];
//        self.sidebarVC=[[SliderViewController alloc]init];
//        self.sidebarVC.rightLab=self.secondLab;
//        self.sidebarVC.myType=self.goodType;
//        [self.navigationController.view addSubview:self.sidebarVC.view];
//        self.sidebarVC.view.frame=self.view.bounds;
//        
//        [self.sidebarVC showHideSlidebar];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FF5000"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"goods_list_arrow_checked"] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"goods_list_arrow_normal"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        
        
    }
    
  
    
}
-(void)timerAction{
    float a = _selectView.frame.size.height;
    a = a+40;
    float c = Height - 10 - buttonall.frame.size.height;
    if (a>c) {
        [myTimer invalidate];
        return;
    }
    float b = _selectView.frame.size.width;
    _selectView.frame = CGRectMake(_selectView.frame.origin.x, _selectView.frame.origin.y, b, a);
}
#pragma mark-table代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid=@"cellid";
    SearchListTableCell * cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
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
    [cell.iconImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_list_pic_error"]];
    cell.nameLab.text=_datasource[indexPath.row][@"title"];
    cell.nameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    [cell.nameLab sizeToFit];
    NSString *priceStr = _datasource[indexPath.row][@"price"];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:priceStr];
    NSUInteger a = str1.length - [[str1 string] rangeOfString:@"."].location;
    NSUInteger b = [[str1 string] rangeOfString:@"."].location;
    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange([[str1 string] rangeOfString:@"."].location, a)];
    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, b)];
    cell.priceLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
    cell.priceLab.attributedText=str1;
    ifsale=_datasource[indexPath.row][@"sell_num"];
    
    cell.moneySign.text=@"￥";
    cell.moneySign.textColor = [UIColor colorWithHexString:@"#ff5000"];
    cell.num1Lab.textColor = [UIColor colorWithHexString:@"#999999"];
    cell.num2Lab.textColor = [UIColor colorWithHexString:@"#999999"];
    //购买人数为空则赋值0
    NSString *string2=[NSString stringWithFormat:@"%@",_datasource[indexPath.row][@"goods_number"]];
    if ([string2  isEqualToString:@"<null>"]) {
        cell.num2Lab.text=@"0好评";
    }else{
        cell.num2Lab.text=[NSString stringWithFormat:@"%@%%好评",string2];
    }
    //判断如果好评人数为空则赋值0
    //将nsnumber类型的数据转化成nsstring
    NSString *string1=[NSString stringWithFormat:@"%@",_datasource[indexPath.row][@"comment_sum"]];
    if(_datasource[indexPath.row][@"comment_sum"]==NULL){
        cell.num1Lab.text=@"评论0条";
    }
    else{
        cell.num1Lab.text=[NSString stringWithFormat:@"评论%@条",string1];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    [cell.iconImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_grid_pic_error"]];
    cell.iconImage.backgroundColor = [UIColor whiteColor];
    cell.nameLab.text=_datasource[indexPath.item][@"title"];
    cell.priceLab.text=_datasource[indexPath.item][@"price"];
    cell.moneySign.text=@"￥";

    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0, 0, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float itemWidth = Width/2;
    return CGSizeMake(itemWidth-0.5, itemWidth+70);
    
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
  
    return 1;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
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
//    SearchViewController *search=[[SearchViewController alloc]init];
//    [self.navigationController pushViewController:search animated:NO];
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark-点击改变列表的排列方式
-(void)bitright:(id)sender
{
 
    // UIButton * btn=(UIButton*)[self.view viewWithTag:80];
    if (changeItem) {
        changeItem=NO;
        UIImage * image12=[UIImage imageNamed:@"goods_grid"];
        image12=[image12  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [buttonall setImage:image12 forState:UIControlStateNormal];
        _view1.hidden = YES;
        _view2.hidden = NO;
//        _table.hidden = YES;
//        _collect.hidden = NO;
    }
    else{
        UIImage * image12=[UIImage imageNamed:@"goods_list"];
        image12=[image12  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [buttonall setImage:image12 forState:UIControlStateNormal];
        changeItem=YES ;
//        [_collect removeFromSuperview];
        _view1.hidden = NO;
        _view2.hidden = YES;
//        _collect.hidden = YES;
//        _table.hidden = NO;
//        [self createTable];
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
  
    float imgFloatX = 12.0/750.0;
    float imgFloatY = 12.0/1334.0;

    UIImage *img = [UIImage imageNamed:@"back.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(Width*imgFloatX, Height*imgFloatY, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(imgFloatX*Width, 20+imgFloatY*Height, 20+Width*imgFloatX, 20+Height*imgFloatY)];
    [btn addSubview:imgView];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    //搜索框背景
    float searchFloatX = 176.0/750.0;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.size.width+btn.frame.origin.x+Width*imgFloatX*2, 25, Width-Width*searchFloatX, 32)];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    searchView.layer.cornerRadius = 16;
    searchView.layer.masksToBounds = YES;
    
    
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(imgFloatX*Width, imgFloatY*Height, 40, 20)];
    [_searchBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"goods_list_arrow_normal"]] forState:UIControlStateNormal];
    [_searchBtn setTitle:@"宝贝" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];

    _searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -W(17), 0, 0);
    _searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0,35, 0, 0);
    //goods_list_arrow_normal@2x
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_searchBtn addTarget:self action:@selector(goodsOrShop:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:_searchBtn];
    
    //(3)中间 搜索框
    _textField=[[UITextField alloc]init];
    _textField.frame=CGRectMake(_searchBtn.frame.size.width+_searchBtn.frame.origin.x +Width*imgFloatX , 0, searchView.frame.size.width - imgFloatX*Width*3-40, 32);
    _textField.backgroundColor = [UIColor clearColor];
    _textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _textField.text = self.secondLab;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.textColor = [UIColor colorWithHexString:@"#43464c"];
    _textField.delegate = self;
//    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.tag = 10000;
    
    [searchView addSubview:_textField];
    [view addSubview:searchView];
    [self.view addSubview:view];
    
    
}
#pragma mark -- nv的事件
//点击宝贝切换店铺
-(void)goodsOrShop:(UIButton *)sender{
    UIButton * btn=(UIButton *)sender;
    NSArray *titles=@[@"宝贝",@"店铺"];
    //    CGPoint point=CGPointMake(_searchBtn.frame.origin.x + _searchBtn.frame.size.width/2, _searchBtn.frame.origin.y + _searchBtn.frame.size.height);
    CGPoint point= CGPointMake(50,64);
    SearchPopView *pop=[[SearchPopView alloc]initWithPoint:point titles:titles];
    
    pop.backgroundColor = [UIColor redColor];
    pop.selectRowAtIndex=^(NSInteger index)
    {
        if (index==0)
        {
            [btn setTitle:@"宝贝" forState:UIControlStateNormal];
            _goodsOrShopStr=@"0";
            [self reloadRequestInfo];
        }
        else if (index==1)
        {
            [btn setTitle:@"店铺" forState:UIControlStateNormal];
            _goodsOrShopStr=@"1";
            [self reloadRequestInfo];
        }
    };
    [pop show];
    
}
//键盘上搜索按钮的事件
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    if ([string isEqualToString:@"\n"]) {//按下return键,在这里写搜索按钮的事件
        //这里隐藏键盘，不做任何处理
        [textField resignFirstResponder];
        [self sureBtn];
        return NO;
    }else {
        if ([textField.text length] < 140) {//判断字符个数
            
            return YES;
        }
    }
    return NO;
}
//点击搜素
-(void)sureBtn
{
    self.gooddid = @"";
    self.typeStay = @"";
    
    if (![self.textField.text isEqualToString:@" "]) {
        if (![self.textField.text isEqualToString:@""]) {
          
            NSMutableArray *pin=[[NSMutableArray alloc]init];
            [pin addObjectsFromArray:[[serDBModel shareDBModel]selectInfo]];
            if (pin.count==0) {
                [[serDBModel shareDBModel] insertInfoDBModelWithName:self.textField.text];
                
            }else{
                int i=0;
                for (shangpinModel *ping in pin) {
                    if ([ping.titleName isEqualToString:self.textField.text]) {
                        break;
                    }else{
                        if (i==pin.count-1) {
                            [[serDBModel shareDBModel] insertInfoDBModelWithName:self.textField.text];
                        }
                    }
                    i++;
                }
            }
            self.keywords=_textField.text;
            if ([_goodsOrShopStr isEqualToString:@"0"]) {
                //0 宝贝搜索
//                SearchListViewController *list=[[SearchListViewController alloc]init];
//                list.secondLab=_keywords;
//                //                list.gooddid =
//                [self.navigationController pushViewController:list animated:YES];
                self.secondLab = _keywords;
                self.page = 1;
                [self reloadRequestInfo];
                float a =_selectView.frame.size.height;
                if (a > 0) {
                    _selectView.frame = CGRectMake(_selectView.frame.origin.x, _selectView.frame.origin.y, _selectView.frame.size.width, 0);
                }
                _selectView.myType = _typeStay;
                _selectView.keyword = _secondLab;
                _selectView.classifyID = _gooddid;
                _selectView.brandID = _brandID;
                [_selectView reloadInfoRequest];
            }else if([_goodsOrShopStr isEqualToString:@"1"]){
                //1 店铺搜索
                ShopSearchListViewController *shopVC = [ShopSearchListViewController new];
                shopVC.keyword = _keywords;
                [self.navigationController pushViewController:shopVC animated:YES];
            }
        }
    }
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
