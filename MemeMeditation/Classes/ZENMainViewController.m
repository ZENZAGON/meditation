//
//  ZENMainViewController.m
//  MemeMeditation
//
//  Created by saito.minori on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ZENMainViewController.h"

@interface ZENMainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ZENMainViewController

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
    [self performSelector:@selector(showCountDown3) withObject:nil afterDelay:0.1f];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showCountDown3
{
    self.imageView.image = [UIImage imageNamed:@"07_countdown3"];
    [self performSelector:@selector(showCountDown2) withObject:nil afterDelay:1.0f];
    
}
- (void)showCountDown2
{
    self.imageView.image = [UIImage imageNamed:@"08_countdown2"];
    [self performSelector:@selector(showCountDown1) withObject:nil afterDelay:1.0f];
    
}

- (void)showCountDown1
{
    self.imageView.image = [UIImage imageNamed:@"09_countdown1"];
    [self performSelector:@selector(showCountDownGo) withObject:nil afterDelay:1.0f];
    
}

- (void)showCountDownGo
{
    self.imageView.image = [UIImage imageNamed:@"10_start"];
    [self performSelector:@selector(showPlaying) withObject:nil afterDelay:1.0f];
}


- (void)showPlaying
{
    self.imageView.image = [UIImage imageNamed:@"11_plaing"];
    //[self performSelector:@selector(showPlaying) withObject:nil afterDelay:1.0f];
    
}


@end
