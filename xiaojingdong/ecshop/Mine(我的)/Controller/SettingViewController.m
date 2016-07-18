//
//  SettingViewController.m
//  ecshop
//
//  Created by Jin on 15/12/7.
//  Copyright © 2015年 jsyh. All rights reserved.
//设置

#import "SettingViewController.h"
#import "SettingViewCell.h"
#import "SDImageCache.h"
#import "AboutViewController.h"
#import "UIColor+Hex.h"
#import "MineTableViewCell.h"
#import "MyAccountViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "OpinionViewController.h"
#define kWIDTH [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height
#define kColorBack [UIColor colorWithHexString:@"#f2f2f2"]
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIButton *backBtn;
@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    if (_backBtn) {
        if (app.tempDic == nil) {
            _backBtn.hidden = YES;
        }else{
            _backBtn.hidden = NO;
        }
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self draw];
    [self initNavigationBar];
    self.view.backgroundColor = kColorBack;
    // Do any additional setup after loading the view.
}
-(void)draw{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, kWIDTH - 50) style:UITableViewStyleGrouped];
   
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = kColorBack;
    _tableview.scrollEnabled = NO;
    
    [self.view addSubview:_tableview];
  
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
    
    _backBtn.frame = CGRectMake(0, kHEIGHT-50, kWIDTH, 50) ;
    [_backBtn setTitle:@"退出当前账户" forState:UIControlStateNormal];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_backBtn addTarget:self action:@selector(backLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];

}
#pragma mark --退出登录
-(void)backLoginAction{
    //退出
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"您确定要退出吗？"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#pragma mark --注册通知各页已经退出
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"quite" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
//        weakSelf.tabBarController.tabBar.hidden=YES;
//        MyTabBarViewController * tabbar =(MyTabBarViewController *)weakSelf.navigationController.tabBarController;
//        [tabbar hiddenTabbar:NO];

        
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }else{
        return 1;
    }
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 1) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, 20)];
//        view.backgroundColor = kColorBack;
//        
//        return view;
//    }else if(section == 0){
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, 20)];
//        view.backgroundColor = kColorBack;
//        
//        return view;
//    }else{
//        return nil;
//    }
//    
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:self options:nil]lastObject];
    }
    if (indexPath.section == 0) {
        
        cell.lab.text = @"个人资料";
        cell.img.image = [UIImage imageNamed:@"mine_setting_person_info"];
        cell.lab2.text = @"";
//        cell.textLabel.text = @"关于我们";
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.detailTextLabel.text = @"V1.01";
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        
    }else if(indexPath.section == 1){
        
        if (indexPath.row == 0) {
            cell.lab.text = @"帮助与反馈";
            cell.img.image = [UIImage imageNamed:@"personal_help"];
            cell.lab2.text = @"";
        }else if(indexPath.row == 1){
            cell.lab.text = @"关于";
            cell.img.image = [UIImage imageNamed:@"personal_about"];
            cell.lab2.text = @"";
        }
        
        
    }else if (indexPath.section == 2){
        cell.lab.text = @"清除本地缓存";
        cell.img.image = [UIImage imageNamed:@"mine_setting_clear"];
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 0, kWIDTH, cell.frame.size.height);
        [but addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:but];
        but.backgroundColor = [UIColor clearColor];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        
        NSString *path = [paths lastObject];
        
        
        
        NSString *str = [NSString stringWithFormat:@"缓存%.1fM", [self folderSizeAtPath:path]];
        cell.lab2.text = str;
        cell.lab2.frame = CGRectMake(kWIDTH - 124, 15, 100, 15);
        cell.lab2.font = [UIFont systemFontOfSize:15];
//        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    
    if (indexPath.section == 0) {
        if (app.tempDic == nil) {
            LoginViewController *loginVC = [LoginViewController new];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            MyAccountViewController *accountVC = [MyAccountViewController new];
            [self.navigationController pushViewController:accountVC animated:YES];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            NSLog(@"帮助与反馈");
            OpinionViewController *opinVC = [OpinionViewController new];
            [self.navigationController pushViewController:opinVC animated:YES];
            
       
        }else{
            AboutViewController *aboutView = [AboutViewController new];
            [self.navigationController pushViewController:aboutView animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -缓存


- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
}

//遍历文件夹获得文件夹大小，返回多少M

- (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}
- (void)action:(UIButton *)sender

{
    
   
    //彻底清除缓存第一种方法
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"确定要清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIButton * button = sender;
        
        [button setTitle:@"清理完毕" forState:UIControlStateNormal];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        
        NSString *path = [paths lastObject];
        
        
        
        NSString *str = [NSString stringWithFormat:@"缓存已清除%.1fM", [weakSelf folderSizeAtPath:path]];
        
        NSLog(@"%@",str);
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
        
        for (NSString *p in files) {
            
            NSError *error;
            
            NSString *Path = [path stringByAppendingPathComponent:p];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                
                [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
                
            }
            
        }
         [weakSelf.tableview reloadData];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
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
    label.text = @"设置";
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
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0,view.frame.size.height-1 , kWIDTH, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
    
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
