//
//  IntegrationViewController.m
//  ecshop
//
//  Created by Jin on 16/4/26.
//  Copyright © 2016年 jsyh. All rights reserved.
//我的积分

#import "IntegrationViewController.h"
#import "UIColor+Hex.h"
#include<QuartzCore/CoreAnimation.h>
#import "signButton.h"
#import "myIntegralTableViewCell.h"
#import "AppDelegate.h"
#import "RequestModel.h"
#import "IntegralModel.h"
#import "BrandViewController.h"
//#import <QuartzCore/CoreAnimation.h>

@interface IntegrationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *nullView;

@property(nonatomic,strong)UILabel *signLab;//签到 已签到
@property(nonatomic,strong)NSMutableArray *myMuArray;
@property(nonatomic,strong) UILabel *signLab2;//+10积分
@property(nonatomic,strong)UILabel *integralLab;
@property(nonatomic,strong)signButton *signBtn;
@end

@implementation IntegrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    [self creatUI];
    [self myAccount];
    // Do any additional setup after loading the view.
}
-(NSMutableArray *)myMuArray{
    if (!_myMuArray) {
        _myMuArray = [NSMutableArray array];
    }
    return _myMuArray;
}
-(void)creatUI{
    float aH400 = 400.0/1334.0;
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Width, aH400*Height)];
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.image = [UIImage imageNamed:@"singed_background"];
    [self.view addSubview:backgroundImageView];
    //background_round
    _signBtn = [signButton buttonWithType:UIButtonTypeCustom];
    _signBtn.frame = CGRectMake(self.view.center.x - W(169)/2.0, H(5), W(169), W(169));
    [_signBtn setImage:[UIImage imageNamed:@"background_round"] forState:UIControlStateNormal];
    [_signBtn addTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:_signBtn];
   
    //签到或已签到
    float aY64 = 64.0/1334.0;
    _signLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _signBtn.center.y - aY64*Height, _signBtn.frame.size.width, 19)];
    if ([self.qd isEqualToString:@"0"]) {
        _signLab.text = @"签到";
    }else{
        _signLab.text = @"已签到";
    }
    
    _signLab.font = [UIFont systemFontOfSize:W(19)];
    _signLab.userInteractionEnabled = YES;
    _signLab.textAlignment = NSTextAlignmentCenter;
    _signLab.textColor = [UIColor colorWithHexString:@"ff5000"];
    [_signBtn addSubview:_signLab];
    float a26 = 20.0/1334.0;
    _signLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _signBtn.center.y +a26*Height, _signBtn.frame.size.width, 12)];
    
    if ([self.qd isEqualToString:@"0"]) {
        _signLab2.text = @"还未签到呢?";
        if ([self.type isEqualToString:@"0"]) {
            [self buttonAnimation:_signBtn];
        }
    }else{
        _signLab2.text = [NSString stringWithFormat:@"+%@积分",_points];
    }
    _signLab2.userInteractionEnabled = YES;
    _signLab2.font = [UIFont systemFontOfSize:W(12)];
    _signLab2.textAlignment = NSTextAlignmentCenter;
    _signLab2.textColor = [UIColor colorWithHexString:@"ff5000"];
    [_signBtn addSubview:_signLab2];
