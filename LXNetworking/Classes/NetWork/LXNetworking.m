//
//  LXNetworking.m
//  YDProject_Example
//
//  Created by louxunmac on 2019/5/9.
//  Copyright © 2019 387970107@qq.com. All rights reserved.
//

#import "LXNetworking.h"
#import "LXHTTPSessionManager.h"
#import "LXNetwokingConfigManager.h"
#import "LXHttpCacheManager.h"

#define HTTP_RETURNCODE_SUCCESS         200
//IM 请求成功的返回状态码
#define HTTP_RETURNCODE_IM_SUCCESS      @"C0000"

///api版本控制
static NSString* const apiVersion = @"2.2.0";

@interface LXNetworking ()


@end


@implementation LXNetworking


+ (void)setupAndConfigurationForNewWorking
{
    
    LXNetwokingConfigManager *config = [LXNetwokingConfigManager shareManager];
    
    [[LXHTTPSessionManager shareManager] settingSessionManager:^(AFHTTPSessionManager * _Nonnull manager) {
        
        AFHTTPRequestSerializer *serializer = manager.requestSerializer;
        
        [serializer setValue:config.appVersion forHTTPHeaderField:@"version"];
        [serializer setValue:apiVersion forHTTPHeaderField:@"apiVersion"];  //???
        [serializer setValue:config.deviceId forHTTPHeaderField:@"deviceId"];
        
        ///浏览平台(1.安卓 2.IOS 3.PC 4.H5)
        [serializer setValue:@"2" forHTTPHeaderField:@"platform"];
        [serializer setValue:config.UUID forHTTPHeaderField:@"userUuid"];
        [serializer setValue:@"440300" forHTTPHeaderField:@"areaCode"];
        //areaCode
    }];
}


+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)key
{
    if (value.length == 0 || key.length == 0) return;
    
    [[LXHTTPSessionManager shareManager] settingSessionManager:^(AFHTTPSessionManager * _Nonnull manager) {
        
        AFHTTPRequestSerializer *serializer = manager.requestSerializer;
        
//        /440300
        [serializer setValue:value forHTTPHeaderField:key];
    }];
}

+ (void)requestGetWithPath:(NSString *)path params:(NSDictionary *)params cache:(BOOL)cache completionHandle:(LXRequestCompletionHandle)handle;
{
    if (cache) {
        [self requestGetFromCacheWithUrl:path params:params completionHandle:handle];
    } else {
        [self requestGetWithPath:path params:params completionHandle:handle];
    }
}

+ (void)requestGetFromCacheWithUrl:(NSString *)url params:(NSDictionary *)params completionHandle:(LXRequestCompletionHandle)completionHandle
{
   [self requestGetFromCacheWithUrl:url params:params update:NO completionHandle:completionHandle];
}

//请求数据 如果有缓存 先返回缓存数据 然后再返回请求成功的数据

+ (void)requestGetByCacheAndServerWithUrl:(NSString *)url params:params completionHandle:(LXRequestCompletionHandle)completionHandle
{
    [self requestGetFromCacheWithUrl:url params:params update:YES completionHandle:completionHandle];
}

+ (void)requestGetFromCacheWithUrl:(NSString *)url params:(NSDictionary *)params update:(BOOL)update completionHandle:(LXRequestCompletionHandle)completionHandle
{
    NSString *cachePath = [[LXURLManager shareManager] absoluteUrlWithRequestUrl:url params:params];
    NSLog(@"%@", cachePath);
    id obj = [[LXHttpCacheManager sharedManager] getCacheDataDictForKey:cachePath];
    BOOL cacheExist = obj;
    if (cacheExist) {
        !completionHandle ? : completionHandle(YES, obj, nil);
    }
    [LXNetworking requestGetWithPath:url params:params completionHandle:^(BOOL success, id responseObject, NSString *errorMsg) {
        BOOL release = [LXURLManager shareManager].environment == 3;
        if (success) {
            [[LXHttpCacheManager sharedManager] cacheDataDict:responseObject forKey:cachePath];
            //数据需要及时更新
            if (!cacheExist || update) {
                !completionHandle ? : completionHandle(success, responseObject, errorMsg);
            }
        } else if (cacheExist && release) {
            //请求失败 如果有缓存 并且是在生产环境则不显示报错  否则就要抛出错误
         } else {
            //数据需要及时更新
            !completionHandle ? : completionHandle(success, responseObject, errorMsg);
        }
    }];
}




+ (void)requestGetWithPath:(NSString *)path params:(NSDictionary *)params completionHandle:(LXRequestCompletionHandle)handle
{
    LXNetWorkingDomainType domainType = LXNetWorkingDomainLouXun;
    if (![path containsString:lx_domain]) {
        domainType = LXNetWorkingDomainQF;
    }
    
    [self requestGetWithPath:path domainType:domainType params:params completionHandle:handle];
}





