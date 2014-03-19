//
//  MyProfileViewController.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "MyProfileViewController.h"
#import "JSONKit.h"
#define backgroundHeaderColor [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1]
#define kOFFSET_FOR_KEYBOARD 200;
#import "AppDelegate.h"
#import <CoreText/CoreText.h>

@interface MyProfileViewController ()

@end
UIImageView *selfPic;
AppDelegate *delegate;
@implementation MyProfileViewController
@synthesize cell1,cell2,cell3,isEditAbout,isEditBasicInfo,isEditWork,username;
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
    
    [SVProgressHUD showWithStatus:@"Loading data.." maskType:SVProgressHUDMaskTypeGradient];
	// Do any additional setup after loading the view.
    username=[FCLUtilities getUserName];
    self.profiletable.dataSource=self;
    self.profiletable.delegate=self;

    [self.view setBackgroundColor:backgroundHeaderColor];
    
    delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //======table view header=========
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320 , 240)];
    view.backgroundColor=backgroundHeaderColor;
    selfPic=[[UIImageView alloc]initWithFrame:CGRectMake(70, 15, 180,180)];
    selfPic.layer.masksToBounds=YES;
    selfPic.layer.cornerRadius=90.0;
    selfPic.image=[UIImage imageNamed:@"placeholderProfile.jpg"];
    selfPic.contentMode=UIViewContentModeScaleAspectFill;
    [view addSubview:selfPic];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 150, 180, 30)];
    label.textAlignment=NSTextAlignmentCenter;
    [label setFont:[UIFont fontWithName:@"Arial" size:11.5]];
    
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"Change pic"];
//    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
//                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
//                      range:(NSRange){0,[attString length]}];
//    label.attributedText=attString;
    label.textColor=[UIColor whiteColor];
    label.text=@"Change Pic";
    label.backgroundColor=[UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:0.7];
    [selfPic addSubview:label];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 30)];
    nameLabel.text=[FCLUtilities getUserName];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.textColor=FCLOrangeColor;
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.font=[UIFont fontWithName:@"Palatino-Bold" size:20.0];
    [view addSubview:nameLabel];
    
    _tapOnImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePic:)];
    selfPic.userInteractionEnabled=YES;
    [selfPic setMultipleTouchEnabled:YES];
    _tapOnImage.delegate=self;
    _tapOnImage.numberOfTapsRequired=1;
    
    
    [selfPic addGestureRecognizer:_tapOnImage];
    self.profiletable.tableHeaderView=view;
    
    self.profiletable.backgroundColor=[UIColor clearColor];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    if (IOS_VERSION>=7.0) {
        _tableBottomSpace.constant=114;
    }
    
    [self getMyProfile];

}

-(void)checkInternet{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (![delegate isNetWorkAvailableMethod]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please check your Internet connection" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)getMyProfile{
    
    FclAPICleint *sharedClient=[FclAPICleint sharedClient];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:username,@"userName", nil];
    NSLog(@"get details params %@",dict);
    [self checkInternet];

    [sharedClient postPath:@"profileDetails" parameters:dict success:^(AFHTTPRequestOperation *operation,id responseObject){
    
        _myProfileDetails=[[NSDictionary alloc]init];
        _myProfileDetails=[[operation responseString] objectFromJSONString];
        NSLog(@"profile details %@",_myProfileDetails);
        _myBirthday=[_myProfileDetails objectForKey:@"DOB"];
        _myDesignation=[_myProfileDetails objectForKey:@"designation"];
        _myAbout=[_myProfileDetails objectForKey:@"Aboutme"];
        _profilePicUrl=[_myProfileDetails objectForKey:@"profileURL"];
        
        [[NSUserDefaults standardUserDefaults] setObject:_profilePicUrl forKey:@"myPicUrl"];
        
        
        [selfPic setImageWithURL:[NSURL URLWithString:_profilePicUrl] placeholderImage:[UIImage imageNamed:@"placeholderProfile.jpg"]];
        
        
        [self.profiletable reloadData];
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


-(void)changePic:(UIGestureRecognizer *)tap{
    NSLog(@"hello");
    
    NSInteger numberOfOptions = 2;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"camerabutton_iPhoneRetina@2x"]],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"gallerybutton_iPadRetina@2x"]]
                       ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.contentSizeForViewInPopover=CGSizeMake(260, 100);

    UIView *rnview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 30)];
    UILabel *titleLabe = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 0, 0)];
