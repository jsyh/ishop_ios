//
//  ShopSearchListViewController.m
//  ecshop
//
//  Created by Jin on 16/4/12.
//  Copyright © 2016年 jsyh. All rights reserved.
//店铺搜索列表

#import "ShopSearchListViewController.h"
#import "UIColor+Hex.h"
#import "SearchShopTableViewCell.h"
#import "RequestModel.h"
#import "ShopModel.h"
#import "GoShopViewController.h"
#import "MJRefresh.h"
#import "SearchPopView.h"
#import "SearchListViewController.h"
#import "serDBModel.h"
#import "shangpinModel.h"
#import "AppDelegate.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define H(b) HEIGHT * b / 667.0
#define W(a) WIDTH * a / 375.0
@interface ShopSearchListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *shopTableView;
@property (nonatomic,strong)NSMutableArray *shopMuArray;//存储请求下来的店铺信息
@property (nonatomic,strong)NSString *pageTotalStr;
@property (nonatomic,assign)int page;
@property (nonatomic, strong) UIButton *searchBtn;//切换店铺宝贝的按钮
@property (nonatomic, strong) NSString *goodsOrShopStr;//记录是宝贝还是店铺
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic,strong)UIView *searchResultView; //没有搜索结果显示的view
@end

@implementation ShopSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    _goodsOrShopStr=@"1";
    [self creatUI];
    [self initNavigationBar];
    [self reloadInfo];
    NSLog(@"%@",self.keyword);
    // Do any additional setup after loading the view.
}
-(void)creatUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _shopMuArray = [[NSMutableArray alloc]init];
    _shopTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    _shopTableView.backgroundColor = [UIColor whiteColor];
    _shopTableView.delegate = self;
    _shopTableView.dataSource = self;
    _shopTableView.tableFooterView = [[UIView alloc]init];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    footer.refreshingTitleHidden = YES;
    _shopTableView.mj_footer = footer;
    
//    _shopTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        self.page++;
//        
//        int b =[self.pageTotalStr intValue];
//        if (self.page <= b) {
//            
//            
//            [self reloadInfo];
//            [_shopTableView.mj_footer endRefreshing];
//        }else{
//            [_shopTableView.mj_footer endRefreshingWithNoMoreData];
//        }
//    }];
    
    [self.view addSubview:_shopTableView];
    //没有搜索结果显示的view
    _searchResultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    float aY336 = 336.0/1334.0;
    float aW172 = 172.0/750.0;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - aW172*WIDTH/2, aY336*HEIGHT, aW172*WIDTH, aW172*WIDTH)];
    imgView.image = [UIImage imageNamed:@"seachGoods_null"];
    [_searchResultView addSubview:imgView];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+18, WIDTH, 16)];
    lab.text = @"未找到相关店铺";
    lab.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textAlignment = NSTextAlignmentCenter;
    [_searchResultView addSubview:lab];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+12, WIDTH, 13)];
    lab2.text = @"暂时没有相关数据";
    lab2.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab2.font = [UIFont systemFontOfSize:13];
    lab2.textAlignment = NSTextAlignmentCenter;
    [_searchResultView addSubview:lab2];
