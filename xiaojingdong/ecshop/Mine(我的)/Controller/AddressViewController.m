
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
#import "UIColor+Hex.h"
#import "MJRefresh.h"
#define kColorBack [UIColor colorWithHexString:@"#f2f2f2"]
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *modArray;
@property(nonatomic,strong)AddressModel *model;
@property (nonatomic,strong)NSString *myaddress;

@property (nonatomic, assign) NSInteger totalRowCount;
@property (nonatomic, weak) UIImageView *animationView;
@property (nonatomic, weak) UIImageView *boxView;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic,strong) UIView *nullView;//空数据的view
@end

@implementation AddressViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [self myProvince];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBack;
    [self draw];
    [self nullDataView];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}

-(void)draw{
    float a88 = 88.0/1334.0;
    float a180 = 160.0/1334.0;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, a88*Height, Width, Height - a180*Height) style:UITableViewStylePlain];
 
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = kColorBack;
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf myProvince];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    [_tableView.mj_header beginRefreshing];
    [self.view addSubview:_tableView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];

    button.frame = CGRectMake(0, Height-50, Width, 50) ;
    [button setTitle:@"+ 新建地址" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(newAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)nullDataView{
    _nullView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - 100)];
    _nullView.hidden = YES;
    float aY336 = 336.0/1334.0;
    float aW172 = 172.0/750.0;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - aW172*Width/2, aY336*Height, aW172*Width, aW172*Width)];
    imgView.image = [UIImage imageNamed:@"seachGoods_null"];
    [_nullView addSubview:imgView];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+18, Width, 16)];
    lab.text = @"您的地址是空的";
    lab.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textAlignment = NSTextAlignmentCenter;
    [_nullView addSubview:lab];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+12, Width, 13)];
    lab2.text = @"暂时没有相关数据";
    lab2.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab2.font = [UIFont systemFontOfSize:13];
    lab2.textAlignment = NSTextAlignmentCenter;
    [_nullView addSubview:lab2];
    [self.view addSubview:_nullView];
}
#pragma mark --请求数据
-(void)myProvince{
    NSString *api_token = [RequestModel model:@"goods" action:@"addresslist"];
    UIApplication * appli=[UIApplication sharedApplication];
    AppDelegate*app=appli.delegate;
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"]};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"addresslist" block:^(id result) {
        NSDictionary *dic = result;
        [weakSelf.modArray removeAllObjects];
        weakSelf.modArray = nil;
        weakSelf.modArray = [[NSMutableArray alloc]init];
        for (NSMutableDictionary *dict in dic[@"data"]) {
            weakSelf.tableView.hidden = NO;
            weakSelf.nullView.hidden = YES;
            weakSelf.model = [AddressModel new];
            
            weakSelf.model.address_id = dict[@"address_id"];
            weakSelf.model.address= dict[@"address"];
            weakSelf.model.telnumber = dict[@"telnumber"];
            weakSelf.model.username = dict[@"username"];
            weakSelf.model.is_default = dict[@"is_default"];
            
            
            
            [weakSelf.modArray addObject:weakSelf.model];
        }
        NSArray *tempArr = dic[@"data"];
        if (tempArr.count == 0) {
            weakSelf.tableView.hidden = YES;
            weakSelf.nullView.hidden = NO;
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
}
-(void)deleteAction:(UIButton *)button{
    MyAddressViewCell * cell = (MyAddressViewCell *)button.superview.superview;
    self.myaddress = cell.address_id;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除地址吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteAddress];
       
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
        AddressModel *model;
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
    return 132;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }else{
//        return 10;
//    }
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 12)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    return view;
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
        [weakSelf myProvince];

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
         [weakSelf myProvince];
        
    }];
    
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
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-1, Width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
    [view addSubview:btn];
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
