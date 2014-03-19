//
//  CustomTabBarViewController.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "LoginSignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#define PASSWORD 1
#define USERNAME 2
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController
@synthesize popover;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
    _alertViewPassword.tag=PASSWORD;
    _alertViewUsername.tag=USERNAME;
    
    
    
    if (IOS_VERSION<7.0) {
        _topSpace.constant=-20;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"320X44-orange.png"] forBarMetrics:UIBarMetricsDefault];
    }else{
        _topSpace.constant=0;
        NSLog(@"self.view %f",self.view.frame.origin.y);

        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"320X64-orange.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.navigationController.topViewController setTitle:@"Home"];
    NSDictionary *normaltextAttr =
    @{UITextAttributeTextColor : [UIColor whiteColor],
      UITextAttributeTextShadowColor : [UIColor  clearColor],
      UITextAttributeFont : [UIFont fontWithName:@"Baskerville-Bold" size:20.f]};
    [[UINavigationBar appearance] setTitleTextAttributes:normaltextAttr];
    
    [self.navigationController.navigationBar setTitleTextAttributes:normaltextAttr];

    
    [self performSegueWithIdentifier:@"homeSegue" sender:[self.buttonsView.subviews objectAtIndex:0]];
    UIButton *button = (UIButton *)[self.buttonsView.subviews objectAtIndex:0];
    [button setSelected:YES];
    _viewName=Home;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"homeSegue"]){
        
        
        if(self.childViewControllers.count >= 2)
        {
            UIViewController *initialViewController = [self.childViewControllers lastObject];
            NSLog(@"child view controllers %@",self.childViewControllers);
            
            [self addChildViewController:segue.destinationViewController];
            [self.container1 addSubview:((UIViewController *)segue.destinationViewController).view];
            
//            [self transitionFromViewController:initialViewController toViewController:segue.destinationViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{} completion:^(BOOL finished) {
                //Once the transition is complete, remove the initial view controller and add the new one
                
               
                [initialViewController.view removeFromSuperview];
                [initialViewController removeFromParentViewController];

                
                [segue.destinationViewController didMoveToParentViewController:self];
                self.delegate = segue.destinationViewController;
                
                
          //  }];
        }else
        {
            [self addChildViewController:segue.destinationViewController];
            
            [self.container1 addSubview:((UIViewController *)segue.destinationViewController).view];
            self.delegate = segue.destinationViewController;
            [segue.destinationViewController didMoveToParentViewController:self];
            
            
        }
        [self.navigationController.topViewController setTitle:@"Home"];
        
        for (int i=0; i<[self.buttonsView.subviews count];i++) {
            UIButton *button = (UIButton *)[self.buttonsView.subviews objectAtIndex:i];
            [button setSelected:NO];
        }
        
        UIButton *button = (UIButton *)sender;
        [button setSelected:YES];
        


    }else if ([segue.identifier isEqualToString:@"newsSegue"]){
        [self.navigationController.topViewController setTitle:@"News Letter"];
        
        for (int i=0; i<[self.buttonsView.subviews count];i++) {
            UIButton *button = (UIButton *)[self.buttonsView.subviews objectAtIndex:i];
            [button setSelected:NO];
        }
        
        UIButton *button = (UIButton *)sender;
        [button setSelected:YES];
        if(self.childViewControllers.count >= 1)
        {
            
            
            UIViewController *initialViewController = [self.childViewControllers lastObject];
            NSLog(@"child view controllers %@",self.childViewControllers);

            
            [self addChildViewController:segue.destinationViewController];
            [self.container1 addSubview:((UIViewController *)segue.destinationViewController).view];
            
//            [self transitionFromViewController:initialViewController toViewController:segue.destinationViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
//                //Once the transition is complete, remove the initial view controller and add the new one
            
                    [initialViewController.view removeFromSuperview];
                    [initialViewController removeFromParentViewController];
                    
                    
                    [segue.destinationViewController didMoveToParentViewController:self];
                    self.delegate = segue.destinationViewController;
                
          //  }];
        }else
        {
            [self addChildViewController:segue.destinationViewController];
            
            [self.container1 addSubview:((UIViewController *)segue.destinationViewController).view];
            self.delegate = segue.destinationViewController;
            [segue.destinationViewController didMoveToParentViewController:self];
            
            
        }
        
        
    }else if ([segue.identifier isEqualToString:@"eventsSegue"]){
        
        if(self.childViewControllers.count >= 1)
        {
            UIViewController *initialViewController = [self.childViewControllers lastObject];
            NSLog(@"child view controllers %@",self.childViewControllers);
            
            [self addChildViewController:segue.destinationViewController];
            [self.container1 addSubview:((UIViewController *)segue.destinationViewController).view];
            
//            [self transitionFromViewController:initialViewController toViewController:segue.destinationViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
//                //Once the transition is complete, remove the initial view controller and add the new one
            
                [initialViewController.view removeFromSuperview];
                [initialViewController removeFromParentViewController];
                
                
                [segue.destinationViewController didMoveToParentViewController:self];
                self.delegate = segue.destinationViewController;
                
           // }];
        }else
        {
            [self addChildViewController:segue.destinationViewController];
            
            [self.container1 addSubview:((UIViewController *)segue.destinationViewController).view];
            self.delegate = segue.destinationViewController;
            [segue.destinationViewController didMoveToParentViewController:self];
            
            
        }

        
        [self.navigationController.topViewController setTitle:@"Events"];

        for (int i=0; i<[self.buttonsView.subviews count];i++) {
            UIButton *button = (UIButton *)[self.buttonsView.subviews objectAtIndex:i];
            [button setSelected:NO];
        }
        
        UIButton *button = (UIButton *)sender;
        [button setSelected:YES];
        
    }else if ([segue.identifier isEqualToString:@"Profilesegue"]){
        
        
        if(self.childViewControllers.count >= 1)
        {
            UIViewController *initialViewController = [self.childViewControllers lastObject];
            NSLog(@"child view controllers %@",self.childViewControllers);
            
            [self addChildViewController:segue.destinationViewController];
            [self.container1 addSubview:((UIViewController *)segue.destinationViewController).view];
            
//            [self transitionFromViewController:initialViewController toViewController:segue.destinationViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
//                //Once the transition is complete, remove the initial view controller and add the new one
            
                [initialViewController.view removeFromSuperview];
                [initialViewController removeFromParentViewController];
                
                
                [segue.destinationViewController didMoveToParentViewController:self];
                self.delegate = segue.destinationViewController;
                
          //  }];
        }else
        {
            [self addChildViewController:segue.destinationViewController];
            
            [self.container1 addSubview:((UIViewController *)segue.destinationViewController).view];
            self.delegate = segue.destinationViewController;
            [segue.destinationViewController didMoveToParentViewController:self];
            
            
        }
        

        [self.navigationController.topViewController setTitle:@"Profile"];

    }
}


