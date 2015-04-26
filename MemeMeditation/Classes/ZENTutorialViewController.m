//
//  ZENTutorialViewController.m
//  MemeMeditation
//
//  Created by saito.minori on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ZENTutorialViewController.h"
#import "ZENTutorialPageView.h"

@interface ZENTutorialViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ZENTutorialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTutorialPageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - scrollView Delegate method

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    // 縦方向のスクロールをキャンセルする
    CGPoint point = scrollView.contentOffset;
    point.y = 0;
    self.scrollView.contentOffset = point;
    // ページャ設定
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;    
    
}
#pragma mark - Action method

/**
 *  閉じるボタンが押された
 *
 *  @param sender アクション
 */
- (void)didTapCloseButtton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Private methods

- (void)setupTutorialPageView
{
    // スクローラーの設定
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    
    NSArray *pages = @[[UIImage imageNamed:@"01_about"],[UIImage imageNamed:@"02_howto"]];
    CGFloat pageWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat pageHeight = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(pages.count * pageWidth, pageHeight);
    
    for (int i = 0; i < pages.count; i++) {
        ZENTutorialPageView *pageView = [ZENTutorialPageView viewWithImage:pages[i] frame:CGRectMake(i * pageWidth, 0.0f, pageWidth, pageHeight)];
        if (i == pages.count - 1) {
            UIButton * nextButton = [ UIButton buttonWithType:UIButtonTypeRoundedRect ];
            
            // ボタンの位置とサイズを指定する
            nextButton.frame = CGRectMake( 50, 300, 220, 40 );
            
            // ボタンのラベル文字列を指定する
            [ nextButton setTitle:@"つぎへ" forState:UIControlStateNormal ];
            // 画像を指定したボタン例文
            /*
            UIImage *img = [UIImage imageNamed:@"hoge.png"];  // ボタンにする画像を生成する
            UIButton *btn = [[[UIButton alloc]
                              initWithFrame:CGRectMake(0, 0, 60, 30)] autorelease];  // ボタンのサイズを指定する
            [btn setBackgroundImage:img forState:UIControlStateNormal];  // 画像をセットする
             */
            [nextButton addTarget:self
                    action:@selector(didTapNextButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [pageView addSubview:nextButton];
        }
        [self.scrollView addSubview:pageView];
    }
    

}

- (void)didTapNextButton:(id)sender
{
    
    [self performSegueWithIdentifier:@"showSettingView" sender:self];
}

@end
