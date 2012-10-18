//
//  CZSNetworkEngine.m
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 16.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import "CZSNetworkEngine.h"
#import "CZSCredentials.h"
#import "CZSItem.h"


static NSString *const kCZSAuthHeader = @"X-CZ-Authorization";

static NSString *const kCZSHTTPMethodGet = @"GET";
static NSString *const kCZSHTTPMethodPost = @"POST";
static NSString *const kCZSHTTPMethodPut = @"PUT";

static NSString *const kCZSItemsPath = @"items.json";
#define ITEM_PATH(__C1__) [NSString stringWithFormat:@"items/%d.json", __C1__]


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
// TODO: handle errors from the server
- (MKNetworkOperation *)createNewItemWithName:(NSString *)name
                                     category:(NSString *)category
                                 onCompletion:(CZSItemResponseBlock)completionBlock
                                      onError:(MKNKErrorBlock)errorBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@{ @"name" : name, @"category" : category }
               forKey:@"item"];
    MKNetworkOperation *op = [self operationWithPath:kCZSItemsPath
                                              params:params
                                          httpMethod:kCZSHTTPMethodPost];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseJSON]);
    } onError:errorBlock];
    [self enqueueOperation:op];
    return op;
}
// TODO: handle errors from the server
- (MKNetworkOperation *)updateItem:(CZSItem *)item
                          withName:(NSString *)name
                          category:(NSString *)category
                      onCompletion:(CZSItemResponseBlock)completionBlock
                           onError:(MKNKErrorBlock)errorBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@{ @"name" : name, @"category" : category }
               forKey:@"item"];
    MKNetworkOperation *op = [self operationWithPath:ITEM_PATH([item.itemID intValue])
                                              params:params
                                          httpMethod:kCZSHTTPMethodPut];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseJSON]);
    } onError:errorBlock];
    [self enqueueOperation:op];
    return op;
}

@end