+ (void)requestGetWithPath:(NSString *)path domainType:(LXNetWorkingDomainType)type params:(NSDictionary *)params completionHandle:(LXRequestCompletionHandle)handle
{
    [self requestWithPath:path domainType:type requestType:GET params:params constructingBody:nil completionHandle:handle];
}



+ (void)requestPostWithPath:(NSString *)path params:(NSDictionary *)params completionHandle:(LXRequestCompletionHandle)handle
{
    LXNetWorkingDomainType domainType = LXNetWorkingDomainLouXun;
    if (![path containsString:lx_domain]) {
        domainType = LXNetWorkingDomainQF;
    }
    [self requestPostWithPath:path domainType:domainType params:params completionHandle:handle];
}

+ (void)requestPostWithPath:(NSString *)path params:(NSDictionary *)params dataArray:(NSArray *)dataArray completionHandle:(LXRequestCompletionHandle)handle
{
    LXNetWorkingDomainType domainType = LXNetWorkingDomainLouXun;
    if (![path containsString:lx_domain]) {
        domainType = LXNetWorkingDomainQF;
    }
    [self requestWithPath:path domainType:domainType requestType:POST params:params constructingBody:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < dataArray.count; i ++) {
            NSData *data = dataArray[i];
            [formData appendPartWithFileData:data name:@"files" fileName:[NSString stringWithFormat:@"%d.png",i] mimeType:@"image/png"];
        }
    } completionHandle:handle];
}

+ (void)requestPostWithPath:(NSString *)path domainType:(LXNetWorkingDomainType)type params:(NSDictionary *)params completionHandle:(LXRequestCompletionHandle)handle
{
    [self requestWithPath:path domainType:type requestType:POST params:params constructingBody:nil completionHandle:handle];
}


+ (void)requestFormWithPath:(NSString *)url params:(NSDictionary *)params completionHandle:(LXRequestCompletionHandle)handle
{
    LXNetWorkingDomainType domainType = LXNetWorkingDomainLouXun;
    if (![url containsString:lx_domain]) {
        domainType = LXNetWorkingDomainQF;
    }
    [self requestWithPath:url domainType:domainType requestType:POST params:nil constructingBody:^(id<AFMultipartFormData> formData) {
        for (NSString *key in params.allKeys) {
            // 循环拿到所有参数进行拼接
            [formData appendPartWithFormData:[params[key] dataUsingEncoding:NSUTF8StringEncoding] name:key];
        }
    } completionHandle:handle];
    
}



+ (void)requestWithPath:(NSString *)path
             domainType:(LXNetWorkingDomainType)type
            requestType:(LXHTTPRequestType)requestType
                 params:(NSDictionary *)params
       constructingBody:(void(^)(id<AFMultipartFormData> formData))block completionHandle:(LXRequestCompletionHandle)handle
{
    [[LXHTTPSessionManager shareManager] settingSessionManager:^(AFHTTPSessionManager * _Nonnull manager) {
        
        AFHTTPRequestSerializer *serializer = manager.requestSerializer;
        
        [serializer willChangeValueForKey:@"timeoutInterval"];
        serializer.timeoutInterval = block ? 60 : 10;
        [serializer didChangeValueForKey:@"timeoutInterval"];
        
    }];
    NSInteger networkStatus = [LXHTTPSessionManager shareManager].networkStatus;
    [[LXHTTPSessionManager shareManager] requestWithUrl:path params:params requestType:requestType constructingBody:block completionHandle:^(BOOL success, id responseObj, NSError *error) {
        NSInteger returnCode = [responseObj[@"code"] integerValue];
        NSString *statusCode = [NSString stringWithFormat:@"%@", [responseObj objectForKey:@"status"]];
        if (success) {
            NSString *msg = responseObj[@"desc"] ? : @"";
            if (type == LXNetWorkingDomainQF) {
                msg = responseObj[@"message"] ? : @"";
            }
            
            if (returnCode == HTTP_RETURNCODE_SUCCESS || [statusCode isEqualToString:HTTP_RETURNCODE_IM_SUCCESS]) {
                !handle ? : handle(YES, responseObj, nil);
            } else {
                !handle ? : handle(NO, responseObj, msg);
                [self logFaileRequestWithPath:path params:params msg:msg];
            }
            
        } else {
            BOOL release = [LXURLManager shareManager].environment == 3;
            NSString *errorMsg = networkStatus < 1 || release ? @"网络错误,请稍后再试" : error.userInfo.description;
            !handle ? : handle(NO, responseObj, errorMsg);
            [self logFaileRequestWithPath:path params:params msg:error.userInfo.description];
        }
    }];

}







+ (void)logFaileRequestWithPath:(NSString *)path params:(NSDictionary *)params msg:(NSString *)msg
{
    NSString *jsonString = @"nil";
    if (params) {
        NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        jsonString = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"\n\n=====================requestInfo===============================\n\n"
          @"     url :  %@\n\n"
          @"  params :  %@\n\n"
          @"errorMsg :  %@\n\n"
          @"============================end=====================================\n\n -------", path, jsonString, msg);
}




@end
