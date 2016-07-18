//
//  OpenQQViewController.m
//  ecshop
//
//  Created by Jin on 16/5/20.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "OpenQQViewController.h"

@interface OpenQQViewController ()

@end

@implementation OpenQQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.tempQQ]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未安装QQ" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
   
    [self.navigationController popViewControllerAnimated:YES];
    // Do any additional setup after loading the view.
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

@end
