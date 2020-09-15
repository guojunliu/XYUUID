//
//  ViewController.m
//  XYUUID
//
//  Created by steve on 2016/7/21.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import "ViewController.h"
#import "XYUUID.h"
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
    #import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif
#import <AdSupport/AdSupport.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary *_dic;
    UITableView *_tableView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    _dic = [[NSMutableDictionary alloc] init];
    [_dic setValue:uuid forKey:@"1、uuid"];
    [_dic setValue:uuidForInstall forKey:@"2、uuidForInstall"];
    [_dic setValue:uuidForAppOpen forKey:@"3、uuidForAppOpen"];
    [_dic setValue:uuidForIDFA forKey:@"4、uuidForIDFA"];
    [_dic setValue:uuidForIDFV forKey:@"5、uuidForIDFV"];
    [_dic setValue:uuidForDeviceInfo forKey:@"6、uuidForDeviceInfo"];
    [_dic setValue:uuidForKeychain forKey:@"7、uuidForKeychain"];
    [_dic setValue:uuidForDevice forKey:@"8、uuidForDevice"];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *keyArray  = [[_dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
      NSString *item1 = obj1;
      NSString *item2 = obj2;
      return [item1 compare:item2 options:NSLiteralSearch];
    }];
    NSString *key = [keyArray objectAtIndex:indexPath.row];
    NSString *value = [_dic objectForKey:key];
    
    NSString *str = [NSString stringWithFormat:@"%@\n%@\n",key,value];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@ 已复制到剪贴板",str] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dic allKeys].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSArray *keyArray  = [[_dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
      NSString *item1 = obj1;
      NSString *item2 = obj2;
      return [item1 compare:item2 options:NSLiteralSearch];
    }];
    NSString *key = [keyArray objectAtIndex:indexPath.row];
    NSString *value = [_dic objectForKey:key];
    cell.textLabel.text = key;
    cell.detailTextLabel.text = value;
    return cell;
}

@end
