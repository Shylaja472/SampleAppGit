//
//  LoadingScreenViewController.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "LoadingScreenViewController.h"
#import "LoginSignUpViewController.h"
#import "AppDelegate.h"
@interface LoadingScreenViewController ()

@end

@implementation LoadingScreenViewController

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
    
    [_loadAct startAnimating];
    
    if ([[UIScreen mainScreen] bounds].size.height) {
        self.loadimage.image=[UIImage imageNamed:@"Default-568h@2x.png"];
        _height.constant=568;
    }
    
    
//    [self performSelector:@selector(DelayMethod) withObject:nil afterDelay:2.0];

}


-(void)viewDidAppear:(BOOL)animated{
    [self checkUserStatus];

}


-(void)checkUserStatus{

    AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    
    if(([FCLUtilities getPassWord] != nil && [FCLUtilities getUserName] != nil)) {
        //        FclAPICleint * sharedClient = [FclAPICleint sharedClient];
        //        [sharedClient setAuthorizationHeaderWithUsername:[FCLUtilities getUserName] password:     [FCLUtilities getPassWord]];
        //        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        
        [self getMyProfile];
        
        [_loadAct stopAnimating];

        [delegate showHomeView];
        
    }else{
        
        [self showLoginpage];
        
    }
    
}

-(void)getMyProfile{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *username=[FCLUtilities getUserName];
    
    FclAPICleint *sharedClient=[FclAPICleint sharedClient];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:username,@"userName", nil];
    NSLog(@"get details params %@",dict);
    [self checkInternet];
    
    [sharedClient postPath:@"profileDetails" parameters:dict success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        _myProfileDetails=[[NSDictionary alloc]init];
        _myProfileDetails=[[operation responseString] objectFromJSONString];
        NSLog(@"profile details %@",_myProfileDetails);
        
        NSString *profilePicUrl=[_myProfileDetails objectForKey:@"profileURL"];
        
        [[NSUserDefaults standardUserDefaults] setObject:profilePicUrl forKey:@"myPicUrl"];
        
        
        [[FCLUtilities getUtils] setMyProfile:[_myProfileDetails mutableCopy]];
        
        NSLog(@"get utils values %@",[[FCLUtilities getUtils] getMyProfile]);
        [SVProgressHUD dismiss];
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        [SVProgressHUD dismiss];
        //        [SVProgressHUD showErrorWithStatus:@"Unable to fetch details"];
        [delegate showErrorNotice:@"Unable to fetch details"];
        
        NSLog(@"failed get profile");
    }];
}

-(void)checkInternet{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (![delegate isNetWorkAvailableMethod]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please check your Internet connection" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
}



-(void)showLoginpage{
    [_loadAct stopAnimating];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginSignUpViewController *vc=(LoginSignUpViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    
    UINavigationController *myNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:myNavigationController animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
