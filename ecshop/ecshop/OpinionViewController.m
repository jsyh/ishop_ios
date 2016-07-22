//
//  OpinionViewController.m
//  ecshop
//
//  Created by Jin on 15/12/4.
//  Copyright © 2015年 jsyh. All rights reserved.
//意见反馈

#import "OpinionViewController.h"
#import "AppDelegate.h"
#import "UIColor+Hex.h"
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
#define kColorOffButton [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
@interface OpinionViewController ()<UITextViewDelegate>
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIButton *button;
@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBack;
    //加上可以使textview文字从顶显示
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self draw];
    [self initNavigationBar];
}

-(void)draw{
    UITextView *txtview = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height/4)];
    txtview.backgroundColor = [UIColor whiteColor];
    txtview.font = [UIFont systemFontOfSize:15];
    txtview.delegate = self;
    txtview.hidden = NO;

    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height/30)];
    
    _label.text = @"请留下您的宝贵意见吧";
    _label.textColor = [UIColor blackColor];
    _label.enabled = NO;
    _label.font = [UIFont systemFontOfSize:15];
    _label.backgroundColor= [UIColor clearColor];
    
    [self.view addSubview:txtview];
    [self.view addSubview:_label];
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"提交" forState:UIControlStateNormal];
    _button.frame = CGRectMake(self.view.frame.size.width/30, (self.view.frame.size.height/4)+70, (self.view.frame.size.width/30)*28, 35);
    _button.titleLabel.font = [UIFont systemFontOfSize:15];
    _button.backgroundColor = kColorOffButton;
    [self.view addSubview:_button];
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _label.text = @"请留下您的宝贵意见吧";
    }else{
        _label.text = @"";
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    label.text = @"意见反馈";
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
