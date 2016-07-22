
//
//  AddressViewController.m
//  ecshop
//
//  Created by Jin on 15/12/4.
//  Copyright © 2015年 jsyh. All rights reserved.
//地址列表

#import "AddressViewController.h"
#import "AppDelegate.h"
#import "AddressViewCell.h"
#import "RequestModel.h"
#import "AddressModel.h"
#import "MyAddressViewCell.h"
#import "NewAddressViewController.h"
#import "SureOrderController.h"
#import "SDRefresh.h"
#import "UIColor+Hex.h"
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,SDRefreshViewAnimationDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *modArray;
@property(nonatomic,strong)AddressModel *model;
@property (nonatomic,strong)NSString *myaddress;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, assign) NSInteger totalRowCount;
@property (nonatomic, weak) UIImageView *animationView;
@property (nonatomic, weak) UIImageView *boxView;
@property (nonatomic, weak) UILabel *label;
@end

@implementation AddressViewController
-(void)viewWillAppear:(BOOL)animated{
   [self myProvince];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBack;
    [self draw];
    [self setupHeader];
    [self setupFooter];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}

-(void)draw{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 114) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorBack;
    [self.view addSubview:_tableView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];

    button.frame = CGRectMake(20, self.tableView.frame.size.height + self.tableView.frame.origin.y + 10, self.view.frame.size.width - 40, 35) ;
    [button setTitle:@"+新建地址" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(newAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)myProvince{
    NSString *api_token = [RequestModel model:@"goods" action:@"addresslist"];
    UIApplication * appli=[UIApplication sharedApplication];
    AppDelegate*app=appli.delegate;
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"]};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"addresslist" block:^(id result) {
        NSDictionary *dic = result;
        weakSelf.modArray = nil;
        weakSelf.modArray = [[NSMutableArray alloc]init];
        for (NSMutableDictionary *dict in dic[@"data"]) {
            weakSelf.model = [AddressModel new];
            
            weakSelf.model.address_id = dict[@"address_id"];
            weakSelf.model.address= dict[@"address"];
            weakSelf.model.telnumber = dict[@"telnumber"];
            weakSelf.model.username = dict[@"username"];
            weakSelf.model.is_default = dict[@"is_default"];
            
            
            
            [weakSelf.modArray addObject:weakSelf.model];
            
        }
        
        
        [weakSelf.tableView reloadData];
        
    }];
}
-(void)newAddress:(id)sender{
    NewAddressViewController *newVC = [[NewAddressViewController alloc]init];
    newVC.tempDic = self.tempDic;
    newVC.tempId = nil;
    [self.navigationController pushViewController:newVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"cell";
    MyAddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyAddressViewCell" owner:self options:nil]lastObject];
    }
    cell.model = self.modArray[indexPath.section];
    [cell.editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.checkBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}
#pragma mark --改变cell上面的button
//设置默认地址
-(void)checkAction:(UIButton *)button{
    MyAddressViewCell * cell = (MyAddressViewCell *)button.superview.superview;
    self.myaddress = cell.address_id;
    [self myAddress];
    [self myProvince];
    [self.tableView reloadData];
    
}
-(void)deleteAction:(UIButton *)button{
    MyAddressViewCell * cell = (MyAddressViewCell *)button.superview.superview;
    self.myaddress = cell.address_id;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除地址吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteAddress];
        [weakSelf myProvince];
        [weakSelf.tableView reloadData];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
}
- (void)editAction:(UIButton *)button{
    MyAddressViewCell * cell = (MyAddressViewCell *)button.superview.superview;
    NewAddressViewController *newVC = [[NewAddressViewController alloc]init];
    newVC.tempDic = self.tempDic;
    newVC.tempId = cell.address_id;
    [self.navigationController pushViewController:newVC animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.panduanid!=NULL) {
        AddressModel *model = [AddressModel new];
        model = self.modArray[indexPath.section];
        
        NSNotificationCenter *secInfo=[NSNotificationCenter defaultCenter];
        NSMutableDictionary *mydictt=[[NSMutableDictionary alloc]init];
        [mydictt setObject:[NSString stringWithFormat:@"%@",model.username] forKey:@"myName"];
        [mydictt setObject:[NSString stringWithFormat:@"%@",model.telnumber]forKey:@"myPhone"];
        [mydictt setObject:[NSString stringWithFormat:@"%@",model.address] forKey:@"mymessage"];
        [mydictt setObject:model.address_id forKey:@"myId"];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:mydictt,@"myaddress", nil];
        NSNotification *nofiInfo=[[NSNotification alloc]initWithName:@"addressInfo" object:nil userInfo:dict];
        [secInfo postNotification:nofiInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.panduanid==NULL)
    {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 144;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 10;
    }
}
#pragma mark--设置默认地址
-(void)myAddress{
    UIApplication * appli=[UIApplication sharedApplication];
    AppDelegate * app=appli.delegate;
    NSString *api_token = [RequestModel model:@"goods" action:@"addrdefault"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"address_id":self.myaddress};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"addrdefault" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        [weakSelf.tableView reloadData];
        
    }];
}
#pragma mark --删除地址
-(void)deleteAddress{
    NSString *api_token = [RequestModel model:@"goods" action:@"deladdress"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":self.tempDic[@"data"][@"key"],@"address_id":self.myaddress};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"deladdress" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        [weakSelf.tableView reloadData];
        
    }];
    
}
#pragma mark -刷新
- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    refreshHeader.backgroundColor = [UIColor whiteColor];
    refreshHeader.delegate = self;
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置
    //    refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    _refreshHeader = refreshHeader;
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    __weak typeof(self) weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.totalRowCount += 3;
            [weakSelf.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 动画view
    UIImageView *animationView = [[UIImageView alloc] init];
    
    animationView.frame = CGRectMake(30, 45, 40, 40);
    animationView.image = [UIImage imageNamed:@"a0v"];
    [refreshHeader addSubview:animationView];
    _animationView = animationView;
    
    NSArray *images = @[[UIImage imageNamed:@"a0v"],
                        [UIImage imageNamed:@"a0w"],
                        [UIImage imageNamed:@"a0x"],
                        [UIImage imageNamed:@"a0y"]
                        ];
    _animationView.animationImages = images;
    
    
    UIImageView *boxView = [[UIImageView alloc] init];
    boxView.frame = CGRectMake(150, 10, 15, 8);
    boxView.image = [UIImage imageNamed:@"box"];
    [refreshHeader addSubview:boxView];
    _boxView = boxView;
    
    UILabel *label= [[UILabel alloc] init];
    label.text = @"下拉加载最新数据";
    label.frame = CGRectMake((self.view.bounds.size.width - 200) * 0.5, 5, 200, 20);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [refreshHeader addSubview:label];
    _label = label;
    
    // 进入页面自动加载一次数据
    [refreshHeader autoRefreshWhenViewDidAppear];
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}


