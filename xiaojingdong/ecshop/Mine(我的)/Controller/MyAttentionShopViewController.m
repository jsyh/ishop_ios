//
//  MyAttentionShopViewController.m
//  ecshop
//
//  Created by Jin on 16/4/27.
//  Copyright © 2016年 jsyh. All rights reserved.
//收藏店铺列表

#import "MyAttentionShopViewController.h"
#import "UIColor+Hex.h"
#import "RequestModel.h"
#import "AppDelegate.h"
#import "CareShopTableViewCell.h"
#import "ShopModel.h"
#import "UIImageView+AFNetworking.h"
#import "GoShopViewController.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface MyAttentionShopViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableViewCellEditingStyle _editingStyle;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *deletBtn;
@property (nonatomic,strong)NSMutableArray *deletArr;
@property (nonatomic,strong)NSMutableArray *array;//存放店铺model
@property (nonatomic,strong)UIButton *editBtn;
@end

@implementation MyAttentionShopViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self myCollectlist];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self draw];
    _deletArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}
-(void)draw{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tintColor = [UIColor colorWithHexString:@"#ff5000"];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    //允许tableview多选
    //    _tableView.allowsMultipleSelection = NO;
    //编辑状态下允许多选
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    
    _deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deletBtn.frame = CGRectMake(0, Height - 50, Width, 50);
    [_deletBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deletBtn.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [_deletBtn addTarget:self action:@selector(deletAction) forControlEvents:UIControlEventTouchUpInside];
    _deletBtn.hidden = YES;
    _deletBtn.userInteractionEnabled = NO;
    _deletBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_tableView];
    [self.view addSubview:_deletBtn];
}
-(void)deletAction{
    
    NSLog(@"%@",_deletArr);
    NSString *deleStr;
    for (NSString *a in _deletArr) {
        if (deleStr.length>0) {
            deleStr = [NSString stringWithFormat:@"%@,%@",deleStr,a];
        }else{
            deleStr = a;
        }
    }
    NSLog(@"%@",deleStr);
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"goods" action:@"qcollect"];
    NSDictionary *dict = @{@"api_token":api_token,@"id_values":deleStr,@"key":app.tempDic[@"data"][@"key"],@"type":@"1"};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"qcollect" block:^(id result) {
        [weakSelf myCollectlist];
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"CareShopTableViewCell";
    CareShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CareShopTableViewCell" owner:self options:nil]lastObject];
    }
  
   
    ShopModel *model;
    model = self.array[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundColor=[UIColor whiteColor];
    
    NSURL *url =[NSURL URLWithString:model.shopLogo];
    [cell.shopLogo setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_list_pic_error"]];
    cell.shopLogo.layer.cornerRadius = 5;
    cell.shopLogo.layer.masksToBounds = YES;
    cell.shopLogo.backgroundColor = [UIColor redColor];
    cell.shopName.text = model.shopName;
    if ([model.shopRage isEqualToString:@"高级店铺"]) {
        cell.shopRank.image = [UIImage imageNamed:@"personal_collect_shop_senior"];
    }else if([model.shopRage isEqualToString:@"中级店铺"]){
       cell.shopRank.image = [UIImage imageNamed:@"personal_collect_shop_middle"];
    }else{
        cell.shopRank.image = [UIImage imageNamed:@"personal_collect_shop_primary"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_deletBtn.hidden) {
        GoShopViewController *goShopVC = [GoShopViewController new];
        ShopModel *model;
        model = self.array[indexPath.row];
        goShopVC.shopUrl = model.shopUrl;
        goShopVC.shopID = model.supplierID;
        goShopVC.attention = 1;
        if ([goShopVC.shopUrl isEqualToString:@"nil"]) {
            
        }else{
            [self.navigationController pushViewController:goShopVC animated:YES];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else{
        ShopModel *model;
        model = self.array[indexPath.row];
        NSLog(@"%ld--%@",(long)indexPath.row,model.supplierID);
        [_deletArr addObject:model.supplierID];
        if (_deletArr.count>0) {
            _deletBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
            _deletBtn.userInteractionEnabled = YES;
        }else{
            _deletBtn.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
            _deletBtn.userInteractionEnabled = NO;
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopModel *model;
    model = self.array[indexPath.row];
    [_deletArr removeObject:model.supplierID];
    if (_deletArr.count>0) {
        _deletBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
        _deletBtn.userInteractionEnabled = YES;
    }else{
        _deletBtn.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
        _deletBtn.userInteractionEnabled = NO;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShopModel *model;
        model = self.array[indexPath.row];
        
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString *api_token = [RequestModel model:@"goods" action:@"qcollect"];
        NSDictionary *dict = @{@"api_token":api_token,@"id_values":model.supplierID,@"key":app.tempDic[@"data"][@"key"],@"type":@"1"};
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"goods" action:@"qcollect" block:^(id result) {
            [weakSelf myCollectlist];
        }];

        [self.array removeObjectAtIndex:indexPath.row];
        //        // Delete the row from the data source.
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark--关注列表解析数据
-(void)myCollectlist{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"goods" action:@"collectlist"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"type":@"1"};
    
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"collectlist" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        weakSelf.array = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in dic[@"data"]) {
            NSLog(@"%@",dict);
            ShopModel *model = [ShopModel new];
            model.shopName = dict[@"shopname"];
            model.shopLogo = dict[@"shop_logo"];
            model.shopRage = dict[@"rank"];
            model.supplierID = dict[@"supplierid"];
            model.shopUrl = dict[@"url"];
            [weakSelf.array addObject:model];
        }
        NSLog(@"%@",weakSelf.array);
        if (weakSelf.array.count == 0) {
            weakSelf.tableView.hidden = YES;
            float aY336 = 336.0/1334.0;
            float aW172 = 172.0/750.0;
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - aW172*Width/2, aY336*Height, aW172*Width, aW172*Width)];
            imgView.image = [UIImage imageNamed:@"my_collection_null_data"];
            [weakSelf.view addSubview:imgView];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+18, Width, 16)];
            lab.text = @"您的收藏夹是空的";
            lab.textColor = [UIColor colorWithHexString:@"#43464c"];
            lab.font = [UIFont systemFontOfSize:16];
            lab.textAlignment = NSTextAlignmentCenter;
            [weakSelf.view addSubview:lab];
            UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+12, Width, 13)];
            lab2.text = @"暂时没有相关数据";
            lab2.textColor = [UIColor colorWithHexString:@"#43464c"];
            lab2.font = [UIFont systemFontOfSize:13];
            lab2.textAlignment = NSTextAlignmentCenter;
            [weakSelf.view addSubview:lab2];
        }
        [weakSelf.tableView reloadData];
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
    
    label.text = @"收藏的店铺";
    
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
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height - 1, Width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
    //编辑按钮
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(Width - 35-12, 20, 35, 44);
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_editBtn];
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)editButtonClick:(UIButton *)button{
    if (_deletBtn.hidden) {
        _tableView.frame = CGRectMake( 0, 44, Width, Height-50);
        _deletBtn.hidden = NO;
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
        
    }else{
        _tableView.frame = CGRectMake( 0, 44, Width, Height);
        _deletBtn.hidden = YES;
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    [self deleteData];
    
    
}
-(void)deleteData{
    _editingStyle = UITableViewCellEditingStyleDelete;
    BOOL isEditing = self.tableView.isEditing;
    [self.tableView setEditing:!isEditing animated:YES];
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
}
//设置哪一行的编辑按钮 状态指定编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _editingStyle;
}
@end
