//
//  LoginSignUpViewController.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "LoginSignUpViewController.h"
#import "CustomTabBarViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "FCLUtilities.h"
#define LOGIN_TAG 2
#define SIGNUP_TAG 1

#define kOFFSET_FOR_KEYBOARD 100

@interface LoginSignUpViewController ()

@end

@implementation LoginSignUpViewController
@synthesize popover,str,str2,str3;
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
    

    _topSpaceLoginBtn.constant=260;
    NSDictionary *normaltextAttr =
    @{UITextAttributeTextColor : FCLOrangeColor,
      UITextAttributeTextShadowColor : [UIColor  clearColor],
      UITextAttributeFont : [UIFont fontWithName:@"Baskerville-Bold" size:20.f]};
    [[UINavigationBar appearance] setTitleTextAttributes:normaltextAttr];
    
    [self.navigationController.navigationBar setTitleTextAttributes:normaltextAttr];

    
    
    _usernameTf.borderStyle=UITextBorderStyleNone;
    _usernameTf.background=[UIImage imageNamed:@"textFieldBackgorund.png"];
    
    
//    _usernameTf.layer.borderWidth = 1.0f;
//    _usernameTf.layer.borderColor = [[UIColor grayColor] CGColor];
//    _usernameTf.layer.cornerRadius = 4.0f;
//    _usernameTf.layer.masksToBounds = YES;
//    
//    [_usernameTf.layer setBorderColor: [[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0] CGColor]];
//    [_usernameTf.layer setBorderWidth: 1.0];
//    [_usernameTf.layer setCornerRadius:6.0];
//    [_usernameTf.layer setShadowOpacity:0.0];
//    [_usernameTf.layer setShadowColor:[[UIColor clearColor] CGColor]];
//    [_usernameTf.layer setShadowOffset:CGSizeMake(0.5, 0.5)];
    
    
    if (IOS_VERSION<7.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"320x44-white.png"] forBarMetrics:UIBarMetricsDefault];
        _topSpaceView.constant=30;
        _signtopSpace.constant=10;
        _topSpaceLogin.constant=10;
        _vSpaceSignUpNow.constant=330;
        _vspaceLbl.constant=335;
    }else{
        _vspaceLbl.constant=413;
        _vSpaceSignUpNow.constant=410;
        _topSpaceView.constant=30;
        _signtopSpace.constant=10;
        _topSpaceLogin.constant=10;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"320x64-white.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    _signUpLoginBtn.backgroundColor=[UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1];
    _signUpLoginBtn.layer.cornerRadius=5.0;
    
    _UserButton.backgroundColor=[UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1];
    _UserButton.layer.cornerRadius=5.0;

    
    [_signUpLoginBtn
     setTitle:@"Login" forState:UIControlStateNormal];
    _confirmpasswrdTf.hidden=YES;
    _confirmpasswrdTf.userInteractionEnabled=NO;
    [self.navigationController.topViewController setTitle:@"Login"];
    _signUpLoginBtn.tag=LOGIN_TAG;
    _paging.currentPage=1;
    [_LoginBtn setSelected:YES];
    
    _usernameTf.delegate=self;
    _passwordTf.delegate=self;
    _confirmpasswrdTf.delegate=self;
        
    self.swipeView.multipleTouchEnabled=YES;
    
    _tapScreen=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    _tapScreen.delegate=self;
    [self.swipeView addGestureRecognizer:_tapScreen];
    
    
    
    
    _leftSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeMethod:)];
    _rightSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeMethod:)];
    _leftSwipe.delegate=self;
    _rightSwipe.delegate=self;
    _leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
    _rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
    [self.swipeView addGestureRecognizer:_leftSwipe];
    [self.swipeView addGestureRecognizer:_rightSwipe];

	// Do any additional setup after loading the view.
}

