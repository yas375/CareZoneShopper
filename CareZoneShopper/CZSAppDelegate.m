//
//  CZSAppDelegate.m
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 16.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import "CZSAppDelegate.h"
#import "MagicalRecord+Setup.h"


@implementation CZSAppDelegate

- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStack];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

@end
