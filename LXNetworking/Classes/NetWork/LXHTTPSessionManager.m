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
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:[NSArray arrayWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json", nil]];
        
        lx_manager.manager = manager;
        lx_manager.networkStatus = 2;   //默认4G
        [lx_manager startNewworkMotoring];
        
        
        
    });
    
    return lx_manager;
}


- (void)startNewworkMotoring
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:@"networkStatus" object:nil];
}

- (void)networkChanged:(NSNotification *)notification
{
    self.networkStatus = [notification.object integerValue];
}


- (void)settingSessionManager:(void (^)(AFHTTPSessionManager * _Nonnull))handle
{
    !handle ? : handle(self.manager);
}


- (void)requestWithUrl:(NSString *)url params:(NSDictionary *)params requestType:(LXHTTPRequestType)requestType constructingBody:(void (^)(id<AFMultipartFormData> _Nonnull))block completionHandle:(LXRequestSessionHandle)handle
{
    [self requestWithUrl:url params:params requestType:requestType constructingBodyWithBlock:block progress:nil completionHandle:handle];
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








@end
