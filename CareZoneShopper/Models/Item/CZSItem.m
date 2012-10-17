//
//  CZSItem.m
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 17.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import "CZSItem.h"
#import "NSManagedObject+MagicalRecord.h"


@implementation CZSItem

@dynamic category;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic itemID;
@dynamic userID;
@dynamic name;

+ (CZSItem *)newFromDictionary:(NSDictionary *)dictionary {
    CZSItem *item = [CZSItem MR_createEntity];
    [item updateFieldsFromDictionary:dictionary];
    return item;
}

- (void)updateFieldsFromDictionary:(NSDictionary *)params {
    // could be optimized. For example by getting list of property names in runtime: https://github.com/MugunthKumar/MKFoundation/blob/master/MKFoundation/Classes/MKFoundation/MKObject%2BXMLExtensions.m#L100
    // but for now, for only one model let's leave it like below
    if ([params objectForKey:@"category"])
        self.category = [params objectForKey:@"category"];
    if ([params objectForKey:@"id"])
        self.itemID = [NSNumber numberWithInt:[[params objectForKey:@"id"] intValue]];
    if ([params objectForKey:@"user_id"])
        self.userID = [NSNumber numberWithInt:[[params objectForKey:@"user_id"] intValue]];
    if ([params objectForKey:@"name"])
        self.name = [params objectForKey:@"name"];

//    if ([params objectForKey:@"created_at"]) {
//        self.createdAt = [params objectForKey:@"created_at"];
//    }
//    if ([params objectForKey:@"updated_at"]) {
//        self.updatedAt = [params objectForKey:@"updated_at"];
//    }
}

@end
