
//
//  RootViewController.m
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "BarCodeViewController.h"

@interface BarCodeViewController ()<UIAlertViewDelegate>
{
    float ScreenHigh ;
    float ScreenWidth;
    float interestHigh;//二维码扫描区域
    float lineWidth;
}
@end

@implementation BarCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    ScreenHigh = self.view.frame.size.height;
    ScreenWidth = self.view.frame.size.width;
    interestHigh = (ScreenWidth - 100)*320.0/ScreenWidth;
    lineWidth = interestHigh-20;
   
    
//    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - interestHigh)/2.0, 40, self.view.frame.size.width-20, 50)];
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.view.frame.size.width-20, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - interestHigh)/2, (ScreenHigh - interestHigh)/2, interestHigh, interestHigh)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((interestHigh-lineWidth)/2, 0, lineWidth, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [imageView addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    scanButton.frame = CGRectMake((ScreenWidth - 120)/2.0, imageView.frame.origin.y+imageView.frame.size.height + 30, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
   


}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake((interestHigh-lineWidth)/2, 2*num, lineWidth, 2);
        if (2*num >= interestHigh) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake((interestHigh-lineWidth)/2, 2*num, lineWidth, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }

}
-(void)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    
    
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_output setRectOfInterest:CGRectMake((ScreenHigh - interestHigh)/ScreenHigh/2,((ScreenWidth-interestHigh)/2)/ScreenWidth,interestHigh/ScreenHigh,interestHigh/ScreenWidth)];
   
//    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.frame;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
   
    NSString *stringValue;
   // goodDetailViewController * good=[[goodDetailViewController alloc]init];
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        if ([self.delegate respondsToSelector:@selector(QRCodeScanFinishiResult:)]) {
            [self.delegate QRCodeScanFinishiResult:stringValue];
//            if ([stringValue rangeOfString:@"goods_id:"].location !=NSNotFound) {
//                int a=[[stringValue substringFromIndex:9 ]intValue];
//                good.goodID=[NSString stringWithFormat:@"%d",a] ;
//                [self.navigationController pushViewController:good animated:YES];
//            }else {
//                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,只能扫描我们的商品二维码哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
//            }
        }
        NSLog(@"qrcode == %@",stringValue);
    }
    
    [_session stopRunning];
    [self dismissViewControllerAnimated:YES completion:^
    {
        [timer invalidate];

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
