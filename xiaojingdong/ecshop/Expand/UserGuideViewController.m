//
//  UserGuideViewController.m
//  lihuibang
//
//  Created by Jin on 15/12/10.
//  Copyright (c) 2015年 jsyh. All rights reserved.
//启动页

#import "UserGuideViewController.h"
#import "UIColor+Hex.h"
#import "ViewController.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define imgCount 5
@interface UserGuideViewController ()<UIScrollViewDelegate>
{
    UIPageControl *pageCtr;
    
}
@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initGuide];
    // Do any additional setup after loading the view.
}
-(void)initGuide{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *GuideButtonBGColor = data[@"GuideButtonBGColor"];
    NSString *GuideButtonTitleColor = data[@"GuideButtonTitleColor"];
    NSString *GuideButtonTitle = data[@"GuideButtonTitle"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    scrollView.delegate = self;
    [scrollView setContentSize:CGSizeMake(kWidth*imgCount, 0)];
    [scrollView setPagingEnabled:YES];  //视图整页显示
    //    [scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来

    
    for (int i = 1; i < imgCount + 1; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth*(i-1), 0, kWidth, kHeight)];
        NSString *imgName = [NSString stringWithFormat:@"%d.png",i];
        [imageview setImage:[UIImage imageNamed:imgName]];
        imageview.userInteractionEnabled = YES;    //打开imageview3的用户交互;否则下面的button无法响应
        scrollView.userInteractionEnabled = YES;
        [scrollView addSubview:imageview];
        if (i == imgCount) {
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button1 setTitle:GuideButtonTitle forState:UIControlStateNormal];
            button1.frame = CGRectMake(20, self.view.frame.size.height - 130, self.view.frame.size.width - 40  , 40);
            [button1 addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
            button1.backgroundColor = [UIColor colorWithHexString:GuideButtonBGColor];
            [button1 setTitleColor:[UIColor colorWithHexString:GuideButtonTitleColor] forState:UIControlStateNormal];
            [imageview addSubview:button1];

        }
    }
    
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:scrollView];
    pageCtr = [[UIPageControl alloc]initWithFrame:CGRectMake(50, scrollView.frame.size.height-20, scrollView.frame.size.width-100, 20)];
    pageCtr.currentPage = 0;
    pageCtr.numberOfPages = imgCount;
    pageCtr.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.view addSubview:pageCtr];
}
-(void)push:(id)sender{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
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
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    pageCtr.currentPage = scrollView.contentOffset.x/self.view.frame.size.width;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
@end
