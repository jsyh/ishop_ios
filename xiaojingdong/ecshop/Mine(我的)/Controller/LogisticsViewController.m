//
//  LogisticsViewController.m
//  ecshop
//
//  Created by Jin on 16/5/11.
//  Copyright © 2016年 jsyh. All rights reserved.
//填写物流单号

#import "LogisticsViewController.h"
#import "UIColor+Hex.h"
#import "RequestModel.h"
#import "AppDelegate.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define H(b) Height * b / 667.0
#define W(a) Width * a / 375.0
@interface LogisticsViewController ()
@property(nonatomic,strong)UIView *repairView;
@property(nonatomic,strong)UITextField *logisticsNameField;
@property(nonatomic,strong)UITextField *logisticsNumField;

@end

@implementation LogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self draw];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    // Do any additional setup after loading the view.
}
-(void)draw{
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

    [self creatRepairView];
}
-(void)creatRepairView{
    //申请维修的view
    self.repairView.frame  = CGRectMake(0, 64, Width, Height-64-46);
    _repairView.backgroundColor = [UIColor whiteColor];

    UIView *viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, _repairView.frame.size.height-1, Width, 1)];
    viewLine1.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [_repairView addSubview:viewLine1];
    //维修原因
    UIView *repairReasonView = [[UIView alloc]initWithFrame:CGRectMake(W(12), H(18), Width-W(24), H(32))];
    repairReasonView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    repairReasonView.layer.cornerRadius = 3;
    repairReasonView.layer.masksToBounds = YES;
    
    UILabel *reasonLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, repairReasonView.frame.size.height)];
    reasonLab.text = @"快递名称：";
    reasonLab.textColor = [UIColor colorWithHexString:@"#999999"];
    reasonLab.font = [UIFont systemFontOfSize:16];
    reasonLab.textAlignment = NSTextAlignmentCenter;
    [repairReasonView addSubview:reasonLab];
    
    _logisticsNameField = [[UITextField alloc]initWithFrame:CGRectMake(reasonLab.frame.size.width, 0, repairReasonView.frame.size.width-reasonLab.frame.size.width, repairReasonView.frame.size.height)];
//    [_logisticsNameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _logisticsNameField.font = [UIFont systemFontOfSize:16];
    [repairReasonView addSubview:_logisticsNameField];
    
    [_repairView addSubview:repairReasonView];
    //维修说明
    UIView *repairExplainView = [[UIView alloc]initWithFrame:CGRectMake(W(12), H(18)+repairReasonView.frame.size.height+repairReasonView.frame.origin.y, Width-W(24), H(32))];
    repairExplainView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    repairExplainView.layer.cornerRadius = 3;
    repairExplainView.layer.masksToBounds = YES;
    
    UILabel *repairExplainLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, repairReasonView.frame.size.height)];
    repairExplainLab.text = @"快递单号：";
    repairExplainLab.textColor = [UIColor colorWithHexString:@"#999999"];
    repairExplainLab.font = [UIFont systemFontOfSize:16];
    repairExplainLab.textAlignment = NSTextAlignmentCenter;
    [repairExplainView addSubview:repairExplainLab];
    
    _logisticsNumField = [[UITextField alloc]initWithFrame:CGRectMake(repairExplainLab.frame.size.width, 0, repairExplainView.frame.size.width-repairExplainLab.frame.size.width, repairExplainView.frame.size.height)];
    _logisticsNumField.textColor = [UIColor colorWithHexString:@"#43464c"];
    _logisticsNumField.font = [UIFont systemFontOfSize:16];
//    [_logisticsNumField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [repairExplainView addSubview:_logisticsNumField];
    
    
    [_repairView addSubview:repairExplainView];
    
    [self.view addSubview:_repairView];
}
-(UIView *)repairView{
    if (!_repairView) {
        _repairView = [[UIView alloc]init];
    }
    return _repairView;
}
#pragma mark --提交快递单号
-(void)applyAction{
    //_logisticsNameField _logisticsNumField
    
    if (_logisticsNameField.text.length>0) {
        if (_logisticsNumField.text.length>0) {
            UIApplication *appli=[UIApplication sharedApplication];
            AppDelegate *app=appli.delegate;
            NSString *api_token = [RequestModel model:@"user" action:@"subcode"];
            NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"back_id":self.backID,@"shipping_no":_logisticsNumField.text,@"shipping_name":_logisticsNameField.text};
            
            __weak typeof(self) weakSelf = self;
            [RequestModel requestWithDictionary:dict model:@"user" action:@"subcode" block:^(id result) {
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

        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写快递单号" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写快递名称" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
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
    NSString *navigationTitleFont = data[@"navigationTitleFont"];
    int titleFont = [navigationTitleFont intValue];
    NSString *naiigationTitleColor = data[@"naiigationTitleColor"];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    
    label.text = @"填写物流单号";
    
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
