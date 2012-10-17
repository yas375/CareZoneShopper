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

static NSString *const kCZSHTTPMethodGet = @"GET";
static NSString *const kCZSHTTPMethodPost = @"POST";

static NSString *const kCZSItemsPath = @"items.json";


@implementation CZSNetworkEngine

+ (CZSNetworkEngine *)sharedEngine {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithHostName:kCZSServerHostName
                                    customHeaderFields:@{ kCZSAuthHeader : kCZSServerToken }];
    });
    return _sharedObject;
}


- (MKNetworkOperation *)listOfItemsWithCompletion:(CZSListResponseBlock)completionBlock
                                          onError:(MKNKErrorBlock)errorBlock {
    MKNetworkOperation *op = [self operationWithPath:kCZSItemsPath];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseJSON]);
    } onError:errorBlock];
    [self enqueueOperation:op];
    return op;
}

@end
