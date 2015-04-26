//
//  ZENSettingViewController.m
//  MemeMeditation
//
//  Created by saito.minori on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ZENSettingViewController.h"
#import "ZENDeviceManager.h"
#import <MEMELib/MEMELib.h>

@interface ZENSettingViewController () <ZENDeviceObserver>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//@property (nonatomic) ZENDeviceStatus devStatus;
//@property (nonatomic, retain) ZENDeviceInfo *devInfo;

@end

@implementation ZENSettingViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        NSLog(@"initWithCoder");
        /*_devMan = [[ZENDeviceManager alloc] init];
         _devMan.observer = self;
         _devStatus = ZEN_DEVICE_STATUS_STOPPED;*/
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"viewDidLoad");
    
    //_devMan = [[ZENDeviceManager alloc] init];
    //_devMan.observer = self;
    //_devStatus = ZEN_DEVICE_STATUS_STOPPED;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    // とりあえず数秒でOKのやつ（OKのイメージをださなければNextView）
    //[self performSelector:@selector(showSettingOkImage) withObject:nil afterDelay:5.0f];
    //[self performSelector:@selector(showNextView) withObject:nil afterDelay:3.0f];
    //_devMan = [[ZENDeviceManager alloc] init];
    [ZENDeviceManager getInstance].observer = self;
    //_devStatus = ZEN_DEVICE_STATUS_STOPPED;
}


- (void)zenDeviceStatus:(ZENDeviceStatus)status {
    NSLog(@"zenDeviceStatus status:%d", status);
    //_devStatus = status;
    //_deviceStatusLabel.text = [NSString stringWithFormat:@"%d", status];
    if (status == ZEN_DEVICE_STATUS_CONNECTED) {
        [self showNextView];
        [ZENDeviceManager getInstance].observer = nil;
    }
}

- (void)zenDeviceInfo:(ZENDeviceInfo *)devInfo {
    NSLog(@"zenDeviceInfo devInfo.deviceId:%@", devInfo.deviceId);
    //_devInfo.deviceId = devInfo.deviceId;
    //_deviceIdLabel.text = devInfo.deviceId;
}

- (void)showSettingOkImage
{
    self.imageView.image = [UIImage imageNamed:@"ここにOKのイメージ画"];
    [self performSelector:@selector(showNextView) withObject:nil afterDelay:1.0f];
}

- (void)showNextView
{
    [self performSegueWithIdentifier:@"showStartView" sender:self];
}

@end
