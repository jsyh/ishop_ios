//
//  PopoveView.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/4.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "PopoveView.h"
#define ROW_HEIGHT 40.f
#define TITLE_FONT [UIFont systemFontOfSize:15]
#define TabHeight 100
@interface PopoveView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *titleArr;
@property(nonatomic) CGPoint showPoint;
@property (nonatomic, strong) UIButton *handerView;
@end
@implementation PopoveView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles
{
    self=[super init];
    if (self) {
        self.showPoint=point;
        self.titleArr=titles;
        self.frame=[self getViewFrame];
        [self addSubview: self.table];
    }
    return self;
}
//获得抽屉的大小
-(CGRect)getViewFrame
{
    CGRect frame=CGRectZero;
    frame.size.height=[self.titleArr count]*ROW_HEIGHT;
        frame.size.width=375;
    frame.origin.x=self.showPoint.x;
    frame.origin.y=self.showPoint.y;
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
    }
//    //右间隔最小5x
    if ((frame.origin.x + frame.size.width) >375) {
        frame.origin.x =375 - frame.size.width;
    }

    return frame;
}
//出现
-(void)show
{
    self.handerView=[UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, arrowPoint.y / self.frame.size.height);
    self.frame = [self getViewFrame];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}
-(void)dismiss
{
    [self dismiss:YES];
}
-(void)dismiss:(BOOL)animated
{
    if (!animated) {
        [_handerView removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.transform=CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha=0.f;
    }completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
    }];
}
-(UITableView *)table
{
    if (_table!=nil) {
        return _table;
    }
    self.table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, TabHeight) style:UITableViewStylePlain];
    _table.delegate=self;
    _table.dataSource=self;
    _table.showsHorizontalScrollIndicator = NO;
    _table.showsVerticalScrollIndicator = NO;
    _table.scrollEnabled = NO;
    _table.backgroundColor = [UIColor clearColor];
    return _table;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArr count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.textLabel.font=TITLE_FONT;
    cell.textLabel.text=[_titleArr objectAtIndex:indexPath.row];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectRowAtIndex) {
        self.selectRowAtIndex(indexPath.row);
    }
    [self dismiss:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
