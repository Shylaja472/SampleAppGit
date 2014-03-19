//
//  AppDelegate.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
   
    

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return YES;
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
-(void)showHomeView {
    UIStoryboard * mainStoryBaord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController * viewController = [mainStoryBaord instantiateViewControllerWithIdentifier:@"CustomTab"];
    UINavigationController *myNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

    [self.window setRootViewController:myNavigationController];
}

-(void)showLogin{
    UIStoryboard * mainStoryBaord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController * viewController = [mainStoryBaord instantiateViewControllerWithIdentifier:@""];
    UINavigationController *myNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self.window setRootViewController:myNavigationController];

}

-(void)showErrorNotice:(NSString *)message{
    
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.window title:@"Error" message:message];
    [notice setDelay:10.0];
    [notice setOriginY:20.0];
    [notice show];

    
}

-(void)showSuccessNotice{
    
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.window title:@"Link Saved Successfully"];
    [notice setOriginY:20.0];
    [notice show];

}


-(BOOL)isNetWorkAvailableMethod{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable){
        return NO;
        NSLog(@"There IS NO internet connection");
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
