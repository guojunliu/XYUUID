# XYUUID


[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen)](https://github.com/guojunliu/XYUUID/blob/master/LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](https://github.com/guojunliu/XYUUID)
[![GitHub Release](https://img.shields.io/badge/release-v1.0.0-orange)](https://github.com/guojunliu/XYUUID/releases/tag/1.0.0)
[![Github All Releases](https://img.shields.io/badge/downloads-41KB-yellowgreen)](https://github.com/guojunliu/XYUUID/files/5116427/XYUUID.zip)
[![Github Platform](https://img.shields.io/badge/platform-iOS-red)]()

### 背景

- iOS 10开始，IDFA可能会被用户限制广告追踪，导致无法正常获取IDFA，从而导致无法使用IDFA作为唯一设备标识


### XYUUID的优点

- API简单
- 使用了最新的iOS 14 API来获取IDFA
- 具有不同持久性级别的通用唯一标识符

### uuidForDevice的有点

- 较长的时效性
- 较长的存储性
- 较低的冲突率
- 较低的漂移率

### API

获取不同持久化级别的UUID

```
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

```

### 持久化级别


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
