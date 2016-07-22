//
//  ChooseAddressViewController.m
//  ecshop
//
//  Created by Jin on 15/12/22.
//  Copyright © 2015年 jsyh. All rights reserved.
//选择地址

#import "ChooseAddressViewController.h"
#import "AddressViewCell.h"
#import "RequestModel.h"
#import "MyAddressModel.h"
#import "UIColor+Hex.h"
@interface ChooseAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *modArray;
@property(nonatomic,strong)MyAddressModel *model;
@property(nonatomic,strong)NSString *iderstr;
@property(nonatomic,strong)NSString *addressName;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *proId;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,strong)NSString *areaId;
@end

@implementation ChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self draw];
    [self initNavigationBar];
    self.iderstr = nil;
    self.iderstr = @"1";
    [self myProvince:@"province" ider:self.iderstr];
    // Do any additional setup after loading the view.
}
-(void)draw{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(void)myProvince:(NSString *)actionstr ider:(NSString*)ider{
    NSString *api_token = [RequestModel model:@"order" action:actionstr];
    NSDictionary *dict = @{@"api_token":api_token,@"region_id":ider};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"order" action:actionstr block:^(id result) {
        NSDictionary *dic = result;
        weakSelf.modArray = nil;
        weakSelf.modArray = [[NSMutableArray alloc]init];
        for (NSMutableDictionary *dict in dic[@"data"]) {
            weakSelf.model = [MyAddressModel new];
            
            weakSelf.model.region_id = dict[@"region_id"];
            weakSelf.model.region_name = dict[@"region_name"];
            
            
            
            
            [weakSelf.modArray addObject:weakSelf.model];
            
        }
        if (weakSelf.modArray.count == 0) {
            
            if (weakSelf.returnTextBlock != nil) {
                //                self.returnTextBlock(self.province,self.city,nil);
                weakSelf.returnTextBlock(weakSelf.province,weakSelf.city,weakSelf.area,weakSelf.proId,weakSelf.cityId,weakSelf.areaId);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
        [weakSelf.tableView reloadData];
        if ([weakSelf.iderstr isEqualToString:@"1"]) {
            weakSelf.iderstr = @"2";
        }else if([weakSelf.iderstr isEqualToString:@"2"]){
            weakSelf.iderstr = @"3";
        }else if([weakSelf.iderstr isEqualToString:@"3"]){
            weakSelf.iderstr = @"4";
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _modArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"cell";
    AddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressViewCell" owner:self options:nil]lastObject];
    }
    cell.model = self.modArray[indexPath.row];
    //    cell.textLabel.text = _model.region_name;
    //    cell.lab.hidden = YES;
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAddressModel *model = self.modArray[indexPath.row];
    
    if ([self.iderstr isEqualToString:@"2"]&&self.modArray.count!=0) {
        self.province = model.region_name;
        self.proId = model.region_id ;
        [self myProvince:@"city" ider:model.region_id];
        
        
    }else if([self.iderstr isEqualToString:@"3"]&&self.modArray.count!=0){
        self.city = model.region_name;
        self.cityId = model.region_id ;
        [self myProvince:@"area" ider:model.region_id];
        
    }else{
        self.area = model.region_name;
        self.areaId = model.region_id ;
        if (self.returnTextBlock != nil) {
            self.returnTextBlock(self.province,self.city,self.area,self.proId,self.cityId,self.areaId);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
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
    label.text = @"选择地址";
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
