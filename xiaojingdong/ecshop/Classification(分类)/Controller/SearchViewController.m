//
//  SearchViewController.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/1.
//  Copyright © 2015年 jsyh. All rights reserved.
//搜索页

#import "SearchViewController.h"
#import "SearchListViewController.h"
#import "serDBModel.h"
#import "shangpinModel.h"
#import "UIColor+Hex.h"
#import "MyTabBarViewController.h"
#import "sonCollectCell.h"
#import "RequestModel.h"
#import "SearchPopView.h"
#import "NSString+Extension.h"
#import "SearchHeaderCollectionReusableView.h"
#import "SearchFooterCollectionReusableView.h"
#import "ShopSearchListViewController.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define H(b) Height * b / 667.0
#define W(a) Width * a / 375.0
@interface SearchViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UITextFieldDelegate>
{
    BOOL kaiguan;
}

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *reLab;

@property (nonatomic, strong) NSMutableArray * collectDatasource;//数据源
@property (nonatomic, strong) UICollectionView *secondAdCollect;
@property (nonatomic, strong) UIButton *searchBtn;//搜索框上的宝贝店铺按钮
@property (nonatomic,strong)SearchHeaderCollectionReusableView *headview;
@property (nonatomic,strong)SearchFooterCollectionReusableView *footview;
@property (nonatomic,strong)NSString *btnOrder;//0是宝贝搜索 1是店铺搜索
@end

@implementation SearchViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    
    [tabbar hiddenTabbar:YES];
    NSArray *arr = [[serDBModel shareDBModel]selectInfo];
    if (arr.count!=0) {
        kaiguan=YES;
        
        
    }else if(arr.count==0)
    {
        kaiguan=NO;
      
    }

    [self.secondAdCollect reloadData];
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
    if (arr.count!=0) {
        kaiguan=YES;
    }else if(arr.count==0)
    {
        kaiguan=NO;
    }
    _btnOrder = @"0";
    [self createSecondAd];
    [self initNavigationBar];
    
    [self reloadInfo];
    self.navigationController.navigationBar.hidden=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
}
-(void)reloadInfo
{
    
    _collectDatasource=[[NSMutableArray alloc]init];
    NSString *api_token = [RequestModel model:@"first" action:@"keywords"];
    NSDictionary * dic;
    dic= @{@"api_token":api_token};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dic model:@"first" action:@"keywords" block:^(id result) {
        [weakSelf.collectDatasource addObjectsFromArray:result[@"data"]];
        [weakSelf.secondAdCollect reloadData];
    }];
    
}

