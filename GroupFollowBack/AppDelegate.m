//
//  AppDelegate.m
//  GroupFollowBack
//
//  Created by Osama Rabie on 12/30/15.
//  Copyright © 2015 Osama Rabie. All rights reserved.
//

#import "AppDelegate.h"
#import "UICKeyChainStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    UICKeyChainStore* wrapper;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    wrapper = [UICKeyChainStore keyChainStore];
    
    if(![wrapper stringForKey:@"ff"])
    {
        [wrapper setString:[NSString stringWithFormat:@"%f###30",[[NSDate date] timeIntervalSince1970]]  forKey:@"ff"];
        [wrapper synchronize];
    }else
    {
        NSString* string = [wrapper stringForKey:@"ff"];
        NSTimeInterval lastInterval = [[[string componentsSeparatedByString:@"###"] objectAtIndex:0] floatValue];
        NSDate* lastDate = [NSDate dateWithTimeIntervalSince1970:lastInterval];
        NSDate * originalDate = [NSDate date];
        NSTimeInterval space = [originalDate timeIntervalSinceDate:lastDate];
        
        if(space >= 3600)
        {
            [wrapper setString:[NSString stringWithFormat:@"%f###30",[[NSDate date] timeIntervalSince1970]]  forKey:@"ff"];
            [wrapper synchronize];
        }
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
