//
//  AppDelegate.m
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 18/10/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //registro per fare da login alla captive
    NSString *values[] = {@"uniroma2-cp-NG"};
    CFArrayRef arrayRef = CFArrayCreate(kCFAllocatorDefault, (void *)values, (CFIndex)1, &kCFTypeArrayCallBacks);
    
    if(CNSetSupportedSSIDs(arrayRef))
        NSLog(@"Successfully registered supported network SSIDs");
    else
        NSLog(@"Error: Failed to register supported network SSIDs");
    
    //prima volta tutorial, altrimenti vado in home
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first_access"]) {
        
        UWTutorialController* tutorialController = [[UWTutorialController alloc]
                                                        initWithNibName:@"UWTutorialController"
                                                        bundle:nil];
        self.window.rootViewController = tutorialController;
        
        
        //keychain
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UniWifi" accessGroup:nil];
        [wrapper resetKeychainItem];
        [wrapper setObject:@"" forKey:(__bridge id)kSecAttrAccount];
        [wrapper setObject:@"" forKey:(__bridge id)kSecValueData];
        
    }else{
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        UWHomeViewController *yourController = (UWHomeViewController *)[mainStoryboard
                                                                    instantiateViewControllerWithIdentifier:@"RootViewController"];
        self.window.rootViewController = yourController;
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
