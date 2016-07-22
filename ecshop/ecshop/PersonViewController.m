//
//  PersonViewController.m
//  ecshop
//
//  Created by Jin on 16/1/19.
//  Copyright © 2016年 jsyh. All rights reserved.
//个人信息

#import "PersonViewController.h"
#import "UIColor+Hex.h"
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
@interface PersonViewController ()
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
@property(nonatomic,strong)UIButton *button3;
@property(nonatomic,strong)NSString *tempStr;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改性别";
    self.view.backgroundColor = kColorBack;
    [self draw];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}
-(void)draw{
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame =  CGRectMake(0, 64, self.view.frame.size.width, 40);
    [_button1 setTitle:@"男" forState:UIControlStateNormal];
    //    [_button1.layer setBorderWidth:0.5];
    _button1.backgroundColor = [UIColor whiteColor];
    [_button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:_button1];
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button2.frame =  CGRectMake(0, 105, self.view.frame.size.width, 40);
    [_button2 setTitle:@"女" forState:UIControlStateNormal];
    //    [_button2.layer setBorderWidth:0.5];
    _button2.backgroundColor = [UIColor whiteColor];
    [_button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_button2];
    _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button3.frame =  CGRectMake(0, 146, self.view.frame.size.width, 40);
    [_button3 setTitle:@"保密" forState:UIControlStateNormal];
    //    [_button3.layer setBorderWidth:0.5];
    [_button3 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button3.backgroundColor = [UIColor whiteColor];
    [_button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_button3];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)returnText:(ReturnBlock)block{
    self.returnTextBlock = block;
}
-(void)viewDidDisappear:(BOOL)animated{
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(self.tempStr);
    }
}
-(void)buttonAction:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    self.tempStr = sender.titleLabel.text;
    [self.navigationController popViewControllerAnimated:YES];
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
    
    labelTitle.text = @"修改性别";
    
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont systemFontOfSize:titleFont];
    labelTitle.textColor = [UIColor colorWithHexString:naiigationTitleColor];
    [view addSubview:labelTitle];
    
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