//    [button.layer addAnimation:[self rotation:2 degree:kRadianToDegrees(90) direction:1 repeatCount:MAXFLOAT] forKey:nil];
    
    
//    __weak typeof(self) weakSelf = self;
//    [UIView animateWithDuration:8 delay:0.0f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn animations:^{
//        [weakSelf.signBtn.layer setTransform:CATransform3DMakeRotation(M_PI, 0, 1, 0)];
//        weakSelf.signLab.text = @"签到";
//    } completion:^(BOOL finished) {
//    }];
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = 5;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = 1;
//    
//    [_signBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    float a54 = 54.0/1334.0;
    UILabel *pointLab = [[UILabel alloc]initWithFrame:CGRectMake(0, backgroundImageView.frame.size.height - a54*Height, Width, 12)];
    pointLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    pointLab.textAlignment = NSTextAlignmentCenter;
    pointLab.font = [UIFont systemFontOfSize:W(12)];
    pointLab.text = @"100积分=1元，购物可抵现金;也可去积分商城兑换商品";
    [backgroundImageView addSubview:pointLab];
   
    //用户层view
    float aX24 = 24.0/750.0;
    float aY24 = 24.0/1334.0;
    float aW60 = 60.0/750.0;
    float aH116 = 116.0/1334.0;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,  aH400*Height+64, Width, aH116*Height)];

    //用户的logo
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(aX24*Width, aY24*Height, aW60*Width, aW60*Width)];
    imgView.image = [UIImage imageNamed:@"comment_user_photo"];
    
    [headView addSubview:imgView];
    //用户名
    UILabel *userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width+imgView.frame.origin.x+aX24*Width, aY24*Height, 150, 14)];
    userNameLab.text = @"用户名";
    userNameLab.font = [UIFont systemFontOfSize:W(15)];
    userNameLab.textColor = [UIColor colorWithHexString:@"#43464d"];
    [headView addSubview:userNameLab];
    //积分
    UIImageView *integralImageView = [[UIImageView alloc]initWithFrame:CGRectMake(userNameLab.frame.origin.x, userNameLab.frame.size.height+userNameLab.frame.origin.y+H(6), W(20), H(13))];
    integralImageView.image = [UIImage imageNamed:@"gold"];
    [headView addSubview:integralImageView];
    
    _integralLab = [[UILabel alloc]initWithFrame:CGRectMake(integralImageView.frame.size.width+integralImageView.frame.origin.x+W(6), integralImageView.frame.origin.y, 100, 15)];
    _integralLab.font = [UIFont systemFontOfSize:W(15)];
    _integralLab.textColor = [UIColor colorWithHexString:@"#ff9402"];
    [headView addSubview:_integralLab];
    NSString *string = [NSString stringWithFormat:@"%@积分",self.integrationStr];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSUInteger a = [[attributStr string] rangeOfString:@"积"].location ;

    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:W(14)] range:NSMakeRange(0, a)];
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:W(10)] range:NSMakeRange(a, 2)];
    _integralLab.attributedText = attributStr;
    
    
    //积分商城
    UIButton *shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopBtn.frame = CGRectMake(Width - W(87), H(12), W(75), H(27));
    [shopBtn setTitle:@"积分商城" forState:UIControlStateNormal];
    [shopBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
    shopBtn.titleLabel.font = [UIFont systemFontOfSize:W(12)];
    shopBtn.layer.cornerRadius = 3;
    [shopBtn addTarget:self action:@selector(pushToShop) forControlEvents:UIControlEventTouchUpInside];
    shopBtn.layer.masksToBounds = YES;
    shopBtn.layer.borderWidth = 0.5f;
    shopBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
    [headView addSubview:shopBtn];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, headView.frame.size.height-1, Width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [headView addSubview:viewLine];
    
    
    
    [self.view addSubview:headView];
    
    //积分明细
    UIView *detailedView = [[UIView alloc]initWithFrame:CGRectMake(0, headView.frame.origin.y+headView.frame.size.height+H(12), Width, H(46))];
    
    UILabel *detailedLab = [[UILabel alloc]initWithFrame:CGRectMake(W(12), detailedView.frame.size.height/2.0-H(14), 100, H(15))];
    detailedLab.text = @"积分明细";
    detailedLab.font = [UIFont systemFontOfSize:W(15)];
    detailedLab.textColor = [UIColor colorWithHexString:@"#43464d"];
    [detailedView addSubview:detailedLab];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(W(12), detailedView.frame.size.height-1, Width-W(12), 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [detailedView addSubview:line];
    [self.view addSubview:detailedView];
#pragma mark -- table
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, detailedView.frame.origin.y+detailedView.frame.size.height, Width, Height- detailedView.frame.origin.y-detailedView.frame.size.height) style:UITableViewStylePlain];
    _tableView.allowsSelection = NO;
    //    tableView.backgroundColor = [UIColor redColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
#pragma mark -- null
    _nullView = [[UIView alloc]initWithFrame:CGRectMake(0, detailedView.frame.origin.y+detailedView.frame.size.height, Width, Height- detailedView.frame.origin.y-detailedView.frame.size.height)];
    _nullView.hidden = YES;
    UIImageView *nullImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_nullView.center.x - W(60)/2.0, W(60),W(60), W(60))];
    nullImgView.image = [UIImage imageNamed:@"my_collection_null_data"];
    [_nullView addSubview:nullImgView];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, nullImgView.frame.origin.y+nullImgView.frame.size.height+18, Width, 16)];
    lab.text = @"暂无积分记录";
    lab.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textAlignment = NSTextAlignmentCenter;
    [_nullView addSubview:lab];
    
    [self.view addSubview:_nullView];
    
    
}
//跳转积分商城
-(void)pushToShop{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url1 = data[@"firstUrl"];
    NSString *newUrl = [NSString stringWithFormat:@"%@exchange.php",url1];
    BrandViewController *brandVC = [BrandViewController new];
    brandVC.url = newUrl;
    brandVC.type = @"exchange";
    [self.navigationController pushViewController:brandVC animated:YES];
}

