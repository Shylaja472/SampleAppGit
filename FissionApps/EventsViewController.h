//
//  EventsViewController.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface EventsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SDWebImageManagerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *recentBirthdays;

- (IBAction)Loginfacebook:(id)sender;

@property NSMutableDictionary *fbFriendsDetail;
@property NSString *profilePicUrl;
@property NSMutableArray *friendDetailsArray;
@property (strong, nonatomic) IBOutlet UIImageView *fbLogoimage;
@property (strong, nonatomic) IBOutlet UIButton *fbConnectBTn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpaceCnctFB;

@property UIImageView *downloadImage;

@property NSMutableArray *todaysBirthday;
@end