//    titleLabe.text = @"Select a photo from:";
    titleLabe.textColor = [UIColor whiteColor];
    titleLabe.backgroundColor=[UIColor clearColor];
    [titleLabe sizeToFit];
    [rnview addSubview:titleLabe];

    av.headerView = rnview;
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
    

}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    
    NSLog(@"Dismissed with item %d:", itemIndex);
    if(itemIndex == 0){
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            _camera=YES;
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
            
        }

    }
    if(itemIndex ==1){
      _camera=NO;
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
            
        }


    }
    
    
    
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *saveImgeToLocal=info[UIImagePickerControllerOriginalImage];

//        selfPic.image = info[UIImagePickerControllerOriginalImage];
        [SVProgressHUD showWithStatus:@"Updating..." maskType:SVProgressHUDMaskTypeGradient];
        FclAPICleint *sharedClient=[FclAPICleint sharedClient];
        NSString *myusername=[FCLUtilities getUserName];
        
        NSLog(@"username %@",username);
        
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:myusername forKey:@"userName"];
        NSData *imageData=UIImagePNGRepresentation(info[UIImagePickerControllerOriginalImage]);
        if (imageData) {
            [self checkInternet];
            
            CGFloat compression = 0.9f;
            CGFloat maxCompression = 0.1f;
            int maxFileSize = 250*1024;
            
            NSData *compressimageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], compression);
            
            while ([compressimageData length] > maxFileSize && compression > maxCompression)
            {
                compression -= 0.1;
                compressimageData = UIImageJPEGRepresentation(saveImgeToLocal, compression);
            }
            
            
            NSLog(@"MyImage size in bytes:%i",[compressimageData length]);
            
            NSMutableURLRequest *request=[sharedClient multipartFormRequestWithMethod:@"POST" path:@"changepic" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>formData){
            
            //[formData appendPartWithFormData:imageData name:@"profilePic"];
            
            [formData appendPartWithFileData:compressimageData name:@"profilePic" fileName:@"profilePic.png" mimeType:@"image/jpeg"];
        }];
            
        
        AFHTTPRequestOperation * imageRequest = [sharedClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation,id responseObject) {
            NSLog(@"successe post image");
            selfPic.image = saveImgeToLocal;
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation,NSError * error) {
            NSLog(@"operation code %ld",(long)operation.response.statusCode);
            NSLog(@"failure post image");
            [SVProgressHUD dismiss];
            [delegate showErrorNotice:@"Unable to update"];

        }];
        
        [imageRequest start];

        }else{
            NSLog(@"nil image");
        }
        
        
        //  _imageView.image = image;
        if (_camera)
            UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage],
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }

    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Your camera privacy is disabled"
                              message:@"Please change your settings to save image to gallery"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        cell1=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell1==nil) {
            cell1=(customCell1 *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell1.backgroundColor=[UIColor clearColor];
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        if ([_myDesignation isEqualToString:@"null"]) {
            _myDesignation=@"None Specified";
        }
        cell1.tf1.text=_myDesignation;
        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell1;
        
    }else if (indexPath.row==1){
        
        cell2=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell2==nil) {
            cell2=(customCell2 *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell2.backgroundColor=[UIColor clearColor];
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        if ([_myBirthday isEqualToString:@"null"]) {
            _myBirthday=@"None Specified";
        }
        cell2.birthdayBtn2.titleLabel.text=_myBirthday;
        cell2.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell2;
        
        
    }else if (indexPath.row==2){
        
        cell3=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell3==nil) {
            cell3=(customCell3 *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        cell3.backgroundColor=[UIColor clearColor];
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        if ([_myAbout isEqualToString:@"null"]) {
            _myAbout=@"None Specified";
        }
        cell3.aboutText.text=_myAbout;
        cell3.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell3;
        
        
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==0) {
        cell1.tf1.delegate=self;
        if (isEditWork) {
            [cell1.tf1 setEnabled:YES];
            [cell1.tf1 setBorderStyle:UITextBorderStyleLine];
            [cell1.tf1 setBackgroundColor:[UIColor darkGrayColor]];
            [cell1.tf1 setTextColor:[UIColor whiteColor]];
            [cell1.tf1 setText:@"write something.."];
            //            [cell1.tf1 becomeFirstResponder];
            
            cell1.cell1View.layer.cornerRadius=5.0;
            
            [cell1.editBtn1 setHidden:YES];
            [cell1.editBtn1 setUserInteractionEnabled:NO];
            
            [cell1.saveBtn setUserInteractionEnabled:YES];
            [cell1.saveBtn setHidden:NO];
            [cell1.saveBtn addTarget:self action:@selector(saveWork:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell1.cancelbtn1 setUserInteractionEnabled:YES];
            [cell1.cancelbtn1 setHidden:NO];
            [cell1.cancelbtn1 addTarget:self action:@selector(cancelWork:) forControlEvents:UIControlEventTouchUpInside];
            
            cell1.saveBtn.layer.cornerRadius=2.0;
            cell1.saveBtn.layer.cornerRadius=2.0;
            
            
        }else{
            
            [cell1.tf1 setEnabled:NO];
            [cell1.tf1 setBorderStyle:UITextBorderStyleNone];
            [cell1.tf1 setBackgroundColor:[UIColor clearColor]];
            [cell1.tf1 setTextColor:[UIColor darkGrayColor]];
            [cell1.tf1 setText:_myDesignation];

            
            [cell1.editBtn1 setHidden:NO];
            [cell1.editBtn1 setUserInteractionEnabled:YES];
            
            [cell1.saveBtn setUserInteractionEnabled:NO];
            [cell1.saveBtn setHidden:YES];
            
            [cell1.cancelbtn1 setUserInteractionEnabled:NO];
            [cell1.cancelbtn1 setHidden:YES];
            
            cell1.cell1View.clipsToBounds=YES;
            cell1.cell1View.layer.cornerRadius=5.0;
            [cell1.editBtn1 addTarget:self action:@selector(DesignationEdit:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        
    }
    if (indexPath.row==1) {
        
        if (isEditBasicInfo) {
            
            cell2.cell2view.layer.cornerRadius=5.0;
            [cell2.birthdayBtn2 setUserInteractionEnabled:YES];
            [cell2.birthdayBtn2 setTitle:@"Select your Birthday" forState:UIControlStateNormal];
            
            
            [cell2.editBtn2 setHidden:YES];
            [cell2.editBtn2 setUserInteractionEnabled:NO];
            
            [cell2.saveBtn2 setUserInteractionEnabled:YES];
            [cell2.saveBtn2 setHidden:NO];
            [cell2.saveBtn2 addTarget:self action:@selector(saveBasicInfo:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell2.cancelBtn2 setUserInteractionEnabled:YES];
            [cell2.cancelBtn2 setHidden:NO];
            [cell2.cancelBtn2 addTarget:self action:@selector(cancelBasicInfo:) forControlEvents:UIControlEventTouchUpInside];
            
            cell2.saveBtn2.layer.cornerRadius=2.0;
            cell2.cancelBtn2.layer.cornerRadius=2.0;
            
            [cell2.birthdayBtn2 addTarget:self action:@selector(changeBirthday:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
        }else{
            [cell2.editBtn2 setHidden:NO];
            [cell2.editBtn2 setUserInteractionEnabled:YES];
            
            [cell2.birthdayBtn2 setUserInteractionEnabled:NO];
            
            [cell2.saveBtn2 setUserInteractionEnabled:NO];
            [cell2.saveBtn2 setHidden:YES];
            
            [cell2.cancelBtn2 setUserInteractionEnabled:NO];
            [cell2.cancelBtn2 setHidden:YES];
            
            cell2.cell2view.layer.cornerRadius=5.0;
            [cell2.editBtn2 addTarget:self action:@selector(DOBedit:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    
    if (indexPath.row==2) {
        
        cell3.aboutText.delegate=self;
        
        if(isEditAbout){
            
            cell3.aboutText.editable=YES;
            cell3.cell3View.layer.cornerRadius=5.0;
            [cell3.aboutText setBackgroundColor:backgroundHeaderColor];
            
            [cell3.editBtn3 setHidden:YES];
            [cell3.editBtn3 setUserInteractionEnabled:NO];
            
            [cell3.saveBtn3 setUserInteractionEnabled:YES];
            [cell3.saveBtn3 setHidden:NO];
            [cell3.saveBtn3 addTarget:self action:@selector(saveAbout:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell3.cancelBtn3 setUserInteractionEnabled:YES];
            [cell3.cancelBtn3 setHidden:NO];
            [cell3.cancelBtn3 addTarget:self action:@selector(cancelAbout:) forControlEvents:UIControlEventTouchUpInside];
            
            cell3.saveBtn3.layer.cornerRadius=2.0;
            cell3.cancelBtn3.layer.cornerRadius=2.0;
            
        }else{
            
            [cell3.aboutText setEditable:NO];
            [cell3.aboutText setBackgroundColor:[UIColor whiteColor]];
            
            [cell3.editBtn3 setHidden:NO];
            [cell3.editBtn3 setUserInteractionEnabled:YES];
            
            [cell3.saveBtn3 setUserInteractionEnabled:NO];
            [cell3.saveBtn3 setHidden:YES];
            
            [cell3.cancelBtn3 setUserInteractionEnabled:NO];
            [cell3.cancelBtn3 setHidden:YES];
            
            cell3.cell3View.layer.cornerRadius=5.0;
            [cell3.editBtn3 addTarget:self action:@selector(editAboutMe:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        if (isEditWork) {
            return 130;
        }
        return 90.0;
    }else if (indexPath.row==1){
        if (isEditBasicInfo) {
            return 150;
        }
        return 120.0;
    }else if (indexPath.row==2){
        if (isEditAbout) {
            return 180;
        }
        return 150;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



#pragma mark - EditActions
-(IBAction)DesignationEdit:(id)sender{
    isEditWork=YES;
    [_profiletable reloadData];
    NSLog(@"edit Design");
    
}

-(IBAction)DOBedit:(id)sender{
    NSLog(@"edit DOB");
    
    isEditBasicInfo=YES;
    [_profiletable reloadData];
    
    
}


-(IBAction)editAboutMe:(id)sender{
    isEditAbout=YES;
    
    
    [_profiletable reloadData];
    NSLog(@"edit about me");
    
}

-(IBAction)changeBirthday:(id)sender{
    [self.profiletable setContentOffset:CGPointMake(0, 300) animated:YES];

    [ActionSheetDatePicker showPickerWithTitle:@"Select Your Birthday" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:self.view];
    

}

#pragma mark - saveCancelActions
-(IBAction)saveBasicInfo:(id)sender{
    isEditBasicInfo=NO;
    [cell2.birthdayBtn2 setTitle:_birthdayStr forState:UIControlStateNormal];
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:username,@"userName",_birthdayStr,@"DOB",nil];
    [self checkInternet];

    [SVProgressHUD showWithStatus:@"Updating..." maskType:SVProgressHUDMaskTypeGradient];
    FclAPICleint *sharedClienr=[FclAPICleint sharedClient];
    
    [sharedClienr postPath:@"updateDOB" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"response update DOB %@",dataToString(operation.responseData));
        _myBirthday=_birthdayStr;
        [self.profiletable reloadData];
        [SVProgressHUD dismiss];

    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"failed savebasic info");
        [SVProgressHUD dismiss];
        [self.profiletable reloadData];
        [delegate showErrorNotice:@"Unable to update"];

    }];
    
}

-(IBAction)cancelBasicInfo:(id)sender{
    isEditBasicInfo=NO;
    [cell2.birthdayBtn2 setTitle:@"None Specified" forState:UIControlStateNormal];

    [self.profiletable reloadData];
    
}

-(IBAction)saveWork:(id)sender{
    isEditWork=NO;
    _tfStr=cell1.tf1.text;
    [self checkInternet];

    [SVProgressHUD showWithStatus:@"Updating..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:username,@"userName",_tfStr,@"designation",nil];
    NSLog(@"param des %@",params);
    
    FclAPICleint *sharedClienr=[FclAPICleint sharedClient];
    
    [sharedClienr postPath:@"updatedesignation" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"response update designation %@",dataToString(operation.responseData));
        _myDesignation=_tfStr;
        [self.profiletable reloadData];
        [SVProgressHUD dismiss];
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"failed savedesignation info");
        [SVProgressHUD dismiss];
        [delegate showErrorNotice:@"Unable to update"];
        [self.profiletable reloadData];


    }];
    

    
}

-(IBAction)cancelWork:(id)sender{
    isEditWork=NO;
    _tfStr=@"None Specified";
    [self.profiletable reloadData];
    
}
-(IBAction)saveAbout:(id)sender{
    isEditAbout=NO;
    [SVProgressHUD showWithStatus:@"Updating..." maskType:SVProgressHUDMaskTypeGradient];
    [self checkInternet];

    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:username,@"userName",cell3.aboutText.text,@"aboutMeText",nil];
    
    FclAPICleint *sharedClienr=[FclAPICleint sharedClient];
    
    [sharedClienr postPath:@"updateaboutme" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"response update aboutme %@",dataToString(operation.responseData));
        _myAbout=cell3.aboutText.text;
        [self.profiletable reloadData];
        [SVProgressHUD dismiss];

    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"failed anoutme info");
        [SVProgressHUD dismiss];
        [delegate showErrorNotice:@"Unable to update"];
        [self.profiletable reloadData];

    }];
    
    

}
-(IBAction)cancelAbout:(id)sender{
    isEditAbout=NO;
    cell3.aboutText.text=@"None Specified";
    [self.profiletable reloadData];
    
}

#pragma mark- UITextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark-UITextviewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
//    [self setViewMovedUp:YES];
    [cell3.aboutText setText:@""];
    [self.profiletable setContentOffset:CGPointMake(0, 400)];
    [self.profiletable setContentSize:CGSizeMake(320, 850)];
    
    
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
//    [self.profiletable setContentOffset:CGPointMake(0, 400)];
    return YES;
}




-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
//    [self setViewMovedUp:NO];
    
}





#pragma mark- KeyBoardHideShow
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect rect = self.view.frame;
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
    self.view.frame = rect;
    [UIView commitAnimations];
}

#pragma mark- Date Picker

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    NSLog(@"date %@",[_dateFormatter stringFromDate:selectedDate]);
//    cell2..text=[_dateFormatter stringFromDate:selectedDate];
    
    [cell2.birthdayBtn2 setTitle:[_dateFormatter stringFromDate:selectedDate] forState:UIControlStateNormal];
    _birthdayStr=[_dateFormatter stringFromDate:selectedDate];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    cell1.tf1.text=@"";
    [self.profiletable setContentOffset:CGPointMake(0, 120)];
}


//-(void)DonePickDate{
//    if (_pickedDate.length!=0) {
//        [_birthdayBtn setTitle:_pickedDate forState:UIControlStateNormal];
//    }else{
//        [_birthdayBtn setTitle:[dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
//        
//    }
//    
//}

@end