-(void)createSecondAd
{
    UICollectionViewFlowLayout * flow=[[UICollectionViewFlowLayout alloc]init];
    flow.minimumInteritemSpacing = 0;
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    _secondAdCollect=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:flow];
    _secondAdCollect.showsVerticalScrollIndicator=NO;
    [_secondAdCollect registerClass:[SearchHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [_secondAdCollect registerClass:[SearchFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
    _secondAdCollect.backgroundColor=[UIColor colorWithHexString:@"#F2F2F2"];
    _secondAdCollect.delegate=self;
    _secondAdCollect.dataSource=self;
    [_secondAdCollect registerClass:[sonCollectCell class] forCellWithReuseIdentifier:@"adString"];
    [self.view addSubview:_secondAdCollect];
    
}


#pragma mark --collection delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (kaiguan == YES) {
        if (section == 0) {
            return _collectDatasource.count;
        }else{
            return [[serDBModel shareDBModel] selectInfo].count;
        }
    }else{
        return _collectDatasource.count;
    }
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (kaiguan == YES) {
        return 2;
    }else{
        return 1;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * adString=@"adString";
    sonCollectCell * cell=[collectionView  dequeueReusableCellWithReuseIdentifier:adString forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.lab.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.cornerRadius=5;
    if (kaiguan==YES) {
        if (indexPath.section == 0) {
            cell.lab.text=_collectDatasource[indexPath.item];
        }else{
            shangpinModel *shangpin ;
            shangpin = [[[serDBModel shareDBModel]selectInfo] objectAtIndex:indexPath.row];
            cell.lab.text = shangpin.titleName;
        }
    }else if (kaiguan==NO){
        cell.lab.text=_collectDatasource[indexPath.item];
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight = 66.0/1334.0;
    float cellWidth = 24.0/750.0;
    if (kaiguan == YES) {
        if (indexPath.section == 0) {
            NSString *a = _collectDatasource[indexPath.item];
            CGSize size = [a sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            return CGSizeMake(size.width+cellWidth*Width*2, cellHeight*Height);
        }else{
            shangpinModel *shangpin;
            shangpin = [[[serDBModel shareDBModel]selectInfo] objectAtIndex:indexPath.row];
            NSString *a = shangpin.titleName;
            CGSize size = [a sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            return CGSizeMake(size.width+cellWidth*Width*2, cellHeight*Height);
        }
    }else{
        NSString *a = _collectDatasource[indexPath.item];
        CGSize size = [a sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        return CGSizeMake(size.width+cellWidth*Width*2, cellHeight*Height);
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        _firstLab=_collectDatasource[indexPath.item];
    }else{
        shangpinModel *shangpin;
        shangpin = [[[serDBModel shareDBModel]selectInfo] objectAtIndex:indexPath.row];
        _firstLab = shangpin.titleName;
    }
    if ([_btnOrder isEqualToString:@"0"]) {
        //0 宝贝搜索
        SearchListViewController *list=[[SearchListViewController alloc]init];
        list.secondLab=_firstLab;
        [self.navigationController pushViewController:list animated:YES];
        
    }else if([_btnOrder isEqualToString:@"1"]){
        //1 店铺搜索
        ShopSearchListViewController *shopVC = [ShopSearchListViewController new];
        shopVC.keyword = _firstLab;
        [self.navigationController pushViewController:shopVC animated:YES];
    }

  
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
   
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    float a = 24.0/750;
    float b = 24.0/1334.0;
    return UIEdgeInsetsMake(Height*b,Width*a,Height*b,Width*a);
    
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    float a = 12.0/750;
    return a*Width;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    float a = 12.0/750;
    return a*Width;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusable = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        _headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        _headview.title.text = @"最近搜索";
        _headview.imgView.image = [UIImage imageNamed:@"search_history"];
        _headview.title.textColor = [UIColor colorWithHexString:@"#656973"];
        _headview.title.font = [UIFont systemFontOfSize:14];
        
        reusable = _headview;
    }else if(kind == UICollectionElementKindSectionFooter){
        _footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        _footview.clearBtn.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
        [_footview.clearBtn addTarget:self action:@selector(clearData2) forControlEvents:UIControlEventTouchUpInside];
        _footview.clearBtn.userInteractionEnabled = YES;
        reusable = _footview;
    }
    return reusable;
}
//header CGSize
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }else{
        float a = 76.0/1334.0;
        
        return CGSizeMake(Width, Height*a);
    }
    
}
//footer CGSize
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (kaiguan == YES) {
        if (section == 0) {
            return CGSizeMake(0, 0);
        }else{
            float btnX = 376.0/750.0;
            float btnY = 188.0/1334.0;
            
            return CGSizeMake(Width*btnX, Height*btnY);
        }
    }else{
        return CGSizeMake(0, 0);
    }
    
    
}

//清除历史搜索
-(void)clearData2{
    [[serDBModel shareDBModel] deleteAll];

    kaiguan=NO;
    [self.secondAdCollect reloadData];
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
            _btnOrder=@"0";
            [self reloadInfo];
        }
        else if (index==1)
        {
            [btn setTitle:@"店铺" forState:UIControlStateNormal];
            _btnOrder=@"1";
            [self reloadInfo];
        }
    };
    [pop show];

}
//返回上一页面
-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击搜素
-(void)sureBtn
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
            if ([_btnOrder isEqualToString:@"0"]) {
                //0 宝贝搜索
                SearchListViewController *list=[[SearchListViewController alloc]init];
                list.secondLab=_firstLab;
//                list.gooddid =
                [self.navigationController pushViewController:list animated:YES];
                
            }else if([_btnOrder isEqualToString:@"1"]){
                //1 店铺搜索
                ShopSearchListViewController *shopVC = [ShopSearchListViewController new];
                shopVC.keyword = _firstLab;
                [self.navigationController pushViewController:shopVC animated:YES];
            }
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
     
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    float imgFloatX = 12.0/750.0;
    float imgFloatY = 12.0/1334.0;
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
    _textField.placeholder = @"开学季";
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.textColor = [UIColor colorWithHexString:@"#43464c"];
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.tag = 10000;
    
    [searchView addSubview:_textField];
    [view addSubview:searchView];
    [self.view addSubview:view];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark -- 模糊搜索
-(void)textFieldDidChange:(UITextField *) textField{
//    NSLog(@"11111%@",textField.text);
}
@end
