//
//  CZSBusiness.h
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 17.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

@interface CZSBusiness : NSObject

+ (CZSBusiness *)sharedInstance;

#pragma mark - Data management
// returns the array of unsaved CZSItem objects from arrayFromNetwork
- (NSArray *)itemsFromNetworkArray:(NSArray *)arrayFromNetwork;

@end
