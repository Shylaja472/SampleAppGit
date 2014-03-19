//
//  LoadingScreenViewController.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingScreenViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadAct;
@property (strong, nonatomic) IBOutlet UIImageView *loadimage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height;
@property NSDictionary *myProfileDetails;

@end