//    //没有搜索结果
//    UILabel *searchResultsLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 400, 100, 40)];
//    searchResultsLab.text = @"没有搜索结果";
//    searchResultsLab.backgroundColor = [UIColor redColor];
//    [_searchResultView addSubview:searchResultsLab];
//    //没有找到相关的店铺
//    UILabel *searchShop = [[UILabel alloc]initWithFrame:CGRectMake(100, 300, 100, 40)];
//    searchShop.text = @"没有找到相关的店铺";
//    searchShop.backgroundColor = [UIColor redColor];
//    [_searchResultView addSubview:searchShop];
    
    _searchResultView.hidden = YES;
    [self.view addSubview:_searchResultView];
    
}
#pragma mark -- 刷新
-(void)footerRefreshAction{
    self.page++;
    
    int b =[self.pageTotalStr intValue];
    if (self.page <= b) {
        
        
        [self reloadInfo];
        [_shopTableView.mj_footer endRefreshing];
    }else{
        [_shopTableView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma mark -- 解析数据
-(void)reloadInfo
{
    
    
    NSString *api_token = [RequestModel model:@"First" action:@"shop_sear"];
    NSDictionary * dic ;
    __weak typeof(self) weakSelf = self;
    NSString *a = [NSString stringWithFormat:@"%d",self.page];
    if ([a isEqualToString:@"1"]) {
        [_shopMuArray removeAllObjects];
    }
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *key = app.tempDic[@"data"][@"key"];
    if (key == nil) {
        key = @"";
    }

    dic= @{@"api_token":api_token,@"keyword":_keyword,@"page":a,@"key":key};
 
    [RequestModel requestWithDictionary:dic model:@"First" action:@"shop_sear" block:^(id result) {
        // [_collectDatasource addObjectsFromArray:result[@"data"]];
        
        NSDictionary *dic = result;
        
        weakSelf.pageTotalStr = dic[@"data"][@"page_total"];
        NSArray *dataArr = dic[@"data"][@"info"];
        for (NSMutableDictionary *dataDic in dataArr) {
            //shop
            ShopModel *model = [ShopModel new];
            model.supplierID = dataDic[@"shop"][@"supplier_id"];
            model.shopRage = dataDic[@"shop"][@"shop_rage"];
            model.shopLogo = dataDic[@"shop"][@"shop_logo"];
            model.shopName = dataDic[@"shop"][@"shop_name"];
            model.address = dataDic[@"shop"][@"address"];
            model.shopUrl = dataDic[@"shop"][@"shop_url"];
            model.sales = dataDic[@"shop"][@"sales"];
            model.goodsNum = dataDic[@"shop"][@"goods_sum"];
            model.attention = [dataDic[@"shop"][@"attention"] intValue];
            //goods
            NSArray *goodsArr = dataDic[@"goods"];
            model.goodsArr = goodsArr;
            [weakSelf.shopMuArray addObject:model];
        }
        
        [self creat];
        
        [weakSelf.shopTableView reloadData];
    }];
   
}
-(void)creat{
    if (_shopMuArray.count == 0) {
          _searchResultView.hidden = NO;
    }else{
        _searchResultView.hidden = YES;
    }
}
#pragma mark --tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _shopMuArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid=@"ShopTableViewCell";

    SearchShopTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[SearchShopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    ShopModel *model;
    model = _shopMuArray[indexPath.section];
    cell.backgroundColor=[UIColor whiteColor];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *imgUrl = data[@"imgUrl"];
    NSString *imgStr = [NSString stringWithFormat:@"%@/%@",imgUrl,model.shopLogo];
    cell.shopNameLab.text = model.shopName;
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgStr]]];
    cell.shopImage.image = img;
    cell.salesNumLab.text = [NSString stringWithFormat:@"销量 %@ 件 共 %@ 件宝贝",model.sales,model.goodsNum];
    if ([model.shopRage isEqualToString:@"1"]) {
        cell.shopGradeLab.text = @"初级店铺";
    }else if([model.shopRage isEqualToString:@"2"]){
        cell.shopGradeLab.text = @"中级店铺";
    }else{
        cell.shopGradeLab.text = @"高级店铺";
    }
    int count = (int)model.goodsArr.count;

    float size = (WIDTH - 12*5)/4.0;
    for (int i = 0; i < count; i++) {
//        NSString *goodsID = model.goodsArr[i][@"goods_id"];
//        NSString *goodsName = model.goodsArr[i][@"goods_name"];
        NSString *goodsThumb = model.goodsArr[i][@"goods_thumb"];
        NSString *goodsPrice = model.goodsArr[i][@"shop_price"];
        float a = i*size+12*(i+1);
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(a, 10, size, size)];
        imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:goodsThumb]]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.frame.size.height-18, 50, 28)];
