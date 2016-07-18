//
//  PersonViewController.m
//  ecshop
//
//  Created by Jin on 16/1/19.
//  Copyright © 2016年 jsyh. All rights reserved.
//个人信息

#import "PersonViewController.h"
#import "UIColor+Hex.h"
#import "RequestModel.h"
#import "AppDelegate.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface PersonViewController ()
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,strong)NSString *tempStr;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self draw];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}
-(void)draw{
    float aX24 = 24.0/750.0;
    float aY24 = 24.0/1334.0;
    float aH92 = 92.0/1334.0;
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(aX24*Width, 64+aY24*Height, Width-2*aX24*Width, aH92*Height)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.layer.cornerRadius = 5;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.layer.masksToBounds = YES;
    _textField.placeholder = @"请输入昵称";
     _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:_textField];
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
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    
    labelTitle.text = @"昵称";
    
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont systemFontOfSize:titleFont];
    labelTitle.textColor = [UIColor colorWithHexString:naiigationTitleColor];
    [view addSubview:labelTitle];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.frame = CGRectMake(view.frame.size.width - 52, 20, 40, 44);
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:saveBtn];
    
    
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
#pragma mark -- 保存个人信息
-(void)saveAction{

        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString *api_token = [RequestModel model:@"User" action:@"modifyUser"];
        NSString *nickName = _textField.text;
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"nickname":nickName};
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"User" action:@"modifyUser" block:^(id result) {
            NSDictionary *dic = result;
            NSLog(@"获得的数据：%@",dic);
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
            
        }];
    
}
@end
