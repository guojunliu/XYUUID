# XYUUID

![Alt text](logo.png)

[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen)](https://github.com/guojunliu/XYUUID/blob/master/LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](https://github.com/guojunliu/XYUUID)
[![GitHub Release](https://img.shields.io/badge/release-v1.0.0-orange)](https://github.com/guojunliu/XYUUID/releases/tag/1.0.0)
[![Cocopods](https://img.shields.io/cocoapods/v/XYUUID.svg?style=flat)](https://cocoapods.org/pods/XYUUID)
[![Github All Releases](https://img.shields.io/badge/downloads-41KB-yellowgreen)](https://github.com/guojunliu/XYUUID/files/5116427/XYUUID.zip)
[![Github Platform](https://img.shields.io/badge/platform-iOS-red)]()

English | [简体中文](README-cn.md)

### Installation

##### CocoaPods:
- `pod'XYUUID'`

##### Manual integration:
- Copy the `XYUUID` folder to your project

### Background

- Starting from iOS 10, IDFA may be restricted by users from ad tracking, resulting in the inability to obtain IDFA normally, thus making it impossible to use IDFA as a unique device identifier


### Advantages of XYUUID

- Simple API
- Use the latest iOS 14 API to get IDFA
- Universally unique identifiers with different persistence levels

### Advantages of uuidForDevice

- onger timeliness
- Long storage
- Lower conflict rate
- Lower drift rate

### API

Get UUIDs of different persistence levels

```
/// Random UUID, this value will be refreshed every time
+ (NSString *)uuid;

/// Install UUID, this value will be refreshed every time you reinstall
+ (NSString *)uuidForInstall;

/// Open the application UUID, this value will be refreshed every time the application is opened
+ (NSString *)uuidForAppOpen;

/// IDFA, open and close authorization, this value will be refreshed
+ (NSString *)uuidForIDFA;

/// IDFV
+ (NSString *)uuidForIDFV;

/// Device information UUID, generated according to device information, can remain unchanged for a period of time
+ (NSString *)uuidForDeviceInfo;

/// Keychain UUID, uninstall application remains unchanged
+ (NSString *)uuidForKeychain;

/// Device UUID, the unique identifier of the device
+ (NSString *)uuidForDevice;

```

### Persistence level


| UUID              	 | App relaunch | Reset Advertising Identifier | App reinstall | System reboot | System upgrade | System reset |
|-----------------------|:----------:|:------------:|:----------------------------:|:-------------:|:-------------:|:--------------:|
| `uuid `                |❌|❌|❌|❌|❌|❌|
| `uuidForInstall `      |✅|✅|❌|✅|✅|❌|
| `uuidForAppOpen `      |❌|✅|❌|❌|❌|❌|
| `uuidForIDFA `    	  |✅|❌|✅|✅|✅|❌|
| `uuidForIDFV `       	  |✅|✅|❌|✅|✅|❌|
| `uuidForDeviceInfo `   |✅|✅|✅|❌|❌|❌|
| `uuidForKeychain `     |✅|✅|✅|✅|✅|❌|
| `uuidForDevice `       |✅|✅|✅|✅|✅|❌|