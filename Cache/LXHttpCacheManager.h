//
//  LXHttpCacheManager.h
//  JMPanKeTong
//
//  Created by louxunmac on 2019/6/17.
//  Copyright © 2019 Qfang.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHttpCacheManager : NSObject

+ (instancetype)sharedManager;



/**
 增
 */
- (void)cacheDataDict:(NSDictionary *)dataDict forKey:(NSString *)key;


/**
 查
 */
- (NSDictionary *)getCacheDataDictForKey:(NSString *)key;







/**
 缓存data

 @param data NSData 类型
 @param key 缓存的key
 */
- (void)cacheData:(NSData *)data forKey:(NSString *)key;



/**
 c获取缓存数据

 @param key 缓存的key
 @return 缓存的对象
 */
- (NSData *)getCacheDataForKey:(NSString *)key;





@end

NS_ASSUME_NONNULL_END