- (IBAction)showSettings:(id)sender {
    
    //========Popover views======
    UIViewController *popVC=[[UIViewController alloc]init];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 170, 130)];
    view1.backgroundColor=[UIColor whiteColor];
    view1.layer.cornerRadius=2.0;
    UIImage *dividerImage=[UIImage imageNamed:@"line.png"];
    
    UIImageView *div1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 170, 1)];
    UIImageView *div2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 80, 170, 1)];
//    UIImageView *div3=[[UIImageView alloc]initWithFrame:CGRectMake(0, 120, 180, 1)];
    div1.image=dividerImage;
    div2.image=dividerImage;
//    div3.image=dividerImage;
    
    
    UIButton *changePswrd=[UIButton buttonWithType:UIButtonTypeCustom];
    changePswrd.frame=CGRectMake(0, 0, 170, 40);
    [changePswrd setTitle:@"Change Password" forState:UIControlStateNormal];
    [changePswrd.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    [changePswrd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changePswrd addTarget:self action:@selector(changePswrdAcn:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIButton *changeUsername=[UIButton buttonWithType:UIButtonTypeCustom];
//    changeUsername.frame=CGRectMake(0,40, 180, 40);
//    [changeUsername.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
//    [changeUsername setTitle:@"Change Username" forState:UIControlStateNormal];
//    [changeUsername setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [changeUsername addTarget:self action:@selector(changeUsername:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *Profile=[UIButton buttonWithType:UIButtonTypeCustom];
    Profile.frame=CGRectMake(0,40, 170, 40);
    [Profile.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    [Profile setTitle:@"Profile" forState:UIControlStateNormal];
    [Profile setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Profile addTarget:self action:@selector(Profile:) forControlEvents:UIControlEventTouchUpInside];
    Profile.userInteractionEnabled=YES;
    
    UIButton *Logout=[UIButton buttonWithType:UIButtonTypeCustom];
    Logout.frame=CGRectMake(0,80, 170, 40);
    [Logout.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    [Logout setTitle:@"Logout" forState:UIControlStateNormal];
    [Logout setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Logout addTarget:self action:@selector(Logout:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [view1 addSubview:changeUsername];
    [view1 addSubview:changePswrd];
    [view1 addSubview:Profile];
    [view1 addSubview:Logout];
    [view1 addSubview:div1];
    [view1 addSubview:div2];
//    [view1 addSubview:div3];
    
    [popVC.view addSubview:view1];
    //    UITableView *view2=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 180, 150) style:UITableViewStylePlain];
    //    [popVC.view addSubview:view2];
    
    
    
    //our popover
    //    popover = [[FPPopoverController alloc] initWithViewController:popVC];
    //
    //    popover.contentSize = CGSizeMake(200,200);
    //    popover.tint = FPPopoverRedTint;
    //    popover.arrowDirection = FPPopoverArrowDirectionAny;
    //    popVC.title = nil;
    //
    //    //the popover will be presented from the okButton view
    //    [popover presentPopoverFromView:sender];
    //
    ////    popover.border = NO;
    ////    popover.tint = FPPopoverWhiteTint;
    ////    popover.alpha = 0.8;

    
    
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:popVC];
    popover.delegate = self;
    popover.contentSize = CGSizeMake(190 , 170);
    popover.tint=FPPopoverDefaultTint;
    
    popover.alpha = 1;
    //    popover.border=NO;
    //    popover.tint=FPPopoverWhiteTint;
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    [popover presentPopoverFromView:sender];

}

- (IBAction)changePswrdAcn:(id)sender {
    // Here we need to pass a full frame
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    NSString *oldPassword=[FCLUtilities getPassWord];
    
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self passWordview]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Yes", @"Cancel", nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
        
        
        AppDelegate *delegate=[UIApplication sharedApplication].delegate;
        //========encoding old password====
        NSInteger wrapWidth =24;
        NSString *encodedPasswordOld=[[_oldPswrdTf.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithWrapWidth:wrapWidth];
        
        
        //======encoding the username to base64 here====>
        NSData *inputData2=[_NewPswrdText.text dataUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedPassword=[inputData2 base64EncodedStringWithWrapWidth:wrapWidth];

        if (buttonIndex==0) {
            if ([encodedPasswordOld isEqualToString:oldPassword]&&
                [_NewPswrdText.text isEqualToString:_confirmPswrdTf.text]&&_NewPswrdText.text.length>=6) {
                NSString *username=[FCLUtilities getUserName];
                NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:username,@"userName",encodedPassword,@"newpassword", nil];
            
                NSLog(@"params %@",params);
                FclAPICleint *sharedClient=[FclAPICleint sharedClient];
                [sharedClient postPath:@"changepassword" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){
                    NSLog(@"response %@",[operation responseString]);
                    [FCLUtilities setPassWord:encodedPassword];
                    
                }failure:^(AFHTTPRequestOperation *operation,NSError *error){
                    [delegate showErrorNotice:@"Unable to update"];
                    NSLog(@"fail pswrd");
                }];

            }else if (![encodedPasswordOld isEqualToString:oldPassword]){
                [delegate showErrorNotice:@"Please enter valid oldpassword"];
            }else if (![_NewPswrdText.text isEqualToString:_confirmPswrdTf.text]){
                [delegate showErrorNotice:@"Passwords doesnot match"];
            }else if(!_NewPswrdText.text.length>=6) {
                [delegate showErrorNotice:@"Your password should be atleaset 6 charactres"];
            }
            
        }
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];

}

//-(IBAction)changeUsername:(id)sender{
//    // Here we need to pass a full frame
//    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
//    
//    // Add some custom content to the alert view
//    [alertView setContainerView:[self userNameView]];
//    
//    // Modify the parameters
//    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Yes", @"Cancel", nil]];
//    [alertView setDelegate:self];
//    
//    // You may use a Block, rather than a delegate.
//    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
//        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
//        [alertView close];
//    }];
//    
//    [alertView setUseMotionEffects:true];
//    
//    // And launch the dialog
//    [alertView show];
//
//}

-(UIView *)passWordview{
 
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 180)];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 280, 20)];
    label.text=@"Please Enter New Password";
    label.textAlignment=NSTextAlignmentCenter;
    label.backgroundColor=[UIColor clearColor];
  //  label.textColor=[UIColor colorWithRed:255 green:69 blue:0 alpha:1];
    label.textColor=[UIColor blackColor];
 //   label.font=[UIFont fontWithName:@"Arial-BoldMT" size:15];
    label.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    
    //Verdana-Bold

    _oldPswrdTf=[[UITextField alloc]init];
    _oldPswrdTf.frame=CGRectMake(20,50 , 240, 30);
    [_oldPswrdTf setBorderStyle:UITextBorderStyleRoundedRect];
    _oldPswrdTf.textAlignment=NSTextAlignmentCenter;
    [_oldPswrdTf setBackgroundColor:[UIColor whiteColor]];
    [_oldPswrdTf setFont:[UIFont fontWithName:@"Arial" size:12]];
    _oldPswrdTf.textAlignment=NSTextAlignmentCenter;
    [_oldPswrdTf setPlaceholder:@"Old Password"];
    [_oldPswrdTf setSecureTextEntry:YES];
    
    _NewPswrdText=[[UITextField alloc]init];
    _NewPswrdText.frame=CGRectMake(20, 90, 240, 30);
    [_NewPswrdText setBorderStyle:UITextBorderStyleRoundedRect];
    _NewPswrdText.textAlignment=NSTextAlignmentCenter;
    [_NewPswrdText setFont:[UIFont fontWithName:@"Arial" size:12]];
    [_NewPswrdText setPlaceholder:@"New Password"];
    [_NewPswrdText setSecureTextEntry:YES];
    

    _confirmPswrdTf=[[UITextField alloc]init];
    _confirmPswrdTf.frame=CGRectMake(20, 130, 240, 30);
    [_confirmPswrdTf setBorderStyle:UITextBorderStyleRoundedRect];
    [_confirmPswrdTf setFont:[UIFont fontWithName:@"Arial" size:12]];
    _confirmPswrdTf.textAlignment=NSTextAlignmentCenter;
    [_confirmPswrdTf setPlaceholder:@"Confirm Password"];
    [_confirmPswrdTf setSecureTextEntry:YES];
    
    [view addSubview:label];
    [view addSubview:_oldPswrdTf];
    [view addSubview:_NewPswrdText];
    [view addSubview:_confirmPswrdTf];
    return view;

}


