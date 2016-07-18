//
//  NewAddressViewController.m
//  ecshop
//
//  Created by Jin on 15/12/21.
//  Copyright © 2015年 jsyh. All rights reserved.
//新建地址

#import "NewAddressViewController.h"
#import "RequestModel.h"
#import "ChooseAddressViewController.h"
#import "UIColor+Hex.h"
#import "MyAddressModel.h"
#import "AppDelegate.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <ContactsUI/CNContactPickerViewController.h>
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
#define kColorOffButton [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
#define kHeight self.view.frame.size.height/15
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define H(b) Height * b / 667.0
#define W(a) Width * a / 375.0
@interface NewAddressViewController ()<CNContactPickerDelegate,UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)UITextField *text1;
@property(nonatomic,strong)UITextField *text2;
@property(nonatomic,strong)UILabel *lab5;
@property(nonatomic,strong)UITextView *text4;
@property(nonatomic,strong)UIButton *saveBtn;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,strong)UILabel *addressLab;//仿placeholder

@end

@implementation NewAddressViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.tempId == nil) {
    
    }else{
       
        [self revise];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    
    [self draw];

    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)draw{
    float a92 = 92.0/1334.0;
    float aW140 = 140.0/750.0;
    float aW142 = 142.0/750.0;
    UILabel *lab1 = [UILabel new];
    lab1.text = @"收货人:";
    lab1.frame = CGRectMake(12, 64, aW140*Width, a92*Height);
    lab1.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab1.font = [UIFont systemFontOfSize:W(15)];
    [self.view addSubview:lab1];
    UILabel *lab2 = [UILabel new];
    lab2.text = @"手机号码:";
    lab2.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab2.frame = CGRectMake(12, 64+a92*Height, aW140*Width, a92*Height);
    lab2.font = [UIFont systemFontOfSize:W(15)];
    [self.view addSubview:lab2];
    UILabel *lab3 = [UILabel new];
    lab3.text = @"所在地区:";
    lab3.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab3.font = [UIFont systemFontOfSize:W(15)];
    lab3.frame = CGRectMake(12, 64+a92*Height*2, aW140*Width, a92*Height);
    [self.view addSubview:lab3];
    UILabel *lab4 = [UILabel new];
    lab4.text = @"详细地址:";
    lab4.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab4.font = [UIFont systemFontOfSize:W(15)];
    lab4.frame = CGRectMake(12, 64+a92*Height*3, aW140*Width, a92*Height);
    [self.view addSubview:lab4];
    _lab5 = [UILabel new];
    _lab5.frame = CGRectMake(12 + lab3.frame.size.width, 64+a92*Height*2, Width-lab3.frame.size.width-12, a92*Height);
    _lab5.textColor = [UIColor colorWithHexString:@"#43464c"];
    [self.view addSubview:_lab5];
    _lab5.font = [UIFont systemFontOfSize:W(15)];
    _text1 = [UITextField new];
    _text1.delegate = self;
    _text1.textColor = [UIColor colorWithHexString:@"#43464c"];
    _text1.frame = CGRectMake(12 + lab1.frame.size.width, 64, Width-aW142*Width-lab1.frame.size.width-12, kHeight);
    [_text1 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _text1.font = [UIFont systemFontOfSize:W(15)];
    [self.view addSubview:_text1];
    _text2 = [UITextField new];
    _text2.frame = CGRectMake(12 + lab2.frame.size.width, lab2.frame.origin.y, Width-aW142*Width-lab2.frame.size.width-12, kHeight);
    _text2.font = [UIFont systemFontOfSize:W(15)];
    _text2.delegate = self;
    _text2.textColor = [UIColor colorWithHexString:@"#43464c"];
    [_text2 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_text2];
    float aH184 = 184.0/1334.0;
    _text4 = [UITextView new];
    _text4.textColor = [UIColor colorWithHexString:@"#43464c"];
    _text4.frame = CGRectMake(12 + lab4.frame.size.width, lab4.frame.origin.y+6, Width-lab4.frame.size.width-12, aH184*Height-6);
    _text4.font = [UIFont systemFontOfSize:W(15)];
    
    _text4.delegate = self;
//    _text4.placeholder = @"街道、楼牌号等";
    [self.view addSubview:_text4];
    //仿placeholder
    _addressLab = [[UILabel alloc]initWithFrame:CGRectMake(3, 6, 150, 15)];
    if (self.tempId == nil) {
        _addressLab.text = @"街道、楼牌号等";
    }else{
        _addressLab.text = @"";
    }
    _addressLab.enabled = NO;
    _addressLab.font = [UIFont systemFontOfSize:15];
    _addressLab.backgroundColor = [UIColor clearColor];
    [_text4 addSubview:_addressLab];
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(12 + self.view.frame.size.width/4, 66 + kHeight *2, (self.view.frame.size.width/2)*3, kHeight);
    button3.backgroundColor = [UIColor clearColor];
    [button3 addTarget:self action:@selector(button3Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = CGRectMake(0, Height-50, Width, 50);
    _saveBtn.userInteractionEnabled = NO;
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    _saveBtn.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:W(15)];
    [_saveBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    float aX54 = 54.0/750.0;
    float aW50 = 50.0/750.0;
    float aY40 = 40.0/1334.0;
    float aH54 = 54.0/1334.0;
    UIImageView *imgView = [UIImageView new];
    imgView.frame = CGRectMake(Width - aX54*Width-aW50*Width, 64+aY40*Height, aW50*Width, aH54*Height);
    imgView.image = [UIImage imageNamed:@"mine_consignee_contacts"];
    [self.view addSubview:imgView];
    float a118 = 118.0/750.0;
    float a24 = 24.0/750.0;
    UILabel *chooseLab = [UILabel new];
    chooseLab.text = @"选联系人";
    chooseLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    chooseLab.font = [UIFont systemFontOfSize:12];
    chooseLab.frame = CGRectMake(Width-Width*a24-a118*Width, imgView.frame.origin.y+imgView.frame.size.height+12 , a118*Width , 12);
    chooseLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:chooseLab];
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame = CGRectMake(20+(self.view.frame.size.width/4)*3, 64, self.view.frame.size.width/4 - 30, kHeight*2);
    //    chooseBtn.backgroundColor = [UIColor blueColor];
    [chooseBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBtn];
    //中间的线
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + a92*Height, (self.view.frame.size.width /4)*3 + 10, 1)];
    view1.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 65 + a92*Height*2, self.view.frame.size.width, 1)];
    view2.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 66 + a92*Height*3, self.view.frame.size.width, 1)];
    view3.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.view addSubview:view3];
    
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, _text4.frame.origin.y+aH184*Height, Width, 1)];
    view4.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [self.view addSubview:view4];
    
    //选联系人旁边的竖线
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(view1.frame.size.width, 64, 1, a92*Height*2)];
    view5.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    [self.view addSubview:view5];
    
    
    
    
}

