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
#import "RequestModel.h"
#import "sonCollectCell.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+AFNetworking.h"
#import "BarCodeViewController.h"
#import "goodDetailViewController.h"
#import "UIColor+Hex.h"
#import "MyTabBarViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "SecondTableViewCell.h"
#import "BrandCollectionViewCell.h"
#import "GoodsCollectionReusableView.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#define Width self.view.frame.size.width
#define Height self.view.frame.size.height   //频幕的高度
#define ScrollHight 100   //滚动视图的高度

@interface secondViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate, QRCodeDelegate>
{
    NSString *InfoPath;
    UIView * viewww;
}
@property (nonatomic, strong) NSMutableArray *datasource1;//一级分类
@property (nonatomic, strong) NSMutableArray *datasource2;//二级分类
@property (nonatomic, strong) NSMutableArray *datasource3;//轮播图
@property (nonatomic, strong) NSMutableArray *brandArr;//存放品牌图片
@property (nonatomic, strong) NSMutableDictionary *dic2;
@property (nonatomic, strong) UITableView *table1;
@property (nonatomic, strong) UICollectionView *collect;

@property (nonatomic, assign) NSString *strr;
@property (nonatomic, strong) UIView *headview;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) GoodsCollectionReusableView *collheadview;
@property (nonatomic, assign) NSInteger tableDeleteNum;//选中第一个大类

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
    [super viewWillAppear:animated];
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
    _brandArr = [[NSMutableArray alloc]init];
    _tableDeleteNum = 0;
    _strr=@"1";
    [self reloadRequestInfo2];
    [self creatCollec];
    //创建左侧tableview
    [self creatVerticalCell];
    
    //请求数据
    [self reloadRequestInfo];
   
    //创建导航条
    [self creatNav];
    [self createNoNet];
}
-(void)afn
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    
    hud.labelText=@"loading";
    //检测网络是否可用
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    [self stringFromStatus:status];
    
    
    
}
-(void)stringFromStatus:(NetworkStatus)status{
    //    NSString *string;
    switch (status) {
        case NotReachable:
            //            string = @"Not Reachable";
            viewww.hidden = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            break;
        case ReachableViaWiFi:
            //            string = @"Reachable via WIFI";
            
            viewww.hidden = YES;
            break;
        case ReachableViaWWAN:
            //            string = @"Reachable via WWAN";
            viewww.hidden = YES;
            break;
        default:
            //            string = @"Unknown";
            break;
    }
    
}
-(void)createNoNet
{
    viewww=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    viewww.hidden = YES;
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
    notBtn.frame=CGRectMake(self.view.frame.size.width/2-35, viewww.frame.size.height/2-34, 70, 30);
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
    [self reloadRequestInfo];
    [self reloadRequestInfo2];
}
#pragma mark-创建左侧tableview
-(void)creatVerticalCell
{
    float a = 150.0/750.0;
    _table1=[[UITableView alloc]initWithFrame:CGRectMake(0,64, Width*a,Height-64) style:UITableViewStylePlain];
    _table1.opaque=YES;
    _table1.delegate=self;
    _table1.dataSource=self;
    _table1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table1.separatorColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    _table1.showsVerticalScrollIndicator=NO;
    _table1.showsHorizontalScrollIndicator = NO;
    [self.view  addSubview:_table1];
}