//-(UIView *)userNameView{
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 150)];
//    
//    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 280, 20)];
//    label.text=@"Please Enter New Username";
//    label.backgroundColor=[UIColor clearColor];
//    label.textAlignment=NSTextAlignmentCenter;
//    label.textColor=[UIColor blackColor];
//   // label.font=[UIFont fontWithName:@"Arial-BoldMT" size:15];
//    label.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
//
//    _oldUserTf=[[UITextField alloc]init];
//    _oldUserTf.frame=CGRectMake(20, 50, 240, 30);
//    [_oldUserTf setBorderStyle:UITextBorderStyleRoundedRect];
//    [_oldUserTf setPlaceholder:@"Old Username"];
//    [_oldUserTf setBackgroundColor:[UIColor whiteColor]];
//    [_oldUserTf setFont:[UIFont fontWithName:@"Arial" size:12]];
//    _oldUserTf.textAlignment=NSTextAlignmentCenter;
//
//    
//    _NewUserText=[[UITextField alloc]init];
//    _NewUserText.frame=CGRectMake(20, 96, 240, 30);
//    [_NewUserText setBorderStyle:UITextBorderStyleRoundedRect];
//    [_NewUserText setPlaceholder:@"New Username"];
//    [_NewUserText setBackgroundColor:[UIColor whiteColor]];
//    [_NewUserText setFont:[UIFont fontWithName:@"Arial" size:12]];
//    _NewUserText.textAlignment=NSTextAlignmentCenter;
//
//    
//    [view addSubview:label];
//    [view addSubview:_oldUserTf];
//    [view addSubview:_NewUserText];
//
//    return view;
// 
//}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
  //  NSLog(@"textfield value %@",tf.text);
    if (alertView.tag==USERNAME) {
        
    }else if (alertView.tag==PASSWORD){
        
    }
    
    NSLog(@"Delegate: Button at position %ld is clicked on alertView %ld.", (long)buttonIndex, (long)[alertView tag]);
    [alertView close];
}


