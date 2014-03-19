//
//  AppDelegate.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
-(void)showHomeView;
-(void)showErrorNotice:(NSString *)message;
-(void)showSuccessNotice;
-(BOOL)isNetWorkAvailableMethod;
@property FBSession *session;
@end
