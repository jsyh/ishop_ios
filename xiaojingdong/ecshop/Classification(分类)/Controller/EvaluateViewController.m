//
//  EvaluateViewController.m
//  ecshop
//
//  Created by Jin on 16/4/5.
//  Copyright © 2016年 jsyh. All rights reserved.
//评价页面

#import "EvaluateViewController.h"
#import "UIColor+Hex.h"
#import "EvaluateViewTableViewCell.h"
#import "RequestModel.h"
#import "AppDelegate.h"
#import "CommentModel.h"
#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height
@interface EvaluateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView *navView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *allEvaluateBtn;//全部评价
@property (nonatomic,strong)UIButton *goodEvaluateBtn;//好评
@property (nonatomic,strong)UIButton *midEvaluateBtn;//中评
@property (nonatomic,strong)UIButton *badEvaluateBtn;//差评
@property (nonatomic,strong)NSMutableArray *goodArray;//好评数组
@property (nonatomic,strong)NSMutableArray *midArray;//中评数组
@property (nonatomic,strong)NSMutableArray *badArray;//差评数组
@property (nonatomic,strong)NSMutableArray *loadArray;//放在table中加载的数组
@property (nonatomic,strong)UIView *nullView;
@end

@implementation EvaluateViewController
-(NSMutableArray *)goodArray{
    if (!_goodArray) {
        _goodArray = [[NSMutableArray alloc]init];
    }
    return _goodArray;
}
-(NSMutableArray *)midArray{
    if (!_midArray) {
        _midArray = [[NSMutableArray alloc]init];
    }
    return _midArray;
}
-(NSMutableArray *)badArray{
    if (!_badArray) {
        _badArray = [[NSMutableArray alloc]init];
    }
    return _badArray;
}
-(NSMutableArray *)loadArray{
    if (!_loadArray) {
        _loadArray = [[NSMutableArray alloc]init];
    }
    return _loadArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    [self creatUI];
    [self nullDataView];
    self.loadArray = [_allEvaluateArray mutableCopy];
    for (CommentModel *model in _allEvaluateArray) {
        if ([model.rank isEqualToString:@"5"]) {
            [self.goodArray addObject:model];
        }else if ([model.rank isEqualToString:@"3"]){
            [self.midArray addObject:model];
        }else if ([model.rank isEqualToString:@"1"]){
            [self.badArray addObject:model];
        }
        
    }
    NSLog(@"%@",self.goodArray);

    
    // Do any additional setup after loading the view.
}
#pragma mark --绘制tableView
-(void)creatUI{
    //创建头视图
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 45)];
    headView.opaque = YES;
    float widthLab = (kWidth-60)/4;
    //nav下的那条线
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    view.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [headView addSubview:view];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, headView.frame.size.height-1, kWidth, 1)];
    view2.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [headView addSubview:view2];
    _allEvaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allEvaluateBtn.frame = CGRectMake(12, 12, widthLab, 21);
    _allEvaluateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _allEvaluateBtn.backgroundColor = [UIColor colorWithHexString:@"#FFECE5"];
    _allEvaluateBtn.layer.cornerRadius = 8;
    _allEvaluateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    int arrCount = (int)_allEvaluateArray.count;
    NSString *all = [NSString stringWithFormat:@"全部(%d)",arrCount];
    [_allEvaluateBtn setTitle:all forState:UIControlStateNormal];
    [_allEvaluateBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    _allEvaluateBtn.layer.masksToBounds = YES;
    [_allEvaluateBtn addTarget:self action:@selector(allEvaluateAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_allEvaluateBtn];
    
    _goodEvaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   _goodEvaluateBtn.frame = CGRectMake(12+_allEvaluateBtn.frame.size.width +_allEvaluateBtn.frame.origin.x, 12, widthLab, 21);
    _goodEvaluateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _goodEvaluateBtn.backgroundColor = [UIColor colorWithHexString:@"#FFECE5"];
    [_goodEvaluateBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    _goodEvaluateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _goodEvaluateBtn.layer.cornerRadius = 8;
    [_goodEvaluateBtn addTarget:self action:@selector(goodEvaluateAction) forControlEvents:UIControlEventTouchUpInside];
    NSString *good = [NSString stringWithFormat:@"好评(%@)",_goodEvaluate];
    [_goodEvaluateBtn setTitle:good forState:UIControlStateNormal];
    _goodEvaluateBtn.layer.masksToBounds = YES;
    [headView addSubview:_goodEvaluateBtn];
    
    _midEvaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _midEvaluateBtn.frame = CGRectMake(12+_goodEvaluateBtn.frame.size.width +_goodEvaluateBtn.frame.origin.x, 12, widthLab, 21);
    [_midEvaluateBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    _midEvaluateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _midEvaluateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _midEvaluateBtn.backgroundColor = [UIColor colorWithHexString:@"#FFECE5"];
    _midEvaluateBtn.layer.cornerRadius = 8;
    NSString *mid = [NSString stringWithFormat:@"中评(%@)",_midEvaluate];
    [_midEvaluateBtn setTitle:mid forState:UIControlStateNormal];
    _midEvaluateBtn.layer.masksToBounds = YES;
    [_midEvaluateBtn addTarget:self action:@selector(midEvaluateAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_midEvaluateBtn];
    
    _badEvaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _badEvaluateBtn.frame = CGRectMake(12+_midEvaluateBtn.frame.size.width +_midEvaluateBtn.frame.origin.x, 12, widthLab, 21);
    _badEvaluateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_badEvaluateBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    _badEvaluateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _badEvaluateBtn.backgroundColor = [UIColor colorWithHexString:@"#FFECE5"];
    _badEvaluateBtn.layer.cornerRadius = 8;
    [_badEvaluateBtn addTarget:self action:@selector(badEvaluateAction) forControlEvents:UIControlEventTouchUpInside];
    NSString *bad = [NSString stringWithFormat:@"差评(%@)",_badEvaluate];
    [_badEvaluateBtn setTitle:bad forState:UIControlStateNormal];
    _badEvaluateBtn.layer.masksToBounds = YES;
    [headView addSubview:_badEvaluateBtn];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    _tableView.tableHeaderView = headView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
//全部评价
-(void)allEvaluateAction{
    [self.loadArray removeAllObjects];
    self.loadArray = [_allEvaluateArray mutableCopy];
    [self.tableView reloadData];
    if (self.loadArray.count == 0) {
        _nullView.hidden = NO;
    }else{
         _nullView.hidden = YES;
    }
    
}
//好评
-(void)goodEvaluateAction{
    [self.loadArray removeAllObjects];
    self.loadArray = [self.goodArray mutableCopy];
     [self.tableView reloadData];
    if (self.loadArray.count == 0) {
        _nullView.hidden = NO;
    }else{
        _nullView.hidden = YES;
    }
}
//中评
-(void)midEvaluateAction{
    [self.loadArray removeAllObjects];
    self.loadArray = [self.midArray mutableCopy];
     [self.tableView reloadData];
    if (self.loadArray.count == 0) {
        _nullView.hidden = NO;
    }else{
        _nullView.hidden = YES;
    }
}
//差评
-(void)badEvaluateAction{
    [self.loadArray removeAllObjects];
    self.loadArray = [self.badArray mutableCopy];
     [self.tableView reloadData];
    if (self.loadArray.count == 0) {
        _nullView.hidden = NO;
    }else{
        _nullView.hidden = YES;
    }
}
-(void)nullDataView{
    _nullView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+45, kWidth, kHeight - 64-45)];
    _nullView.hidden = YES;
    float aY336 = 336.0/1334.0;
    float aW172 = 172.0/750.0;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - aW172*kWidth/2, aY336*kHeight, aW172*kWidth, aW172*kWidth)];
    imgView.image = [UIImage imageNamed:@"seachGoods_null"];
    [_nullView addSubview:imgView];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+18, kWidth, 16)];
    lab.text = @"暂无评论";
    lab.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textAlignment = NSTextAlignmentCenter;
    [_nullView addSubview:lab];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+12, kWidth, 13)];
    lab2.text = @"暂时没有相关数据";
    lab2.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab2.font = [UIFont systemFontOfSize:13];
    lab2.textAlignment = NSTextAlignmentCenter;
    [_nullView addSubview:lab2];
    [self.view addSubview:_nullView];
}
#pragma mark --tableViewdelegate和tableViewdataSoure
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.loadArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return 130;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string=@"EvaluateViewTableViewCell";
    EvaluateViewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:string];
    if (cell==nil) {
        cell=[[EvaluateViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }


    CommentModel *model;
    model = self.loadArray[indexPath.row];
    cell.userNameLab.text = model.contentName;
    cell.contentLab.text = model.content;
//    [cell.contentLab fsizeToFit];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    int time = [model.time intValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSString *timeDate = [formatter stringFromDate:date];
    cell.timeLab.text = timeDate;
    NSString *str = [NSString stringWithFormat:@"%@",model.gmjl];
    str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
    cell.goodsPropertyLab.text = str;
//    [cell.timeLab sizeToFit];
//    [cell.goodsPropertyLab sizeToFit];
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    
    labelTitle.text = @"评价";
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