//        label.backgroundColor = [UIColor blackColor];
//        label.alpha = 0.5;
        label.textColor = [UIColor colorWithHexString:@"#ffffff"];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:10];
        label.text = [NSString stringWithFormat:@"%@",goodsPrice];
        [label sizeToFit];
        
        UIImageView *imgDiSe = [[UIImageView alloc]initWithFrame:CGRectMake(0, imgView.frame.size.height-28, imgView.frame.size.width, 28)];
        imgDiSe.image = [UIImage imageNamed:@"goods_pice_background"];
        [imgView addSubview:imgDiSe];
        [imgView addSubview:label];
        [cell.imgView addSubview:imgView];
        UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, cell.imgView.frame.size.height, WIDTH, 1)];
        viewLine.backgroundColor = [UIColor colorWithHexString:@"#DBDBDB"];
        [cell.imgView addSubview:viewLine];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShopModel *model ;
    model = _shopMuArray[indexPath.section];
    GoShopViewController *goShopVC = [GoShopViewController new];
    goShopVC.shopUrl = model.shopUrl;
    goShopVC.shopID = model.supplierID;
    goShopVC.attention = model.attention;
    [self.navigationController pushViewController:goShopVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    float imgFloatX = 12.0/750.0;
    float imgFloatY = 12.0/1334.0;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH*imgFloatX, HEIGHT*imgFloatY, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(imgFloatX*WIDTH, 20+imgFloatY*HEIGHT, 20+WIDTH*imgFloatX, 20+HEIGHT*imgFloatY)];
    [btn addSubview:imgView];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    
    //搜索框背景
    float searchFloatX = 176.0/750.0;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.size.width+btn.frame.origin.x+WIDTH*imgFloatX*2, 25, WIDTH-WIDTH*searchFloatX, 32)];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    searchView.layer.cornerRadius = 16;
    searchView.layer.masksToBounds = YES;
    
    
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(imgFloatX*WIDTH, imgFloatY*HEIGHT, 40, 20)];
    [_searchBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"goods_list_arrow_normal"]] forState:UIControlStateNormal];
    [_searchBtn setTitle:@"店铺" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];

    _searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -W(17), 0, 0);
    _searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0,35, 0, 0);

    //goods_list_arrow_normal@2x
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_searchBtn addTarget:self action:@selector(goodsOrShop:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:_searchBtn];
    
    //(3)中间 搜索框
    _textField=[[UITextField alloc]init];
    _textField.frame=CGRectMake(_searchBtn.frame.size.width+_searchBtn.frame.origin.x +WIDTH*imgFloatX , 0, searchView.frame.size.width - imgFloatX*WIDTH*3-40, 32);
    _textField.backgroundColor = [UIColor clearColor];
    _textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _textField.text = self.keyword;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.textColor = [UIColor colorWithHexString:@"#43464c"];
    _textField.delegate = self;
    //    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.tag = 10000;
    
    [searchView addSubview:_textField];
    [view addSubview:searchView];
    
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [view addSubview:viewLine];
    
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
            [self reloadInfo];
        }
        else if (index==1)
        {
            [btn setTitle:@"店铺" forState:UIControlStateNormal];
            _goodsOrShopStr=@"1";
            [self reloadInfo];
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
                SearchListViewController *list=[[SearchListViewController alloc]init];
                list.secondLab=_keywords;
                //                list.gooddid =
                [self.navigationController pushViewController:list animated:YES];
                
            }else if([_goodsOrShopStr isEqualToString:@"1"]){
                //1 店铺搜索
//                ShopSearchListViewController *shopVC = [ShopSearchListViewController new];
//                shopVC.keyword = _keywords;
//                [self.navigationController pushViewController:shopVC animated:YES];
                self.keyword = _keywords;
                self.page = 1;
                [self reloadInfo];
            }
        }
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
