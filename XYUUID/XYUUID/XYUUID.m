//
//  XYUUID.m
//  XYUUID
//
//  Created by steve on 2016/7/21.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import "XYUUID.h"
#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>
#import "XYDeviceInfoUUID.h"
#import "XYKeyChain.h"
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
    #import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif


static NSString *XY_ZeroIdfa = @"00000000-0000-0000-0000-000000000000";

static NSString *STR_XYUUIDForInstall = @"XYUUID-Install";
static NSString *STR_XYUUIDForKeyChain = @"XYUUID-KeyChain-ServiceDomain";
static NSString *STR_XYUUIDForKeyChainAndDeviceOrIdfa = @"XYUUID-KeyChain-Device-Idfa";
//static NSString *STR_XYUUIDForKeyChain = base64Decode:@"Y29tLkhvbGF2ZXJzZS5Ib2xhU3RhdGlzdGljYWw=";

@interface XYUUID ()
@property (nonatomic,copy) NSString *appOpenUUID;
@end

@implementation XYUUID

+ (instancetype)shareManager{
    static XYUUID *instantce = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instantce == nil) {
            instantce = [[XYUUID alloc] init];
        }
    });
    return instantce;
}

+ (NSString *)uuid {
    return [[NSUUID UUID] UUIDString];
}

+ (NSString *)uuidForInstall {
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:STR_XYUUIDForInstall];
    if (uuid && ![uuid isEqualToString:@""]) {
        return uuid;
    }
    uuid = [self uuid];
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:STR_XYUUIDForInstall];
    return uuid;
}

+ (NSString *)uuidForAppOpen {
    if ([XYUUID shareManager].appOpenUUID && ![[XYUUID shareManager].appOpenUUID isEqualToString:@""]) {
        return [XYUUID shareManager].appOpenUUID;
    }
    NSString *appOpenUUID = [self uuid];
    [XYUUID shareManager].appOpenUUID = appOpenUUID;
    return appOpenUUID;
}

+ (NSString *)uuidForIDFA {
    
    if (@available(iOS 14.0, *)) {
        ATTrackingManagerAuthorizationStatus states = [ATTrackingManager trackingAuthorizationStatus];
        if (states == ATTrackingManagerAuthorizationStatusNotDetermined) {
            // 未提示用户
            return XY_ZeroIdfa;
        }
        else if (states == ATTrackingManagerAuthorizationStatusRestricted) {
            // 限制使用
            return XY_ZeroIdfa;
        }
        else if (states == ATTrackingManagerAuthorizationStatusDenied) {
            // 拒绝
            return XY_ZeroIdfa;
        }
        else if (states == ATTrackingManagerAuthorizationStatusAuthorized) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            return idfa;
        }
        return XY_ZeroIdfa;
    }
    
    if (@available(iOS 10.0, *)) {
        BOOL canUseIDFA = [ASIdentifierManager sharedManager].advertisingTrackingEnabled;   //如果返回的YES说明没有 “开启限制广告跟踪”，可以获取到正确的idfa  如果返回的是NO，说明等待你的就是00000000-0000-0000-0000-000000000000
        if (canUseIDFA) {
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            return idfa;
        }
        return XY_ZeroIdfa;
    }
    
    // iOS 10以下关闭广告追踪，也可以正常获取到IDFA
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
}

+ (NSString *)uuidForIDFV {
    NSString *idfv = [UIDevice currentDevice].identifierForVendor.UUIDString;
    return idfv;
}

+ (NSString *)uuidForDeviceInfo {
    NSString *uuid = [XYDeviceInfoUUID createDeviceInfoUUID];
    return uuid;
}

+ (NSString *)uuidForKeychain {
    NSString *uuid = [XYKeyChain getDataWithServiceDomain:STR_XYUUIDForKeyChain];
    if (uuid && ![uuid isEqualToString:@""]) {
        return uuid;
    }
    uuid = [self uuid];
    [XYKeyChain setData:uuid serviceDomain:STR_XYUUIDForKeyChain];
    return uuid;
}

+ (NSString *)uuidForDevice {
    NSString *deviceUUID = [XYKeyChain getDataWithServiceDomain:STR_XYUUIDForKeyChainAndDeviceOrIdfa];
    if (deviceUUID && ![deviceUUID isEqualToString:@""] && ![deviceUUID isEqualToString:XY_ZeroIdfa]) {
        return deviceUUID;
    }
    
    NSString *idfa = [self uuidForIDFA];
    if (idfa && ![idfa isEqualToString:@""] && ![idfa isEqualToString:XY_ZeroIdfa]) {
        [XYKeyChain setData:idfa serviceDomain:STR_XYUUIDForKeyChainAndDeviceOrIdfa];
        return idfa;
    }
    
    NSString *deviceInfoUUID = [self uuidForDeviceInfo];
    if (deviceInfoUUID && ![deviceInfoUUID isEqualToString:@""]) {
        [XYKeyChain setData:deviceInfoUUID serviceDomain:STR_XYUUIDForKeyChainAndDeviceOrIdfa];
        return deviceInfoUUID;
    }
    
    NSString *uuid = [self uuid];
    if (uuid && ![uuid isEqualToString:@""]) {
        [XYKeyChain setData:uuid serviceDomain:STR_XYUUIDForKeyChainAndDeviceOrIdfa];
        return uuid;
    }
    
    return @"";
}

@end
