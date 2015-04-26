//
//  ViewController.m
//  MemeMeditation
//
//  Created by saito.minori on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(showHowToView) withObject:nil afterDelay:0.1f];
    
}

- (void)showHowToView
{
    [self performSegueWithIdentifier:@"showHowToView" sender:self];
}
@end
