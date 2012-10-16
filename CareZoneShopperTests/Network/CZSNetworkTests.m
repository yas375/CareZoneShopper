//
//  CZSNetworkTests.m
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 16.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import "CZSNetworkTests.h"
#import "CZSNetworkEngine.h"
#import "CZSCredentials.h"

@implementation CZSNetworkTests


- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatNetworkEngineInitializedWithAuthHeader {
    CZSNetworkEngine *engine = [CZSNetworkEngine sharedInstance];
    MKNetworkOperation *op = [engine operationWithPath:@"arr"];
    STAssertEqualObjects([op.readonlyRequest.allHTTPHeaderFields objectForKey:@"X-CZ-Authorization"],
                         kCZSServerToken,
                         @"auth header should be correct");
}

- (void)testThatNetworkEngineInitializedWithRightHostname {
    CZSNetworkEngine *engine = [CZSNetworkEngine sharedInstance];
    MKNetworkOperation *op = [engine operationWithPath:@"arr"];
    STAssertEqualObjects(op.readonlyRequest.URL.host,
                         kCZSServerHostName,
                         @"hostname should be like in credentials specified");
}

@end
