//
//  CZSNetworkEngine.h
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 16.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import "MKNetworkEngine.h"

@class CZSItem;

#pragma mark - Responses
typedef void (^CZSListResponseBlock)(NSArray *list);
typedef void (^CZSItemResponseBlock)(NSDictionary *item);


@interface CZSNetworkEngine : MKNetworkEngine

+ (CZSNetworkEngine *)sharedEngine;

- (MKNetworkOperation *)listOfItemsWithCompletion:(CZSListResponseBlock)completionBlock
                                          onError:(MKNKErrorBlock)errorBlock;

- (MKNetworkOperation *)createNewItemWithName:(NSString *)name
                                     category:(NSString *)category
                                 onCompletion:(CZSItemResponseBlock)completionBlock
                                      onError:(MKNKErrorBlock)errorBlock;

- (MKNetworkOperation *)updateItem:(CZSItem *)item
                          withName:(NSString *)name
                          category:(NSString *)category
                      onCompletion:(CZSItemResponseBlock)completionBlock
                           onError:(MKNKErrorBlock)errorBlock;

- (MKNetworkOperation *)deleteItem:(CZSItem *)item
                      onCompletion:(MKNKResponseBlock)completionBlock
                           onError:(MKNKErrorBlock)errorBlock;

@end
