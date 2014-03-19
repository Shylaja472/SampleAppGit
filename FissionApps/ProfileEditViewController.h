//
//  ProfileEditViewController.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/22/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import "THLabel.h"

#define backgroundHeaderColor [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1]

@interface ProfileEditViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,RNGridMenuDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate>

#pragma mark - profilePicSection
@property (strong, nonatomic) IBOutlet UIScrollView *topScroller;
@property (strong, nonatomic) IBOutlet UIImageView *myProfilePic;
@property UITapGestureRecognizer *tapOnImage;
@property (strong, nonatomic) IBOutlet THLabel *nameLabel;
@property BOOL camera;



#pragma mark - workSection
@property (strong, nonatomic) IBOutlet UIView *view_Work;
@property (strong, nonatomic) IBOutlet UITextField *DesignationTF;
@property (strong, nonatomic) IBOutlet UIButton *eidtWorkBtn;
- (IBAction)editWorkActn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *saveWorkBtn;
- (IBAction)saveWorkActn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelWorkBtn;
- (IBAction)cancelWorkActn:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *workHeight;

#pragma mark - birthdaySection
@property (strong, nonatomic) IBOutlet UIView *viewBasicInfo;
@property (strong, nonatomic) IBOutlet UIButton *burthdayBtn;
@property NSDateFormatter* dateFormatter;
@property NSString *birthdayStr;
- (IBAction)birthdayEdit:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *editUsernfoBtn;
- (IBAction)editUserInfoActn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *saveBasicOnfoBtn;
- (IBAction)saveBasicInfoActn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelBasicBtn;
- (IBAction)cancelBasicactn:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *basicHeight;


#pragma mark - aboutMeSection
@property (strong, nonatomic) IBOutlet UIView *viewAboutMe;
@property (strong, nonatomic) IBOutlet UITextView *aboutMeTextView;

@property (strong, nonatomic) IBOutlet UIButton *editAboutBtn;
- (IBAction)editAboutActn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *saveAboutBtn;
- (IBAction)saveAboutActn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelAboutBtn;
- (IBAction)cancelAboutActn:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *aboutheight;

@end
