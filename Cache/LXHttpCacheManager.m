//
//  LXHttpCacheManager.m
//  JMPanKeTong
//
//  Created by louxunmac on 2019/6/17.
//  Copyright © 2019 Qfang.com. All rights reserved.
//

#import "LXHttpCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

#define kDocPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kCachePath [NSString stringWithFormat:@"%@/RequestData", kDocPath]

@implementation LXHttpCacheManager



static LXHttpCacheManager *_manager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [LXHttpCacheManager new];
    });
    
    return _manager;
}



#pragma mark - 增

/// 针对字典数据
- (void)cacheDataDict:(NSDictionary *)dataDict forKey:(NSString *)key
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    [self cacheData:data forKey:key];
}



/// NSData 类型数据
- (void)cacheData:(NSData *)data forKey:(NSString *)key
{
    if (key.length == 0) return;
    NSString *filePath = [kCachePath stringByAppendingPathComponent:[self md5StringWithString:key]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self storeData:data atFilePath:filePath];
    });
}




- (void)storeData:(NSData *)data atFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = filePath.stringByDeletingLastPathComponent;
    NSError *error;
    if (![fileManager fileExistsAtPath:directory]) {
        //文件路径不存在  先创建对应的文件路径
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    BOOL success = [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
    if (!success && error) {
        NSLog(@"%@", error.userInfo);
    }

}




#pragma mark - 查
- (NSDictionary *)getCacheDataDictForKey:(NSString *)key
{
    
    
    NSData *data = [self getCacheDataForKey:key];
    if (!data) return nil;
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    return dataDict;
}

- (NSData *)getCacheDataForKey:(NSString *)key
{
    if (key.length == 0) return nil;
    NSString *filePath = [kCachePath stringByAppendingPathComponent:[self md5StringWithString:key]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        //如果缓存数据存在
        return [NSData dataWithContentsOfFile:filePath];
    }
    
    return nil;
}

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
///var/mobile/Containers/Data/Application/F49C74AD-7278-40B4-8F7A-CB83A48A56DA/Library/Caches/CacheData/3ccb19e064ec515c660b6864f0555d6b
///var/mobile/Containers/Data/Application/82E88C23-DC91-4745-BE47-09DFEF91F2CB/Library/Caches/CacheData/3ccb19e064ec515c660b6864f0555d6b