-(void)checkInternet{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (![delegate isNetWorkAvailableMethod]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet connection" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }

}
-(void)hideKeyBoard{
//    [self.swipeView endEditing:YES];
//    CGRect rect = self.view.frame;
//    rect.origin.y=64;
//    self.view.frame = rect;

    
}

-(void)viewDidAppear:(BOOL)animated{
    

}

-(void)SwipeMethod:(UISwipeGestureRecognizer *)swipe{
        if (swipe.direction==UISwipeGestureRecognizerDirectionRight) {
            [self rightSwipeMethod];
        }
        
        else if(swipe.direction==UISwipeGestureRecognizerDirectionLeft){
            [self leftSwipeMethod];
        }
    
}


-(void)rightSwipeMethod{
    _usernameTf.text=@"";
    _passwordTf.text=@"";
    _confirmpasswrdTf.text=@"";
    CATransition *transition=[CATransition animation];
    transition.duration=0.3;
    transition.type=kCATransitionPush;
    
    NSLog(@"right swipe");
    transition.subtype=kCATransitionFromLeft;
    NSLog(@"signup buttn tag %li",(long)_signUpLoginBtn.tag);
    if (_signUpLoginBtn.tag!=SIGNUP_TAG) {
        
        _topSpaceLoginBtn.constant=300;

        [_SignUpBtn setSelected:NO];
        [_LoginBtn setSelected:YES];
        [_UserButton setHidden:YES];
        [_UserButton setUserInteractionEnabled:NO];
        [_newuserLabel setHidden:YES];
        _paging.currentPage=0;
        [_signUpLoginBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
        [_SignUpBtn setSelected:YES];
        [_LoginBtn setSelected:NO];
        _confirmpasswrdTf.hidden=NO;
        _confirmpasswrdTf.userInteractionEnabled=YES;
        [self.navigationController.topViewController setTitle:@"Sign Up"];
        _signUpLoginBtn.tag=SIGNUP_TAG;
        [self.swipeView.layer addAnimation:transition forKey:kCATransition];
        

}
}

-(void)leftSwipeMethod{
    _usernameTf.text=@"";
    _passwordTf.text=@"";
    _confirmpasswrdTf.text=@"";
    CATransition *transition=[CATransition animation];
    transition.duration=0.3;
    transition.type=kCATransitionPush;
    
    transition.subtype=kCATransitionFromRight;
    
    NSLog(@"left swipe");
    if (_signUpLoginBtn.tag!=LOGIN_TAG) {

        [_LoginBtn setSelected:YES];
        [_SignUpBtn setSelected:NO];
        _paging.currentPage=1;
        [_signUpLoginBtn setTitle:@"Login" forState:UIControlStateNormal];
        [_UserButton setHidden:NO];
        [_UserButton setUserInteractionEnabled:YES];
        [_newuserLabel setHidden:NO];
        _confirmpasswrdTf.hidden=YES;
        _confirmpasswrdTf.userInteractionEnabled=NO;
        [self.navigationController.topViewController setTitle:@"Login"];
        _signUpLoginBtn.tag=LOGIN_TAG;
        
        _topSpaceLoginBtn.constant=260;
        
        [self.swipeView.layer addAnimation:transition forKey:kCATransition];
        
    }

}
- (IBAction)Login_SignUpAction:(id)sender {
    [self checkInternet];

    FclAPICleint * sharedClient = [FclAPICleint sharedClient];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;

    if (_signUpLoginBtn.tag==LOGIN_TAG) {
        
//        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//        [delegate showHomeView];
        
        if ([self validateLoginFields]) {
            
            
            //======encoding the username to base64 here====>
            NSInteger wrapWidth =24;
            NSString *username = _usernameTf.text;
            
            //=====encode password to base64======>
            NSData *inputData2=[_passwordTf.text dataUsingEncoding:NSUTF8StringEncoding];
            NSString *encodedPassword=[inputData2 base64EncodedStringWithWrapWidth:wrapWidth];
            
            NSLog(@"string password %@",encodedPassword);
            
            
            NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:username,@"userName",encodedPassword,@"password", nil];
            
            NSLog(@"params %@",params);
            
            
            [SVProgressHUD showWithStatus:@"Connecting.." maskType:SVProgressHUDMaskTypeGradient];
        
            [sharedClient postPath:@"login" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject) {
                               
                NSLog(@"response from server %@",responseObject);
                
                NSLog(@"Success Request: %@",dataToString(operation.request.HTTPBody));
                NSLog(@"Success Response: %@",dataToString(operation.responseData));
                
                NSString *responseStr=[[NSString alloc]init];
                responseStr=dataToString(operation.responseData);
                NSLog(@"response str %@",responseStr);
                if ([responseStr isEqualToString:@"true"]) {
                    [[FBSession activeSession] closeAndClearTokenInformation];
                    [[FBSession activeSession] close];
                    [FCLUtilities setPassWord:encodedPassword];
                    [FCLUtilities setUserName:username];
                    [self dismissCurrentView];
                }else{
                    [delegate showErrorNotice:@"The username or password you entered is incorrect"];
                }
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation,NSError * error) {
                [SVProgressHUD dismiss];
                NSLog(@"failure response");
                [delegate showErrorNotice:@"Could not connect to the server"];

            }];
            

        }
        
    }else if (_signUpLoginBtn.tag==SIGNUP_TAG){
        if ([self validateSignUpFields]) {
            [SVProgressHUD showWithStatus:@"Connecting.." maskType:SVProgressHUDMaskTypeGradient];
        
            
            //======encoding the username to base64 here====>
            NSInteger wrapWidth =24;
            NSString *username = _usernameTf.text;
            //NSLog(@"encode value %@",encodedString);
           
            //=====encode password to base64======>
            NSData *inputData2=[_passwordTf.text dataUsingEncoding:NSUTF8StringEncoding];
            NSString *encodedPassword=[inputData2 base64EncodedStringWithWrapWidth:wrapWidth];
            
            NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:username,@"userName",encodedPassword,@"password", nil];

            NSLog(@"params %@",params);
            [sharedClient postPath:@"signUp" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject) {
                
                // TO DO
               // [sharedClient setAuthorizationHeaderWithUsername:username  password:encodedPassword];
                [FCLUtilities setPassWord:encodedPassword];
                [FCLUtilities setUserName:username];
                [self dismissCurrentView];
                
                NSLog(@"response from server %@",responseObject);
                
                NSLog(@"Success Request: %@",dataToString(operation.request.HTTPBody));
                NSLog(@"Success Response: %@",dataToString(operation.responseData));
                
                [SVProgressHUD dismiss];
                
            } failure:^(AFHTTPRequestOperation *operation,NSError * error) {
                NSLog(@"failure response");
                [SVProgressHUD dismiss];
                [delegate showErrorNotice:@"Registration failed"];

              //  [sharedClient clearAuthorizationHeader];
                
            }];

            

        }
    }
}

