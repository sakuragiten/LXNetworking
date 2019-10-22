//
//  LXNetwokingConfigManager.m
//  YDProject_Example
//
//  Created by louxunmac on 2019/5/17.
//  Copyright © 2019 387970107@qq.com. All rights reserved.
//

#import "LXNetwokingConfigManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>

#import <Security/Security.h>


NSString * const KEY_UDID = @"com.louxun.broker";

@implementation LXNetwokingConfigManager


static LXNetwokingConfigManager *_manager = nil;

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [LXNetwokingConfigManager new];
        
        [_manager initialProperties];
    });
    
    return _manager;
}


- (void)initialProperties
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    
    _appVersion = info[@"CFBundleShortVersionString"];
    _device = [self getDeviceModelName];
    _systemVersion = [UIDevice currentDevice].systemVersion;
    
}

- (NSString *)getDeviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone_X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone_X";
    
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    return deviceModel;
}


///获取设备UUID
- (NSString *)UUID
{
    if (!_UUID) {
        NSString *uuid_local = [[NSUserDefaults standardUserDefaults] stringForKey:@"uuid_local"];
        if (uuid_local.length == 0) {
            uuid_local = [self md5StringWithString:[[NSUUID UUID] UUIDString].lowercaseString];
        }
        _UUID = uuid_local;
    }
    return _UUID;
}


- (NSString *)deviceId
{
    if (!_deviceId) {
        
        NSString *deviceId_keychain = [self getUDIDFromeKeychain:KEY_UDID];
        if (deviceId_keychain.length == 0) {
            NSLog(@"uuid不存在");
            //生成UUID
            CFUUIDRef puuid = CFUUIDCreate(nil);
            CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
            deviceId_keychain = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
            CFRelease(puuid);
            CFRelease(uuidString);
            NSLog(@"生成UUID：%@",deviceId_keychain);
            [self save:KEY_UDID data:deviceId_keychain];
        }
        _deviceId = deviceId_keychain;
    }

    return _deviceId;
}


- (NSString *)getUDIDFromeKeychain:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}


- (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}


//delete
- (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

//save
- (void)save:(NSString *)service data:(id)data {
    
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}



//32位十六进制
- (NSString *)md5StringWithString:(NSString *)baseString
{
    if (baseString.length == 0) return @"";
    
    const char *cStr = [baseString UTF8String];
    unsigned char result[32];
    
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString * resultStr = [NSString stringWithFormat:
                            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                            result[0], result[1], result[2], result[3],
                            result[4], result[5], result[6], result[7],
                            result[8], result[9], result[10], result[11],
                            result[12], result[13], result[14], result[15]
                            ];
    return [resultStr lowercaseString];
}





@end
