//
//  EventsViewController.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "EventsViewController.h"
#import "SVProgressHUD.h"
@interface EventsViewController ()

@end

@implementation EventsViewController

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
    
//    if (FBSessionStateOpen) {
//        [_fbLogoimage setHidden:YES];
//        [_fbConnectBTn setHidden:YES];
//        [_fbConnectBTn setUserInteractionEnabled:NO];
//
//        _recentBirthdays.hidden=NO;
//        
//        [FBSession openActiveSessionWithPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session,FBSessionState status,NSError *error)
//         {
//             if (session.isOpen)
//             {
//                 [self sessionStateChanged:session state:status error:error];
//                 
//             }
//         }];
//    }else{
    _recentBirthdays.hidden=YES;
    _todaysBirthday=[[NSMutableArray alloc]init];

//    _recentBirthdays.separatorColor=FCLOrangeColor;
    
    [_fbLogoimage setHidden:NO];
    [_fbConnectBTn setHidden:NO];
    [_fbConnectBTn setUserInteractionEnabled:YES];

    _recentBirthdays.delegate=self;
    _recentBirthdays.dataSource=self;
    //}
    
    if (IOS_VERSION<7.0) {
        _bottomSpaceImage.constant=150;
        _topSpaceCnctFB.constant=320;
        self.recentBirthdays.contentInset=UIEdgeInsetsMake(2, 0, 100, 0);
    }
    
