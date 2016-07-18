//
//  ApplyViewController.m
//  ecshop
//
//  Created by Jin on 16/5/10.
//  Copyright © 2016年 jsyh. All rights reserved.
//申请售后/退货

#import "ApplyViewController.h"
#import "RequestModel.h"
#import "MyAllOrderViewController.h"
#import "AppDelegate.h"
#import "UIColor+Hex.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define H(b) Height * b / 667.0
#define W(a) Width * a / 375.0
@interface ApplyViewController ()
@property (nonatomic,strong)UIButton *returnGoodsBtn;//退货退款
@property (nonatomic,strong)UIButton *repairBtn;//申请维修
@property (nonatomic,strong)UIView *returnGoodsView;//退货退款的视图
@property (nonatomic,strong)UIView *repairView;//申请维修的视图
@property (nonatomic,strong)UITextField *explainField;//退款说明
@property (nonatomic,strong)UILabel *moneyField;//退款金额
@property (nonatomic,strong)UITextField *reasonField;//退货原因
@property (nonatomic,strong)UITextField *repairReasonField;//维修原因
@property (nonatomic,strong)UITextField *repairExplainField;//维修说明
@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self draw];
    // Do any additional setup after loading the view.
}
-(void)draw{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, 65)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    //申请服务的lab
    
    UILabel *serviceLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 64+12, 100, 14)];
    serviceLab.text = @"申请服务";
    serviceLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    serviceLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:serviceLab];
    
    //退货退款按钮
    self.returnGoodsBtn.frame = CGRectMake(12, serviceLab.frame.size.height+serviceLab.frame.origin.y+12, 70, 14);
    _returnGoodsBtn.selected = YES;
    _returnGoodsBtn.highlighted = NO;
    [_returnGoodsBtn setTitle:@"退货退款" forState:UIControlStateNormal];
    [_returnGoodsBtn setImage:[UIImage imageNamed:@"mine_application_return_press"] forState:UIControlStateNormal];
    [_returnGoodsBtn addTarget:self action:@selector(returnGoodsAction) forControlEvents:UIControlEventTouchUpInside];
    _returnGoodsBtn.titleLabel.font = [UIFont systemFontOfSize:W(14)];
    [_returnGoodsBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    [self.view addSubview:_returnGoodsBtn];
    //申请维修按钮
    self.repairBtn.frame = CGRectMake(Width/2.0, _returnGoodsBtn.frame.origin.y, 70, 14);
    [_repairBtn setTitle:@"申请维修" forState:UIControlStateNormal];
    _repairBtn.selected = NO;
    [_repairBtn setImage:[UIImage imageNamed:@"mine_application_return"] forState:UIControlStateNormal];
    [_repairBtn addTarget:self action:@selector(repairAction) forControlEvents:UIControlEventTouchUpInside];
    _repairBtn.titleLabel.font = [UIFont systemFontOfSize:W(14)];
    [_repairBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    [self.view addSubview:_repairBtn];
    
    [self creatReturnView];
    [self creatRepairView];
    //提交申请按钮
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    applyBtn.frame = CGRectMake(Width/2.0-38, Height - 12-27, 76, 27);
    [applyBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
    applyBtn.layer.cornerRadius = 3;
    applyBtn.layer.borderWidth = 0.5;
    applyBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
    applyBtn.layer.masksToBounds = YES;
    [applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:applyBtn];
}
#pragma mark -- 申请事件
-(void)applyAction{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;

    if (_repairBtn.selected) {
        NSLog(@"申请维修");
       // _repairReasonField 维修原因 _repairExplainField 维修说明
        //postscript 问题说明
        NSString *api_token = [RequestModel model:@"user" action:@"back_goods"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"type":@"3",@"order_id":self.orderID,@"goods_id":self.goodsID,@"postscript":_repairExplainField.text,@"back_reason":_repairReasonField.text,@"money":self.price};
        
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"user" action:@"back_goods" block:^(id result) {
            NSDictionary *dic = result;
            NSLog(@"%@",dic);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:result[@"msg"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        }];
    }else if (_returnGoodsBtn.selected){
        NSLog(@"退货申请");
        NSLog(@"%@",_reasonField.text);//退货原因
        NSLog(@"%@",_explainField.text);//退货说明
        NSString *api_token = [RequestModel model:@"user" action:@"back_goods"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"type":@"1",@"order_id":self.orderID,@"goods_id":self.goodsID,@"postscript":_explainField.text,@"back_reason":_reasonField.text,@"money":self.price};
        
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"user" action:@"back_goods" block:^(id result) {
            NSDictionary *dic = result;
            NSLog(@"%@",dic);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                
                
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            
            
        }];
    }
   
}
-(void)creatReturnView{
    //退货退款视图
    self.returnGoodsView.frame = CGRectMake(0, 64+65, Width, Height-64-65-46);
    _returnGoodsView.backgroundColor = [UIColor whiteColor];
    _returnGoodsView.hidden = NO;
    //
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [_returnGoodsView addSubview:viewLine];
    UIView *viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, _returnGoodsView.frame.size.height-1, Width, 1)];
    viewLine1.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [_returnGoodsView addSubview:viewLine1];
    //退货原因
    UIView *reasonView = [[UIView alloc]initWithFrame:CGRectMake(W(12), H(18), Width-W(24), H(32))];
    reasonView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    reasonView.layer.cornerRadius = 3;
    reasonView.layer.masksToBounds = YES;
    
    UILabel *reasonLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, reasonView.frame.size.height)];
    reasonLab.text = @"退货原因";
    reasonLab.textColor = [UIColor colorWithHexString:@"#999999"];
    reasonLab.font = [UIFont systemFontOfSize:16];
    reasonLab.textAlignment = NSTextAlignmentCenter;
    [reasonView addSubview:reasonLab];
    
    _reasonField = [[UITextField alloc]initWithFrame:CGRectMake(reasonLab.frame.size.width, 0, reasonView.frame.size.width-reasonLab.frame.size.width, reasonView.frame.size.height)];
    _reasonField.font = [UIFont systemFontOfSize:16];
    _reasonField.textColor = [UIColor colorWithHexString:@"#43464c"];
    [_reasonField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [reasonView addSubview:_reasonField];
    
    [_returnGoodsView addSubview:reasonView];
    //退货金额
    UIView *moneyView = [[UIView alloc]initWithFrame:CGRectMake(W(12), H(18)+reasonView.frame.size.height+reasonView.frame.origin.y, Width-W(24), H(32))];
    moneyView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    moneyView.layer.cornerRadius = 3;
    moneyView.layer.masksToBounds = YES;
    
    UILabel *moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, moneyView.frame.size.height)];
    moneyLab.text = @"退货金额  ¥";
    moneyLab.textColor = [UIColor colorWithHexString:@"#999999"];
    moneyLab.font = [UIFont systemFontOfSize:16];
    moneyLab.textAlignment = NSTextAlignmentCenter;
    [moneyView addSubview:moneyLab];
    
    _moneyField = [[UILabel alloc]initWithFrame:CGRectMake(moneyLab.frame.size.width, 0, moneyView.frame.size.width-moneyLab.frame.size.width, moneyView.frame.size.height)];
    _moneyField.font = [UIFont systemFontOfSize:16];
    _moneyField.text = self.price;
    _moneyField.textColor = [UIColor colorWithHexString:@"#ff5000"];
    [moneyView addSubview:_moneyField];
    
    [_returnGoodsView addSubview:moneyView];
    
    //退货说明
    UIView *explainView = [[UIView alloc]initWithFrame:CGRectMake(W(12), H(18)+moneyView.frame.size.height+moneyView.frame.origin.y, Width-W(24), H(32))];
    explainView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    explainView.layer.cornerRadius = 3;
    explainView.layer.masksToBounds = YES;
    
    
    UILabel *explainLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, explainView.frame.size.height)];
    explainLab.text = @"退货说明";
    explainLab.textColor = [UIColor colorWithHexString:@"#999999"];
    explainLab.font = [UIFont systemFontOfSize:16];
    explainLab.textAlignment = NSTextAlignmentCenter;
    [explainView addSubview:explainLab];
    
    
    _explainField = [[UITextField alloc]initWithFrame:CGRectMake(explainLab.frame.size.width, 0, explainView.frame.size.width-explainLab.frame.size.width, explainView.frame.size.height)];
    _explainField.font = [UIFont systemFontOfSize:16];
    _explainField.placeholder = @"最多200字";
    _explainField.textColor = [UIColor colorWithHexString:@"#43464c"];
    [explainView addSubview:_explainField];
    [_explainField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_returnGoodsView addSubview:explainView];
    
    [self.view addSubview:_returnGoodsView];
}
-(void)creatRepairView{
    //申请维修的view
    self.repairView.frame  = CGRectMake(0, 64+65, Width, Height-64-65-46);
    _repairView.backgroundColor = [UIColor whiteColor];
    self.repairView.hidden = YES;
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [_repairView addSubview:viewLine];
    UIView *viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, _repairView.frame.size.height-1, Width, 1)];
    viewLine1.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [_repairView addSubview:viewLine1];
    //维修原因
    UIView *repairReasonView = [[UIView alloc]initWithFrame:CGRectMake(W(12), H(18), Width-W(24), H(32))];
    repairReasonView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    repairReasonView.layer.cornerRadius = 3;
    repairReasonView.layer.masksToBounds = YES;
    
    UILabel *reasonLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, repairReasonView.frame.size.height)];
    reasonLab.text = @"维修原因";
    reasonLab.textColor = [UIColor colorWithHexString:@"#999999"];
    reasonLab.font = [UIFont systemFontOfSize:16];
    reasonLab.textAlignment = NSTextAlignmentCenter;
    [repairReasonView addSubview:reasonLab];
    
    _repairReasonField = [[UITextField alloc]initWithFrame:CGRectMake(reasonLab.frame.size.width, 0, repairReasonView.frame.size.width-reasonLab.frame.size.width, repairReasonView.frame.size.height)];
    [_repairReasonField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _repairReasonField.font = [UIFont systemFontOfSize:16];
    [repairReasonView addSubview:_repairReasonField];
    
    [_repairView addSubview:repairReasonView];
    //维修说明
    UIView *repairExplainView = [[UIView alloc]initWithFrame:CGRectMake(W(12), H(18)+repairReasonView.frame.size.height+repairReasonView.frame.origin.y, Width-W(24), H(32))];
    repairExplainView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    repairExplainView.layer.cornerRadius = 3;
    repairExplainView.layer.masksToBounds = YES;
    
    UILabel *repairExplainLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, repairReasonView.frame.size.height)];
    repairExplainLab.text = @"维修说明";
    repairExplainLab.textColor = [UIColor colorWithHexString:@"#999999"];
    repairExplainLab.font = [UIFont systemFontOfSize:16];
    repairExplainLab.textAlignment = NSTextAlignmentCenter;
    [repairExplainView addSubview:repairExplainLab];
    
    _repairExplainField = [[UITextField alloc]initWithFrame:CGRectMake(repairExplainLab.frame.size.width, 0, repairExplainView.frame.size.width-repairExplainLab.frame.size.width, repairExplainView.frame.size.height)];
    _repairExplainField.placeholder = @"最多200字";
    _repairExplainField.textColor = [UIColor colorWithHexString:@"#43464c"];
    _repairExplainField.font = [UIFont systemFontOfSize:16];
    [_repairExplainField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [repairExplainView addSubview:_repairExplainField];
    
    
    [_repairView addSubview:repairExplainView];
    
    [self.view addSubview:_repairView];
}
//退款按钮
-(void)returnGoodsAction{
//    if (_returnGoodsBtn.selected) {
//        _returnGoodsBtn.selected = NO;
//        [_returnGoodsBtn setImage:[UIImage imageNamed:@"mine_application_return"] forState:UIControlStateNormal];
//        _repairBtn.selected = YES;
//        [_repairBtn setImage:[UIImage imageNamed:@"mine_application_return_press"] forState:UIControlStateNormal];
//        _returnGoodsView.hidden = YES;
//        _repairView.hidden = NO;
//    }else
    if (_returnGoodsBtn.selected==NO){
        _returnGoodsBtn.selected = YES;
        [_returnGoodsBtn setImage:[UIImage imageNamed:@"mine_application_return_press"] forState:UIControlStateNormal];
        _repairBtn.selected = NO;
        [_repairBtn setImage:[UIImage imageNamed:@"mine_application_return"] forState:UIControlStateNormal];
        _returnGoodsView.hidden = NO;
        _repairView.hidden = YES;
    }
  
}
//维修按钮
-(void)repairAction{
//    if (_repairBtn.selected) {
//        _repairBtn.selected = NO;
//        _returnGoodsView.hidden = NO;
//        _repairView.hidden = YES;
//        [_repairBtn setImage:[UIImage imageNamed:@"mine_application_return"] forState:UIControlStateNormal];
//        _returnGoodsBtn.selected = YES;
//        [_returnGoodsBtn setImage:[UIImage imageNamed:@"mine_application_return_press"] forState:UIControlStateNormal];
//        
//    }else
    if(_repairBtn.selected==NO){
        _repairBtn.selected = YES;
        _returnGoodsView.hidden = YES;
        _repairView.hidden = NO;
        [_repairBtn setImage:[UIImage imageNamed:@"mine_application_return_press"] forState:UIControlStateNormal];
        _returnGoodsBtn.selected = NO;
        [_returnGoodsBtn setImage:[UIImage imageNamed:@"mine_application_return"] forState:UIControlStateNormal];
    }
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _explainField) {
        if (textField.text.length > 200) {
            textField.text = [textField.text substringToIndex:200];
        }
    }else if(textField == _repairExplainField){
        if (textField.text.length>200) {
            textField.text = [textField.text substringToIndex:200];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --懒加载
-(UIButton *)returnGoodsBtn{
    if (!_returnGoodsBtn) {
        _returnGoodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       
    }
    return _returnGoodsBtn;
}
-(UIButton *)repairBtn{
    if (!_repairBtn) {
        _repairBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _repairBtn;
}
-(UIView *)repairView{
    if (!_repairView) {
        _repairView = [[UIView alloc]init];
    }
    return _repairView;
}
-(UIView *)returnGoodsView{
    if (!_returnGoodsView) {
        _returnGoodsView = [[UIView alloc]init];
    }
    return _returnGoodsView;
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
    
    label.text = @"申请售后";
    
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
