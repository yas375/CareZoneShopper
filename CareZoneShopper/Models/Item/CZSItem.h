//
//  CZSItem.h
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 17.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CZSItem : NSManagedObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSNumber *itemID;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *name;

@end
