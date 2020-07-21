//
//  AppDelegate.m
//  XYUUID
//
//  Created by steve on 2016/7/21.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import "AppDelegate.h"
#import "XYUUID.h"
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
    #import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        // 获取到权限后，依然使用老方法获取idfa
        if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            NSLog(@"%@",idfa);
        } else {
            NSLog(@"请在设置-隐私-Tracking中允许App请求跟踪");
        }
    }];
    
    NSString *uuid = [XYUUID uuid];
    NSLog(@"LOG uuid %@",uuid);

    NSString *uuidForInstall = [XYUUID uuidForInstall];
    NSLog(@"LOG uuidForInstall %@",uuidForInstall);

    NSString *uuidForAppOpen = [XYUUID uuidForAppOpen];
    NSLog(@"LOG uuidForAppOpen %@",uuidForAppOpen);

    NSString *uuidForIDFA = [XYUUID uuidForIDFA];
    NSLog(@"LOG uuidForIDFA %@",uuidForIDFA);

    NSString *uuidForIDFV = [XYUUID uuidForIDFV];
    NSLog(@"LOG uuidForIDFV %@",uuidForIDFV);

    NSString *uuidForDeviceInfo = [XYUUID uuidForDeviceInfo];
    NSLog(@"LOG uuidForDeviceInfo %@",uuidForDeviceInfo);

    NSString *uuidForKeychain = [XYUUID uuidForKeychain];
    NSLog(@"LOG uuidForKeychain %@",uuidForKeychain);

    NSString *uuidForDevice = [XYUUID uuidForDevice];
    NSLog(@"LOG uuidForDevice %@",uuidForDevice);
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
