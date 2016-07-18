//
//  SelectView.m
//  ecshop
//
//  Created by Jin on 16/4/14.
//  Copyright © 2016年 jsyh. All rights reserved.
//筛选

#import "SelectView.h"
#import "SlectPriceTableViewCell.h"
#import "DiscountTableViewCell.h"
#import "UIColor+Hex.h"
#import "GoodsClassCollectionViewCell.h"
#import "RequestModel.h"
#import "ClassModel.h"
#import "JSONKit.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface SelectView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (nonatomic,strong) UICollectionView *collection;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,assign) float collectHeight;//collection 的高度
@property (nonatomic,assign) int collectCount;//collection  item的个数
@property (nonatomic,strong) NSString *minPriceStr;//请求下来的最低价格
@property (nonatomic,strong) NSString *maxPriceStr;//请求下来的最高价格
@property (nonatomic,strong) NSString *minPricePutStr;//输入的最低价格
@property (nonatomic,strong) NSString *maxPricePutStr;//输入的最高价格
@property (nonatomic,strong) NSMutableArray *collectArr;//存放数据
@property (nonatomic,strong) NSString *promoting;//是否促销
@property (nonatomic,strong) NSString *free;//是否免费
@property (nonatomic,strong) NSString *pDelivery;//是否货到付款
@property (nonatomic,strong) NSString *classID;//选择的类的id
@property (nonatomic,strong) NSMutableDictionary *myfiltrate;
@end
@implementation SelectView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creat];
    }
    return self;
}
-(void)creat{
    float heightBtnFloat = 80.0/1334.0;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    _collectHeight = 100.0;
    _collectCount = 3;
   
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  0, Width, Height-50)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.allowsSelection = NO;
    _myTableView.backgroundColor = [UIColor whiteColor];
    
    
    UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc]init];
    flow.minimumInteritemSpacing = 0;
    flow.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    _collection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, Width, 90) collectionViewLayout:flow];
    _collection.collectionViewLayout = flow;
    
    if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_myTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }

    [self addSubview:_myTableView];
    self.backgroundColor = [UIColor redColor];
    
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, Height - heightBtnFloat*Height-64 -50, Width, 50)];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, 0, Width, view.frame.size.height);
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [view addSubview:sureBtn];
    view.backgroundColor = [UIColor yellowColor];

    [self addSubview:view];
}