-(void)dismissCurrentView{
    
    [self dismissViewControllerAnimated:YES completion:^{
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate showHomeView];
    }];

    
}

-(BOOL)validateLoginFields{
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    
    if (_usernameTf.text.length==0) {
        [delegate showErrorNotice:@"Please Enter Username"];
        return NO;
    }else if (_usernameTf.text.length<6){
        [delegate showErrorNotice:@"Please Enter valid Username"];
        return NO;
    }else if (_passwordTf.text.length==0){
        [delegate showErrorNotice:@"Please Enter Password"];
        return NO;
    }else if (_passwordTf.text.length<6){
        [delegate showErrorNotice:@"Please Enter valid Password"];
        return NO;
    }

    return YES;
}

-(BOOL)validateSignUpFields{
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;

    if (_usernameTf.text.length==0) {
        [delegate showErrorNotice:@"Username should not be empty"];
        return NO;
    }else if (_usernameTf.text.length<6){
        [delegate showErrorNotice:@"Username should contain atleast 6 characters"];
        return NO;
    }else if (_passwordTf.text.length==0){
        [delegate showErrorNotice:@"Password should not be empty"];
        return NO;
    }else if (_passwordTf.text.length<6){
        [delegate showErrorNotice:@"Password should contain atleast 6 characters"];
        return NO;
    }else if (![_confirmpasswrdTf.text isEqualToString:_passwordTf.text]){
        [delegate showErrorNotice:@"Passwords do not match!"];
        return NO;
    }

    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)SignUpSegAction:(id)sender {
//    
//    if (_SignUpLoginSeg.selectedSegmentIndex==1) {
//        [self leftSwipeMethod];
//    }else if (_SignUpLoginSeg.selectedSegmentIndex==0){
//        [self rightSwipeMethod];
//    }
//    
//    
//}
- (IBAction)SignUpActn:(id)sender {
    [self rightSwipeMethod];

}
- (IBAction)LoginActn:(id)sender {
    [self leftSwipeMethod];

}
- (IBAction)NewUser:(id)sender {
    [self rightSwipeMethod];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self setViewMovedUp:NO];
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    [self setViewMovedUp:YES];

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  
    if (_signUpLoginBtn.tag==SIGNUP_TAG) {
        
        if (textField==_usernameTf) {
            
            UIActivityIndicatorView *checkAvailabilty=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            checkAvailabilty.frame=CGRectMake(150, 0, 35, 35);
            [_usernameTf addSubview:checkAvailabilty];
            [checkAvailabilty startAnimating];
            
            FclAPICleint *sharedClient=[FclAPICleint sharedClient];
            NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:_usernameTf.text,@"userName", nil];
            
            [sharedClient postPath:@"userAvalaibility" parameters:dict success:^(AFHTTPRequestOperation *operation,id responseObject) {
                [checkAvailabilty stopAnimating];
                NSLog(@"response from server %@",responseObject);
                
                NSLog(@"Success Request: %@",dataToString(operation.request.HTTPBody));
                NSLog(@"Success Response: %@",dataToString(operation.responseData));
                
//                NSLog(@"response array %@",dataToArray(operation.responseData));
                
                NSArray *array = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"array %@",array);
                [checkAvailabilty stopAnimating];

                if (array.count==3) {
                   
                //========Popover views======
                UIViewController *popVC=[[UIViewController alloc]init];
                UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,0 , 300, 90)];
                view1.backgroundColor=[UIColor whiteColor];
                
                UILabel *suggetions=[[UILabel alloc]initWithFrame:CGRectMake(8, 4, 300, 20)];
                suggetions.text=@"Username already taken";
                
                UILabel *suggetions2=[[UILabel alloc]initWithFrame:CGRectMake(0, 24, 40, 20)];
                suggetions.text=@"Available:";
                
                UIButton *name1=[UIButton buttonWithType:UIButtonTypeCustom];
                name1.frame=CGRectMake(40, 20, 80, 40);
                str=[self suggestedString:[array objectAtIndex:0]];
                [name1 setAttributedTitle:str forState:UIControlStateNormal];
                [name1.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
                [name1 addTarget:self action:@selector(name1Actn:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UIButton *name2=[UIButton buttonWithType:UIButtonTypeCustom];
                name2.frame=CGRectMake(120,20, 80, 40);
                str2=[self suggestedString:[array objectAtIndex:1]];
                [name2 setAttributedTitle:str2 forState:UIControlStateNormal];
                [name2.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
                [name2 addTarget:self action:@selector(name2Actn:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UIButton *name3=[UIButton buttonWithType:UIButtonTypeCustom];
                name3.frame=CGRectMake(200,20, 80, 40);
                str3=[self suggestedString:[array objectAtIndex:2]];
                [name3 setAttributedTitle:str3 forState:UIControlStateNormal];
                [name3.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
                [name3 addTarget:self action:@selector(name3Actn:) forControlEvents:UIControlEventTouchUpInside];
                
                [view1 addSubview:name1];
                [view1 addSubview:name2];
                [view1 addSubview:name3];
                [view1 addSubview:suggetions];
                [view1 addSubview:suggetions2];

                [popVC.view addSubview:view1];
                popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:popVC];
                popover.delegate = self;
                popover.contentSize = CGSizeMake(310 , 100);
                popover.tint=FPPopoverDefaultTint;
                
                popover.alpha = 1;
                popover.border=NO;
                popover.tint=FPPopoverWhiteTint;
                popover.arrowDirection = FPPopoverArrowDirectionDown;
                [popover presentPopoverFromView:checkAvailabilty];

            }

                
            } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            
                NSLog(@"failed");
            }];
            
            NSLog(@"user name end editing");
        }
        
    }
    

}

-(IBAction)name1Actn:(id)sender{
    _usernameTf.text=[str string];
}

-(IBAction)name2Actn:(id)sender{
    _usernameTf.text=[str2 string];
    
}

-(IBAction)name3Actn:(id)sender{
    _usernameTf.text=[str3 string];

}

-(NSMutableAttributedString *)suggestedString:(NSString *)string{
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:string];
    [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,[commentString length])];
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    return commentString;
    
}
#pragma mark- KeyBoardHideShow
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect rect = self.view.frame;
    NSLog(@"origin view %f",rect.origin.y);
    if (IOS_VERSION<7.0) {
        if (movedUp)
        {
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            
            
            if (rect.origin.y == 0 ) {
                rect.origin.y -= kOFFSET_FOR_KEYBOARD;
            }
            
        }
        else
        {
            if (rect.origin.y != 0 ) {
                rect.origin.y =0;
            }
        }

    }else{
        if (movedUp)
        {
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
        
        
            if (rect.origin.y == 64 ) {
            rect.origin.y -= kOFFSET_FOR_KEYBOARD;
            }
        
        }
        else
        {
            if (rect.origin.y != 64 ) {
                rect.origin.y =64;
            }
        }
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

@end
