//
//  XYKeyChain.m
//  XYUUID
//
//  Created by steve on 2016/7/21.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import "XYKeyChain.h"
#import <Security/Security.h>

@implementation XYKeyChain

+ (NSMutableDictionary *)getKeychainQueryMap:(NSString *)serviceDomain {
    
    NSMutableDictionary *queryMap = [[NSMutableDictionary alloc] init];
    [queryMap setObject:serviceDomain forKey:(__bridge id<NSCopying>)kSecAttrAccount];
    [queryMap setObject:serviceDomain forKey:(__bridge id<NSCopying>)kSecAttrService];
    [queryMap setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id<NSCopying>)kSecClass];
    [queryMap setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlock forKey:(__bridge id<NSCopying>)kSecAttrAccessible];
    return queryMap;
}

+ (BOOL)setData:(id)data serviceDomain:(NSString *)serviceDomain {
    NSMutableDictionary *queryMap = [self getKeychainQueryMap:serviceDomain];
    SecItemDelete((__bridge CFDictionaryRef)(queryMap));
    NSData *archivedData;
    if (@available(iOS 13.0, macOS 13.0, *)) {
        NSError *error;
        archivedData = [NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:YES error:&error];
        if (error) {
            return NO;
        }
    }
    else {
        archivedData = [NSKeyedArchiver archivedDataWithRootObject:data];
    }
    [queryMap setObject:archivedData forKey:(__bridge id<NSCopying>)(kSecValueData)];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)(queryMap), NULL);
    return status == errSecSuccess?YES:NO;
}

+ (id)getDataWithServiceDomain:(NSString *)serviceDomain {
    id data = nil;
    NSMutableDictionary *queryMap = [self getKeychainQueryMap:serviceDomain];
    [queryMap setObject:(id)kCFBooleanTrue forKey:(__bridge id<NSCopying>)(kSecReturnData)];
    [queryMap setObject:(__bridge id)(kSecMatchLimitOne) forKey:(__bridge id<NSCopying>)(kSecMatchLimit)];

    CFTypeRef result = NULL;
    CFDictionaryRef cfDicRef = (__bridge_retained CFDictionaryRef)queryMap;
    if (SecItemCopyMatching(cfDicRef, &result) == noErr) {
        
        if (@available(iOS 13.0, *)) {
            NSError *error;
            data = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSString class] fromData:(__bridge NSData*)result error:&error];
        }
        else {
            data = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData*)result];
        }
        CFRelease(result);
    }
    return data;
}

+ (BOOL)deleteDataWithServiceDomain:(NSString *)serviceDomain {
    NSMutableDictionary *queryMap = [self getKeychainQueryMap:serviceDomain];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)(queryMap));
    return status == errSecSuccess?YES:NO;
}

@end
