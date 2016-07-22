//
//  SearchViewController.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/1.
//  Copyright © 2015年 jsyh. All rights reserved.
//搜索页

#import "SearchViewController.h"
#import "Masonry.h"
#import "SearchListViewController.h"
#import "serDBModel.h"
#import "shangpinModel.h"
#import "UIColor+Hex.h"
#import "MyTabBarViewController.h"
#import "sonCollectCell.h"
#import "RequestModel.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    BOOL kaiguan;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *reLab;
@property (nonatomic, strong) UICollectionView * adCollect;//热搜广告
@property (nonatomic, strong) NSMutableArray * collectDatasource;//数据源
@property (nonatomic, strong) UICollectionView *secondAdCollect;

@end

@implementation SearchViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    
    [tabbar hiddenTabbar:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //self.navigationController.navigationBar.hidden=NO;
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = [[serDBModel shareDBModel]selectInfo];
    [self  createUI];
    if (arr.count!=0) {
        kaiguan=YES;
        [self createAd];
        
        
    }else if(arr.count==0)
    {
        kaiguan=NO;
        
        [self createSecondAd];
        [_table removeFromSuperview];
    }
    
    [self initNavigationBar];
    
    [self reloadInfo];
    self.navigationController.navigationBar.hidden=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor colorWithRed:247/255.0 green:243/255.0 blue:245/255.0 alpha:1.0];
    
}
-(void)reloadInfo
{
    _collectDatasource=[[NSMutableArray alloc]init];
    NSString *api_token = [RequestModel model:@"first" action:@"keywords"];
    NSDictionary * dic;
    dic= @{@"api_token":api_token};
    [RequestModel requestWithDictionary:dic model:@"first" action:@"keywords" block:^(id result) {
        [_collectDatasource addObjectsFromArray:result[@"data"]];
        [_adCollect reloadData];
        [_secondAdCollect reloadData];
    }];
    
}
-(void)createAd
{
    UICollectionViewFlowLayout* flout=[[UICollectionViewFlowLayout alloc]init];
    flout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    _adCollect=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 35) collectionViewLayout:flout];
    _adCollect.backgroundColor=[UIColor colorWithRed:247/255.0 green:243/255.0 blue:245/255.0 alpha:1.0];
    _adCollect.showsHorizontalScrollIndicator=NO;
    _adCollect.delegate=self;
    _adCollect.dataSource=self;
    
    
    [_adCollect registerClass:[sonCollectCell class] forCellWithReuseIdentifier:@"ad"];
    [self.view addSubview:_adCollect];
}
-(void)createSecondAd
{
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, 40, 40)];
    label.text=@"热搜";
    label.font=[UIFont systemFontOfSize:17];
    [self.view addSubview:label];
    UICollectionViewFlowLayout * flow=[[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    _secondAdCollect=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120) collectionViewLayout:flow];
    _secondAdCollect.showsVerticalScrollIndicator=NO;
    _secondAdCollect.backgroundColor=[UIColor colorWithRed:247/255.0 green:243/255.0 blue:245/255.0 alpha:1.0];   _secondAdCollect.delegate=self;
    _secondAdCollect.dataSource=self;
    [_secondAdCollect registerClass:[sonCollectCell class] forCellWithReuseIdentifier:@"ad"];
    [_table removeFromSuperview];
    [self.view addSubview:_secondAdCollect];
    
}
-(void)createUI
{
    UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _table.frame.size.width, 50)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake( self.view.frame.size.width/2-60                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,10, 120, 40);
    button.layer.cornerRadius = 10.0;
    [button.layer setBorderWidth:1];
    button.layer.borderColor=[UIColor lightGrayColor].CGColor;
    button.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [button setTitle:@"清空历史搜索" forState:UIControlStateNormal ];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearData2) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    UIView *viewHistory=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel * labeHot=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 20)];
    labeHot.text=@"历史搜索";
    labeHot.font=[UIFont systemFontOfSize:15];
    UILabel * labelHua=[[UILabel alloc]initWithFrame:CGRectMake(15, 39, self.view.frame.size.width, 0.5)];
    labelHua.backgroundColor=[UIColor lightGrayColor];
    [viewHistory addSubview:labelHua];
    [viewHistory addSubview:labeHot];
    _table=[[UITableView alloc]initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, self.view.frame.size.height-140) style:UITableViewStylePlain];
    [_table.layer setBorderWidth:0.3];
    _table.delegate=self;
    _table.dataSource=self;
    _table.tableHeaderView=viewHistory;
    _table.tableFooterView=footerView;
    _table.backgroundColor=[UIColor colorWithRed:247/255.0 green:243/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:_table];
    _datasource=[[NSMutableArray alloc]init];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _collectDatasource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ad=@"ad";
    sonCollectCell * cell=[collectionView  dequeueReusableCellWithReuseIdentifier:ad forIndexPath:indexPath];
    if (kaiguan==YES) {
        if (indexPath.item==0) {
            cell.lab.text=@"热搜";
            cell.lab.font=[UIFont systemFontOfSize:17];
            cell.backgroundColor=[UIColor colorWithRed:247/255.0 green:243/255.0 blue:245/255.0 alpha:1.0];
        }
        else{
            cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
            cell.backgroundColor=[UIColor whiteColor];
            cell.layer.borderWidth=1;
            cell.layer.cornerRadius=10;
            cell.lab.text=_collectDatasource[indexPath.item];
        }
    }else if (kaiguan==NO){
        cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.backgroundColor=[UIColor whiteColor];
        cell.layer.borderWidth=1;
        cell.layer.cornerRadius=10;
        cell.lab.text=_collectDatasource[indexPath.item];
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(43, 35);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _firstLab=_collectDatasource[indexPath.item];
    SearchListViewController *list=[[SearchListViewController alloc]init];
    
    list.secondLab=_firstLab;
    NSMutableArray *pin=[[NSMutableArray alloc]init];
    [pin addObjectsFromArray:[[serDBModel shareDBModel]selectInfo]];
    if (pin.count==0) {
        [[serDBModel shareDBModel] insertInfoDBModelWithName:_firstLab];
        
    }else{
        int i=0;
        for (shangpinModel *ping in pin) {
            if ([ping.titleName isEqualToString:_firstLab]) {
                break;
                
            }else{
                if (i==pin.count-1) {
                    
                    [[serDBModel shareDBModel] insertInfoDBModelWithName:_firstLab];
                }
            }
            i++;
        }
    }
    [self.navigationController pushViewController:list animated:NO];
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    return @"历史搜索";
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[serDBModel shareDBModel] selectInfo].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = @"string";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        cell.backgroundColor=[UIColor colorWithRed:247/255.0 green:243/255.0 blue:245/255.0 alpha:1.0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    shangpinModel *shangpin = [[shangpinModel alloc]init];
    shangpin = [[[serDBModel shareDBModel]selectInfo] objectAtIndex:indexPath.row];
    cell.textLabel.text = shangpin.titleName;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    shangpinModel *shangpin = [[shangpinModel alloc]init];
    shangpin = [[[serDBModel shareDBModel]selectInfo] objectAtIndex:indexPath.row];
    
    self.firstLab=shangpin.titleName;
    SearchListViewController *list=[[SearchListViewController alloc]init];
    list.secondLab=_firstLab;
    [self.navigationController pushViewController:list animated:YES];
    
}
////尾视图
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"清空历史搜索" forState:UIControlStateNormal ];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clearData2) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//    
//}
//清除历史搜索
-(void)clearData2{
    [[serDBModel shareDBModel] deleteAll];
    [_adCollect removeFromSuperview];
    [_table reloadData];
    kaiguan=NO;
    [self createSecondAd];
}
//区尾高度
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 20;
//}
//返回上一页面
-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击搜素
-(void)sureBtn:(id)sender
{
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
            self.firstLab=_textField.text;
            SearchListViewController *list=[[SearchListViewController alloc]init];
            
            list.secondLab=_firstLab;
            [self.navigationController pushViewController:list animated:YES];
        }
    }
}
//释放键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)dealloc {
    NSLog(@"%@ --%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 自定义导航栏
- (void)initNavigationBar{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *naviBGColor = data[@"navigationBGColor"];
    NSString *navigationRightFont = data[@"navigationRightFont"];
    int navigationRFont = [navigationRightFont intValue];
    NSString *navigationRightColor = data[@"navigationRightColor"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    [btn addSubview:imgView];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 52, 32, 40, 20)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor colorWithHexString:navigationRightColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:navigationRFont];
    [searchBtn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:searchBtn];
    
    //(3)中间 搜索框
    _textField=[[UITextField alloc]init];
    _textField.frame=CGRectMake(44 , 26, self.view.frame.size.width - 108, 32);
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    
    UIImage * imagebtn=[UIImage imageNamed:@"search"];
    imagebtn=[imagebtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView * imageviewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 18, 18)];
    imageviewLeft.image=imagebtn;
    
//    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 6, 18, 18)];
//    leftImageView.image = [UIImage imageNamed:@"search"];
   // _textField.leftView = leftImageView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.tag = 10000;
    [_textField addSubview:imageviewLeft];
    [view addSubview:_textField];
    [self.view addSubview:view];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
