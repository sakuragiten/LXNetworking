//
//  LXURLManager.m
//  JMPanKeTong
//
//  Created by louxunmac on 2019/6/17.
//  Copyright © 2019 Qfang.com. All rights reserved.
//

#import "LXURLManager.h"


@interface LXURLManager ()

@property(nonatomic, copy) NSArray *lx_domains;
@property(nonatomic, copy) NSArray *xf_domains;
@property(nonatomic, copy) NSArray *zs_domains;
@property(nonatomic, copy) NSArray *yd_domains;
@property(nonatomic, copy) NSArray *un_domains;

@end



@implementation LXURLManager



static LXURLManager *url_manager = nil;
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url_manager = [[self alloc] init];
        
    });
    
    return url_manager;
}


- (NSString *)lx_urlStringWithBaseUrl:(NSString *)baseUrl
{
    return [NSString stringWithFormat:@"%@/%@", lx_domain, baseUrl];
}

- (NSString *)xf_urlStringWithBaseUrl:(NSString *)baseUrl
{
    return [NSString stringWithFormat:@"%@/%@", xf_domain, baseUrl];
}

- (NSString *)zs_urlStringWithBaseUrl:(NSString *)baseUrl
{
    return [NSString stringWithFormat:@"%@/%@", zs_domain, baseUrl];
}

- (NSString *)yd_urlStringWithBaseUrl:(NSString *)baseUrl
{
    if ([baseUrl hasPrefix:@":"] || [baseUrl hasPrefix:@"/"]) {
        return [NSString stringWithFormat:@"%@%@", yd_domain, baseUrl];
    }
    return [NSString stringWithFormat:@"%@/%@", yd_domain, baseUrl];
}

- (NSString *)un_urlStringWithBaseUrl:(NSString *)baseUrl
{
    return [NSString stringWithFormat:@"%@/%@", un_domain, baseUrl];
}


- (NSString *)absoluteUrlWithRequestUrl:(NSString *)requestUrl params:(NSDictionary *)params
{
    if (requestUrl.length == 0) return @"";
    
    if (params.allKeys.count == 0) return requestUrl;
    NSMutableString *baseUrl = [[NSMutableString alloc] initWithString:requestUrl];
    if (![requestUrl containsString:@"?"]) {
        [baseUrl appendString:@"?"];
    } else {
        [baseUrl appendFormat:@"&"];
    }
    for (int i = 0; i < params.allKeys.count; i ++) {
        NSString *key = params.allKeys[i];
        id obj = params[key];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *tmp = (NSArray *)obj;
            for (int j = 0; j < tmp.count; j ++) {
                id item = tmp[j];
                NSString *value = [NSString stringWithFormat:@"%@", item];
                [baseUrl appendString:[NSString stringWithFormat:@"%@=%@", key, value]];
                if (j < tmp.count - 1) [baseUrl appendFormat:@"&"];
            }
        } else {
            NSString *objStr = [NSString stringWithFormat:@"%@", params[key]];
            [baseUrl appendString:[NSString stringWithFormat:@"%@=%@", key, objStr]];
        }
        if (i < params.allKeys.count - 1) [baseUrl appendFormat:@"&"];
    }
    
    return baseUrl;
}



- (NSString *)get_lx_domain
{
    NSInteger e = self.environment;
    return self.lx_domains[e];
}


- (NSString *)get_xf_domain
{
    NSInteger e = self.environment;
    return self.xf_domains[e];
}


- (NSString *)get_zs_domain
{
    NSInteger e = self.environment;
    return self.zs_domains[e];
}

- (NSString *)get_yd_domain
{
    NSInteger e = self.environment;
    return self.yd_domains[e];
}

- (NSString *)get_un_domain
{
    NSInteger e = self.environment;
    return self.un_domains[e];
}


- (NSArray *)lx_domains
{
    if (!_lx_domains) {//@"http://39.108.162.76:9090"
        _lx_domains = @[@"http://10.1.220.5:9090", @"http://10.1.220.5:9090", @"https://zuul.louxun.com", @"https://zuul.louxun.com"];
    }
    return _lx_domains;
}

//http://192.168.0.67 http://alipaytest46.qfang.com
- (NSArray *)xf_domains
{
    if (!_xf_domains) {
//        _xf_domains = @[@"", @"http://192.168.0.67", @"http://yfb.louxun.com:82", @"http://xf.louxun.com"];
        _xf_domains = @[@"http://192.168.0.67", @"http://alipaytest46.qfang.com", @"http://yfb.louxun.com", @"http://xf.louxun.com"];
    }
    
    return _xf_domains;
}

- (NSArray *)zs_domains
{
    if (!_zs_domains) {
//        _zs_domains = @[@"", @"http://192.168.0.67", @"http://yfb.louxun.com:82", @"http://zs.louxun.com"];
        _zs_domains = @[@"http://192.168.0.67", @"http://alipaytest46.qfang.com", @"http://yfb.louxun.com", @"http://zs.louxun.com"];
    }
    return _zs_domains;
}

- (NSArray *)yd_domains
{
    if (!_yd_domains) {
        _yd_domains = @[@"http://10.1.221.232:9091", @"http://10.1.221.232:9091", @"http://yfb.louxun.com/marketing", @"http://xf.louxun.com/marketing"];
    }
    return _yd_domains;
}

- (NSArray *)un_domains
{
    if (!_un_domains) {
        _un_domains = @[@"http://10.1.221.232", @"http://10.1.221.232", @"http://yfb.louxun.com", @"http://xf.louxun.com"];
    }
    return _un_domains;
}



////接口域名
//#ifdef DEBUG
//static  NSString * const lx_domain             = @"http://10.1.220.5:9090";                 ///App
////static  NSString * const xf_domain             = @"http://192.168.0.67";                    ///qf
//static  NSString * const xf_domain             = @"http://alipaytest46.qfang.com";
////static  NSString * const zs_domain             = @"http://zs.louxun.com";                   ///qf
//static  NSString * const zs_domain             = @"http://alipaytest46.qfang.com";                   ///qf
//
//#elif PreRelease
//
//static  NSString * const lx_domain             = @"http://39.108.162.76:9090";
//static  NSString * const xf_domain             = @"http://yfb.louxun.com:82";                   ///qf
//static  NSString * const zs_domain             = @"http://yfb.louxun.com:82";                   ///qf
//
//#else
//
//
//static  NSString * const lx_domain             = @"http://zuul.louxun.com:9090";
//static  NSString * const xf_domain             = @"http://xf.louxun.com";                   ///qf
//static  NSString * const zs_domain             = @"http://zs.louxun.com";                   ///qf
//
//#endif


@end
