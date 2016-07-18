//
//  GoodsCarViewController.m
//  ecshop
//
//  Created by Jin on 16/4/28.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "GoodsCarViewController.h"
#import "fourthViewController.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"
#import "MyTabBarViewController.h"
#import "LoginViewController.h"
#import "GoodsCarTableViewCell.h"
#import "RequestModel.h"
#import "shangpinModel.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"
#import "KeyboardManager.h"
#import "goodDetailViewController.h"
#import "SureOrderViewController.h"
#import "MyAttentionViewController.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface GoodsCarViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *goodsDic;//存放商品信息
@property(nonatomic,strong)NSMutableArray *shopArr; //商店名称的数组
@property (nonatomic,strong)NSMutableArray *contacts;//存放是否选择的信息
@property (nonatomic,strong)NSMutableArray *deleteArr;//选择的商品存放在数组中
@property (nonatomic,strong)NSMutableDictionary *sectionDic;
@property (nonatomic,strong)NSMutableDictionary *selectDic;//存放每个section选中了几个
@property (nonatomic,strong)UILabel *totalLab;//合计的lab
@property (nonatomic,strong)UILabel *totalPrieLab;//总价钱
@property (nonatomic,strong)UIButton *settlementBtn;//去结算按钮
@property (nonatomic,strong)UIButton *allChangeBtn;//全选按钮
@property (nonatomic,strong)UIButton *editBtn;//编辑按钮
@property (nonatomic,strong)UITextField *tempTextField;
@property (nonatomic,strong)IQKeyboardReturnKeyHandler *returnKeyHander;
@property (nonatomic,strong)UIView *nullView;
@property (nonatomic,strong)UIView *bottomView;
@end

