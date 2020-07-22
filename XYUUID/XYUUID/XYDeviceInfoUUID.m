//
//  XYDeviceInfoUUID.m
//  XYUUID
//
//  Created by steve on 2016/7/21.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDeviceInfoUUID.h"
#import <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation XYDeviceInfoUUID

static NSString *systemBootTime(){
    struct timeval boottime;
    size_t len = sizeof(boottime);
    int mib[2] = { CTL_KERN, KERN_BOOTTIME };
    
    if( sysctl(mib, 2, &boottime, &len, NULL, 0) < 0 )
    {
        return @"";
    }
    time_t bsec = boottime.tv_sec / 10000;
    
//    time_t bsec = 1476249507 / 10000;   //  2016/10/11 13:18:27
//    time_t bsec = 1476249507 / 10000;   //  2015/10/11 13:18:27
    
    NSString *bootTime = [NSString stringWithFormat:@"%ld",bsec];
    
    return bootTime;
}

static NSString *countryCode() {
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    return countryCode;
}

static NSString *language() {
    NSString *language;
    NSLocale *locale = [NSLocale currentLocale];
    if ([[NSLocale preferredLanguages] count] > 0) {
        language = [[NSLocale preferredLanguages]objectAtIndex:0];
    } else {
        language = [locale objectForKey:NSLocaleLanguageCode];
    }
    
    return language;
}

static NSString *systemVersion() {
    return [[UIDevice currentDevice] systemVersion];
}

static NSString *deviceName(){
    return [[UIDevice currentDevice] name];
}


static const char *SIDFAModel =       "hw.model";
static const char *SIDFAMachine =     "hw.machine";
static NSString *getSystemHardwareByName(const char *typeSpecifier) {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithUTF8String:answer];
    free(answer);
    return results;
}

static NSUInteger getSysInfo(uint typeSpecifier) {
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

static NSString *carrierInfo() {
    NSMutableString* cInfo = [NSMutableString string];
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    NSString *carrierName = [carrier carrierName];
    if (carrierName != nil){
        [cInfo appendString:carrierName];
    }
    
    NSString *mcc = [carrier mobileCountryCode];
    if (mcc != nil){
        [cInfo appendString:mcc];
    }
    
    NSString *mnc = [carrier mobileNetworkCode];
    if (mnc != nil){
        [cInfo appendString:mnc];
    }
    
    return cInfo;
}


static NSString *systemHardwareInfo(){
    NSString *model = getSystemHardwareByName(SIDFAModel);
    NSString *machine = getSystemHardwareByName(SIDFAMachine);
    NSString *carInfo = carrierInfo();
    NSUInteger totalMemory = getSysInfo(HW_PHYSMEM);
    
    return [NSString stringWithFormat:@"%@,%@,%@,%td",model,machine,carInfo,totalMemory];
}



static NSString *systemFileTime(){
    NSFileManager *file = [NSFileManager defaultManager];
    NSDictionary *dic= [file attributesOfItemAtPath:@"System/Library/CoreServices" error:nil];
    return [NSString stringWithFormat:@"%@,%@",[dic objectForKey:NSFileCreationDate],[dic objectForKey:NSFileModificationDate]];
}

static NSString *disk(){
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSString *diskSize = [[fattributes objectForKey:NSFileSystemSize] stringValue];
    return diskSize;
}

static void MD5_16(NSString *source, unsigned char *ret){
    const char* str = [source UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    for(int i = 4; i < CC_MD5_DIGEST_LENGTH - 4; i++) {
        ret[i-4] = result[i];
    }
}

static NSString *combineTwoFingerPrint(unsigned char *fp1,unsigned char *fp2){
    NSMutableString *hash = [NSMutableString stringWithCapacity:36];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i+=1)
    {
        if (i==4 || i== 6 || i==8 || i==10)
            [hash appendString:@"-"];
        
        if (i < 8) {
            [hash appendFormat:@"%02X",fp1[i]];
        }else{
            [hash appendFormat:@"%02X",fp2[i-8]];
        }
    }
    
    return hash;
}

+ (NSString *)createDeviceInfoUUID {
    NSString *sysBootTime = systemBootTime();
    NSString *countryC= countryCode();
    NSString *languge = language();
    NSString *deviceN = deviceName();
    
    NSString *sysVer = systemVersion();
    NSString *systemHardware = systemHardwareInfo();
    NSString *systemFT = systemFileTime();
    NSString *diskS = disk();
    
    NSString *fingerPrintUnstablePart = [NSString stringWithFormat:@"%@,%@,%@,%@", sysBootTime, countryC, languge, deviceN];
    NSString *fingerPrintStablePart = [NSString stringWithFormat:@"%@,%@,%@,%@", sysVer, systemHardware, systemFT, diskS];
    
    unsigned char fingerPrintUnstablePartMD5[CC_MD5_DIGEST_LENGTH/2];
    MD5_16(fingerPrintUnstablePart,fingerPrintUnstablePartMD5);
    
    unsigned char fingerPrintStablePartMD5[CC_MD5_DIGEST_LENGTH/2];
    MD5_16(fingerPrintStablePart,fingerPrintStablePartMD5);
    
    NSString *simulateIDFA = combineTwoFingerPrint(fingerPrintStablePartMD5,fingerPrintUnstablePartMD5);
    return simulateIDFA;
}

@end
