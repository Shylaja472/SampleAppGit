//
//  ProfileEditViewController.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/22/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "ProfileEditViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController

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
        _aboutMeTextView.delegate=self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        _myProfilePic.layer.cornerRadius=80.0;
        _myProfilePic.layer.masksToBounds=YES;
        _myProfilePic.clipsToBounds=YES;
        [_myProfilePic setImage:[UIImage imageNamed:@"pic.jpg"]];
        
        [self.view setBackgroundColor:backgroundHeaderColor];
        
        _view_Work.layer.cornerRadius=10.0;
        _viewBasicInfo.layer.cornerRadius=10.0;
//        _saveBtn.layer.cornerRadius=5.0;
//        _cancelBtn.layer.cornerRadius=5.0;
    
        [self viewDefaultState];

    });
    
    
       
    _nameLabel.strokeSize=0.3;
//    _nameLabel.textColor=[UIColor magentaColor];
    _nameLabel.strokeColor=[UIColor blackColor];

    
    
    self.DesignationTF.backgroundColor=[UIColor clearColor];
    self.DesignationTF.userInteractionEnabled=NO;
    
    self.burthdayBtn.userInteractionEnabled=NO;
    
    self.aboutMeTextView.userInteractionEnabled=NO;
    
//    self.saveBtn.userInteractionEnabled=NO;
//    self.cancelBtn.userInteractionEnabled=NO;
//    self.saveBtn.hidden=YES;
//    self.cancelBtn.hidden=YES;
    
    
    _tapOnImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePic:)];
    _myProfilePic.userInteractionEnabled=YES;
    [_myProfilePic setMultipleTouchEnabled:YES];
    _tapOnImage.delegate=self;
    _tapOnImage.numberOfTapsRequired=1;    
    [_myProfilePic addGestureRecognizer:_tapOnImage];
    
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [self getMyProfile];
    


}
-(void)getMyProfile{
    
    
    FclAPICleint *sharedClient=[FclAPICleint sharedClient];
    NSString *username=[FCLUtilities getUserName];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:username,@"userName", nil];
    
    [sharedClient postPath:@"profileDetails" parameters:dict success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"rmy profile data %@",dataToString(operation.responseData));
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"failed get profile");
    }];
}

-(void)viewDefaultState{

    [self workNonEditState];
    [self basicInfoNonEditState];
    [self aboutMeNonEditState];
        
}

#pragma mark - WorkStuff
-(void)workNonEditState{
    _workHeight.constant=97;
}

-(void)workEditState{
    _workHeight.constant=130;
}
- (IBAction)editWorkActn:(id)sender {
}
- (IBAction)saveWorkActn:(id)sender {
}
- (IBAction)cancelWorkActn:(id)sender {
}

#pragma mark - BasicInfoStuff
-(void)basicInfoEditState{
    _basicHeight.constant=130;
}
-(void)basicInfoNonEditState{
    _basicHeight.constant=97;
}
- (IBAction)editUserInfoActn:(id)sender {
}
- (IBAction)saveBasicInfoActn:(id)sender {
}
- (IBAction)cancelBasicactn:(id)sender {
}



#pragma mark - AboutMeStuff
-(void)aboutMeNonEditState{
    _aboutheight.constant=170;
}
-(void)aboutMeEditState{
    _aboutheight.constant=130;

}

- (IBAction)editAboutActn:(id)sender {
}
- (IBAction)saveAboutActn:(id)sender {
}
- (IBAction)cancelAboutActn:(id)sender {
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
        _myProfilePic.image = info[UIImagePickerControllerOriginalImage];
        
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

-(void)viewDidLayoutSubviews{
    _topScroller.contentSize=CGSizeMake(320, 780);
}


-(void)viewDidAppear:(BOOL)animated{
    
    

}


#pragma mark - UIScrollviewDelegate



- (IBAction)saveDetail:(id)sender {
    
    FclAPICleint *sharedClient=[FclAPICleint sharedClient];
    
    NSString *username=[FCLUtilities getUserName];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:username,@"userName",_aboutMeTextView.text,@"aboutMeText", nil];
    
    
    [sharedClient postPath:@"updateaboutme" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        NSLog(@"reponse %@",dataToString(operation.responseData));
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
    
    
    
}



-(IBAction)EditPrfoile:(id)sender{
    
    self.DesignationTF.backgroundColor=[UIColor lightGrayColor];
    self.DesignationTF.userInteractionEnabled=YES;
    self.DesignationTF.placeholder=@"designation";
    
    self.burthdayBtn.userInteractionEnabled=YES;
    [self.burthdayBtn setTitle:@"Select your Birthday" forState:UIControlStateNormal];
    
    self.aboutMeTextView.userInteractionEnabled=YES;
    self.aboutMeTextView.backgroundColor=[UIColor lightGrayColor];

//    self.saveBtn.userInteractionEnabled=YES;
//    self.cancelBtn.userInteractionEnabled=YES;
//    self.saveBtn.hidden=NO;
//    self.cancelBtn.hidden=NO;

    
//    
//    UIImageView *gradientView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 00, 160, 160)];
//    gradientView.backgroundColor=[UIColor blackColor];
//    gradientView.alpha=0.5;
//    [_myProfilePic addSubview:gradientView];
    
    
}


- (IBAction)birthdayEdit:(id)sender {
    [ActionSheetDatePicker showPickerWithTitle:@"Select Your Birthday" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:self.view];
}

#pragma mark- Date Picker

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    NSLog(@"date %@",[_dateFormatter stringFromDate:[NSDate date]]);
    //    cell2..text=[_dateFormatter stringFromDate:selectedDate];
    
    [self.burthdayBtn setTitle:[_dateFormatter stringFromDate:selectedDate] forState:UIControlStateNormal];
    _birthdayStr=[_dateFormatter stringFromDate:selectedDate];
    
}

#pragma mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    
    
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
//    [self.topScroller layoutIfNeeded]; // 3

//    [self.topScroller setContentOffset:CGPointMake(0, 100)];
    [_aboutMeTextView setText:@""];
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
    }
    
    return YES;
    
}



-(void)viewDidDisappear:(BOOL)animated{
}




@end
