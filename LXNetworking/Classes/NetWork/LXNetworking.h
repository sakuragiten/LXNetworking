//
//  LXNetworking.h
//  YDProject_Example
//
//  Created by louxunmac on 2019/5/9.
//  Copyright © 2019 387970107@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LXURLManager.h"


typedef void(^LXRequestCompletionHandle)(BOOL success, id responseObject, NSString *errorMsg);


typedef NS_ENUM(NSUInteger, LXNetWorkingDomainType){
    LXNetWorkingDomainLouXun = 0,
    LXNetWorkingDomainQF = 1,
};



@interface LXNetworking : NSObject



/** 初始化设置 */
+ (void)setupAndConfigurationForNewWorking;


/**
 设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)key;

/**
 GET 请求
 
 @param path 请求的url
 @param params 请求参数
 @param handle 请求完成的回调
 */
+ (void)requestGetWithPath:(NSString *)path
                    params:(NSDictionary *)params
          completionHandle:(LXRequestCompletionHandle)handle;






/**
 GET 请求

 @param path 请求的url
 @param params 请求参数
 @param cache 是否需要缓存
 @param handle 请求完成的回调
 */
+ (void)requestGetWithPath:(NSString *)path
                    params:(NSDictionary *)params
                     cache:(BOOL)cache
          completionHandle:(LXRequestCompletionHandle)handle;


/**
 GET 请求 优先拿缓存数据

 @param url 请求的url
 @param params 请求参数
 @param completionHandle 请求完成的回调
 */
+ (void)requestGetFromCacheWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                  completionHandle:(LXRequestCompletionHandle)completionHandle;




/**
 POST 请求
 
 @param path 请求的url
 @param params 请求参数
 @param handle 请求完成的回调
 */
+ (void)requestPostWithPath:(NSString *)path
                    params:(NSDictionary *)params
          completionHandle:(LXRequestCompletionHandle)handle;




/**
 POST请求 form-data 的形式
 
 @param path 请求的url
 @param params 请求参数
 @param handle 请求完成的回调
 */
+ (void)requestFormWithPath:(NSString *)url
                    params:(NSDictionary *)params
          completionHandle:(LXRequestCompletionHandle)handle;



/**
 Post 请求
 
 @param path 请求的url
 @param type 域名类型
 @param params 请求参数
 @param handle 请求完成的回调
 */
+ (void)requestPostWithPath:(NSString *)path
                domainType:(LXNetWorkingDomainType)type
                    params:(NSDictionary *)params
          completionHandle:(LXRequestCompletionHandle)handle;






/**
 Post 上传图片
 
 @param path 请求的url
 @param params 请求参数
 @param handle 请求完成的回调
 */
+ (void)requestPostWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  dataArray:(NSArray *)dataArray
           completionHandle:(LXRequestCompletionHandle)handle;




@end