-(void)sureAction{
    
    NSLog(@"确认");
    NSLog(@"最低%@",_minPricePutStr);
    NSLog(@"最高%@",_maxPricePutStr);
    int minPricePut = [_minPricePutStr intValue];
    int maxPricePut = [_maxPricePutStr intValue];
    int  minPrice = [_minPriceStr intValue];
    int  maxPrice = [_maxPriceStr intValue];
    if (_minPricePutStr.length == 0 || _maxPricePutStr.length == 0) {
        [self sureBack];
    }else{
        if (maxPricePut<minPricePut) {
            //输入反了
            UIAlertView *alewt = [[UIAlertView alloc]initWithTitle:@"您输入有误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alewt show];
        }else{
            //输入的不在范围
            if (minPrice > minPricePut) {
                UIAlertView *alewt = [[UIAlertView alloc]initWithTitle:@"您输入的最低价格不在范围内" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alewt show];
            }else if(maxPrice<maxPricePut){
                UIAlertView *alewt = [[UIAlertView alloc]initWithTitle:@"您输入的最高价格不在范围内" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alewt show];
            }else{
                //开始请求
                NSLog(@"正确");
                
                [self sureBack];
            }
            
        }
    }
    
}
-(void)sureBack{
    NSString * mystr;
 
    if (_minPricePutStr.length>0) {
        if (_maxPricePutStr.length>0) {
            //填写了最大最小
            mystr=[NSString stringWithFormat:@"%@-%@",_minPricePutStr,_maxPricePutStr];
        }else{
            //只有最小
            mystr=[NSString stringWithFormat:@"%@-%@",_minPricePutStr,_maxPriceStr];
        }
    }else{
        if (_maxPricePutStr.length>0) {
            //只有最大
            mystr=[NSString stringWithFormat:@"%@-%@",_minPriceStr,_maxPricePutStr];
        }else{
            //最大最小都没填写
            mystr=[NSString stringWithFormat:@"%@-%@",_minPriceStr,_maxPriceStr];
        }
    }

    _myfiltrate=[[NSMutableDictionary alloc]init];
    if (!_promoting) {
        [_myfiltrate setObject:[NSString stringWithFormat:@""] forKey:@"is_promotion"];
    }else{
        [_myfiltrate setObject:[NSString stringWithFormat:@"%@",_promoting] forKey:@"is_promotion"];
    }
    if (!_pDelivery) {
        [_myfiltrate setObject:[NSString stringWithFormat:@""] forKey:@"p_delivery"];
    }else{
        [_myfiltrate setObject:[NSString stringWithFormat:@"%@",_pDelivery] forKey:@"p_delivery"];
    }
    if (mystr==NULL) {
        [_myfiltrate setObject:[NSString stringWithFormat:@""] forKey:@"price_range"];
    }else if(mystr!=NULL)
    {[_myfiltrate setObject:[NSString stringWithFormat:@"%@",mystr] forKey:@"price_range"];
    }
    if (!_free) {
        [_myfiltrate setObject:[NSString stringWithFormat:@""] forKey:@"is_fare"];
    }else
    {
        [_myfiltrate setObject:[NSString stringWithFormat:@"%@",_free] forKey:@"is_fare"];}
    if (!_classID) {
        [_myfiltrate setObject:[NSString stringWithFormat:@""]forKey:@"classify"];
    }else{
        [_myfiltrate setObject:[NSString stringWithFormat:@"%@",_classID]forKey:@"classify"];}
    NSString * strr=[_myfiltrate JSONString];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:strr,@"lis", nil];
    NSLog(@".......%@",dict);
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    NSNotification *nofity=[[NSNotification alloc]initWithName:@"text" object:nil userInfo:dict];
    [nc postNotification:nofity];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
}
#pragma mark-请求数据
-(void)reloadInfoRequest
{
    if (self.myType==NULL) {
        self.myType=@"";
    }
    
    NSString *api_token = [RequestModel model:@"First" action:@"index"];
    NSDictionary *dict = @{@"api_token":[NSString stringWithFormat:@"%@",api_token],@"type":@"fitrate",@"keyword":self.keyword,@"goods_type":self.myType,@"classify_id":self.classifyID,@"brand_id":self.brandID};
    __weak typeof(self) weakSelf = self;
    _collectArr = [[NSMutableArray alloc]init];
    [RequestModel requestWithDictionary:dict model:@"First" action:@"index" block:^(id result) {
        NSDictionary *ddd = result;
        NSDictionary * dic1;
        dic1=ddd[@"data"];
        NSString *priceStr = dic1[@"price_range"];
        weakSelf.minPriceStr = [[priceStr componentsSeparatedByString:@"-"]lastObject];
        weakSelf.maxPriceStr = [[priceStr componentsSeparatedByString:@"-"]firstObject];
        NSArray *classArr = dic1[@"classify"];
        for (NSMutableDictionary *classDic in classArr) {
            ClassModel *model = [ClassModel new];
            model.className = classDic[@"cat_name"];
            model.classID   = classDic[@"cat_id"];
            [weakSelf.collectArr addObject:model];
        }
        
        NSLog(@"%@",weakSelf.collectArr);
        [weakSelf.myTableView reloadData];
        [weakSelf.collection reloadData];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark --tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * cellid=@"SlectPriceTableViewCell";
        SlectPriceTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[SlectPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.minPriceText.placeholder = [NSString stringWithFormat:@"最低价:%@",_minPriceStr];

        cell.maxPriceText.placeholder =[NSString stringWithFormat:@"最高价:%@",_maxPriceStr] ;

        cell.minPriceText.delegate = self;
        cell.minPriceText.keyboardType = UIKeyboardTypeNumberPad;
        cell.minPriceText.tag = 20000;
        cell.maxPriceText.text = @"";
        cell.minPriceText.text = @"";
        cell.maxPriceText.delegate = self;
        cell.maxPriceText.keyboardType = UIKeyboardTypeNumberPad;
        cell.maxPriceText.tag = 20001;
        
        return cell;
    }else if(indexPath.row == 1){
        static NSString * cellid=@"DiscountTableViewCell";
        DiscountTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[DiscountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell.freightBtn addTarget:self action:@selector(discountAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.freightBtn.tag = 10000;
        [cell.promotionBtn addTarget:self action:@selector(discountAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.promotionBtn.tag = 10001;
        
        [cell.payBtn addTarget:self action:@selector(discountAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.payBtn.tag = 10002;
        
        [cell.freightBtn setImage:[UIImage imageNamed:@"goods_list_options_unchecked"] forState:UIControlStateNormal];
        [cell.payBtn setImage:[UIImage imageNamed:@"goods_list_options_unchecked"] forState:UIControlStateNormal];
         [cell.promotionBtn setImage:[UIImage imageNamed:@"goods_list_options_unchecked"] forState:UIControlStateNormal];
        _pDelivery = @"";
        _promoting = @"";
        _free = @"";
        return cell;
    }else{
        static NSString * cellid=@"DiscountTableViewCell";
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            
            _collection.backgroundColor = [UIColor clearColor];
            _collection.delegate=self;
            _collection.dataSource=self;
            _collection.showsHorizontalScrollIndicator=NO;
            _collection.showsVerticalScrollIndicator=NO;
            [_collection registerClass:[GoodsClassCollectionViewCell class] forCellWithReuseIdentifier:@"string"];
            [cell.contentView addSubview:_collection];
            UILabel *classLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 18, 132, 14)];
            classLab.text = @"商品分类: 所有分类";
            classLab.font = [UIFont systemFontOfSize:14];
            classLab.textColor = [UIColor colorWithHexString:@"#43464c"];
            [cell.contentView addSubview:classLab];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(Width - 32 , 12, 20, 20);
            [button setImage:[UIImage imageNamed:@"goods_closejiantou"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(extensionAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
        }
        
        
      
        //    _collect.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        //        _collection.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
        
      
        
        
        return cell;
    }
    
}
-(void)extensionAction:(UIButton*)sender{
    
    if (_collectHeight  > 100) {
        [sender setImage:[UIImage imageNamed:@"goods_closejiantou"] forState:UIControlStateNormal];
        _collectHeight = 100;
        int a = (int)_collectArr.count;
        _collectCount = a;
        [_myTableView reloadData];
        [_collection reloadData];
    }else{
        [sender setImage:[UIImage imageNamed:@"goods_openjiantou"] forState:UIControlStateNormal];
        _collectHeight = 140;
        _collectCount = 3;
        [_myTableView reloadData];
        [_collection reloadData];
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 52;
    }else if(indexPath.row == 1){
        return 80;
    }else{
        return _collectHeight;
    }
    return 200;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)discountAction:(UIButton *)sender{
    UIButton *btn1=(UIButton *)[self viewWithTag:10000];
    UIButton *btn2=(UIButton *)[self viewWithTag:10001];
    UIButton *btn3=(UIButton *)[self viewWithTag:10002];
    NSLog(@"%@",btn1.titleLabel.text);
    if (sender.tag == 10000) {
        if (sender.selected) {
            sender.selected = NO;
            _free = @"";
            [btn1 setImage:[UIImage imageNamed:@"goods_list_options_unchecked"] forState:UIControlStateNormal];
        }else{
            sender.selected = YES;
            _free = @"1";
            [btn1 setImage:[UIImage imageNamed:@"goods_list_options_checked"] forState:UIControlStateNormal];
        }
    }else if(sender.tag == 10001){
        if (sender.selected) {
            sender.selected = NO;
            _promoting = @"";
            [btn2 setImage:[UIImage imageNamed:@"goods_list_options_unchecked"] forState:UIControlStateNormal];
        }else{
            sender.selected = YES;
            _promoting = @"1";
            [btn2 setImage:[UIImage imageNamed:@"goods_list_options_checked"] forState:UIControlStateNormal];
        }
    }else if(sender.tag == 10002){
        if (sender.selected) {
            sender.selected = NO;
            _pDelivery = @"";
            [btn3 setImage:[UIImage imageNamed:@"goods_list_options_unchecked"] forState:UIControlStateNormal];
        }else{
            sender.selected = YES;
            _pDelivery = @"1";
            [btn3 setImage:[UIImage imageNamed:@"goods_list_options_checked"] forState:UIControlStateNormal];
        }
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 100)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(Width/2-54, 37, 109, 21);
    [button setTitle:@"重置" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.layer.borderColor = [UIColor colorWithHexString:@"ff5000"].CGColor;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    [view addSubview:button];
    return view;
}
-(void)resetAction{
    [self.myTableView reloadData];
    [self.collection reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

#pragma mark --collection代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_collectHeight  > 100) {
        return _collectArr.count;
    }else{
        if (_collectArr.count>0) {
            return 3;
        }else{
            return 0;
        }
    }
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * right=@"string";
    GoodsClassCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:right forIndexPath:indexPath];
    
    ClassModel *model ;
    model = _collectArr[indexPath.item];
    
    
    NSString *str = model.className;
    cell.titleLab.text = str;
    cell.titleLab.textColor = [UIColor colorWithHexString:@"#43464c"];
//    NSLog(@"aaaaaaaaaa%@",_collectArr);
    cell.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    UIView* selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
    cell.selectedBackgroundView = selectedBGView;

    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float a = 214.0/750.0;
    return CGSizeMake(a*Width, 21);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(6, 12, 18, 12);
}
//选中item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    ClassModel *model;
    model = _collectArr[indexPath.item];
    NSLog(@"%@",model.classID);
    GoodsClassCollectionViewCell *cell = (GoodsClassCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLab.textColor = [UIColor whiteColor];
    _classID = model.classID;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsClassCollectionViewCell *cell = (GoodsClassCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    if (cell.selected == NO) {
        cell.titleLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    }
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
/**
 * Cell根据Cell选中状态来改变Cell上Button按钮的状态
 */
- (void) changeSelectStateWithIndexPath: (NSIndexPath *) indexPath{
    NSLog(@"22");
}
-(void)readCell:(UIButton *)button{
    NSLog(@"333");
}
#pragma mark --textFiled delegate
//获得textField上的价格
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 20000) {
        //最低价格
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        _minPricePutStr = text;
        NSLog(@"%@",text);
    }else if(textField.tag == 20001){
        //最高价格
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        _maxPricePutStr = text;
        NSLog(@"%@",text);
    }
    
    return YES;
}


@end
