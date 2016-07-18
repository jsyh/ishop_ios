//
//  GoToCommentViewController.m
//  ecshop
//
//  Created by Jin on 16/5/4.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "GoToCommentViewController.h"
#import "UIColor+Hex.h"
#import "CommentSendTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ShopScoreTableViewCell.h"
#import "AppDelegate.h"
#import "RequestModel.h"
#import "JSONKit.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface GoToCommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,strong)UILabel *commentText;
@property(nonatomic,strong)NSString *descrebeStr;
@property(nonatomic,strong)NSString *serviceStr;
@property(nonatomic,strong)NSString *speedStr;
@property(nonatomic,strong)NSString *comment;//好评，差评，中评
@property(nonatomic,strong)NSMutableDictionary *commentDic;
@end

@implementation GoToCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    [self draw];
    _commentDic = [[NSMutableDictionary alloc]init];
    //获取通知中心单例对象
    //接收店铺评价
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"shopScore" object:nil];
    
    //接收商品评价
    NSNotificationCenter * goodsCenter = [NSNotificationCenter defaultCenter];
    [goodsCenter addObserver:self selector:@selector(goodsNotice:) name:@"goodsComment" object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)notice:(NSNotification *)sender{
    NSDictionary *dic = sender.userInfo;
    
    NSLog(@"%@",dic[@"descrebeStr"]);
    //serviceStr   speedStr
    _descrebeStr = dic[@"descrebeStr"];
    _speedStr = dic[@"speedStr"];
    _serviceStr = dic[@"serviceStr"];
}

-(void)goodsNotice:(NSNotification *)sender{
    NSDictionary *dic = sender.userInfo;
    NSLog(@"%@",dic);


    [_commentDic setObject:dic forKey:dic[@"goods_id"]];
}
-(void)draw{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width , Height-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    //
    UIView *viewComment = [[UIView alloc]initWithFrame:CGRectMake(0, Height-50, Width, 49)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(Width-100, 0, 100, 49);
    [button setTitle:@"发表评论" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
    [button addTarget:self action:@selector(fabiao) forControlEvents:UIControlEventTouchUpInside];
    [viewComment addSubview:button];
    [self.view addSubview:viewComment];
}
-(void)fabiao{

    NSLog(@"%@",_commentDic);
    if (_commentDic.count>0) {
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写评价内容" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    NSMutableArray *commentArr = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *dic in [_commentDic allValues]) {
        [commentArr addObject:dic];
        NSString *strr = dic[@"comments"];
        if (strr.length==0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写评价内容" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
    }
    NSLog(@"%@",commentArr);
    NSString *commentStr = [commentArr JSONString];
    NSLog(@"%@---%@---%@---%@",_descrebeStr,_speedStr,_serviceStr,_comment);
    
  
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString *api_token = [RequestModel model:@"integral" action:@"convert"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"goods_info":commentStr,@"order_id":self.orderID};
    
        [RequestModel requestWithDictionary:dict model:@"integral" action:@"convert" block:^(id result) {
            NSDictionary *dic = result;
            NSLog(@"%@",dic);
           
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
           
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            
        }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrr.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int section = (int)indexPath.section;
    if (section<_arrr.count) {
        static NSString *string = @"CommentSendTableViewCell";
        CommentSendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentSendTableViewCell" owner:self options:nil]lastObject];
        }
        NSMutableDictionary *dic = self.arrr[indexPath.section];
        NSURL *url = [NSURL URLWithString:dic[@"imgUrl"]];
        [cell.imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_list_pic_error"]];
        cell.goodsID = dic[@"goodsID"];
        cell.btn1.frame = CGRectMake(0, 101, Width/3.0, 50);
        [cell.btn1 setTitle:@"好评" forState:UIControlStateNormal];
        [cell.btn1 setImage:[UIImage imageNamed:@"comment_good_press"] forState:UIControlStateNormal];
        cell.btn1.tag = 1001;
        cell.btn2.tag = 1002;
        cell.btn3.tag = 1003;
        cell.btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        cell.btn1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [cell.btn1 setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
        cell.btn2.frame = CGRectMake(Width/3.0, 101, Width/3.0, 50);
        cell.btn2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        cell.btn2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [cell.btn2 setTitle:@"中评" forState:UIControlStateNormal];
        [cell.btn2 setTitleColor:[UIColor colorWithHexString:@"#656973"] forState:UIControlStateNormal];
        [cell.btn2 setImage:[UIImage imageNamed:@"comment_mid"] forState:UIControlStateNormal];
        cell.btn3.frame = CGRectMake((Width/3.0)*2, 101, Width/3.0, 50);
        cell.btn3.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        cell.btn3.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [cell.btn3 setTitleColor:[UIColor colorWithHexString:@"#656973"] forState:UIControlStateNormal];
        [cell.btn3 setTitle:@"差评" forState:UIControlStateNormal];
        [cell.btn3 setImage:[UIImage imageNamed:@"comment_bad"] forState:UIControlStateNormal];
        cell.viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
        return cell;
    }else{
        static NSString * cellid=@"ShopScoreTableViewCell";
        
        ShopScoreTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell=[[ShopScoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 171;
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
    
    label.text = @"发表评价";
    
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
-(void)dealloc{
    
     NSNotificationCenter * goodsCenter = [NSNotificationCenter defaultCenter];
    [goodsCenter removeObserver:self name:@"goodsComment" object:nil];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"shopScore" object:nil];
}
@end
