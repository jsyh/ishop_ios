//
//  MyAccountViewController.m
//  ecshop
//
//  Created by Jin on 15/12/9.
//  Copyright © 2015年 jsyh. All rights reserved.
//我的账户

#import "MyAccountViewController.h"
#import "MyAccountViewCell.h"
#import "SettingViewCell.h"
#import "ChangePasswordViewController.h"
#import "RequestModel.h"
#import "PersonalInfoModel.h"
#import "AppDelegate.h"
#import "PersonViewController.h"
#import "UIColor+Hex.h"
#define kWIDTH [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
@interface MyAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray *modArray;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)PersonalInfoModel *model;
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)UIView *shadowView;
@property (nonatomic,strong)UIButton *cancleBtn;
@property (nonatomic,strong)NSString *sex1;
@property (nonatomic,strong)UIImage *image1;
@end

@implementation MyAccountViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self myAccount];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self draw];
    [self myAccount];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}
-(void)myAccount{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"user" action:@"userinfo"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"]};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"userinfo" block:^(id result) {
        NSLog(@"111");
        NSDictionary *dic = result;
        weakSelf.modArray = [[NSMutableArray alloc]init];
        for (NSMutableDictionary *dict in dic[@"data"]) {
            weakSelf.model = [PersonalInfoModel new];
            
            weakSelf.model.user_id = dict[@"user_id"];//缺少
            weakSelf.model.nick_name = dict[@"nick_name"];
            weakSelf.model.sex = dict[@"sex"];
            weakSelf.model.address = dict[@"address"];
            weakSelf.model.mobile = dict[@"mobile"];
            weakSelf.model.integration = dict[@"integration"];
            weakSelf.model.attention = dict[@"attention"];
            //birthday
            weakSelf.model.birthday = dict[@"birthday"];
            weakSelf.model.email = dict[@"email"];
            
            [weakSelf.modArray addObject:weakSelf.model];
            
        }
        
        
        [weakSelf.tableview reloadData];
    }];
}
-(void)draw{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kWIDTH, kHEIGHT) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
//    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableview.tableFooterView = [[UIView alloc]init];
    _tableview.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:_tableview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 4) {
//        return 20;
//    }else if (section == 3)
//    {
//        return 0.00000000000001;
//    }
//    else{
//        return 0.0000000000000000001;
//    }
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
    
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, 1)];
//    view.backgroundColor = kColorBack;
//    return view;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *string = @"MyAccountViewCell";
        MyAccountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyAccountViewCell" owner:self options:nil]lastObject];
        }
        cell.titleLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
        NSLog(@"imageFile->>%@",imageFilePath);
        UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//
        if (selfPhoto != nil) {
            cell.imgView.image = selfPhoto;
            [cell.imgView.layer setCornerRadius:17];
            cell.imgView.layer.masksToBounds = YES;
        }else{
            cell.imgView.image = [UIImage imageNamed:@"personal_info_change_photo"];
            [cell.imgView.layer setCornerRadius:17];
            cell.imgView.layer.masksToBounds = YES;
        }
        
        cell.imgView.backgroundColor = [UIColor clearColor];
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(12, cell.frame.size.height-1, kWIDTH-12, 1)];
        bgview.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        [cell addSubview:bgview];
        return cell;
    }else{
        static NSString *string = @"SettingViewCell";
        SettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingViewCell" owner:self options:nil]lastObject];
        }
        cell.propertyBtn.hidden = YES;
      cell.titleLab.font = [UIFont systemFontOfSize:15];
        cell.titleLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        if (indexPath.section == 1) {
            cell.titleLab.text = @"昵称";
            
//            cell.titleLab.textColor = [UIColor colorWithHexString:@"#434564c"];
            cell.detailLab.text = self.model.nick_name;
            cell.detailLab.frame = CGRectMake(kWIDTH - 24, 15, 40, 15);
            cell.detailLab.font = [UIFont systemFontOfSize:15];
            cell.detailLab.textColor = [UIColor colorWithHexString:@"#999999"];
//            cell.focusStyle = UITableViewCellFocusStyleDefault;
//            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.backView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
            cell.backView.frame = CGRectMake(12, 45, kWIDTH-12, 1);
        }else if(indexPath.section == 2){
            cell.titleLab.text = @"用户名";
            cell.detailLab.text = self.model.mobile;
            cell.detailLab.frame = CGRectMake(kWIDTH - 24, 15, 40, 15);
            cell.detailLab.font = [UIFont systemFontOfSize:15];
            cell.detailLab.textColor = [UIColor colorWithHexString:@"#999999"];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.backView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
            cell.backView.frame = CGRectMake(12, 45, kWIDTH-12, 1);
        }else if(indexPath.section == 3){
            cell.titleLab.text = @"性别";
            NSString *sex = [NSString stringWithFormat:@"%@",self.model.sex];
            
            if ([sex isEqualToString:@"0"]) {
                _sex1 = @"男";
            }else if([sex isEqualToString:@"1"]){
                _sex1 = @"女";
            }else{
                _sex1 = @"保密";
            }
            cell.detailLab.text = _sex1;
            cell.detailLab.frame = CGRectMake(kWIDTH - 24, 15, 40, 15);
            cell.detailLab.font = [UIFont systemFontOfSize:15];
            cell.detailLab.textColor = [UIColor colorWithHexString:@"#999999"];
            cell.backView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
            cell.backView.frame = CGRectMake(12, 45, kWIDTH-12, 1);
        }else if(indexPath.section == 4){
            cell.titleLab.text = @"出生日期";
            cell.detailLab.text =self.model.birthday;
            cell.detailLab.frame = CGRectMake(kWIDTH - 24, 15, 40, 15);
            cell.detailLab.font = [UIFont systemFontOfSize:15];
            cell.detailLab.textColor = [UIColor colorWithHexString:@"#999999"];
            cell.backView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
            cell.backView.frame = CGRectMake(12, 45, kWIDTH-12, 1);
        }else{
            cell.titleLab.text = @"修改密码";
            cell.titleLab.font = [UIFont systemFontOfSize:15];
            cell.backView.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
            cell.backView.frame = CGRectMake(0, 45, kWIDTH, 1);
            cell.detailLab.text = @"";
            
        }

        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 5) {
        ChangePasswordViewController *changePassVC = [ChangePasswordViewController new];
        changePassVC.tempDic = self.tempDic;
        [self.navigationController pushViewController:changePassVC animated:YES];
    }else if(indexPath.section == 3){
        UIActionSheet *menu = [[UIActionSheet alloc]initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",@"保密", nil];
        menu.tag = 30000;
        menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [menu showInView:self.view];
//        PersonViewController *personVC = [PersonViewController new];
//        [personVC returnText:^(NSString *showText) {
//            if ([showText isEqualToString:@"男"]) {
//                self.model.sex = @"0";
//            }else if ([showText isEqualToString:@"女"]){
//                self.model.sex = @"1";
//            }else{
//                self.model.sex = @"2";
//            }
//            
//            [self.tableview reloadData];
//        }];
//        [self.navigationController pushViewController:personVC animated:YES];
    }else if (indexPath.section == 4){
        //选择日期
        [self myData];
    }else if (indexPath.section == 0){
        //上传头像
        UIActionSheet *menu = [[UIActionSheet alloc]initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册上传", nil];
        menu.tag = 30001;
        menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [menu showInView:self.view];
    }else if (indexPath.section == 1){
        PersonViewController *personVC = [PersonViewController new];
        [self.navigationController pushViewController:personVC animated:YES];
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
//时间选择器
-(void)myData{
    self.shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.shadowView.backgroundColor = [UIColor blackColor];
    self.shadowView.alpha = 0.2;
    [self.view addSubview:self.shadowView];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kHEIGHT - 300, self.view.frame.size.width, 216)];
    self.datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
   [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [self.datePicker setDate:[NSDate date] animated:YES];
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.view addSubview:self.datePicker];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.frame = CGRectMake(20, _datePicker.frame.size.height+_datePicker.frame.origin.y+12, self.view.frame.size.width - 40, 40);
    [_cancleBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cancleBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_cancleBtn];
    
}
-(void)dateChanged:(id)sender
{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate *date = control.date;
    NSLog(@"%@",date);
    NSString *str = [NSString stringWithFormat:@"%@",date];
    NSString *str1 = [str substringToIndex:10];
    NSLog(@"%@",str1);
    self.model.birthday = str1;
    [self.tableview reloadData];
    //    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:@"时间选择器" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"请选择日期", nil];
    //    [actionsheet showInView:self.view];
}
-(void)sureAction:(id)sender{
    [self saveInfo];
    [self.datePicker removeFromSuperview];
    [self.cancleBtn removeFromSuperview];
    [self.shadowView removeFromSuperview];
}
#pragma mark -- 保存个人信息
-(void)saveInfo{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"User" action:@"modifyUser"];
    NSString *path = [NSString stringWithFormat:@"%@",self.model.sex];
    
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"sex":path,@"birthday":self.model.birthday};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"User" action:@"modifyUser" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"获得的数据：%@",dic);
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [weakSelf presentViewController:alertVC animated:YES completion:nil];
    }];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 30000) {
        if (buttonIndex == 0) {
            
           self.model.sex = @"0";
        }else if (buttonIndex == 1){
           self.model.sex = @"1";
            
        }else if(buttonIndex == 2){
            self.model.sex = @"2";
        }
        [self saveInfo];
        [self.tableview reloadData];
    }else if(actionSheet.tag == 30001){
        if (buttonIndex == 0) {
            [self snapImage];
            
        }else if (buttonIndex == 1){
            [self pickImage];
            
        }
    }
   
}
//拍照
-(void)snapImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
    ipc.delegate=self;
    ipc.allowsEditing=YES;
    [self presentViewController:ipc animated:YES completion:nil];
}
//从相册里找
-(void)pickImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate=self;
    ipc.allowsEditing=YES;
    //    [self presentModalViewController:ipc animated:YES];
    [self presentViewController:ipc animated:YES completion:nil];
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    //    UIImage *img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:) withObject:img afterDelay:0.5];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}



- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
//    BOOL success;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
//    success = [fileManager fileExistsAtPath:imageFilePath];
//    if(success) {
//        success = [fileManager removeItemAtPath:imageFilePath error:&error];
//    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(80, 80)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    //    self.img.image = selfPhoto;
    self.image1 = selfPhoto;
    [self.tableview reloadData];
}
// 改变图像的尺寸，方便上传服务器

- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size

{
    
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}




//2.保持原来的长宽比，生成一个缩略图

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        }
        
        else{
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
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
    
    label.text = @"个人资料";
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:titleFont];
    label.textColor = [UIColor colorWithHexString:naiigationTitleColor];
    [view addSubview:label];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"确定" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
//    button.frame = CGRectMake(self.view.frame.size.width - 50, 15, 50, 50);
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [view addSubview:button];
    
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