//签到
-(void)signAction:(signButton*)button{
    
    if ([self.qd isEqualToString:@"0"]) {
        [self buttonAnimation:button];
    }

}

- (CAAnimation *) animationRotate {
    CATransform3D rotationTransform  = CATransform3DMakeRotation( M_PI , 0 , 1 , 0 );
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration = 0.5;
    animation.autoreverses = YES;
    animation.cumulative = YES;
    animation.repeatCount = 1;
//    animation.beginTime = 0.1;
    animation.delegate = self;
    
    return animation;
}

- (void)buttonAnimation:(signButton *) sender{
    signButton *theButton = sender;
  
    CAAnimation *myAnimationRotate = [self animationRotate];
    CAAnimationGroup* m_pGroupAnimation;
    m_pGroupAnimation = [CAAnimationGroup animation];
    m_pGroupAnimation.delegate = self;
    m_pGroupAnimation.removedOnCompletion = NO;
    m_pGroupAnimation.duration = 1;
    m_pGroupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    m_pGroupAnimation.repeatCount = 1;
    m_pGroupAnimation.fillMode = kCAFillModeForwards;
    m_pGroupAnimation.animations = [NSArray arrayWithObjects:myAnimationRotate, nil];
    [theButton.layer addAnimation:m_pGroupAnimation forKey:@"animationRotate"];
}
-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"开始了");
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //方法中的flag参数表明了动画是自然结束还是被打断,比如调用了removeAnimationForKey:方法或removeAnimationForKey方法，flag为NO，如果是正常结束，flag为YES。
    NSLog(@"结束了");
    NSString *api_token = [RequestModel model:@"attendance" action:@"qiandao"];
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"]};
    
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"attendance" action:@"qiandao" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
        if ([code isEqualToString:@"1"]) {
            weakSelf.signLab.text = @"已签到";
            weakSelf.signLab2.text = [NSString stringWithFormat:@"+%@积分",weakSelf.points];
            int aint = [weakSelf.integrationStr integerValue];
            int bint = [weakSelf.points integerValue];
            int cint = aint+bint;
            NSString *string = [NSString stringWithFormat:@"%d积分",cint];
            NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
            NSUInteger a = [[attributStr string] rangeOfString:@"积"].location ;
            
            [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:W(14)] range:NSMakeRange(0, a)];
            [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:W(10)] range:NSMakeRange(a, 2)];
            weakSelf.integralLab.attributedText = attributStr;
            [weakSelf myAccount];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:dic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
//    _signLab.text = @"已签到";
    
   
}

#pragma mark ====旋转动画======

-(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount

{
    
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    
    animation.duration  =  dur;
    
    animation.autoreverses = NO;
    
    animation.cumulative = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    animation.repeatCount = repeatCount;
    
    animation.delegate = self;
    
    
    
    return animation;
    
    
    
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
#pragma mark --tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myMuArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellid=@"myIntegralTableViewCell";
    
    myIntegralTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[myIntegralTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    IntegralModel *model = self.myMuArray[indexPath.row];
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return H(69);
}


#pragma mark --积分明细请求

-(void)myAccount{
    NSString *api_token = [RequestModel model:@"attendance" action:@"index"];
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"]};
    __weak typeof(self) weakSelf = self;
    [_myMuArray removeAllObjects];
    [RequestModel requestWithDictionary:dict model:@"attendance" action:@"index" block:^(id result) {
        NSArray *array = result[@"data"][@"record"];
        for (NSMutableDictionary *dataDic in array) {
            NSLog(@"%@",dataDic);
            IntegralModel *model = [IntegralModel new];
            model.integralFrom = dataDic[@"from"];
            model.userID = dataDic[@"userid"];
            model.name = dataDic[@"name"];
            model.points = dataDic[@"points"];
            model.state = dataDic[@"state"];
            model.time = dataDic[@"time"];
            [weakSelf.myMuArray addObject:model];
        }
        NSLog(@"%@",weakSelf.myMuArray);
        [weakSelf.tableView reloadData];
        
    }];
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
    label.text = @"我的积分";
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
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0,view.frame.size.height-1 , self.view.frame.size.width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
    
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