//    UIImageView *imageFb=[[UIImageView alloc]initWithFrame:CGRectMake(10,10, 300, 340)];
//    imageFb.image=[UIImage imageNamed:@"facebook.jpg"];
//    [self.view addSubview:imageFb];
//    
//    UIButton *fbConnect=[UIButton buttonWithType:UIButtonTypeCustom];
//    fbConnect.frame=CGRectMake(50, 360, 200, 40);
//    [fbConnect setBackgroundImage:[UIImage imageNamed:@"connec_facebook"] forState:UIControlStateNormal];
//    [fbConnect addTarget:self action:@selector(Loginfacebook:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:fbConnect];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Loginfacebook:(id)sender {
    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
    
        [FBSession openActiveSessionWithPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session,FBSessionState status,NSError *error)
         {
             if (session.isOpen)
             {
                 [self sessionStateChanged:session state:status error:error];
                 
             }
         }];


    
    
}
/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            
                
                
                
                // id,name,friends.fields(picture.type(square).width(100).height(100))
                FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/friends?fields=name,birthday,picture.type(square)"];
                [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    NSArray *data = [result objectForKey:@"data"];
//                   NSLog(@"data.count %lu",(unsigned long)data.count);
//                   NSLog(@"result %@",data);
                    [self getDetails:data];
                    
//                    for (FBGraphObject<FBGraphUser> *friend in data) {
//                        NSLog(@"%@:%@ %@", [friend name],[friend birthday],[[[friend objectForKey:(id)@"picture"] valueForKey:@"data"] valueForKey:@"url"]);
//                        _profilePicUrl=[[[friend objectForKey:(id)@"picture"] valueForKey:@"data"] valueForKey:@"url"];
//                        if ([friend name].length!=0&&[friend birthday].length!=0&&_profilePicUrl.length!=0)
//                        {
//                            [_fbFriendsDetail setObject:[friend name] forKey:@"Name"];
//                            [_fbFriendsDetail setObject:[friend birthday] forKey:@"DOB"];
//                            [_fbFriendsDetail setObject:[[[friend objectForKey:(id)@"picture"] valueForKey:@"data"] valueForKey:@"url"] forKey:@"url"];
//                            [_friendDetailsArray addObject:_fbFriendsDetail];
//                        }
//                    }
//                    NSLog(@"friends %@",_friendDetailsArray);
//
                   
                }];

            }else if (error){
                [SVProgressHUD dismiss];
                UIAlertView *error=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [error show];
                NSLog(@"error facebookk");
            }
            break;
        case FBSessionStateClosed:
        {
            [SVProgressHUD dismiss];
            UIAlertView *error=[[UIAlertView alloc]initWithTitle:@"Error" message:@"State Closed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [error show];
            NSLog(@"error facebookk");
        }
            break;
            
        case FBSessionStateClosedLoginFailed:
        {
            [SVProgressHUD dismiss];
            UIAlertView *error=[[UIAlertView alloc]initWithTitle:@"Error" message:@"FBsession Login failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [error show];
            NSLog(@"error facebookk");

            
            [FBSession.activeSession closeAndClearTokenInformation];
        }
            break;
            
        
        default:
            break;
    }
    
    if (error) {
        [SVProgressHUD dismiss];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


-(void)getDetails:(NSArray *)data{
    _friendDetailsArray=[[NSMutableArray alloc]init];
    _todaysBirthday=[[NSMutableArray alloc]init];

    for (id friend in data) {
        _fbFriendsDetail=[[NSMutableDictionary alloc]init];
//        NSLog(@"%@:%@ %@", [friend name],[friend birthday],[[[friend objectForKey:(id)@"picture"] valueForKey:@"data"] valueForKey:@"url"]);
        //        NSLog(@"friends %@",friend);
        _profilePicUrl=[[[friend objectForKey:(id)@"picture"] valueForKey:@"data"] valueForKey:@"url"];
        if ([friend name].length!=0&&[friend birthday].length!=0&&_profilePicUrl.length!=0)
        {
//            [_fbFriendsDetail setObject:[friend name] forKey:@"Name"];
//            [_fbFriendsDetail setObject:[friend birthday] forKey:@"DOB"];
//            [_fbFriendsDetail setObject:[NSString stringWithFormat:@"%ld",(long)[self returnNumberOfDays:[friend birthday]]] forKey:@"timeIntervelDays"];
//            [_fbFriendsDetail setObject:[[[friend objectForKey:(id)@"picture"] valueForKey:@"data"] valueForKey:@"url"] forKey:@"url"];
//            //            NSLog(@"fb frieds %@",_fbFriendsDetail);
//            //            NSLog(@"array %@",_friendDetailsArray);
//            [_friendDetailsArray addObject:_fbFriendsDetail];
            
            if ([self returnNumberOfDays:[friend birthday]]>=0&&[self returnNumberOfDays:[friend birthday]]<=50) {
                
                [_fbFriendsDetail setObject:[friend name] forKey:@"Name"];
                [_fbFriendsDetail setObject:[friend birthday] forKey:@"DOB"];
                [_fbFriendsDetail setObject:[NSString stringWithFormat:@"%ld",(long)[self returnNumberOfDays:[friend birthday]]] forKey:@"timeIntervelDays"];
                [_fbFriendsDetail setObject:[[[friend objectForKey:(id)@"picture"] valueForKey:@"data"] valueForKey:@"url"] forKey:@"url"];

                
                if ([self returnNumberOfDays:[friend birthday]]==0) {
                    [_todaysBirthday addObject:_fbFriendsDetail];
                    NSLog(@"todays birthday %@",_todaysBirthday);
                }
                else{
                [_friendDetailsArray addObject:_fbFriendsDetail];
                }

            }
        }

    }
//    NSLog(@"friends %@",_friendDetailsArray);
//    NSLog(@"friends count %lu",(unsigned long)_friendDetailsArray.count);
    
    if (_friendDetailsArray.count==0&&_todaysBirthday.count==0) {
        _recentBirthdays.hidden=YES;
        [_fbLogoimage setHidden:NO];
        _fbLogoimage.image=[UIImage imageNamed:@"NO EVENTS.jpg"];
        [_fbConnectBTn setHidden:YES];
        [_fbConnectBTn setUserInteractionEnabled:NO];
    }else{
        _recentBirthdays.hidden=NO;
        [_fbLogoimage setHidden:YES];
        [_fbConnectBTn setHidden:YES];
        [_fbConnectBTn setUserInteractionEnabled:NO];
    }
    [self sortSearchResultWithInDocumentTypeArray:_friendDetailsArray basedOn:@"timeIntervelDays"];
    
    
    
    
//    [_fbLogoimage setHidden:YES];
//    [_fbConnectBTn setHidden:YES];
//    [_fbConnectBTn setUserInteractionEnabled:NO];
//
//    _recentBirthdays.hidden=NO;
    [SVProgressHUD dismiss];

}



-(NSInteger)returnNumberOfDays:(NSString *)DOB{
    
    
    //======convert NSString to NSDate=====
    NSString *dateStr=DOB;
   // NSLog(@"datestr %@",dateStr);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    if (dateStr.length==5) {
        [dateFormatter setDateFormat:@"MM'/'dd"];
    }else{
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    NSDate *formattedDate =[[NSDate alloc]init];
    formattedDate=[dateFormatter dateFromString:dateStr];
   // NSLog(@"format %@",formattedDate);
    
    
    //====convert date to desired format======
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter2 setDateFormat:@"MM'/'dd"];
    NSString *formattedDate2 = [dateFormatter2 stringFromDate:formattedDate];
    
   // NSLog(@"format %@",formattedDate2);
    
    //===get current date in desired format====
    NSDate *date=[NSDate date];
   // NSLog(@"current date %@",date);
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter3 setDateFormat:@"MM'/'dd"];
    NSString *formattedDate3 = [dateFormatter3 stringFromDate:date];
   // NSLog(@"format %@",formattedDate3);
   
    
    //==============
    NSDateFormatter *dateFormatter4 = [[NSDateFormatter alloc] init];
    [dateFormatter4 setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter4 setDateFormat:@"MM'/'dd"];
    
    NSDate *formattedDate4 =[[NSDate alloc]init];
    formattedDate4=[dateFormatter4 dateFromString:formattedDate2];
  //  NSLog(@"format4 to dd/mm%@",formattedDate4);
    
    
    
    //========
    NSDateFormatter *dateFormatter5 = [[NSDateFormatter alloc] init];
    [dateFormatter5 setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter5 setDateFormat:@"MM'/'dd"];
    
    NSDate *formattedDate5 =[[NSDate alloc]init];
    formattedDate5=[dateFormatter5 dateFromString:formattedDate3];
   // NSLog(@"format5 to dd/mm%@",formattedDate5);
    
    
    
    //====get time interval since date in days=======
    NSTimeInterval distanceBetweenDates = [formattedDate4 timeIntervalSinceDate:formattedDate5];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
   // NSLog(@"time intervel %ld",(long)hoursBetweenDates);
    
    double daysPeriod=24;
    NSInteger days=hoursBetweenDates/daysPeriod;
  //  NSLog(@"num of days %ld",(long)days);

    return days;
}


