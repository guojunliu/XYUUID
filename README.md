# XYUUID

### 背景

- iOS 10开始，IDFA可能会被用户限制广告追踪，导致无法正常获取IDFA，从而导致无法使用IDFA作为唯一设备标识


### XYUUID的优点

- API简单
- 使用了最新的iOS 14 API来获取IDFA
- 具有不能持久性级别的通用唯一标识符

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
|-----------------------|:----------:|:------------:|:----------------------------:|:-------------:|:-------------:|:--------------:|:------------:|
| `uuid `                |❌|❌|❌|❌|❌|❌|
| `uuidForInstall `      |✅|✅|❌|✅|✅|❌|
| `uuidForAppOpen `      |❌|✅|❌|❌|❌|❌|
| `uuidForIDFA `    	  |✅|❌|✅|✅|✅|❌|
| `uuidForIDFV `       	  |✅|✅|❌|✅|✅|❌|
| `uuidForDeviceInfo `   |✅|✅|✅|❌|❌|❌|
| `uuidForKeychain `     |✅|✅|✅|✅|✅|❌|
| `uuidForDevice `       |✅|✅|✅|✅|✅|❌|