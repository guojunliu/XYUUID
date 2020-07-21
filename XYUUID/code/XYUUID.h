//
//  XYUUID.h
//  XYUUID
//
//  Created by steve on 2016/7/21.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYUUID : NSObject

+ (NSString *)uuid;

+ (NSString *)uuidForInstall;

+ (NSString *)uuidForAppOpen;

+ (NSString *)uuidForIDFA;

+ (NSString *)uuidForIDFV;

+ (NSString *)uuidForDeviceInfo;

+ (NSString *)uuidForKeychain;

+ (NSString *)uuidForDevice;

@end
