//
//  MyEvaluationViewController.m
//  ecshop
//
//  Created by Jin on 16/4/27.
//  Copyright © 2016年 jsyh. All rights reserved.
//我的评价

#import "MyEvaluationViewController.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"
#import "RequestModel.h"
#import "CommentModel.h"
#import "MyEvaluationViewTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface MyEvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)UILabel *evaluationLab;//评论条数的lab
@property(nonatomic,strong)UILabel *userNameLab;//用户名的lab
@property(nonatomic,strong)UIView *nullView;
@property(nonatomic,strong)UIView *headView;
@end

@implementation MyEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    [self myCollectlist];
    [self creatnullView];
    [self draw];
    // Do any additional setup after loading the view.
}
-(void)creatnullView{
    _nullView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-64)];
    _nullView.hidden = YES;
    float aY336 = 336.0/1334.0;
    float aW172 = 172.0/750.0;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - aW172*Width/2, aY336*Height, aW172*Width, aW172*Width)];
    imgView.image = [UIImage imageNamed:@"myorder_null_data"];
    [_nullView addSubview:imgView];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+18, Width, 16)];
    lab.text = @"您还没有进行评价";
    lab.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textAlignment = NSTextAlignmentCenter;
    [_nullView addSubview:lab];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+12, Width, 13)];
    lab2.text = @"可以去看看有哪些想买的";
    lab2.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab2.font = [UIFont systemFontOfSize:13];
    lab2.textAlignment = NSTextAlignmentCenter;
    [_nullView addSubview:lab2];
    [self.view addSubview:_nullView];
}
-(void)draw{
    float aX24 = 24.0/750.0;
    float aY24 = 24.0/1334.0;
    float aW60 = 60.0/750.0;
    float aH116 = 116.0/1334.0;
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, aH116*Height)];
    _headView.hidden = YES;
    //用户的logo
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(aX24*Width, aY24*Height, aW60*Width, aW60*Width)];
    imgView.image = [UIImage imageNamed:@"comment_user_photo"];

    [_headView addSubview:imgView];
    //用户名
    _userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width+imgView.frame.origin.x+aX24*Width, aY24*Height, 150, 14)];
    _userNameLab.text = @"用户名";
    _userNameLab.font = [UIFont systemFontOfSize:14];
    _userNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    [_headView addSubview:_userNameLab];
    //发布评价条数
    _evaluationLab = [[UILabel alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x, _userNameLab.frame.size.height+_userNameLab.frame.origin.y+9, 100, 10)];
    _evaluationLab.font  = [UIFont systemFontOfSize:10];
    _evaluationLab.text = @"发布50条评价";
    _evaluationLab.textColor = [UIColor colorWithHexString:@"#999999"];
    [_headView addSubview:_evaluationLab];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.frame.size.height-1, Width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [_headView addSubview:viewLine];
    
    
    
    [self.view addSubview:_headView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _headView.frame.size.height+_headView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-58-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.tintColor = [UIColor colorWithHexString:@"#ff5000"];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --请求数据
-(void)myCollectlist{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"user" action:@"contents"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"type":@"0"};
    
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"contents" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        weakSelf.evaluationLab.text =[NSString stringWithFormat:@"发布%@条评价",dic[@"data"][@"count"]] ;
        weakSelf.userNameLab.text = dic[@"data"][@"username"];
        weakSelf.array = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in dic[@"data"][@"commnet"]) {
            CommentModel *model = [CommentModel new];
            model.time = dict[@"order_time"];
            model.rank = dict[@"rank"];
            model.content = dict[@"content"];
            model.userName = dict[@"user_name"];
            model.goodsName = dict[@"goods_name"];
            model.goodsImage = dict[@"goods_img"];
            model.arrt = dict[@"goods_attr"];
            [weakSelf.array addObject:model];
        }
        NSLog(@"%@",weakSelf.array);
        if (weakSelf.array.count == 0) {
            weakSelf.tableView.hidden = YES;
            weakSelf.headView.hidden = YES;
            weakSelf.nullView.hidden = NO;
            
        }else{
            weakSelf.tableView.hidden = NO;
            weakSelf.headView.hidden = NO;
            weakSelf.nullView.hidden = YES;
        }
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark --tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"MyEvaluationViewTableViewCell";
    MyEvaluationViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyEvaluationViewTableViewCell" owner:self options:nil]lastObject];
    }
    CommentModel *model;
    model = self.array[indexPath.row];
    //名称
    cell.goodsName.text = model.goodsName;
    cell.goodsName.textColor = [UIColor colorWithHexString:@"#43464c"];
    //图片
    NSURL *url =[NSURL URLWithString:model.goodsImage];
    [cell.goosImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_list_pic_error"]];
    //评论内容
    cell.contentLab.text = model.content;
    cell.contentLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    NSString * time=model.time;
    NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY-MM-dd"];
    NSString * goodsTime = [df stringFromDate:dt];
    
    cell.timeAndArrtLab.text = [NSString stringWithFormat:@"%@ %@",goodsTime,model.arrt];
    cell.timeAndArrtLab.textColor = [UIColor colorWithHexString:@"#999999"];
    cell.rankLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
    if ([model.rank isEqualToString:@"1"]) {
        cell.rankLab.text = @"已差评";
    }else if([model.rank isEqualToString:@"2"]){
        cell.rankLab.text = @"已中评";
    }else if([model.rank isEqualToString:@"3"]){
        cell.rankLab.text = @"已中评";
    }else if([model.rank isEqualToString:@"4"]){
        cell.rankLab.text = @"已好评";
    }else if([model.rank isEqualToString:@"5"]){
        cell.rankLab.text = @"已好评";
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114;
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
    NSString *navigationTitleFont = data[@"navigationTitleFont"];
    int titleFont = [navigationTitleFont intValue];
    NSString *naiigationTitleColor = data[@"naiigationTitleColor"];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    
    label.text = @"我的评价";
    
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
    
    [self.view addSubview:view];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
