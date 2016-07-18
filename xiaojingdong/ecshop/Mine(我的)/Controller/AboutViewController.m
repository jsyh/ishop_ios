//
//  AboutViewController.m
//  ecshop
//
//  Created by Jin on 16/1/4.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "AboutViewController.h"
#import "UIColor+Hex.h"
#import "OpinionViewController.h"
@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *banbenLab;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    UIView *suggestionView = [[UIView alloc]initWithFrame:CGRectMake(0, _banbenLab.frame.size.height+_banbenLab.frame.origin.y+H(65), Width, 40)];
    suggestionView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(W(12), H(12), W(20), W(20))];
    imageView.image = [UIImage imageNamed:@"personal_help"];
    [suggestionView addSubview:imageView];
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(W(44), 0, W(100), H(46))];
    nameLab.text = @"意见反馈";
    nameLab.textColor = [UIColor blackColor];
    nameLab.font = [UIFont systemFontOfSize:W(15)];
    [suggestionView addSubview:nameLab];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, Width, 40);
    [button addTarget:self action:@selector(changetoSuggestion) forControlEvents:UIControlEventTouchUpInside];
    [suggestionView addSubview:button];
    [self.view addSubview:suggestionView];
    [self initNavigationBar];
    // Do any additional setup after loading the view from its nib.
}
-(void)changetoSuggestion{
    OpinionViewController *opinVC = [OpinionViewController new];
    [self.navigationController pushViewController:opinVC animated:YES];
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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, view.frame.size.width - 200, 44)];
    
    label.text = @"关于";
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:titleFont];
    label.textColor = [UIColor colorWithHexString:naiigationTitleColor];
    [view addSubview:label];
    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    //    btn.backgroundColor = [UIColor redColor];
    [btn addSubview:imgView];
    //    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-1, self.view.frame.size.width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
    [view addSubview:btn];
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