@implementation GoodsCarViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    if (app.tempDic == nil) {
        
        LoginViewController *loginVC = [LoginViewController new];
        MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
        loginVC.type = @"购物车";
        [tabbar hiddenTabbar:YES];
        [self.navigationController pushViewController:loginVC animated:YES];

    }else if(app.tempDic != nil){
        [self myGoods];
        [self draw];
        if ([self.temp isEqualToString:@"1"]) {
            MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
            
            [tabbar hiddenTabbar:YES];
        }else{
            MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
            
            [tabbar hiddenTabbar:NO];
        }
    }
   

}
-(void)dealloc{
    _returnKeyHander = nil;
    self.temp = @"0";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    _returnKeyHander = [[IQKeyboardReturnKeyHandler alloc]initWithViewController:self];
    [self initNavigationBar];
    [self creatnullView];
    _sectionDic = [NSMutableDictionary dictionary];
    if (app.tempDic != nil) {
        
    }
  
    _deleteArr = [NSMutableArray array];
    _selectDic = [NSMutableDictionary dictionary];

    // Do any additional setup after loading the view.
}
-(void)creatnullView{
    _nullView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-64)];
    _nullView.hidden = YES;
    _nullView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    float aY336 = 336.0/1334.0;
    float aW172 = 172.0/750.0;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - aW172*Width/2, aY336*Height, aW172*Width, aW172*Width)];
    imgView.image = [UIImage imageNamed:@"cart_empty_data"];
    [_nullView addSubview:imgView];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+18, Width, 16)];
    lab.text = @"购物车快饿瘪啦T.T";
    lab.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textAlignment = NSTextAlignmentCenter;
    [_nullView addSubview:lab];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+12, Width, 13)];
    lab2.text = @"看看关注有要购买的吗";
    lab2.textColor = [UIColor colorWithHexString:@"#666666"];
    lab2.font = [UIFont systemFontOfSize:13];
    lab2.textAlignment = NSTextAlignmentCenter;
    [_nullView addSubview:lab2];
    UIButton *careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    careBtn.frame = CGRectMake(Width/2.0 - 68, lab2.frame.size.height+lab2.frame.origin.y+12, 136, 33);
    [careBtn setTitle:@"看看关注" forState:UIControlStateNormal];
    [careBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    careBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    careBtn.layer.borderWidth = 0.3f;
    careBtn.layer.masksToBounds = YES;
    careBtn.layer.cornerRadius = 5;
    [careBtn addTarget:self action:@selector(careAction) forControlEvents:UIControlEventTouchUpInside];
    [_nullView addSubview:careBtn];
 
    [self.view addSubview:_nullView];
}
-(void)careAction{
    //看看关注
    MyAttentionViewController *myAttentionVC = [MyAttentionViewController new];
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    [self.navigationController pushViewController:myAttentionVC animated:YES];
}
-(void)draw{
    _goodsDic = [NSMutableDictionary dictionary];
    _shopArr = [NSMutableArray array];
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width, Height - 160) style:UITableViewStyleGrouped];
        
        if ([self.temp isEqualToString:@"1"]) {
            //从商品详情调过来
            _tableView.frame = CGRectMake(0, 64, Width, Height - 116);
        }else{
            _tableView.frame = CGRectMake(0, 64, Width, Height - 160);
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.allowsMultipleSelectionDuringEditing=YES;
        [_tableView setShowsVerticalScrollIndicator:NO];
        _tableView.tintColor = [UIColor colorWithHexString:@"#ff5000"];
        [_tableView setSeparatorColor:[UIColor colorWithHexString:@"#ffffff"]];
        //    [self.tableView setEditing:YES animated:YES];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf myGoods];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
        [_tableView.mj_header beginRefreshing];
        [self.view addSubview:_tableView];
        
        _bottomView = [[UIView alloc]init];
        if ([self.temp isEqualToString:@"1"]) {
            //从商品详情调过来
            _bottomView.frame = CGRectMake(0, Height-50, Width, 50);
        }else{
            _bottomView.frame = CGRectMake(0, Height-96, Width, 50);
        }
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        //全选
        _allChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allChangeBtn.frame = CGRectMake(0, 0, 100, 46);
        _allChangeBtn.selected = NO;
        [_allChangeBtn setTitle:@"全选" forState:UIControlStateNormal];
        _allChangeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_allChangeBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        [_allChangeBtn setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
        [_allChangeBtn addTarget:self action:@selector(selectAllActioon:) forControlEvents:UIControlEventTouchUpInside];
        _allChangeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _allChangeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
        [_bottomView addSubview:_allChangeBtn];
        //结算
        float aW200 = 200.0/750.0;
        _settlementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settlementBtn setTitle:@"结算(0)" forState:UIControlStateNormal];
        _settlementBtn.frame = CGRectMake(Width-aW200*Width, 0, aW200*Width, _bottomView.frame.size.height);
        _settlementBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
        [_settlementBtn addTarget:self action:@selector(settlement:) forControlEvents:UIControlEventTouchUpInside];
        _settlementBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomView addSubview:_settlementBtn];
        
        //合计
        _totalLab = [[UILabel alloc]initWithFrame:CGRectMake(_allChangeBtn.frame.size.width, 0, 50, 46)];
        _totalLab.hidden = NO;
        _totalLab.text = @"合计：";
        _totalLab.font = [UIFont systemFontOfSize:15];
        _totalLab.textAlignment = NSTextAlignmentRight;
        _totalLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        [_bottomView addSubview:_totalLab];
        //总价钱
        _totalPrieLab = [[UILabel alloc]initWithFrame:CGRectMake(_totalLab.frame.size.width+_totalLab.frame.origin.x, 0, 100, 46)];
        NSString *price = @"¥0.00";
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
        NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
        NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, a)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a, b)];
        _totalPrieLab.attributedText = attributStr;
        _totalPrieLab.hidden = NO;
        _totalPrieLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
        [_bottomView addSubview:_totalPrieLab];
        
        
        [self.view addSubview:_bottomView];
    }
    
}
#pragma mark --去结算和删除按钮事件
-(void)settlement:(UIButton*)button{
    NSString *text = [button.titleLabel.text substringToIndex:2];
    
    NSString *name;
    NSString *recID;
    if (self.deleteArr.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择商品。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        for (shangpinModel *model in self.deleteArr) {
            if (name.length>0) {
                name = [NSString stringWithFormat:@"%@,%@",name,model.goodsName];
                recID = [NSString stringWithFormat:@"%@,%@",recID,model.recID];
            }else{
                name = model.goodsName;
                recID = model.recID;
            }
        }
        
        
        if ([text isEqualToString:@"结算"]) {
            //去结算
            SureOrderViewController *sureVC = [[SureOrderViewController alloc]init];
            sureVC.type = @"0";
            sureVC.goodsID = recID;
            MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
            [tabbar hiddenTabbar:YES];
            [self.navigationController pushViewController:sureVC animated:YES];
            NSLog(@"结算%@",name);
            
            
        }else if([text isEqualToString:@"删除"]){
            NSLog(@"删除%@",recID);
            
            
            
            UIApplication *appli=[UIApplication sharedApplication];
            AppDelegate *app=appli.delegate;
            NSString *api_token = [RequestModel model:@"goods" action:@"delcart"];
            NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"rec_id":recID};
            __weak typeof(self) weakSelf = self;
            [RequestModel requestWithDictionary:dict model:@"goods" action:@"delcart" block:^(id result) {
                [weakSelf.deleteArr removeAllObjects];
                [weakSelf myGoods];
                //最下面的全选按钮改变取消全选状态
                [weakSelf.allChangeBtn setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
                weakSelf.allChangeBtn.selected = NO;
                weakSelf.totalPrieLab.text = @"¥0.0";
                NSString *text = [_settlementBtn.titleLabel.text substringToIndex:2];
                if ([text isEqualToString:@"结算"]) {
                    [weakSelf.settlementBtn setTitle:@"结算(0)" forState:UIControlStateNormal];
                }else if([text isEqualToString:@"删除"]){
                    [weakSelf.settlementBtn setTitle:@"删除(0)" forState:UIControlStateNormal];
                }
            }];
            
        }
    }
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- tableview代理
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *sectionSt = [NSString stringWithFormat:@"%lu",section];
  
    if (_selectDic[sectionSt] == nil) {
        [_selectDic setObject:@"0" forKey:sectionSt];

    }
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 44)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    //店铺是否选择
    UIButton *checkShopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkShopBtn setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
    checkShopBtn.selected = NO;
    NSString *temp = _sectionDic[sectionSt];
    int a = (int)section;
    checkShopBtn.tag = 1000+a;
    if (temp != nil) {
        if ([_sectionDic[sectionSt] isEqualToString:@"YES"]) {
            [checkShopBtn setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
            checkShopBtn.selected = YES;
        }
    }else{
        [_sectionDic setObject:@"NO" forKey:sectionSt];
    }

    checkShopBtn.frame = CGRectMake(12, 12, 20, 20);
    [checkShopBtn addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:checkShopBtn];

//    UIImageView *checkImgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
//    checkImgView.image = [UIImage imageNamed:@"cart_uncheck"];
//    [headView addSubview:checkImgView];
    //店铺logo
    UIImageView *shopLogo = [[UIImageView alloc]initWithFrame:CGRectMake(checkShopBtn.frame.size.width+checkShopBtn.frame.origin.x+12, 14, 15, 15)];
    shopLogo.image = [UIImage imageNamed:@"goods_detail_shop"];
    [headView addSubview:shopLogo];
    //店铺名称
    UILabel *shopNameLab = [[UILabel alloc]initWithFrame:CGRectMake(shopLogo.frame.size.width+shopLogo.frame.origin.x+12, 14, 200, 15)];
    if (_shopArr.count>0) {
        NSString *shopName = _shopArr[section];
        
        shopNameLab.text = shopName;
        shopNameLab.font = [UIFont systemFontOfSize:15];
        shopNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    }
   
    [headView addSubview:shopNameLab];
    
    return headView;
}
//每个店铺的全选
-(void)allSelectAction:(UIButton *)button{
    int section = (int)button.tag-1000;
    //总价
    NSString *priceTotalStr = [_totalPrieLab.text substringFromIndex:1];
    double priceTotal = [priceTotalStr doubleValue];
    //去结算的数目
    NSString *totalCountStr = _settlementBtn.titleLabel.text;
    NSRange range = NSMakeRange(3, totalCountStr.length - 4);
    NSString *totalCountStr2 = [totalCountStr substringWithRange:range];
    int totalCount = [totalCountStr2 intValue];
    
    if (button.selected) {
        //取消全选
        [button setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
        button.selected = NO;


        //最下面的全选按钮改变取消全选状态
        [_allChangeBtn setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
        _allChangeBtn.selected = NO;
        int sectionCount = (int)_shopArr.count;
        for (int i = 0; i<sectionCount;i++) {
            NSString *shopName = _shopArr[i];
            NSArray *arr = _goodsDic[shopName];
            NSString *sectionStr = [NSString stringWithFormat:@"%d",i];
            
            int rowCount = (int)arr.count;
            for (int j = 0; j<rowCount; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                GoodsCarTableViewCell *otherCell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                int sectttt = (int)[indexPath section];
                if (sectttt == section) {
                    shangpinModel *model;
                    NSUInteger row = [indexPath row];
                    model = arr[row];
                    [_sectionDic setObject:@"NO" forKey:sectionStr];
                    [_selectDic setObject:@"0" forKey:sectionStr];
                    [otherCell.checkBtn setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
                    
                    otherCell.checked = NO;
                    //单价
                    NSString *priceCellStr;
                    if (otherCell.priceLab.text.length >0) {
                        priceCellStr = [otherCell.priceLab.text substringFromIndex:1];
                    }else{
                        priceCellStr = model.goodsPrice;
                    }
                    double priceCell = [priceCellStr doubleValue];
                    //数量
                    int count;
                    if (otherCell.numLab.text.length>0) {
                        count = [otherCell.numLab.text intValue];
                    }else{
                        count = [model.goodsNumber intValue];
                    }
                    //总价
                    if (priceTotal>0) {
                        priceTotal = priceTotal - count*priceCell;
                    }
                    //总数
                    totalCount = totalCount-count;
                    
                    [self.deleteArr removeObject:model];
                    
                    
                }
            }
        }
        
        
    }else{
        //全选
        [button setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
        button.selected = YES;
      
        
        
        int sectionCount = (int)_shopArr.count;
        for (int i = 0; i<sectionCount;i++) {
            NSString *shopName = _shopArr[i];
            NSArray *arr = _goodsDic[shopName];
          
            int rowCount = (int)arr.count;
            for (int j = 0; j<rowCount; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                GoodsCarTableViewCell *otherCell = [self.tableView cellForRowAtIndexPath:indexPath];
                int sectttt = (int)[indexPath section];
                if (sectttt == section) {
                    NSString *sectionStr = [NSString stringWithFormat:@"%d",i];
                    [_sectionDic setObject:@"YES" forKey:sectionStr];
                    NSString *arrCount = [NSString stringWithFormat:@"%lu",(unsigned long)arr.count];
                    [_selectDic setObject:arrCount forKey:sectionStr];
                    if (![[_sectionDic allValues] containsObject:@"NO"]) {
                        [_allChangeBtn setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
                        _allChangeBtn.selected = YES;
                    }
                    [otherCell.checkBtn setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
                    if (otherCell.checked == NO) {
                        otherCell.checked = YES;
                        
                        shangpinModel *model ;
                        NSUInteger row = [indexPath row];
                        model = arr[row];
                        //单价
                        NSString *priceCellStr;
                        if (otherCell.priceLab.text.length >0) {
                          priceCellStr = [otherCell.priceLab.text substringFromIndex:1];
                        }else{
                            priceCellStr = model.goodsPrice;
                        }
                        
                        double priceCell = [priceCellStr doubleValue];
                        //数量
                        int count;
                        if (otherCell.numLab.text.length>0) {
                            count = [otherCell.numLab.text intValue];
                        }else{
                            count = [model.goodsNumber intValue];
                        }
                        
                        //总数
                        totalCount = totalCount+count;
                        priceTotal = priceTotal + count*priceCell;
                        [self.deleteArr addObject:model];
                    }
                    
                }
                //            [otherCell.checkBtn setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
            }
            
        }
    }
    
    NSString *price = [NSString stringWithFormat:@"¥%.2f",priceTotal];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
    NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
    NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, a)];
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a, b)];
    _totalPrieLab.attributedText = attributStr;
    NSString *text = [_settlementBtn.titleLabel.text substringToIndex:2];
    if ([text isEqualToString:@"结算"]) {
        [_settlementBtn setTitle:[NSString stringWithFormat:@"结算(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
    }else if([text isEqualToString:@"删除"]){
        [_settlementBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 12)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0,  0, Width, 1)];
    view1.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [footerView addSubview:view1];
    int sectionCount = (int)section;
    if (_shopArr.count - 1 > sectionCount) {
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, footerView.frame.size.height-1, Width, 1)];
        view2.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
        [footerView addSubview:view2];
    }
    
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ( section  == _shopArr.count - 1) {
        return 1;
    }
    return 12;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return _shopArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSString *a = self.shopArr[section];
    NSMutableArray *arr = _goodsDic[a];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"cell";
    GoodsCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsCarTableViewCell" owner:self options:nil]lastObject];
    }
    if (_shopArr.count>0) {
        shangpinModel *model;
        int sectionCount = (int)indexPath.section;
        NSString *shopName = _shopArr[sectionCount];
        NSArray *arr = _goodsDic[shopName];
        model = arr[indexPath.row];
        [cell.checkBtn setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
        cell.checkBtn.imageView.contentMode = UIViewContentModeCenter;
        [cell.checkBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.checked = NO;
        //选中状态cart_check@2x
        for (shangpinModel *deleModel in _deleteArr) {
            if ([model.recID isEqualToString:deleModel.recID]) {
                [cell.checkBtn setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
                cell.checked = YES;
            }
        }
        
        cell.recID = model.recID;
        cell.goodsNameLab.text = model.goodsName;
        cell.goodsNameLab.font = [UIFont systemFontOfSize:14];
        cell.goodsNameLab.textColor = [UIColor colorWithHexString:@"43464c"];
        cell.goodsNameLab.numberOfLines = 0;
        //    cell.priceLab.text = model.goodsPrice;
        cell.priceLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
        
        NSString *price = [NSString stringWithFormat:@"¥%@",model.goodsPrice];
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
        NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
        NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, a)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a, b)];
        cell.priceLab.attributedText = attributStr;
        NSString *string = model.attrStr;
        string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
        cell.goodsArrtLab.text = string;
        cell.goodsArrtLab.textColor = [UIColor colorWithHexString:@"#999999"];
        cell.goodsArrtLab.font = [UIFont systemFontOfSize:12];
        NSString *url = model.goodsImage;
        NSURL *imgUrl = [NSURL URLWithString:url];
        [cell.goodsImage setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"goods_list_pic_error"]];
        cell.numLab.borderStyle=UITextBorderStyleNone;
        cell.numLab.text = model.goodsNumber;
        cell.numLab.textAlignment = NSTextAlignmentCenter;
        cell.numLab.font = [UIFont systemFontOfSize:15];
        cell.numLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        cell.numLab.keyboardType = UIKeyboardTypeNumberPad;
//        cell.numLab.delegate = self;
        _tempTextField = cell.numLab;
        int sectionInt = (int)indexPath.section;
        int row = (int)indexPath.row;
        int temp = sectionInt*1000+row;
        _tempTextField.tag = temp;
        [cell.subBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
        [cell.subBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.plusBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
        [cell.plusBtn addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
//        cell.plusBtn.backgroundColor = [UIColor blueColor];
//       cell.subBtn.backgroundColor = [UIColor blueColor];
        cell.plusBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        cell.subBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        [cell.subBtn setTitle:@"-" forState:UIControlStateNormal];
        cell.plusBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        cell.subBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        cell.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    }
    
    return cell;
}
//减数量
-(void)subAction:(UIButton*)button{
    GoodsCarTableViewCell * cell = (GoodsCarTableViewCell *)button.superview.superview;
//    NSUInteger section = [_tableView indexPathForCell:cell].section;
    NSString *num = cell.numLab.text;
    NSString *recID = cell.recID;
    
    int numCount = [num intValue];
    if (numCount>1) {
        numCount--;
        NSString *a = [NSString stringWithFormat:@"%d",numCount];
        
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString *api_token = [RequestModel model:@"goods" action:@"charnum"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"rec_id":recID,@"num":a};
         __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"goods" action:@"charnum" block:^(id result) {
            NSDictionary *dic = result;
            NSLog(@"获得的数据：%@",dic);
            if ([dic[@"code"] isEqualToString:@"1"]) {
                cell.numLab.text = a;
                if (cell.checked) {
                    //总数
                    NSString *totalCountStr = weakSelf.settlementBtn.titleLabel.text;
                    NSRange range = NSMakeRange(3, totalCountStr.length - 4);
                    NSString *totalCountStr2 = [totalCountStr substringWithRange:range];
                    int totalCount = [totalCountStr2 intValue];
                    
                    totalCount--;
                    [weakSelf.settlementBtn setTitle:[NSString stringWithFormat:@"结算(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
                    //总价
                    NSString *priceTotalStr = [_totalPrieLab.text substringFromIndex:1];
                    double priceTotal = [priceTotalStr doubleValue];
                    //单价
                    NSString *priceC = [cell.priceLab.text substringFromIndex:1];
                    double priceCell = [priceC doubleValue];
                    priceTotal = priceTotal - priceCell ;
                    
                    NSString *price = [NSString stringWithFormat:@"¥%.2f",priceTotal];
                    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
                    NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
                    NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
                    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
                    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, a)];
                    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a, b)];
                    weakSelf.totalPrieLab.attributedText = attributStr;
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:dic[@"msg"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
                
            }
            
            
        }];

        
    }
    
}
//加数量
-(void)plusAction:(UIButton *)button{
    GoodsCarTableViewCell * cell = (GoodsCarTableViewCell *)button.superview.superview;
//    NSUInteger section = [_tableView indexPathForCell:cell].section;
    NSString *num = cell.numLab.text;
    int numCount = [num intValue];
    NSString *recID = cell.recID;
    numCount++;
    NSString *a = [NSString stringWithFormat:@"%d",numCount];
    
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"goods" action:@"charnum"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"rec_id":recID,@"num":a};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"charnum" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"获得的数据：%@",dic);
        if ([dic[@"code"] isEqualToString:@"1"]) {
            cell.numLab.text = a;
            if (cell.checked) {
                //总数
                NSString *totalCountStr = weakSelf.settlementBtn.titleLabel.text;
                NSRange range = NSMakeRange(3, totalCountStr.length - 4);
                NSString *totalCountStr2 = [totalCountStr substringWithRange:range];
                int totalCount = [totalCountStr2 intValue];
            
                totalCount++;
                [weakSelf.settlementBtn setTitle:[NSString stringWithFormat:@"结算(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
                //总价
                NSString *priceTotalStr = [weakSelf.totalPrieLab.text substringFromIndex:1];
                double priceTotal = [priceTotalStr doubleValue];
                //单价
                NSString *priceC = [cell.priceLab.text substringFromIndex:1];
                double priceCell = [priceC doubleValue];
                priceTotal = priceCell + priceTotal;
                
                NSString *price = [NSString stringWithFormat:@"¥%.2f",priceTotal];
                NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
                NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
                NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
                [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
                [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, a)];
                [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a, b)];
                weakSelf.totalPrieLab.attributedText = attributStr;
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:dic[@"msg"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        
    }];
    NSLog(@"+++%@",num);

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
 
    shangpinModel *model ;
    int sectionCount = (int)indexPath.section;
    NSString *shopName = _shopArr[sectionCount];
    NSArray *arr = _goodsDic[shopName];
    model = arr[indexPath.row];
    
    goodDetailViewController *goodDetailVC = [goodDetailViewController new];
    goodDetailVC.goodID = model.goodsID;
    [self.navigationController pushViewController:goodDetailVC animated:YES];
    

}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        shangpinModel *model ;
        int sectionCount = (int)indexPath.section;
        NSString *shopName = _shopArr[sectionCount];
        NSMutableArray *arr = [_goodsDic[shopName] mutableCopy];
        model = arr[indexPath.row];
        for (shangpinModel *model2 in self.deleteArr) {
            if ([model2.recID isEqualToString:model.recID]) {
                [self.deleteArr removeObject:model2];
            }
        }
        
        NSLog(@"删除");
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString *api_token = [RequestModel model:@"goods" action:@"delcart"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"rec_id":model.recID};
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"goods" action:@"delcart" block:^(id result) {
            [weakSelf myGoods];
            
        }];

        
        //单价
        double priceCell = [model.goodsPrice doubleValue];
        //数量
        int count = [model.goodsNumber intValue];
        //总价
        NSString *priceTotalStr = [_totalPrieLab.text substringFromIndex:1];
        double priceTotal = [priceTotalStr doubleValue];
        //去结算的数目
