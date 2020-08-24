//
//  XYUUID.h
//  XYUUID
//
//  Created by steve on 2016/7/21.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XYUUIDVersion @"1.0.0"

@interface XYUUID : NSObject

/// 随机UUID，此值每次都会刷新
+ (NSString *)uuid;

/// 安装UUID，每次重新安装，此值会刷新
+ (NSString *)uuidForInstall;

/// 开启应用UUID，每次开启应用，此值会刷新
+ (NSString *)uuidForAppOpen;

/// IDFA，开启关闭授权，此值会刷新
+ (NSString *)uuidForIDFA;

/// IDFV
+ (NSString *)uuidForIDFV;

/// 设备信息UUID，根据设备信息生成，能维持一段时间内不变
+ (NSString *)uuidForDeviceInfo;

/// 钥匙串UUID，卸载应用保持不变
+ (NSString *)uuidForKeychain;

/// 设备UUID，设备唯一标识符
+ (NSString *)uuidForDevice;

@end
