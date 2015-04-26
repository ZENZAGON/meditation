//
//  ZENDeviceManager.m
//  TheZen
//
//  Created by 文 光石 on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ZENDeviceManager.h"
#import "ZENDataAnalyzer.h"


#define ZEN_ID ""

typedef enum {
    ZEN_DEVICE_COMMAND_NONE   = 0,
    ZEN_DEVICE_COMMAND_READY,
    ZEN_DEVICE_COMMAND_START,
    ZEN_DEVICE_COMMAND_STOP,
} ZENDeviceCommand;

@implementation ZENDeviceInfo


@end

@interface ZENDeviceManager() <MEMELibDelegate>

//@property (nonatomic, retain) ZENDataAnalyzer *dataAnalyzer;
@property (nonatomic) ZENDataAnalyzer *dataAnalyzer;

@property (nonatomic, copy) NSString *memeId;
//@property (nonatomic, retain) CBPeripheral *meme;
@property (nonatomic) CBPeripheral *meme;
@property (nonatomic) BOOL calibration;
@property (nonatomic) ZENDeviceStatus status;
@property (nonatomic) BOOL isReady;
@property (nonatomic) BOOL isStarted;
@property (nonatomic) ZENDeviceCommand command;

@end

@implementation ZENDeviceManager

static ZENDeviceManager *sharedInstance = nil;

+ (ZENDeviceManager*)getInstance
{
    if (!sharedInstance) {
        sharedInstance = [ZENDeviceManager new];
    }
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        _dataAnalyzer = [[ZENDataAnalyzer alloc] init];
        
        [MEMELib sharedInstance].delegate = self;
        [[MEMELib sharedInstance] addObserver: self forKeyPath: @"centralManagerEnabled" options: NSKeyValueObservingOptionNew context:nil];
        //_memeLib = [MEMELib sharedInstance];
        //[MEMELib sharedInstance].delegate = self;
        _memeId = @"5C46CC41-C062-42B0-6813-8DAC6436FA5D";
        
        [self reset];
    }
    
    return self;
}

- (void)connect
{
    NSLog(@"connect");
    //_memeLib = [MEMELib sharedInstance];
    //_memeLib.delegate = self;
//    [MEMELib sharedInstance].delegate = self;
//    [[MEMELib sharedInstance] addObserver: self forKeyPath: @"centralManagerEnabled" options: NSKeyValueObservingOptionNew context:nil];
    
    // Start Scanning
    /*MEMEStatus status = [[MEMELib sharedInstance] startScanningPeripherals];
    NSLog(@"startScanningPeripherals");
    [self checkMEMEStatus: status];
    
    _status = ZEN_DEVICE_STATUS_CONNECTING;
    if (_observer != nil) {
        [_observer zenDeviceStatus:_status];
    }*/
    
    // Start Scanning
    MEMEStatus status = [[MEMELib sharedInstance] startScanningPeripherals];
    NSLog(@"startScanningPeripherals");
    [self checkMEMEStatus: status];
    
    _status = ZEN_DEVICE_STATUS_CONNECTING;
    if (_observer != nil) {
        [_observer zenDeviceStatus:_status];
    }
}

- (void)ready:(int)seconds
{
    NSLog(@"ready");
    [self setupConfig];
    
    // Start Scanning
    /*MEMEStatus status = [[MEMELib sharedInstance] startScanningPeripherals];
    NSLog(@"startScanningPeripherals");
    [self checkMEMEStatus: status];
    
    _status = ZEN_DEVICE_STATUS_CONNECTING;
    if (_observer != nil) {
        [_observer zenDeviceStatus:_status];
    }*/
    
    _command = ZEN_DEVICE_COMMAND_READY;
}

- (void)start
{
    _command = ZEN_DEVICE_COMMAND_START;
}

- (void)stop
{
    //[[MEMELib sharedInstance] disconnectPeripheral];
    _command = ZEN_DEVICE_COMMAND_STOP;
}

- (void)disconnect
{
    [[MEMELib sharedInstance] disconnectPeripheral];
}

- (void)setupConfig
{
    ZENConfig *config = [[ZENConfig alloc] init];
    config.calibrationRoll = 30;
    config.calibrationPitch = 30;
    config.calibrationRaw = 15;
    config.thresholdRoll = 10;
    config.thresholdPitch = 10;
    config.thresholdYaw = 10;
    config.thresholdBlinkNum = 10;
    
    [_dataAnalyzer setupConfig:config];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"keyPath %@", keyPath);
    if ([keyPath isEqualToString: @"centralManagerEnabled"]){
        // Start Scanning
        MEMEStatus status = [[MEMELib sharedInstance] startScanningPeripherals];
        NSLog(@"startScanningPeripherals");
        [self checkMEMEStatus: status];
        
        _status = ZEN_DEVICE_STATUS_CONNECTING;
        if (_observer != nil) {
            [_observer zenDeviceStatus:_status];
        }
    }
}

