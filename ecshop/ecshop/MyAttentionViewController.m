//
//  MyAttentionViewController.m
//  ecshop
//
//  Created by Jin on 15/12/31.
//  Copyright © 2015年 jsyh. All rights reserved.
//关注商品

#import "MyAttentionViewController.h"
#import "MyAttentionViewCell.h"
#import "RequestModel.h"
#import "AppDelegate.h"
#import "shangpinModel.h"
#import "SDRefresh.h"
#import "UIColor+Hex.h"
#import "goodDetailViewController.h"
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
@interface MyAttentionViewController ()<UITableViewDelegate,UITableViewDataSource,SDRefreshViewAnimationDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *array;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, assign) NSInteger totalRowCount;
@property (nonatomic, weak) UIImageView *animationView;
@property (nonatomic, weak) UIImageView *boxView;
@property (nonatomic, weak) UILabel *label;
@end

@implementation MyAttentionViewController
-(void)viewWillAppear:(BOOL)animated{
    [self myCollectlist];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = kColorBack;
    [self draw];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}
-(void)draw{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorBack;
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--关注列表
-(void)myCollectlist{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"goods" action:@"collectlist"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"]};

    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"collectlist" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        weakSelf.array = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in dic[@"data"]) {
            NSLog(@"%@",dict);
            
            shangpinModel *model = [shangpinModel new];
            model.goodsImage = dict[@"goods_img"];
            model.goodsName = dict[@"goods_name"];
            model.goodsPrice = dict[@"goods_price"];
            model.orderId = dict[@"goods_id"];
            if ([model.goodsImage isEqualToString:@"http://shopapi.99-k.com/ecshop/"]) {
                model.goodsPrice = @"nil";
                model.goodsImage = @"nil";
                model.goodsName = @"nil";
                model.orderId = @"nil";
            }
           [weakSelf.array addObject:model];
            
            
        }
        NSLog(@"%@",weakSelf.array);
        if (weakSelf.array.count == 0) {
            weakSelf.tableView.hidden = YES;
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(weakSelf.view.frame.size.width/2 - 80, 150, 160, 40)];
            lab.text = @"您还没有关注商品";
            lab.font = [UIFont systemFontOfSize:13];
            lab.textAlignment = NSTextAlignmentCenter;
            [weakSelf.view addSubview:lab];
        }
        [weakSelf.tableView reloadData];
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark --tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"MyAttentionViewCell";
    
    MyAttentionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyAttentionViewCell" owner:self options:nil]lastObject];
    }
    cell.model = self.array[indexPath.row];
//    cell.model = self.array[2];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    goodDetailViewController *goodVC = [goodDetailViewController new];
    shangpinModel *mode = [shangpinModel new];
    mode = self.array[indexPath.row];
    goodVC.goodID = mode.orderId;
    if ([goodVC.goodID isEqualToString:@"nil"]) {
        
    }else{
        [self.navigationController pushViewController:goodVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -刷新
- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    refreshHeader.backgroundColor = [UIColor whiteColor];
    refreshHeader.delegate = self;
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置
    //        refreshHeader.isEffectedByNavigationController = NO;
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.totalRowCount += 2;
        [self.tableView reloadData];
        [self.refreshFooter endRefreshing];
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
    
    label.text = @"关注商品";
    
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
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
