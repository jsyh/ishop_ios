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
    UITextView *txtview = [[UITextView alloc]initWithFrame:CGRectMake(12, 76, self.view.frame.size.width - 24, self.view.frame.size.height/4)];
    txtview.backgroundColor = [UIColor whiteColor];
    txtview.font = [UIFont systemFontOfSize:15];
    txtview.delegate = self;
    txtview.hidden = NO;

    _label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 300, 40)];
    
    _label.text = @"请输入产品意见，我们将不断优化。";
    _label.textColor = [UIColor blackColor];
    _label.enabled = NO;
    _label.font = [UIFont systemFontOfSize:15];
    _label.backgroundColor= [UIColor clearColor];
    [txtview addSubview:_label];
    [self.view addSubview:txtview];
   
   
    
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
    label.text = @"帮助与反馈";
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
    //提交
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(self.view.frame.size.width - 35-12, 20, 35, 44);
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [editBtn setTitle:@"提交" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:editBtn];

    
    [self.view addSubview:view];
    
    
}
-(void)editButtonClick{
    NSLog(@"提交");
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