#pragma mark-创建右侧collectview
-(void)creatCollec
{
    UICollectionViewFlowLayout * flow=[[UICollectionViewFlowLayout alloc]init];
    flow.minimumInteritemSpacing = 0;
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    float a = 150.0/750.0;
    _collect=[[UICollectionView alloc]initWithFrame:CGRectMake(Width*a ,64 , Width-Width*a, Height-ScrollHight) collectionViewLayout:flow];
    _collect.opaque=YES;
    _collect.delegate=self;
    _collect.dataSource=self;
    _collect.backgroundColor=[UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:_collect];
    _datasource2=[[NSMutableArray alloc]init];
    [_collect registerClass:[sonCollectCell class] forCellWithReuseIdentifier:@"sonCollectCell"];
    [_collect registerClass:[BrandCollectionViewCell class] forCellWithReuseIdentifier:@"BrandCollectionViewCell"];
    [_collect registerClass:[GoodsCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
}
#pragma mark-请求tableview数据
-(void)reloadRequestInfo
{
    [self afn];
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
        [weakSelf.brandArr removeAllObjects];
        [weakSelf.datasource2 addObjectsFromArray:weakSelf.dic2[@"classify"]];
        if (_dic2[@"product"]==[NSNull null]) {
            
        }else{
            [weakSelf.brandArr addObjectsFromArray:weakSelf.dic2[@"product"]];
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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





#pragma mark-右侧collect代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_brandArr.count) {
        if (section==0) {
            return _brandArr.count;
        }else{
            return _datasource2.count;
        }
    }else{
        return _datasource2.count;
    }
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_brandArr.count == 0) {
        return 1;
    }else{
        return 2;
    }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_brandArr.count == 0) {
        //无品牌
        static NSString *string=@"sonCollectCell";
        sonCollectCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
        cell.lab.text=_datasource2[indexPath.item][@"classify_name"];
        cell.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        cell.layer.borderWidth=0.5;
        cell.layer.cornerRadius=10;
        cell.lab.font=[UIFont systemFontOfSize:12];
        cell.lab.textColor=[UIColor colorWithHexString:@"#666666"];
        cell.lab.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor=[UIColor whiteColor];
        return cell;
    }else{
        //有品牌
        if (indexPath.section == 0) {
            static NSString *string=@"BrandCollectionViewCell";
            BrandCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
            NSString *imageUrl = _brandArr[indexPath.row][@"brand_logo"];
            NSURL *imgUrl = [NSURL URLWithString:imageUrl];
            UIImage *imgFromUrl = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgUrl]];
            cell.brandImgView.image = imgFromUrl;
     
            return cell;
        }else{
            static NSString *string=@"sonCollectCell";
            sonCollectCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
            cell.lab.text=_datasource2[indexPath.item][@"classify_name"];
            cell.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
            cell.layer.borderWidth=0.5;
            cell.layer.cornerRadius=10;
            cell.lab.font=[UIFont systemFontOfSize:12];
            cell.lab.textColor=[UIColor colorWithHexString:@"#666666"];
            cell.lab.textAlignment = NSTextAlignmentCenter;
            cell.backgroundColor=[UIColor whiteColor];
            return cell;
        }
        
    }
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    float a = 12.0/750;
    float b = 12.0/1334.0;
    return UIEdgeInsetsMake(Height*b,Width*a,Height*b,Width*a);
    
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     float a = 184.0/750.0;
    if (_brandArr.count == 0) {
        //没有品牌的时候
       
        return CGSizeMake(Width*a,40);
    }else{
        if (indexPath.section == 0) {
            float b = 90.0/1334.0;
            return CGSizeMake(Width*a, Height*b);
        }else{
            return CGSizeMake(Width*a,40);
        }
    }
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusable = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        _collheadview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
//        _collheadview.title.text = [[NSString alloc] initWithFormat:@"%@",_brandArr[indexPath.section]];
        if (_brandArr.count != 0) {
            if (indexPath.section == 0) {
                _collheadview.title.text = @"推荐品牌";
            }else{
                int a = (int)_tableDeleteNum;
                _collheadview.title.text = _datasource1[a][@"classify_name"];;
            }
        }else{
            int a = (int)_tableDeleteNum;
            _collheadview.title.text = _datasource1[a][@"classify_name"];
        }
        _collheadview.title.textColor = [UIColor colorWithHexString:@"#666666"];
        UIView *viewLine = [[UIView alloc]init];
        if (indexPath.section == 0) {
            viewLine.frame=CGRectMake(0, 0,Width , 1);
        }else{
            viewLine.frame = CGRectMake(12, 0, Width-24, 1);
        }
        
        viewLine.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [_collheadview addSubview:viewLine];
        
        reusable = _collheadview;
    }
    return reusable;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    float a = 88.0/1334.0;
    return CGSizeMake(100, a*Height);
}
#pragma mark-collection点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_brandArr.count) {
        //有品牌
        if (indexPath.section == 0) {
            _selectId=_brandArr[indexPath.row][@"brand_id"];
            NSLog(@"品牌%ld,%@,%@",(long)indexPath.row,_selectId,_brandArr[indexPath.row][@"brand_name"]);
            SearchListViewController *good=[[SearchListViewController alloc]init];
            good.brandID=_selectId;
            [self.navigationController pushViewController:good animated:NO];
        }else{
            _selectId=_datasource2[indexPath.row][@"classify_id"];
            SearchListViewController *good=[[SearchListViewController alloc]init];
            good.gooddid=_selectId;
            [self.navigationController pushViewController:good animated:NO];
        }
    }else{
        //无品牌
        _selectId=_datasource2[indexPath.row][@"classify_id"];
        SearchListViewController *good=[[SearchListViewController alloc]init];
        good.gooddid=_selectId;
        [self.navigationController pushViewController:good animated:NO];
        
    }
    
}
#pragma mark-父类tableview的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource1.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string=@"string";
    SecondTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:string];
    if (cell==nil) {
        cell=[[SecondTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
       // _table1.backgroundColor=[UIColor lightGrayColor];
    }
    _table1.backgroundColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.borderColor=[UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    cell.layer.borderWidth=0.4;
    //cell.layer.cornerRadius=10;
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [_table1 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    cell.label.text=_datasource1[indexPath.row][@"classify_name"];
    cell.label.font=[UIFont systemFontOfSize:14];
    cell.label.textColor=[UIColor colorWithHexString:@"#656973"];
    cell.label.textAlignment=NSTextAlignmentCenter;
    cell.label.numberOfLines = 0;
    cell.label.highlightedTextColor=[UIColor colorWithHexString:@"#ff5000"];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float a = 112.0/1334.0;
    return Height*a;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self afn];
    _strr=NULL;
    _strr=_datasource1[indexPath.row][@"classify_id"];
    _tableDeleteNum = indexPath.row;
    _collheadview.title.text = _datasource1[indexPath.row][@"classify_name"];
    [self reloadRequestInfo2];
}
#pragma mark-创建搜索框
-(void)creatNav
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *navigationBGColor = data[@"navigationBGColor"];
    //导航栏
    UIView * vieww=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    vieww.backgroundColor = [UIColor colorWithHexString:navigationBGColor];
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 0.5)];
    label.backgroundColor=[UIColor colorWithHexString:@"#dbdbdb"];
    [vieww addSubview:label];
    float searchX = 24.0/750.0;
    
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(searchX*Width, 25, self.view.frame.size.width-59, 32);
    searchBtn.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2 "];
//    searchBtn.layer.borderWidth=1;
//    searchBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    searchBtn.layer.cornerRadius = 16;
    searchBtn.layer.masksToBounds=YES;
    [searchBtn addTarget:self action:@selector(pushSearch) forControlEvents:UIControlEventTouchUpInside];
    UIImage * imagebtn=[UIImage imageNamed:@"category_search"];
    imagebtn=[imagebtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView * leftImgView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 16, 16)];
    leftImgView.image=imagebtn;
    [searchBtn addSubview:leftImgView];
    UILabel * centerLab=[[UILabel alloc]initWithFrame:CGRectMake(40, 8, 200, 16)];
    centerLab.text=@"搜索商品/店铺";
    centerLab.textColor=[UIColor colorWithHexString:@"#b2b2b2"];
    centerLab.font=[UIFont systemFontOfSize:16];
    centerLab.textAlignment=NSTextAlignmentLeft;
    [searchBtn addSubview:centerLab];
    
    [vieww addSubview:searchBtn];
    //右边
    UIButton *rightbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame=CGRectMake(self.view.frame.size.width-48, 16, 50, 50);
    [rightbtn setImage:[UIImage imageNamed:@"category_sao"] forState:UIControlStateNormal];
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