- (BOOL)calibrateDevice: (MEMERealTimeData *) data
{
    BOOL ret = NO;
    
    return ret;
}

- (void)reset
{
    _calibration = NO;
    _status = ZEN_DEVICE_STATUS_STOPPED;
    _isReady = NO;
    _isStarted = NO;
    _command = ZEN_DEVICE_COMMAND_NONE;
    [_dataAnalyzer reset];
}

#pragma mark
#pragma mark MEMELib Delegates

- (void) memePeripheralFound: (CBPeripheral *) peripheral;
{
    NSLog(@"peripheral found %@", [peripheral.identifier UUIDString]);
    if ([MEMELib sharedInstance].isConnected == NO) {
        if ([[peripheral.identifier UUIDString] compare:_memeId] == NSOrderedSame) {
            _meme = peripheral;
            NSLog(@"set meme %@", [peripheral.identifier UUIDString]);
        }
    }
}

- (void) memePeripheralConnected: (CBPeripheral *)peripheral
{
    NSLog(@"MEME Device Connected!(%@)", [peripheral.identifier UUIDString]);
    
#if 1
    if ([[peripheral.identifier UUIDString] compare:_memeId] != NSOrderedSame) {
        [[MEMELib sharedInstance] disconnectPeripheral];
        return;
    }
#endif
    
    // Set Data Mode to Standard Mode
    [[MEMELib sharedInstance] changeDataMode: MEME_COM_REALTIME];
    
    NSLog(@"_status: %d", _status);
    if (_status == ZEN_DEVICE_STATUS_CONNECTING) {
        _status = ZEN_DEVICE_STATUS_CONNECTED;
        if (_observer != nil) {
            [_observer zenDeviceStatus:_status];
            ZENDeviceInfo *info = [[ZENDeviceInfo alloc] init];
            //info.deviceId = [NSString stringWithFormat:@"(%@)%@", peripheral.name, [peripheral.identifier UUIDString]];
            info.deviceId = [peripheral.identifier UUIDString];
            [_observer zenDeviceInfo:info];
        }
    }
}

- (void) memePeripheralDisconnected: (CBPeripheral *)peripheral
{
    NSLog(@"MEME Device Disconnected!(%@)", [peripheral.identifier UUIDString]);
}


- (void) memeStandardModeDataReceived: (MEMEStandardData *) data
{
}


- (void) memeRealTimeModeDataReceived: (MEMERealTimeData *) data
{
    NSLog(@"command %d", _command);
    if (_command == ZEN_DEVICE_COMMAND_READY) {
        if (_calibration == NO) {
            if ([_dataAnalyzer checkCalibrationData:data]) {
                _calibration = YES;
                _status = ZEN_DEVICE_STATUS_RUNNING;
                if (_observer != nil) {
                    [_observer zenDeviceStatus:_status];
                }
                NSLog(@"_calibration: %d _status: %d", _calibration, _status);
            }
        }
    } else if (_command == ZEN_DEVICE_COMMAND_START) {
        if ([_dataAnalyzer checkReceivedData:data]) {
            _status = ZEN_DEVICE_STATUS_PERFECT;
        } else {
            _status = ZEN_DEVICE_STATUS_LEAN;
        }
        
        if (_observer != nil) {
            [_observer zenDeviceStatus:_status];
        }
    } else if (_command == ZEN_DEVICE_COMMAND_STOP) {
        [self reset];
    }
}

- (void) memeDataModeChanged:(MEMEDataMode)mode
{
    
    
}

- (void) memeAppAuthorized:(MEMEStatus)status
{
    [self checkMEMEStatus: status];
}

#pragma mark UTILITY

- (void) checkMEMEStatus: (MEMEStatus) status
{
    if (status == MEME_ERROR_APP_AUTH){
        NSLog(@"Status: App Auth Failed");
        //_status = ZEN_DEVICE_STATUS_ERROR;
    } else if (status == MEME_ERROR_SDK_AUTH){
        NSLog(@"Status: SDK Auth Failed");
        //_status = ZEN_DEVICE_STATUS_ERROR;
    } else if (status == MEME_OK){
        NSLog(@"Status: MEME_OK");
    }
}

@end