#pragma mark --获取地区
-(void)button3Action:(id)sender{
    
    ChooseAddressViewController *chooseVC = [[ChooseAddressViewController alloc]init];

    __weak typeof(self) weakSelf = self;
    [chooseVC returnText:^(NSString *province, NSString *city, NSString *area, NSString *proId, NSString *cityId, NSString *areaId) {
        weakSelf.lab5.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        weakSelf.province = proId;
        weakSelf.city = cityId;
        weakSelf.area = areaId;
        
    }];
    [self.navigationController pushViewController:chooseVC animated:YES];
    
    
    
}
#pragma mark --保存联系人
-(void)saveBtnAction:(id)sender{
    NSLog(@"保存");
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"goods" action:@"address"];
    
    if (self.tempId == nil) {
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"province":self.province,@"city":self.city,@"district":self.area,@"username":self.text1.text,@"address_p":self.text4.text,@"telnumber":self.text2.text};
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"goods" action:@"address" block:^(id result) {
            NSDictionary *dic = result;
            NSLog(@"获得的数据：%@",dic);
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        }];
    }else{
        
        
        if (self.province==nil) {
            self.province = @"";
        }
        if (self.city==nil) {
            self.city = @"";
        }
        if (self.area==nil) {
            self.area = @"";
        }
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"province":self.province,@"city":self.city,@"district":self.area,@"username":self.text1.text,@"address_p":self.text4.text,@"telnumber":self.text2.text,@"address_id":self.tempId};
        __weak typeof(self) weakSelf = self;
        
        [RequestModel requestWithDictionary:dict model:@"goods" action:@"address" block:^(id result) {
            NSDictionary *dic = result;
            NSLog(@"获得的数据：%@",dic);
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        }];
    }
    
}
#pragma mark --选择联系人
-(void)chooseBtnAction:(id)sender{
    CNContactPickerViewController *con = [[CNContactPickerViewController alloc]init];
    con.delegate = self;
    _saveBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.userInteractionEnabled = YES;
    [self presentViewController:con animated:YES completion:nil];
}
#pragma mark --联系人delegate
//视图取消时 调用的方法
-(void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    self.text1.text = self.name;
    self.text2.text = self.phone;
}
//选中时调用的方法
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    NSString *string = [NSString stringWithFormat:@"%@",contact.phoneNumbers[0]];
    //从字符中分隔成2个元素的数组
    NSArray *array = [string componentsSeparatedByString:@"digits="];
    NSArray *array1 = [array[1] componentsSeparatedByString:@">"];
    //array1[0]存的是手机号
    self.phone = array1[0];
    self.name = [NSString stringWithFormat:@"%@ %@",contact.familyName,contact.givenName];
    self.text1.text = self.name;
    self.text2.text = self.phone;
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
-(void)textFieldChanged:(id)sender{
    if (self.text1.text.length>0&&self.text2.text.length>0) {
        _saveBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveBtn.userInteractionEnabled = YES;
    }else{
        _saveBtn.backgroundColor = [UIColor colorWithHexString:@"dbdbdb"];
        [_saveBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _saveBtn.userInteractionEnabled = NO;
    }
}
#pragma mark -- 修改收货地址
-(void)revise{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"goods" action:@"addrdetail"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"address_id":self.tempId};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"addrdetail" block:^(id result) {
        NSDictionary *dic = result[@"data"];
        NSLog(@"获得的数据：%@",dic);
        if (weakSelf.text1.text.length>0) {
            
        }else{
            weakSelf.text1.text = dic[@"username"];
        }
        
        if (weakSelf.text2.text.length>0) {
            
        }else{
            weakSelf.text2.text = dic[@"telnum"];
        }
        if (weakSelf.text4.text.length>0) {
            
        }else{
             weakSelf.text4.text = dic[@"address"];
        }
        
        
       
        if (weakSelf.lab5.text.length>0) {
            
        }else{
            weakSelf.lab5.text = dic[@"area"];
        }
        weakSelf.province = dic[@"province"];
        weakSelf.city = dic[@"city"];
        weakSelf.area = dic[@"district"];
        
    }];
}
//关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _addressLab.text = @"街道、楼牌号等";
    }else{
        _addressLab.text = @"";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        
        [_text4 resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
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
    if (self.tempId == nil) {
        label.text = @"新建收货地址";
    }else{
        label.text = @"修改收货地址";
    }
   
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
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-1, Width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
