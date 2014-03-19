//
//  othersProfileViewController.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 3/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "othersProfileViewController.h"
#import "AppDelegate.h"
@interface othersProfileViewController ()

@end

@implementation othersProfileViewController
@synthesize friendPic,profileDetails;
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
    
    [self.navigationController.topViewController setTitle:@"Profile"];
    self.view.backgroundColor=backgroundHeaderColor;
    _profilePic.layer.cornerRadius=9.0;
    _profilePic.layer.borderWidth=2.0;
    _profilePic.layer.borderColor=FCLOrangeColor.CGColor;
    _profilePic.layer.masksToBounds=YES;
    _aboutText.userInteractionEnabled=NO;
    _clickProfile.layer.cornerRadius=6.0;
    _clickProfile.layer.masksToBounds=YES;
    _clickProfile.backgroundColor=[UIColor whiteColor];
    _bottomView.layer.cornerRadius=6.0;
    _bottomView.backgroundColor=[UIColor whiteColor];
    _nameLbl.text=_userName;
    _bottomView.clipsToBounds = YES;
    
	// Do any additional setup after loading the view.
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"back-btn-white.png"]  ; // Here set the back button image
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(Home) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 28, 30);
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    NSLog(@"username %@",_userName);
    [self getProfile];

}

-(void)Home{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)checkInternet{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (![delegate isNetWorkAvailableMethod]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please check your Internet connection" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)getProfile{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:_userName forKey:@"userName"];
    NSLog(@"params %@",params);
    [self checkInternet];

    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
    FclAPICleint *sharedClient=[FclAPICleint sharedClient];
    [sharedClient postPath:@"profileDetails" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        profileDetails=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"profile details %@",profileDetails);
        NSString *about=[profileDetails objectForKey:@"Aboutme"];
        NSString *url=[profileDetails objectForKey:@"profileURL"];
        NSString *dob=[profileDetails objectForKey:@"DOB"];
        NSString *design=[profileDetails objectForKey:@"designation"];
        
        if ([about isEqualToString:@"null"]) {
            about=@"None Specified";
            
        }if ([dob isEqualToString:@"null"]) {
            dob=@"None Specified";

        }if ([design isEqualToString:@"null"]) {
            design=@"None Specified";

        }
        
        _designLbl.text=design;
        _aboutText.text=about;
        _birdthdayLbl.text=dob;
        dispatch_async(dispatch_get_main_queue(), ^{
        
        [_profilePic setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderProfile.jpg"]];
        });
        
        [SVProgressHUD dismiss];
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [SVProgressHUD dismiss];

    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)profile:(id)sender {
    _bottomView.clipsToBounds=YES;
    _bottomView.layer.masksToBounds=YES;
    if (_isShowingDetails) {
        
        _isShowingDetails=!_isShowingDetails;
        
        [UIView animateWithDuration:0.15f animations:^{
            _heightCn.constant=243;
            _bottomView.alpha=1;
        } completion:^(BOOL finished) {
            
        }];

        
    }else{
        _isShowingDetails=!_isShowingDetails;
        [UIView animateWithDuration:0.05f animations:^{
            _heightCn.constant=0;
            _bottomView.alpha=0;
            
        } completion:^(BOOL finished) {
        }];

    }
}
@end
