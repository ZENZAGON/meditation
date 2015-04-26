//
//  ZENData.m
//  TheZen
//
//  Created by 文 光石 on 2015/04/26.
//  Copyright (c) 2015年 zenzagon. All rights reserved.
//

#import "ZENData.h"

@implementation ZENData

- (void)copyData:(MEMERealTimeData *)data
{
    self.roll = data.roll;
    self.pitch = data.pitch;
    self.yaw = data.yaw;
    self.accX = data.accX;
    self.accY = data.accY;
    self.accZ = data.accZ;
    
    NSLog(@"===roll = %f pitch = %f yaw = %f accX = %d accY = %d accZ = %d", self.roll, self.pitch, self.yaw, self.accX, self.accY, self.accZ);
}

- (void)setData:(MEMERealTimeData *)data
{
    self.roll = data.roll;
    self.pitch = data.pitch;
    self.yaw = data.yaw;
    self.accX = data.accX;
    self.accY = data.accY;
    self.accZ = data.accZ;
    
    if (data.eyeMoveUp == 1 ||
        data.eyeMoveDown == 1 ||
        data.eyeMoveLeft == 1 ||
        data.eyeMoveRight == 1) {
        self.blinkNum++;
    }
    
    NSLog(@"===roll = %f pitch = %f yaw = %f accX = %d accY = %d accZ = %d blinkNum = %d", self.roll, self.pitch, self.yaw, self.accX, self.accY, self.accZ, self.blinkNum);
}

- (void)clearData
{
    self.roll = 0;
    self.pitch = 0;
    self.yaw = 0;
    self.accX = 0;
    self.accY = 0;
    self.accZ = 0;
    self.blinkNum = 0;
}

@end
