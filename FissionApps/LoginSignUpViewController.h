//
//  LoginSignUpViewController.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"
#import "FPPopoverKeyboardResponsiveController.h"
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface LoginSignUpViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,FPPopoverControllerDelegate>

- (IBAction)Login_SignUpAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *usernameTf;
@property (strong, nonatomic) IBOutlet UITextField *passwordTf;
@property (strong, nonatomic) IBOutlet UITextField *confirmpasswrdTf;
@property UISwipeGestureRecognizer *leftSwipe;
@property UISwipeGestureRecognizer *rightSwipe;
@property (strong, nonatomic) IBOutlet UIPageControl *paging;
@property (strong, nonatomic) IBOutlet UIButton *signUpLoginBtn;
@property (strong, nonatomic) IBOutlet UIView *swipeView;
@property (strong, nonatomic) IBOutlet UIButton *SignUpBtn;
- (IBAction)SignUpActn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *LoginBtn;
- (IBAction)LoginActn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *UserButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vSpaceSignUpNow;

- (IBAction)NewUser:(id)sender;
-(BOOL)validateLoginFields;
-(BOOL)validateSignUpFields;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpaceView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *signtopSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpaceLogin;
@property (strong, nonatomic) IBOutlet UILabel *newuserLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topspacePswrd;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpaceLoginBtn;
@property UITapGestureRecognizer *tapScreen;
@property(nonatomic,strong)FPPopoverKeyboardResponsiveController * popover;
-(NSMutableAttributedString *)suggestedString:(NSString *)str;
@property NSMutableAttributedString *str;
@property NSMutableAttributedString *str2;
@property NSMutableAttributedString *str3;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vspaceLbl;

@end
