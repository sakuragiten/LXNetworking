//
//  LXViewController.m
//  LXNetworking
//
//  Created by 387970107@qq.com on 10/21/2019.
//  Copyright (c) 2019 387970107@qq.com. All rights reserved.
//

#import "LXViewController.h"
#import <LXNetworking/LXNetworking.h>
@interface LXViewController ()

@end

@implementation LXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *url = zs_url(@"newhouse-web/info/login");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = @"16675589669";
    params[@"password"] = @"123456";
    params[@"source"] = @"APP";
    [LXNetworking requestFormWithPath:url params:params completionHandle:^(BOOL success, id responseObject, NSString *errorMsg) {
        NSLog(@"%@", responseObject);

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
