//
//  XYKeyChain.h
//  XYUUID
//
//  Created by steve on 2016/7/21.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYKeyChain : NSObject

+ (BOOL)setData:(id)data serviceDomain:(NSString *)serviceDomain;

+ (id)getDataWithServiceDomain:(NSString *)serviceDomain;

+ (BOOL)deleteDataWithServiceDomain:(NSString *)serviceDomain;

@end