//        NSString *totalCountStr = _settlementBtn.titleLabel.text;
//        NSRange range = NSMakeRange(3, totalCountStr.length - 4);
//        NSString *totalCountStr2 = [totalCountStr substringWithRange:range];
        //计算总价
        double total = priceTotal - count*priceCell;
        NSString *price = [NSString stringWithFormat:@"¥%.2f",total];
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
        NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
        NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, a)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a, b)];
        _totalPrieLab.attributedText = attributStr;
     
        //计算总数

        NSString *text = [_settlementBtn.titleLabel.text substringToIndex:2];
        if ([text isEqualToString:@"结算"]) {
            [_settlementBtn setTitle:[NSString stringWithFormat:@"结算(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
        }else if([text isEqualToString:@"删除"]){
            [_settlementBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
        }

        
        
        [arr removeObjectAtIndex:indexPath.row];
        [_goodsDic setObject:arr forKey:shopName];
        //        // Delete the row from the data source.
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


#pragma mark-购物车数据
-(void)myGoods{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"goods" action:@"cartlist"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"]};
    __weak typeof(self) weakSelf = self;
    [_goodsDic removeAllObjects];
    [_deleteArr removeAllObjects];
    [_selectDic removeAllObjects];
  
    [_sectionDic removeAllObjects];
    [_allChangeBtn setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
    [_settlementBtn setTitle:@"结算(0)" forState:UIControlStateNormal];
    NSString *price = @"¥0.00";
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
    NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
    NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, a)];
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a, b)];
    _totalPrieLab.attributedText = attributStr;
    fourthViewController *fourVC = [fourthViewController new];
    [fourVC myAccount];
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"cartlist" block:^(id result) {
        [weakSelf.shopArr removeAllObjects];
        NSDictionary *dic = result;
        NSString *code = dic[@"code"];
        if ([code isEqualToString:@"1"]) {
            weakSelf.bottomView.hidden = NO;
            weakSelf.nullView.hidden = YES;
            weakSelf.tableView.hidden = NO;
            weakSelf.editBtn.hidden = NO;
            for (NSMutableDictionary *dict in dic[@"data"]) {
                
                NSMutableArray *goodsArr = [[NSMutableArray alloc]init];
                NSArray *goodsinfoArr = dict[@"goods"];
                
                float totalPrice = 0.0;
                for (NSMutableDictionary *goodsDic in goodsinfoArr) {
                    shangpinModel *model = [shangpinModel new];
                    model.supplierName = dict[@"shopname"];
                    model.shopUrl = dict[@"url"];
                    model.goodsName = goodsDic[@"goods_name"];
                    model.goodsPrice = goodsDic[@"goods_price"];
                    model.goodsNumber = goodsDic[@"number"];
                    model.goodsImage = goodsDic[@"goods_img"];
                    model.recID = goodsDic[@"rec_id"];
                    model.goodsID = goodsDic[@"goods_id"];
                    model.attrStr = goodsDic[@"goods_attr"];
                    model.attrvalueID = goodsDic[@"attrvalue_id"];
                    [goodsArr addObject:model];
                    totalPrice = totalPrice +[model.goodsPrice floatValue];
                }
                
                [weakSelf.goodsDic setObject:goodsArr forKey:dict[@"shopname"]];
                [weakSelf.shopArr addObject:dict[@"shopname"]];
            }
            [weakSelf.tableView reloadData];
           
        }else{
            weakSelf.bottomView.hidden = YES;
            weakSelf.nullView.hidden = NO;
            weakSelf.tableView.hidden = YES;
            weakSelf.editBtn.hidden = YES;
        }
        
      
    }];
}
#pragma mark --选中与不选
-(void)selectAction:(UIButton *)button{
    GoodsCarTableViewCell * cell = (GoodsCarTableViewCell *)button.superview.superview;
    int section =(int) [_tableView indexPathForCell:cell].section;
    int row = (int)[_tableView indexPathForCell:cell].row;
    shangpinModel *model;
    int sectionCount = section;
    NSString *shopName = _shopArr[sectionCount];
    NSArray *arr = _goodsDic[shopName];
    model = arr[row];
    NSString *sectionStr = [NSString stringWithFormat:@"%d",section];
    NSString *priceCellStr = [cell.priceLab.text substringFromIndex:1];
    //单价
    double priceCell = [priceCellStr doubleValue];
    //数量
    int count = [cell.numLab.text intValue];
    //总价
    NSString *priceTotalStr = [_totalPrieLab.text substringFromIndex:1];
    double priceTotal = [priceTotalStr doubleValue];
    //去结算的数目
//    NSString *totalCountStr = _settlementBtn.titleLabel.text;
//    NSRange range = NSMakeRange(3, totalCountStr.length - 4);
//    NSString *totalCountStr2 = [totalCountStr substringWithRange:range];
    
    
    if (cell.checked) {
        //取消选择cell
        [cell setImage:NO];
        cell.checked = NO;
        //计算总价
        double total = priceTotal - count*priceCell;
        NSString *price = [NSString stringWithFormat:@"¥%.2f",total];
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
        NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
        NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, a)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a, b)];
        _totalPrieLab.attributedText = attributStr;

        for (shangpinModel *model2 in _deleteArr) {
            if ([model2.recID isEqualToString:model.recID]) {
                [self.deleteArr removeObject:model2];
                break;
            }
        }
        //计算总数
        NSString *text = [_settlementBtn.titleLabel.text substringToIndex:2];
        if ([text isEqualToString:@"结算"]) {
             [_settlementBtn setTitle:[NSString stringWithFormat:@"结算(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
        }else if([text isEqualToString:@"删除"]){
             [_settlementBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
        }
       
        NSString *acount =_selectDic[sectionStr];
        int count= [acount intValue];
        if (count == arr.count) {
            NSLog(@"取消全选");
            [_allChangeBtn setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
            _allChangeBtn.selected = NO;
            [_sectionDic setObject:@"NO" forKey:sectionStr];
            [self.tableView reloadData];
        }
        count--;
        NSString *selectCount = [NSString stringWithFormat:@"%d",count];
        [_selectDic setObject:selectCount forKey:sectionStr];
        
        
        
    }else{
        //选择cell
        [cell setImage:YES];
        cell.checked = YES;
        //计算总价
        double total = priceTotal + count*priceCell;
        NSString *price = [NSString stringWithFormat:@"¥%.2f",total];
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
        NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
        NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, a)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a, b)];
        _totalPrieLab.attributedText = attributStr;
        //计算总数
        [self.deleteArr addObject:model];
        NSString *text = [_settlementBtn.titleLabel.text substringToIndex:2];
        if ([text isEqualToString:@"结算"]) {
            [_settlementBtn setTitle:[NSString stringWithFormat:@"结算(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
        }else if([text isEqualToString:@"删除"]){
            [_settlementBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
        }
        NSString *acount =_selectDic[sectionStr];
        if (acount.length>0) {
            int count= [acount intValue];
            count++;
            NSString *selectCount = [NSString stringWithFormat:@"%d",count];
            [_selectDic setObject:selectCount forKey:sectionStr];
            if (count == arr.count) {
                //全选了
                [_sectionDic setObject:@"YES" forKey:sectionStr];
                if (![[_sectionDic allValues] containsObject:@"NO"]) {
                    [_allChangeBtn setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
                    _allChangeBtn.selected = YES;
                }
                NSLog(@"全选");
                
                [self.tableView reloadData];
            }
        }else{
            [_selectDic setObject:@"1" forKey:sectionStr];
        }
        
        
    }
}
#pragma mark --最下面的全选
-(void)selectAllActioon:(UIButton*)button{
    //总价
    NSString *priceTotalStr = [_totalPrieLab.text substringFromIndex:1];
    double priceTotal = [priceTotalStr doubleValue];
    //去结算的数目
    NSString *totalCountStr = _settlementBtn.titleLabel.text;
    NSRange range = NSMakeRange(3, totalCountStr.length - 4);
    NSString *totalCountStr2 = [totalCountStr substringWithRange:range];
    int totalCount = [totalCountStr2 intValue];
    
    if (button.selected) {
        //取消全选
        [button setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
        button.selected = NO;
        
        int sectionCount = (int)_shopArr.count;
        for (int i = 0; i<sectionCount;i++) {
            NSString *shopName = _shopArr[i];
            NSArray *arr = _goodsDic[shopName];
            NSString *sectionStr = [NSString stringWithFormat:@"%d",i];
            [_sectionDic setObject:@"NO" forKey:sectionStr];
            [_selectDic setObject:@"0" forKey:sectionStr];
            int rowCount = (int)arr.count;
            for (int j = 0; j<rowCount; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                GoodsCarTableViewCell *otherCell = [self.tableView cellForRowAtIndexPath:indexPath];
                [otherCell.checkBtn setImage:[UIImage imageNamed:@"cart_uncheck"] forState:UIControlStateNormal];
                if (otherCell.checked == YES) {
                    otherCell.checked = NO;

                
                    priceTotal = 0.0;
                
                    [_deleteArr removeAllObjects];
                }
            }
        }
    }else{
        //全选
       
        [button setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
        button.selected = YES;
        
        int sectionCount = (int)_shopArr.count;
        for (int i = 0; i<sectionCount;i++) {
            NSString *shopName = _shopArr[i];
            NSArray *arr = _goodsDic[shopName];
            NSString *sectionStr = [NSString stringWithFormat:@"%d",i];
            [_sectionDic setObject:@"YES" forKey:sectionStr];
            NSString *arrCount = [NSString stringWithFormat:@"%lu",(unsigned long)arr.count];
            [_selectDic setObject:arrCount forKey:sectionStr];
            int rowCount = (int)arr.count;
            for (int j = 0; j<rowCount; j++) {
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                GoodsCarTableViewCell *otherCell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                [otherCell.checkBtn setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateNormal];
                if (otherCell.checked == NO) {
                    otherCell.checked = YES;
                    shangpinModel *model;
                    NSUInteger row = [indexPath row];
                    model = arr[row];
                    //单价
                    NSString *priceCellStr;
                    if (otherCell.priceLab.text.length >0) {
                        priceCellStr = [otherCell.priceLab.text substringFromIndex:1];
                    }else{
                        priceCellStr = model.goodsPrice;
                    }
                    double priceCell = [priceCellStr doubleValue];
                    //数量
                    int count;
                    if (otherCell.numLab.text.length>0) {
                        count = [otherCell.numLab.text intValue];
                    }else{
                        count = [model.goodsNumber intValue];
                    }
                    //总数
                    totalCount = totalCount+count;
                    priceTotal = priceTotal + count*priceCell;
                    [self.deleteArr addObject:model];
                    
                    
                }

            }
        }
        
       
    }
    NSString *price = [NSString stringWithFormat:@"¥%.2f",priceTotal];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
    NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
    NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, a)];
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a, b)];
    _totalPrieLab.attributedText = attributStr;
    NSString *text = [_settlementBtn.titleLabel.text substringToIndex:2];
    if ([text isEqualToString:@"结算"]) {
        [_settlementBtn setTitle:[NSString stringWithFormat:@"结算(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
    }else if([text isEqualToString:@"删除"]){
        [_settlementBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}
#pragma mark -- 自定义导航栏
- (void)initNavigationBar{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *naviBGColor = data[@"navigationBGColor"];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    
    float imgFloatX = 24.0/750.0;
    float imgFloatY = 24.0/1334.0;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    label.text = @"购物车";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
//    label.textColor = [UIColor colorWithHexString:@"#707580"];
    [view addSubview:label];
    //编辑按钮
    _editBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _editBtn.frame = CGRectMake(Width-imgFloatX*Width-50, 22, 60, 44);
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_editBtn setTitleColor:[UIColor colorWithHexString:@"#707580"] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.selected = NO;
    _editBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_editBtn];
    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(Width*imgFloatX, Height*imgFloatY, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 22, 40, 44)];
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [btn addSubview:imgView];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    if ([self.temp isEqualToString:@"1"]) {
        btn.hidden = NO;
    }else{
        btn.hidden = YES;
    }
    [view addSubview:btn];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-1, Width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
    
    
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --编辑事件
-(void)editAction:(UIButton*)button{
  
    
    if (button.selected) {
        //显示编辑状态下
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        button.selected = NO;
        _totalLab.hidden = NO;
        _totalPrieLab.hidden = NO;
        [_settlementBtn setTitle:[NSString stringWithFormat:@"结算(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
        _settlementBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
    }else{
        //显示完成状态下
        [button setTitle:@"完成" forState:UIControlStateNormal];
        button.selected = YES;
        _totalLab.hidden = YES;
        _totalPrieLab.hidden = YES;
        [_settlementBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",(unsigned long)_deleteArr.count] forState:UIControlStateNormal];
        _settlementBtn.backgroundColor = [UIColor colorWithHexString:@"#ff3b30"];
    }
}
#pragma mark textfiled delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    CGRect frame = _tempTextField.frame;
//    int offset = frame.origin.y + 50 - (Height - 216);
//    
//    //将试图的y坐标上移offset个单位，以使下面腾出地方用于软键盘的显示
//    if (offset < -131) {
//        self.view.frame = CGRectMake(0, offset, Width, Height);
//        
//    }
//    
//    [UIView commitAnimations];
    
    
    
    
}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame = CGRectMake(0, 0, Width, Height);
}

@end
