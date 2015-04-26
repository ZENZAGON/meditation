//
//  ZENSettingViewController.m
//  MemeMeditation
//
//  Created by saito.minori on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ZENSettingViewController.h"

@interface ZENSettingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ZENSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    // とりあえず数秒でOKのやつ（OKのイメージをださなければNextView）
    //[self performSelector:@selector(showSettingOkImage) withObject:nil afterDelay:5.0f];
    [self performSelector:@selector(showNextView) withObject:nil afterDelay:3.0f];
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
