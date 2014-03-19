//
//  WritePostViewController.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/13/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "WritePostViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
@interface WritePostViewController ()

@end
UIButton *button;
UILabel *placeholderLabel;
@implementation WritePostViewController

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
    

    [self.postTextView setDelegate:self];
    
    [self.view setBackgroundColor:backgroundHeaderColor];
    
    self.postTextView.backgroundColor=[UIColor whiteColor];
    self.postTextView.layer.cornerRadius=2.0;
    
    
    // you might have to play around a little with numbers in CGRectMake method
    // they work fine with my settings
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, _postTextView.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:@"Write Something..."];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    
    // textView is UITextView object you want add placeholder text to
    [self.postTextView addSubview:placeholderLabel];
    UIButton *postbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postbutton addTarget:self action:@selector(PostFeed:) forControlEvents:UIControlEventTouchUpInside];
    postbutton.frame = CGRectMake(0, 0, 40, 24);
    [postbutton setTitle:@"Post" forState:UIControlStateNormal];
    [postbutton setBackgroundColor:[UIColor clearColor]];
    [postbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:postbutton] ;
    self.navigationItem.rightBarButtonItem = rightItem;

    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"back-btn-white.png"]  ; // Here set the back button image
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(Home) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 28, 30);
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

    
    
    if (IOS_VERSION<7.0) {
        _plusButton.frame=CGRectMake(155, 420, _plusButton.frame.size.width, _plusButton.frame.size.height);
    }

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
-(IBAction)PostFeed:(id)sender{
    [self checkInternet];
    if (_pickedImage) {
    
        FclAPICleint *sharedClient=[FclAPICleint sharedClient];
        NSString *myusername=[FCLUtilities getUserName];
        NSString *text;
        if (_postTextView.text.length==0) {
            text=@"";
        }else{
            text=_postTextView.text;
        }
        NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:text,@"Feedtext",myusername,@"userName", nil];
        NSLog(@"paarsm %@",params);
        NSData *imageData;
        NSLog(@"image to be posetd %@",_imageToBePosted);
        imageData=UIImagePNGRepresentation(_imageToBePosted);
//        NSLog(@"image data %@",imageData);

        if (imageData) {
            [SVProgressHUD showWithStatus:@"Posting..." maskType:SVProgressHUDMaskTypeGradient];
            NSMutableURLRequest *request=[sharedClient multipartFormRequestWithMethod:@"POST" path:@"createFeed" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>formData){
                
                [formData appendPartWithFileData:imageData name:@"feedURL" fileName:@"feedURL.png" mimeType:@"image/png"];
                
            }];
            
            AFHTTPRequestOperation * imageRequest = [sharedClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation,id responseObject) {
                NSLog(@"successe post feed");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"postFeed" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD dismiss];
                
            } failure:^(AFHTTPRequestOperation *operation,NSError * error) {
                NSLog(@"operation code %ld",(long)operation.response.statusCode);
                NSLog(@"failure post feed");
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            [imageRequest start];
        }
    }else{
        if ([_postTextView.text isEqualToString:@""]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Feed Cannot be empty" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }else{
        FclAPICleint *sharedclient=[FclAPICleint sharedClient];
        
        NSString *username=[FCLUtilities getUserName];
        NSLog(@"username %@",username);
        
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:_postTextView.text,@"Feedtext",username,@"userName", nil];
            [SVProgressHUD showWithStatus:@"Posting..." maskType:SVProgressHUDMaskTypeGradient];
        [sharedclient postPath:@"createFeedtext" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"postFeed" object:nil];
            [SVProgressHUD dismiss];
            NSLog(@"Success Request: %@",dataToString(operation.request.HTTPBody));
            NSLog(@"Success Response: %@",dataToString(operation.responseData));
            [self.navigationController popViewControllerAnimated:YES];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [SVProgressHUD dismiss];
            NSLog(@"fail post");
            
        }];
        }

    }
  
        
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
//    textView.text=@"";
    [textView setFont:[UIFont fontWithName:@"Arial" size:13.0]];
    textView.textColor=[UIColor blackColor];
    
    
    button=[UIButton buttonWithType:UIButtonTypeCustom];
    if ([[UIScreen mainScreen]bounds].size.height==568) {
        button.frame=CGRectMake(280, self.view.center.y-80, 40, 40);
    }else{
        button.frame=CGRectMake(280, self.view.center.y-50, 40, 40);
    }
    [button setBackgroundImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}

-(IBAction)dismissKeyBoard:(id)sender{
    [self.postTextView resignFirstResponder];
    [button setHidden:YES];
}

- (IBAction)plusButtonAction:(id)sender {
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self
                                                 cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Gallery",nil];
    actionSheet.destructiveButtonIndex=4;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"buton inde 0");
        
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

    }else if (buttonIndex==1){
        NSLog(@"button index 1");
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            _camera=NO;
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
    _pickedImage=YES;
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
      //  _postImage.image = [self imageByScalingAndCroppingForSize:CGSizeMake(_postImage.frame.size.width, _postImage.frame.size.height) :info[UIImagePickerControllerOriginalImage]];
        _postImage.image=info[UIImagePickerControllerOriginalImage];
        _imageToBePosted=info[UIImagePickerControllerOriginalImage];
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


- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize :(UIImage *)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    
    UIGraphicsBeginImageContextWithOptions(targetSize, self.view.opaque, 0.0);
    
    
    // UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void) textViewDidChange:(UITextView *)theTextView
{
    if(![theTextView hasText]) {
        [theTextView addSubview:placeholderLabel];
    } else if ([[theTextView subviews] containsObject:placeholderLabel]) {
        [placeholderLabel removeFromSuperview];
    }
}

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![theTextView hasText]) {
        [theTextView addSubview:placeholderLabel];
    }
}


@end
