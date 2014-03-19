//
//  MyProfileViewController.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RNGridMenu.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "customCell1.h"
#import "customCell2.h"
#import "customCell3.h"
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface MyProfileViewController : UIViewController<UIGestureRecognizerDelegate,RNGridMenuDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *profiletable;

@property customCell1 *cell1;
@property customCell2 *cell2;
@property customCell3 *cell3;
@property BOOL isEditWork;
@property BOOL isEditBasicInfo;
@property BOOL isEditAbout;
@property NSDateFormatter* dateFormatter;
@property UITapGestureRecognizer *tapOnImage;

@property BOOL camera;

@property NSString *tfStr;
@property NSString *birthdayStr;
@property NSString *aboutStr;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableBottomSpace;
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element;
@property NSString *username;


@property NSString *myBirthday;
@property NSString *myDesignation;
@property NSString *myAbout;

@property NSDictionary *myProfileDetails;
@property NSString *profilePicUrl;
@end