-(IBAction)Profile:(id)sender{
    [popover dismissPopoverAnimated:YES completion:^(void){
        
        if (_viewName!=Profile) {
            _viewName=Profile;
            [self performSegueWithIdentifier:@"Profilesegue" sender:nil];

        }
    }];
    
}




-(IBAction)Logout:(id)sender{
        
    [popover dismissPopoverAnimated:YES completion:^(void){

    [[FBSession activeSession]closeAndClearTokenInformation];
    [[FBSession activeSession] close];
        
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"myPicUrl"];

    
    [FCLUtilities setUserName:nil];
    [FCLUtilities setPassWord:nil];
    [[FCLUtilities getUtils] setMyFeed:nil];
    [[FCLUtilities getUtils] setMyProfile:nil];
        
    [self showLoginpage];
    }];
     
}



-(void)showLoginpage{
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginSignUpViewController *vc=(LoginSignUpViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    
    
    UINavigationController *myNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:myNavigationController animated:YES completion:nil];
    
}


- (IBAction)navigateHome:(id)sender {
    if (_viewName!=Home) {
        [self performSegueWithIdentifier:@"homeSegue" sender:[self.buttonsView.subviews objectAtIndex:0]];
        UIButton *button = (UIButton *)[self.buttonsView.subviews objectAtIndex:0];
        [button setSelected:YES];
        _viewName=Home;
    }
}

- (IBAction)showNewsLetter:(id)sender {
    
    if (_viewName!=NewsLetter) {
        [self performSegueWithIdentifier:@"newsSegue" sender:[self.buttonsView.subviews objectAtIndex:1]];
        UIButton *button = (UIButton *)[self.buttonsView.subviews objectAtIndex:1];
        [button setSelected:YES];
        _viewName=NewsLetter;

    }
}

- (IBAction)eventsNavigate:(id)sender {
    
    if(_viewName!=Events) {
        [self performSegueWithIdentifier:@"eventsSegue" sender:[self.buttonsView.subviews objectAtIndex:2]];
        UIButton *button = (UIButton *)[self.buttonsView.subviews objectAtIndex:2];
        [button setSelected:YES];
        _viewName=Events;
   }
    

}


@end