- (void)sortSearchResultWithInDocumentTypeArray:(NSMutableArray *)aResultArray basedOn:(NSString *)aSearchString {
    
    NSSortDescriptor * frequencyDescriptor =[[NSSortDescriptor alloc] initWithKey:aSearchString ascending:YES comparator:^(id firstDocumentName, id secondDocumentName) {
        
        static NSStringCompareOptions comparisonOptions =
        NSCaseInsensitiveSearch | NSNumericSearch |
        NSWidthInsensitiveSearch | NSForcedOrderingSearch;
        
        return [firstDocumentName compare:secondDocumentName options:comparisonOptions];
    }];
    
    NSArray * descriptors =    [NSArray arrayWithObjects:frequencyDescriptor, nil];
    [aResultArray sortUsingDescriptors:descriptors];
    [_recentBirthdays reloadData];

    
//    NSLog(@"sorted array %@",_friendDetailsArray);
//    
//    NSLog(@"sorted array count %lu",(unsigned long)_friendDetailsArray.count);

}



#pragma mark - UITableView delegate, datasource
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        if (_todaysBirthday.count==0) {
            return nil;
        }
        return @"Today's Birthday";
    }
    return @"Upcoming Birthdays";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"count %lu",(unsigned long)_friendDetailsArray.count);
    if (section==0) {
       return _todaysBirthday.count;
    }
    return _friendDetailsArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    eventsCell *cell=(eventsCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    
    if (cell==nil) {
        cell=(eventsCell *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
    }
    
    cell.profilePic.layer.cornerRadius=35;
    cell.profilePic.layer.masksToBounds=YES;
    cell.nameLabel.font=[UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:18];
    cell.DOBLabel.font=[UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:16];

    
    if (indexPath.section==0) {
        NSString *urlString=[[_todaysBirthday objectAtIndex:indexPath.row] objectForKey:@"url"];
        [cell.profilePic setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholderProfile.jpg"]];
        cell.nameLabel.text=[[_todaysBirthday objectAtIndex:indexPath.row] objectForKey:@"Name"];
        cell.DOBLabel.text=[[_todaysBirthday objectAtIndex:indexPath.row] objectForKey:@"DOB"];
    }else{
        
        NSString *urlString=[[_friendDetailsArray objectAtIndex:indexPath.row] objectForKey:@"url"];
        [cell.profilePic setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholderProfile.jpg"]];
        cell.nameLabel.text=[[_friendDetailsArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
        cell.DOBLabel.text=[[_friendDetailsArray objectAtIndex:indexPath.row] objectForKey:@"DOB"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