- (void)footerRefresh
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.totalRowCount += 2;
        [weakSelf.tableView reloadData];
        [weakSelf.refreshFooter endRefreshing];
    });
}

#pragma mark - SDRefreshView Animation Delegate

- (void)refreshView:(SDRefreshView *)refreshView didBecomeNormalStateWithMovingProgress:(CGFloat)progress
{
    refreshView.hidden = NO;
    
    if (progress == 0) {
        _animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _boxView.hidden = NO;
        
        _label.text = @"下拉可以刷新";
        
        [_animationView stopAnimating];
    }
    //    self.animationView.transform = CGAffineTransformMakeTranslation(progress * 20, -20 * progress);
    self.animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(progress * 30, -20 * progress), CGAffineTransformMakeScale(progress, progress));
    self.boxView.transform = CGAffineTransformMakeTranslation(- progress * 65, progress * 35);
    
}

- (void)refreshView:(SDRefreshView *)refreshView didBecomeRefreshingStateWithMovingProgress:(CGFloat)progress
{
    _label.text = @"正在加载数据...";
    [UIView animateWithDuration:1.5 animations:^{
        //        self.animationView.transform = CGAffineTransformMakeTranslation(200, -20);
    }];
}

- (void)refreshView:(SDRefreshView *)refreshView didBecomeWillRefreshStateWithMovingProgress:(CGFloat)progress
{
    _boxView.hidden = YES;
    _label.text = @"松开后刷新";
    _animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(30, -20), CGAffineTransformMakeScale(1, 1));
    [_animationView startAnimating];
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
    label.text = @"地址管理";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:titleFont];
    label.textColor = [UIColor colorWithHexString:naiigationTitleColor];
    [view addSubview:label];
    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    //    btn.backgroundColor = [UIColor redColor];
    [btn addSubview:imgView];
    //    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
