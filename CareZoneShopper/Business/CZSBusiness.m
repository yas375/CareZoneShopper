//
//  CZSBusiness.m
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 17.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import "CZSBusiness.h"
#import "CZSItem.h"

@interface CZSBusiness ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation CZSBusiness

+ (CZSBusiness *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        // 2012-10-10T18:28:03Z
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    }
    return self;
}

#pragma mark - Data management

- (NSArray *)itemsFromNetworkArray:(NSArray *)arrayFromNetwork {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *params in arrayFromNetwork) {
        @autoreleasepool {
            CZSItem *item = [CZSItem MR_createEntity];
            if ([params objectForKey:@"category"])
                item.category = [params objectForKey:@"category"];
            if ([params objectForKey:@"id"])
                item.itemID = [NSNumber numberWithInt:[[params objectForKey:@"id"] intValue]];
            if ([params objectForKey:@"user_id"])
                item.userID = [NSNumber numberWithInt:[[params objectForKey:@"user_id"] intValue]];
            if ([params objectForKey:@"name"])
                item.name = [params objectForKey:@"name"];

            if ([params objectForKey:@"created_at"]) {
                item.createdAt = [self.dateFormatter dateFromString:[params objectForKey:@"created_at"]];
            }
            if ([params objectForKey:@"updated_at"]) {
                item.updatedAt = [self.dateFormatter dateFromString:[params objectForKey:@"updated_at"]];
            }
        }
    }

    return [NSArray arrayWithArray:array]; // to be imutable
}

@end
