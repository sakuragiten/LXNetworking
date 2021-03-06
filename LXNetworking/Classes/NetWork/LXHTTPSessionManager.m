//
//  LXHTTPSessionManager.m
//  YDProject_Example
//
//  Created by louxunmac on 2019/5/16.
//  Copyright © 2019 387970107@qq.com. All rights reserved.
//

#import "LXHTTPSessionManager.h"


@interface LXHTTPSessionManager ()

@property(nonatomic, strong) AFHTTPSessionManager *manager;


@end

@implementation LXHTTPSessionManager

static LXHTTPSessionManager *lx_manager = nil;
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lx_manager = [[self alloc] init];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:[NSArray arrayWithObjects:@"text/plain",@"text/html",@"text/json", @"multipart/form-data", @"application/json", nil]];
        
        lx_manager.manager = manager;
        lx_manager.networkStatus = 2;   //默认4G
        [lx_manager startNewworkMotoring];
        
        
        
    });
    
    return lx_manager;
}

- (void)startNewworkMotoring
{
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.networkStatus = status;
        NSString *networkString = [self networkString];
        [[LXHTTPSessionManager shareManager].manager.requestSerializer setValue:networkString forHTTPHeaderField:@"clientNet"];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
 }



- (void)settingSessionManager:(void (^)(AFHTTPSessionManager * _Nonnull))handle
{
    !handle ? : handle(self.manager);
}


- (void)requestWithUrl:(NSString *)url params:(NSDictionary *)params requestType:(LXHTTPRequestType)requestType constructingBody:(void (^)(id<AFMultipartFormData> _Nonnull))block progress:(void(^)(NSProgress *downloadProgress))progress completionHandle:(LXRequestSessionHandle)handle
{
    [self requestWithUrl:url params:params requestType:requestType constructingBodyWithBlock:block progress:progress completionHandle:handle];
}

- (void)requestWithUrl:(NSString *)url params:(NSDictionary *)params  requestType:(LXHTTPRequestType)requestType constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void(^)(NSProgress *downloadProgress))progress completionHandle:(LXRequestSessionHandle)handle
{
    void (^success)(NSURLSessionDataTask * _Nonnull, id _Nullable) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !handle ? : handle(YES, responseObject, nil);
    };
    
    void (^failure)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !handle ? : handle(NO, nil, error);
    };
    
    
    if (requestType == GET) {
        [self.manager GET:url parameters:params progress:progress success:success failure:failure];
    } else if (requestType == POST) {
        if (block) {
            [self.manager POST:url parameters:params constructingBodyWithBlock:block progress:progress success:success failure:failure];
        } else {
             [self.manager POST:url parameters:params progress:progress success:success failure:failure];
        }
       
//
    }
}




- (NSString *)networkString
{
    switch (self.networkStatus) {
        case -1:
            return @"未知";
        case 0:
            return @"无网络";
        case 1:
            return @"4G";
        case 2:
            return @"WIFI";
        default:
            return @"未知";
    }
}



@end
