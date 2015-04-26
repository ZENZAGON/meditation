//
//  ZENDataAnalyzer.m
//  TheZen
//
//  Created by 文 光石 on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ZENDataAnalyzer.h"


@implementation ZENConfig


@end


@interface ZENDataAnalyzer ()

@property (nonatomic) ZENConfig *config;
@property (nonatomic) BOOL isFirstData;

@property (nonatomic) ZENData *firstData;
@property (nonatomic) ZENData *currentData;
@property (nonatomic) ZENData *lastData;

@end

@implementation ZENDataAnalyzer

- (id)init
{
    if (self = [super init]) {
        _config = [[ZENConfig alloc] init];
        _firstData = [[ZENData alloc] init];
        _currentData = [[ZENData alloc] init];
        _lastData = [[ZENData alloc] init];
    }
    
    return self;
}

- (void)setupConfig:(ZENConfig *)config
{
    _config.calibrationRoll = config.calibrationRoll;
    _config.calibrationPitch = config.calibrationPitch;
    _config.calibrationRaw = config.calibrationRaw;
    
    _config.thresholdRoll = config.thresholdRoll;
    _config.thresholdPitch = config.thresholdPitch;
    _config.thresholdYaw = config.thresholdYaw;
    _config.thresholdAccX = config.thresholdAccX;
    _config.thresholdAccY = config.thresholdAccY;
    _config.thresholdAccZ = config.thresholdAccZ;
    
    _config.thresholdBlinkNum = config.thresholdBlinkNum;
}

- (BOOL)checkCalibrationData:(MEMERealTimeData *)data
{
    BOOL ret = YES;
    
    float calibrationRoll = fabs(data.roll);
    float calibrationPitch = fabs(data.pitch);
    float calibrationYaw = fabs(data.yaw);
    NSLog(@"===calibrationRoll = %f calibrationPitch = %f calibrationYaw = %f", calibrationRoll, calibrationPitch, calibrationYaw);
    NSLog(@"===calibrationRoll = %f calibrationPitch = %f calibrationRaw = %f", _config.calibrationRoll, _config.calibrationPitch, _config.calibrationRaw);
    
    if (calibrationRoll > _config.calibrationRoll ||
        calibrationPitch > _config.calibrationPitch/* ||
        calibrationYaw > _config.calibrationRaw*/) {
        ret = NO;
    } else {
        NSLog(@"===Calibration OK!");
        ret = YES;
        if (_isFirstData == YES) {
            [_firstData copyData:data];
            _isFirstData = NO;
        }
    }
    
    return ret;
}

- (void)memeRealTimeModeDataReceived: (MEMERealTimeData *)data
{
    /*if (_isFirstData == YES) {
        [_firstData copyData:data];
        _isFirstData = NO;
    }*/
    [_currentData setData:data];
}

- (BOOL)checkReceivedData:(MEMERealTimeData *)data
{
    BOOL ret = YES;
    
    [_currentData setData:data];
    
    float subRoll = fabs(_currentData.roll - _firstData.roll);
    float subPitch = fabs(_currentData.pitch - _firstData.pitch);
    float subYaw = fabs(_currentData.yaw - _firstData.yaw);
    int subAccX = abs(_currentData.accX - _firstData.accX);
    int subAccY = abs(_currentData.accY - _firstData.accY);
    int subAccZ = abs(_currentData.accZ - _firstData.accZ);
    
    NSLog(@"===subRoll = %f subPitch = %f subYaw = %f subAccX = %d subAccY = %d subAccZ = %d blink = %d", subRoll, subPitch, subYaw, subAccX, subAccY, subAccZ, _currentData.blinkNum);
    NSLog(@"===thresholdRoll = %f thresholdPitch = %f thresholdYaw = %f", _config.thresholdRoll, _config.thresholdPitch, _config.thresholdYaw);
    
    if ( subRoll > _config.thresholdRoll ||
         subPitch > _config.thresholdPitch /*||
         subYaw > _config.thresholdYaw ||
         subAccX > _config.thresholdAccX ||
         subAccY > _config.thresholdAccY ||
         subAccZ > _config.thresholdAccZ*/||
         _currentData.blinkNum > _config.thresholdBlinkNum) {
        ret = NO;
        
        NSLog(@"*********************NG*********************");
    }
    
    return ret;
}

- (void)reset
{
    [_firstData clearData];
    [_currentData clearData];
    [_lastData clearData];
}

@end
