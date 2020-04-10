//
//  LXHTTPSessionManager.h
//  YDProject_Example
//
//  Created by louxunmac on 2019/5/16.
//  Copyright © 2019 387970107@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


typedef void(^LXRequestSessionHandle)(BOOL success, id _Nullable responseObj, NSError * _Nullable error);

typedef NS_ENUM(NSUInteger, LXHTTPRequestType){
    GET = 1,
    POST = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface LXHTTPSessionManager : NSObject


+ (instancetype)shareManager;


/** 网络状况 */
@property(nonatomic, assign) NSInteger networkStatus;

/** sessionId */
@property (nonatomic, copy) NSString *appSid;


- (void)settingSessionManager:(void(^)(AFHTTPSessionManager *manager))handle;

- (void)requestWithUrl:(NSString *)url
                params:(NSDictionary *)params
           requestType:(LXHTTPRequestType)requestType
      constructingBody:(void(^)(id<AFMultipartFormData> formData))block
      completionHandle:(LXRequestSessionHandle)handle;


@end

NS_ASSUME_NONNULL_END
