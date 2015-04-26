//
//  ZENTutorialPageView.m
//  MemeMeditation
//
//  Created by saito.minori on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ZENTutorialPageView.h"

@implementation ZENTutorialPageView

#pragma mark - Lifecycle mehtods

+ (instancetype)viewWithImage:(UIImage *)image frame:(CGRect)frame
{
    return [[self alloc] initWithImage:image frame:frame];
}

- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // チュートリアル画像
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageview.image = image;
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageview];
        
    }
    return self;
}

@end
