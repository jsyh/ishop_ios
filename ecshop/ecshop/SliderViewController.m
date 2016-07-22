//
//  SliderViewController.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/7.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "SliderViewController.h"
#import "SearchListViewController.h"
#import "RequestModel.h"
#import "JSONKit.h"
@interface SliderViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView * tableviewNew;
    UIButton * freeBtn1;
    UIButton * freeBtn2;
    UIButton * saleBtn1;
    UIButton * saleBtn2;
    NSString * str;
    NSMutableArray * fieldArr;
    UITextField * field1;
    UITextField * field2;
    NSString * free;//是否免费
    NSString * promoting;//是否促销
    NSString * classID;//选中的table所在分类的id号
   // BOOL hide;//是否隐藏
    NSIndexPath *selectedIndexPath;//记录行号
}
@property (nonatomic, strong) NSMutableArray *datasource;
@property(nonatomic,retain)NSIndexPath *selectedIndexPath;//记录行号
@end

@implementation SliderViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.hidden=NO;
    [self creatUI];
    [self reloadInfoRequest];
    self.contentView.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    _datasource=[[NSMutableArray alloc]init];
    fieldArr=[[NSMutableArray alloc]init];
    
}
#pragma mark-请求数据
-(void)reloadInfoRequest
{
    if (self.myType==NULL) {
        self.myType=@"";
    }

    NSString *api_token = [RequestModel model:@"First" action:@"index"];
    NSDictionary *dict = @{@"api_token":[NSString stringWithFormat:@"%@",api_token],@"type":@"fitrate",@"keyword":self.rightLab,@"goods_type":self.myType};
    [RequestModel requestWithDictionary:dict model:@"First" action:@"index" block:^(id result) {
        [self sendMessage:result];
    }];
}
-(void)sendMessage:(id)message
{
    NSDictionary * dic1=[[NSDictionary alloc]init];
    dic1=message[@"data"];
    [_datasource addObjectsFromArray:dic1[@"classify"]];
    //获得最高价和最低价
    str=dic1[@"price_range"];
    //分割价格字符串
    [fieldArr removeAllObjects];
    NSArray *array1=[str componentsSeparatedByString:@"-"];
    [fieldArr  addObjectsFromArray:array1];
    field1.placeholder=[NSString stringWithFormat:@"最低价%@",fieldArr[1]];
    field2.placeholder=[NSString stringWithFormat:@"最高价%@",fieldArr[0]];
    [tableviewNew reloadData];
    
}
#pragma mark-创建界面
-(void)creatUI
{

    //设置顶部的框
    NSArray *arr=@[@"取消",@"筛选",@"确定"];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSliderbarWidth, 64)];
    view1.backgroundColor=[UIColor whiteColor];
    
    for (int i=0; i<3; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor=[UIColor whiteColor];
            button.frame=CGRectMake(10+i*(kSliderbarWidth/3), 15, 50, 40);
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(buttonC:) forControlEvents:UIControlEventTouchUpInside];
            //添加手势
            UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
            [panGesture delaysTouchesBegan];
            [button addGestureRecognizer:panGesture];
    
            button.tag=95+i;
            [view1 addSubview:button];
        }
    [self.contentView addSubview:view1];
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSliderbarWidth, 280)];

    field1=[[UITextField alloc]initWithFrame:CGRectMake(80, 20, 75, 40)];
    field1.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    field1.textColor=[UIColor blackColor];
    field1.delegate=self;
    field1.font=[UIFont systemFontOfSize:10];
    field1.returnKeyType=UIReturnKeyDone;
    
    UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(157, 40, 10, 1)];
    lab.backgroundColor=[UIColor lightGrayColor];
    [headView addSubview:lab];
    field2=[[UITextField alloc]initWithFrame:CGRectMake(170, 20, 75, 40)];
    field2.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    field2.textColor=[UIColor blackColor];
    field2.delegate=self;
    field2.font=[UIFont systemFontOfSize:10];
    field2.returnKeyType=UIReturnKeyDone;
    
    field2.tag=1001;
    if (fieldArr.count==0) {
        
    }else{
        field1.placeholder=[NSString stringWithFormat:@"最低价%@",fieldArr[1]];
        field2.placeholder=[NSString stringWithFormat:@"最高价%@",fieldArr[0]];
    }
    field1.tag=1000;
    NSArray * labArr=@[@"价格区间",@"是否免费",@"是否促销",@"所有分类"];
    for (int i=0; i<4; i++) {
        UILabel * lab2=[[UILabel alloc]initWithFrame:CGRectMake(0, i*80, headView.frame.size.width, 5)];
        lab2.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        [headView addSubview:lab2];
        UILabel * labFirst2=[[UILabel alloc]init];
        if(i==0)
        {
            labFirst2.frame =CGRectMake(15,35, 60, 15);
        }if(i==1)
        {
            labFirst2.frame =CGRectMake(15, 95, 60, 15);
        }
        if (i==2) {
            labFirst2.frame =CGRectMake(15, 175, 60, 15);
        }
        if (i==3) {
            labFirst2.frame =CGRectMake(15, 255, 60, 15);
        }
        labFirst2.text=labArr[i];
        labFirst2.font=[UIFont systemFontOfSize:15];
        labFirst2.textColor=[UIColor blackColor];
        labFirst2.textAlignment=NSTextAlignmentLeft;
        [headView addSubview:labFirst2];
    }
   
    [headView addSubview:field1];
    [headView addSubview:field2];

    freeBtn1=[UIButton buttonWithType: UIButtonTypeCustom];
    freeBtn1.frame=CGRectMake(5, 120, 100, 40);
    [freeBtn1 addTarget:self action:@selector(free1Click) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image22=[UIImage imageNamed:@"单选框1.png"];
    image22=[image22 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [freeBtn1 setTitle:@"是" forState:UIControlStateNormal];
    [freeBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    freeBtn1.titleLabel.font=[UIFont systemFontOfSize:14];
    [freeBtn1 setImage:image22 forState:UIControlStateNormal];
    freeBtn1.imageEdgeInsets=UIEdgeInsetsMake(10, 20, 10,60);
    freeBtn1.titleEdgeInsets=UIEdgeInsetsMake(10, -55, 10, 0);
    [headView addSubview:freeBtn1];
    
    freeBtn2=[UIButton buttonWithType: UIButtonTypeCustom];
    freeBtn2.frame=CGRectMake(120, 120, 100, 40);
    [freeBtn2 addTarget:self action:@selector(free2Click) forControlEvents:UIControlEventTouchUpInside];
    [freeBtn2 setTitle:@"否" forState:UIControlStateNormal];
    [freeBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    freeBtn2.titleLabel.font=[UIFont systemFontOfSize:14];
    [freeBtn2 setImage:image22 forState:UIControlStateNormal];
    freeBtn2.imageEdgeInsets=UIEdgeInsetsMake(10, 20, 10,60);
    freeBtn2.titleEdgeInsets=UIEdgeInsetsMake(10, -55, 10, 0);
    [headView addSubview:freeBtn2];
    
    saleBtn1=[UIButton buttonWithType: UIButtonTypeCustom];
    saleBtn1.frame=CGRectMake(5, 200, 100, 40);
    [saleBtn1 addTarget:self action:@selector(sale1Click) forControlEvents:UIControlEventTouchUpInside];
    [saleBtn1 setTitle:@"是" forState:UIControlStateNormal];
    [saleBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saleBtn1.titleLabel.font=[UIFont systemFontOfSize:14];
    [saleBtn1 setImage:image22 forState:UIControlStateNormal];
    saleBtn1.imageEdgeInsets=UIEdgeInsetsMake(10, 20, 10,60);
    saleBtn1.titleEdgeInsets=UIEdgeInsetsMake(10, -55, 10, 0);
    [headView addSubview:saleBtn1];

    saleBtn2=[UIButton buttonWithType: UIButtonTypeCustom];
    saleBtn2.frame=CGRectMake(120, 200, 100, 40);
    [saleBtn2 addTarget:self action:@selector(sale2Click) forControlEvents:UIControlEventTouchUpInside];
    [saleBtn2 setTitle:@"否" forState:UIControlStateNormal];
    [saleBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saleBtn2.titleLabel.font=[UIFont systemFontOfSize:14];
    [saleBtn2 setImage:image22 forState:UIControlStateNormal];
    saleBtn2.imageEdgeInsets=UIEdgeInsetsMake(10, 20, 10,60);
    saleBtn2.titleEdgeInsets=UIEdgeInsetsMake(10, -55, 10, 0);
   
    [headView addSubview:saleBtn2];
    UIView * footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSliderbarWidth, 50)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(kSliderbarWidth/2-50,0, 100, 40);
    button.layer.cornerRadius = 10.0;
    [button.layer setBorderWidth:1];
    button.layer.borderColor=[UIColor lightGrayColor].CGColor;
    button.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [button setTitle:@"取消选项" forState:UIControlStateNormal ];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearData:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:button];
    tableviewNew =[[UITableView alloc]initWithFrame:CGRectMake(0, 70, kSliderbarWidth, self.view.frame.size.height-70) style:UITableViewStylePlain];
    tableviewNew.showsVerticalScrollIndicator=NO;
    tableviewNew.delegate=self;
    tableviewNew.dataSource=self;
    tableviewNew.tableHeaderView=headView;
    tableviewNew.tableFooterView=footview;
    [self.contentView addSubview:tableviewNew];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString * new=@"new";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:new];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:new];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if ([self.selectedIndexPath isEqual:indexPath]){
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.text=_datasource[indexPath.row][@"cat_name"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
        classID=_datasource[indexPath.item][@"cat_id"];
        if (self.selectedIndexPath) {
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        self.selectedIndexPath = indexPath;
        
}
-(void)free1Click{
    
    free=@"1";
    [freeBtn1 setImage:[UIImage imageNamed:@"单选框（选中).png"] forState:UIControlStateNormal];
    [freeBtn2 setImage:[UIImage imageNamed:@"单选框1.png"] forState:UIControlStateNormal];
    
}
-(void)free2Click{
    
    free=@"0";
    [freeBtn2 setImage:[UIImage imageNamed:@"单选框（选中).png"] forState:UIControlStateNormal];
    [freeBtn1 setImage:[UIImage imageNamed:@"单选框1.png"] forState:UIControlStateNormal];
}
-(void)sale1Click{
    promoting=@"1";
    [saleBtn1 setImage:[UIImage imageNamed:@"单选框（选中).png"] forState:UIControlStateNormal];
    [saleBtn2 setImage:[UIImage imageNamed:@"单选框1.png"] forState:UIControlStateNormal];
}
-(void)sale2Click{
    promoting=@"0";
    [saleBtn2 setImage:[UIImage imageNamed:@"单选框（选中).png"] forState:UIControlStateNormal];
    [saleBtn1 setImage:[UIImage imageNamed:@"单选框1.png"] forState:UIControlStateNormal];
}

#pragma mark-顶部取消或者确定的点击事件
-(void)buttonC:(id)sender
{
    UIButton * btn=(UIButton *)sender;
    if (btn.tag==95) {
        self.view.backgroundColor=[UIColor clearColor];
        self.view.hidden=YES;
    }
    else if(btn.tag==97)
    {
        self.view.backgroundColor=[UIColor clearColor];
        self.view.hidden=NO;
        NSString * mystr=@"";
        if (field1.text.length&&field2.text.length) {
            mystr=[NSString stringWithFormat:@"%@-%@",field1.text,field2.text];
        }
        _myfiltrate=[[NSMutableDictionary alloc]init];
        if (!promoting) {
            [_myfiltrate setObject:[NSString stringWithFormat:@""] forKey:@"is_promotion"];
        }else{
            [_myfiltrate setObject:[NSString stringWithFormat:@"%@",promoting] forKey:@"is_promotion"];
        }
        if (mystr==NULL) {
            [_myfiltrate setObject:[NSString stringWithFormat:@""] forKey:@"price_range"];
        }else if(mystr!=NULL)
        {[_myfiltrate setObject:[NSString stringWithFormat:@"%@",mystr] forKey:@"price_range"];
        }
        if (!free) {
            [_myfiltrate setObject:[NSString stringWithFormat:@""] forKey:@"is_fare"];
        }else
        {
            [_myfiltrate setObject:[NSString stringWithFormat:@"%@",free] forKey:@"is_fare"];}
        if (!classID) {
            [_myfiltrate setObject:[NSString stringWithFormat:@""]forKey:@"classify"];
        }else{
            [_myfiltrate setObject:[NSString stringWithFormat:@"%@",classID]forKey:@"classify"];}
        NSString * strr=[_myfiltrate JSONString];
        
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:strr,@"lis", nil];
        NSLog(@".......%@",dict);
        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
        NSNotification *nofity=[[NSNotification alloc]initWithName:@"text" object:nil userInfo:dict];
        [nc postNotification:nofity];
        self.view.hidden=YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [field1 resignFirstResponder];
    [field2 resignFirstResponder];
    return YES;
}
//取消选项点击事件
-(void)clearData:(id)sender
{
    [field1 setText:@""];
    [field1 setPlaceholder:[NSString stringWithFormat:@"最低价%@",fieldArr[1]]];
    [field2 setText:@""];
    [field2 setPlaceholder:[NSString stringWithFormat:@"最高价%@",fieldArr[0]]];
    UIImage *imgClean=[UIImage imageNamed:@"单选框1.png"];
    imgClean=[imgClean imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [freeBtn1 setImage:imgClean forState:UIControlStateNormal];
    [freeBtn2 setImage:imgClean forState:UIControlStateNormal];
    [saleBtn1 setImage:imgClean forState:UIControlStateNormal];
    [saleBtn2 setImage:imgClean forState:UIControlStateNormal];
    classID=@"";
    self.selectedIndexPath=0;
    [tableviewNew reloadData];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [tableviewNew endEditing:YES];
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
