//
//  LXURLManager.h
//  JMPanKeTong
//
//  Created by louxunmac on 2019/6/17.
//  Copyright © 2019 Qfang.com. All rights reserved.
//

#import <Foundation/Foundation.h>



#define lx_domain [[LXURLManager shareManager] get_lx_domain]
#define xf_domain [[LXURLManager shareManager] get_xf_domain]
#define zs_domain [[LXURLManager shareManager] get_zs_domain]
#define yd_domain [[LXURLManager shareManager] get_yd_domain]

#define lx_url(url) [[LXURLManager shareManager] lx_urlStringWithBaseUrl:url]
#define xf_url(url) [[LXURLManager shareManager] xf_urlStringWithBaseUrl:url]
#define zs_url(url) [[LXURLManager shareManager] zs_urlStringWithBaseUrl:url]
#define yd_url(url) [[LXURLManager shareManager] yd_urlStringWithBaseUrl:url]







@interface LXURLManager : NSObject

+ (instancetype)shareManager;

/**
 当前的环境
 */
@property(nonatomic, assign) NSInteger environment;

- (NSString *)get_lx_domain;
- (NSString *)get_xf_domain;
- (NSString *)get_zs_domain;
- (NSString *)get_yd_domain;

- (NSString *)lx_urlStringWithBaseUrl:(NSString *)baseUrl;

- (NSString *)xf_urlStringWithBaseUrl:(NSString *)baseUrl;

- (NSString *)zs_urlStringWithBaseUrl:(NSString *)baseUrl;

- (NSString *)yd_urlStringWithBaseUrl:(NSString *)baseUrl;

/**
 拼凑完整的url 不支持参数嵌套或者包含数组

 @param requestUrl 发起请求的url
 @param params 请求参数
 @return 返回拼凑完的url
 */
- (NSString *)absoluteUrlWithRequestUrl:(NSString *)requestUrl params:(NSDictionary *)params;




@end

