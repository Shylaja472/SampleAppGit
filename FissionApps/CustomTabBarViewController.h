//
//  CustomTabBarViewController.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverKeyboardResponsiveController.h"
#import "FPPopoverController.h"
#import "CustomIOS7AlertView.h"

typedef enum{
    Home=0,NewsLetter=1,Events=2,Profile=3
}currentView;


@protocol customTabbarDelegate <NSObject>



@end



@interface CustomTabBarViewController : UIViewController<FPPopoverControllerDelegate,CustomIOS7AlertViewDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, assign) currentView viewName;

@property (weak,nonatomic)UIViewController *currentViewController;
@property (strong, nonatomic) IBOutlet UIView *placeHolder;
@property (strong, nonatomic) IBOutlet UIView *buttonsView;
- (IBAction)showSettings:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *seetingsbutton;
@property (strong, nonatomic) IBOutlet UIButton *homeBtn;
@property (strong, nonatomic) IBOutlet UIButton *newsLetterBtn;
@property (strong, nonatomic) IBOutlet UIButton *eventsBtn;

@property(nonatomic,strong)FPPopoverKeyboardResponsiveController * popover;

@property(nonatomic, assign)id <customTabbarDelegate>delegate;

@property UIPopoverController *popOverController;
@property CustomIOS7AlertView *alertViewPassword;
@property CustomIOS7AlertView *alertViewUsername;
@property UITextField *oldPswrdTf;
@property UITextField *NewPswrdText;
@property UITextField *confirmPswrdTf;

@property UITextField *oldUserTf;
@property UITextField *NewUserText;
@property (strong, nonatomic) IBOutlet UIView *container1;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
- (IBAction)navigateHome:(id)sender;
- (IBAction)showNewsLetter:(id)sender;

- (IBAction)eventsNavigate:(id)sender;


@end
