//
//  CZSNetworkEngine.m
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 16.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import "CZSNetworkEngine.h"
#import "CZSCredentials.h"

static NSString *const kCZSAuthHeader = @"X-CZ-Authorization";

@implementation CZSNetworkEngine


+ (id)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[CZSNetworkEngine alloc] initWithHostName:kCZSServerHostName
                                                customHeaderFields:@{ kCZSAuthHeader : kCZSServerToken }];
    });
    return _sharedObject;
}

@end
