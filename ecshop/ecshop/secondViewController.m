//
//  secondViewController.m
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//第二页

#import "secondViewController.h"
#import "SearchViewController.h"
#import "SearchListViewController.h"
#import "Masonry.h"
#import "RequestModel.h"
#import "sonCollectCell.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+AFNetworking.h"
#import "BarCodeViewController.h"
#import "goodDetailViewController.h"
#import "UIColor+Hex.h"
#import "MyTabBarViewController.h"
#import "AFNetworkReachabilityManager.h"
#define Tablewidth 100   //tableview的宽度
#define TableCell 42    //tableviewcell的高度
#define ScrollHight 100   //滚动视图的高度
#define HEGHT self.view.frame.size.height   //频幕的高度
@interface secondViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate, QRCodeDelegate>
{
    NSString *InfoPath;
    UIView * viewww;
}
@property (nonatomic, strong) NSMutableArray *datasource1;
@property (nonatomic, strong) NSMutableArray *datasource2;
@property (nonatomic, strong) NSMutableArray *datasource3;
@property (nonatomic, strong) NSMutableDictionary *dic2;
@property (nonatomic, strong) UITableView *table1;
@property (nonatomic, strong) UICollectionView *collect;
@property (nonatomic, strong) UIScrollView *myScroll;
@property (nonatomic, assign) NSString *strr;
@property (nonatomic, strong) UIView *headview;
@property (nonatomic, strong) UIPageControl *pagecontrol;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation secondViewController

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //self.navigationController.navigationBarHidden=NO;
    //定时器停止
    [_timer setFireDate:[NSDate distantFuture]];
}
-(void)viewWillAppear:(BOOL)animated
{
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    
    [tabbar hiddenTabbar:NO];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    //定时器开始
    [_timer setFireDate:[NSDate distantPast]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    _datasource3=[[NSMutableArray alloc]init];
    _strr=@"1";
    [self reloadRequestInfo2];
    [self creatCollec];
    //创建左侧tableview
    [self creatVerticalCell];
    [self afn];
    
    //请求数据
    [self reloadRequestInfo];
   
    //创建导航条
    [self creatNav];
    
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
    //[self reloadRequestInfo];
}
#pragma mark-创建左侧tableview
-(void)creatVerticalCell
{
    _table1=[[UITableView alloc]initWithFrame:CGRectMake(0,64, Tablewidth,HEGHT-64) style:UITableViewStylePlain];
    _table1.opaque=YES;
    
    _table1.delegate=self;
    _table1.dataSource=self;
    _table1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table1.separatorColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    _table1.showsVerticalScrollIndicator=NO;
    [self.view  addSubview:_table1];
}
#pragma mark-scrollview广告轮播效果
-(void)createScroll
{
    
    _myScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(Tablewidth+5, 64+5, self.view.frame.size.width-Tablewidth-5, ScrollHight)];
    // _myScroll.opaque=YES;
    _myScroll.bounces=NO;
    _myScroll.directionalLockEnabled=YES;
    _myScroll.showsVerticalScrollIndicator=NO;
    _myScroll.showsHorizontalScrollIndicator=NO;
    _myScroll.delegate=self;
    _myScroll.pagingEnabled=YES;//防止出现半页
    for (int i = 0; i < _datasource3.count; i++) {
        UIImageView *imgeview;
        NSString *str2;
        NSURL *url;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSString *imgUrl = data[@"imgUrl"];
        
        NSString *str1=[NSString stringWithFormat:@"%@/",imgUrl];
        NSString *str3;
        str2=_datasource3[i][@"goods_thumb"];
        str3=[str1 stringByAppendingString:str2];
        url=[NSURL URLWithString:str3];
        imgeview=[[UIImageView alloc]initWithFrame:CGRectMake(_myScroll.frame.size.width *i, 0, _myScroll.frame.size.width, ScrollHight)];
        imgeview.contentMode = UIViewContentModeScaleAspectFit;
        [imgeview setImageWithURL:url];
        imgeview.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired=1;
        tap.numberOfTouchesRequired=1;
        imgeview.tag=i;
        [imgeview addGestureRecognizer:tap];
        [_myScroll addSubview:imgeview];
        
    }
    _myScroll.contentSize=CGSizeMake((int)_myScroll.frame.size.width*(_datasource3.count), ScrollHight);
    _myScroll.contentOffset=CGPointMake(0,0);
    
    [self addtimer];
    
    [self.view addSubview:_myScroll];
    [self addpagecontroller];
    
}
#pragma mark-创建右侧collectview
-(void)creatCollec
{
    UICollectionViewFlowLayout * flow=[[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    _collect=[[UICollectionView alloc]initWithFrame:CGRectMake(Tablewidth ,ScrollHight+64+5+5 , self.view.frame.size.width-Tablewidth-5, HEGHT-ScrollHight) collectionViewLayout:flow];
    _collect.opaque=YES;
    _collect.delegate=self;
    _collect.dataSource=self;
    _collect.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_collect];
    _datasource2=[[NSMutableArray alloc]init];
    [_collect registerClass:[sonCollectCell class] forCellWithReuseIdentifier:@"string"];
}
#pragma mark-请求tableview数据
-(void)reloadRequestInfo
{
    //[self afn];
    NSString *api_token = [RequestModel model:@"First" action:@"classify"];
    // strr=@"0";
    NSDictionary *dict = @{@"api_token":api_token,@"type":@0};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"First" action:@"classify" block:^(id result) {
        //NSDictionary *dic = ;
        NSDictionary* dicarr=result[@"data"];
        weakSelf.datasource1=[[NSMutableArray alloc]init];
        weakSelf.datasource1=dicarr[@"classify" ];
        [weakSelf.table1 reloadData];
    }];
    
}
#pragma mark-请求滑动广告和collect
-(void)reloadRequestInfo2
{
    _dic2=[[NSMutableDictionary alloc]init];
    NSString *api_token = [RequestModel model:@"First" action:@"classify"];
    // strr=@"0";
    NSDictionary *dict = @{@"api_token":api_token,@"type":@1,@"prent_id":self.strr};
    __weak typeof(self) weakSelf = self;
    
    [RequestModel requestWithDictionary:dict model:@"First" action:@"classify" block:^(id result) {
        weakSelf.dic2=result[@"data"];
        [weakSelf.datasource2 removeAllObjects];
        [weakSelf.datasource3 removeAllObjects];
        [weakSelf.datasource2 addObjectsFromArray:weakSelf.dic2[@"classify"]];
        if (_dic2[@"product"]==[NSNull null]) {
            
        }else{
            [weakSelf.datasource3 addObjectsFromArray:weakSelf.dic2[@"product"]];
        }
        
        
#pragma mark-为轮播广告加图
        
        [weakSelf createScroll] ;
        [weakSelf.collect reloadData];
    }];
}
#pragma mark-点击滑动图进入下一页
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    int num=(int)[(UIImageView *)tap.view tag];
    if (num!=0||num!=_datasource3.count+1) {
        NSMutableArray * array=[[NSMutableArray alloc]init];
        [array addObjectsFromArray:_dic2[@"product"]];
        InfoPath=array[num][@"goods_name"];
        SearchListViewController *list=[[SearchListViewController alloc]init];
        list.secondLab=InfoPath;
        [self.navigationController pushViewController:list animated:YES];
    }else
    {
        NSLog(@"%d",num);
    }
    
}
#pragma mark-滑动开始时定时器启动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView==_myScroll) {
        if (_timer) {
            [_timer invalidate];
        }
        
    }
    
}
#pragma mark-实现滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat scrollviewW =  _myScroll.frame.size.width;
    CGFloat x = _myScroll.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.pagecontrol.currentPage = page;
    [self addtimer];
}
-(void)addpagecontroller
{    [_pagecontrol removeFromSuperview];
    _pagecontrol=[[UIPageControl  alloc]initWithFrame:CGRectMake(Tablewidth+140,64+ScrollHight-10,50, 20)];
    _pagecontrol.numberOfPages=_datasource3.count;
    _pagecontrol.pageIndicatorTintColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    _pagecontrol.currentPageIndicatorTintColor=[UIColor lightGrayColor];
    [self.view addSubview:_pagecontrol];
}
-(void)addtimer{
    if (_timer!=nil) {
        [_timer invalidate];
    }
    _timer=[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timeAction2:) userInfo:nil repeats:YES];
}
-(void)timeAction2:(NSTimer*)timer
{
    
    int page = (int)self.pagecontrol.currentPage;
    if (page == _datasource3.count - 1) {
        page = 0;
        
        self.pagecontrol.currentPage = 0;
        [_myScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        page ++;
        self.pagecontrol.currentPage ++;
        [_myScroll setContentOffset:CGPointMake(_myScroll.contentOffset.x+_myScroll.frame.size.width, 0) animated:YES];
    }
}

#pragma mark-右侧collect代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _datasource2.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string=@"string";
    sonCollectCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    cell.lab.text=_datasource2[indexPath.item][@"classify_name"];
    cell.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    cell.layer.borderWidth=0.5;
    cell.layer.cornerRadius=10;
    cell.lab.font=[UIFont systemFontOfSize:12];
    cell.lab.textColor=[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0];
    cell.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5,5,5,5);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.view.frame.size.width-Tablewidth-50)/3,40);
    
}
#pragma mark-collection点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectId=_datasource2[indexPath.row][@"classify_id"];
    SearchListViewController *good=[[SearchListViewController alloc]init];
    good.gooddid=_selectId;
    [self.navigationController pushViewController:good animated:NO];
}
#pragma mark-父类tableview的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource1.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string=@"string";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:string];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
       // _table1.backgroundColor=[UIColor lightGrayColor];
    }
    _table1.backgroundColor=[UIColor colorWithRed:240/255.0 green:241/255.0 blue:243/255.0 alpha:1.0];
    cell.backgroundColor=[UIColor colorWithRed:240/255.0 green:241/255.0 blue:243/255.0 alpha:1.0];
    cell.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    cell.layer.borderWidth=0.4;
    //cell.layer.cornerRadius=10;
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [_table1 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text=_datasource1[indexPath.row][@"classify_name"];
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    cell.textLabel.textColor=[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.highlightedTextColor=[UIColor redColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myScroll removeFromSuperview];
    
    _strr=NULL;
    _strr=_datasource1[indexPath.row][@"classify_id"];
    [self reloadRequestInfo2];
}
#pragma mark-创建搜索框
-(void)creatNav
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *navigationBGColor = data[@"navigationBGColor"];
    //左边
    UIView * vieww=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    vieww.backgroundColor = [UIColor colorWithHexString:navigationBGColor];
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 0.5)];
    label.backgroundColor=[UIColor lightGrayColor];
    [vieww addSubview:label];
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(12, 25, self.view.frame.size.width-59, 32);
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.layer.borderWidth=1;
    searchBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    searchBtn.layer.cornerRadius = 5;
    searchBtn.layer.masksToBounds=YES;
    [searchBtn addTarget:self action:@selector(pushSearch) forControlEvents:UIControlEventTouchUpInside];
    UIImage * imagebtn=[UIImage imageNamed:@"search"];
    imagebtn=[imagebtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView * leftImgView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 16, 16)];
    leftImgView.image=imagebtn;
    [searchBtn addSubview:leftImgView];
    [vieww addSubview:searchBtn];
    //右边
    UIButton *rightbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame=CGRectMake(self.view.frame.size.width-48, 16, 50, 50);
    [rightbtn setImage:[UIImage imageNamed:@"商品列表-saoyisao"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(bitBtnn:) forControlEvents:UIControlEventTouchUpInside];
    [vieww addSubview:rightbtn];
//    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(vieww.mas_top).with.offset(26);
//        make.left.equalTo(vieww.mas_left).with.offset(12);
//        make.right.equalTo(vieww.mas_right).with.offset(-50);
//        make.height.mas_equalTo(@32);
//    }];
//    [rightbtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(vieww.mas_top).with.offset(22);
//        make.right.equalTo(vieww.mas_right).with.offset(-12);
//        make.left.equalTo(searchBtn.mas_right).with.offset(12);
//        make.height.mas_equalTo(@40);
//        make.width.mas_equalTo(@40);
//    }];
    [self.view addSubview:vieww];
}


#pragma mark-扫一扫点击事件
-(void)bitBtnn:(id)sender
{
    BarCodeViewController * codee=[[BarCodeViewController alloc]init];
    codee.delegate=self;
    [self presentViewController:codee animated:YES completion:^{
        
    }];
    
}
-(void)QRCodeScanFinishiResult:(NSString *)result
{
    goodDetailViewController* good=[[goodDetailViewController alloc]init];
    if ([result rangeOfString:@"goods_id:"].location !=NSNotFound) {
        int a=[[result substringFromIndex:9 ]intValue];
        good.goodID=[NSString stringWithFormat:@"%d",a] ;
        [self.navigationController pushViewController:good animated:YES];
    }else {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,只能扫描我们的商品二维码哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark-搜索
-(void)pushSearch
{
    SearchViewController *search=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)dealloc {
    NSLog(@"%@ --%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
