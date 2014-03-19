//
//  WritePostViewController.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/13/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface WritePostViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextView *postTextView;
@property (strong, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomTool;
@property (strong, nonatomic) IBOutlet UIButton *plusButton;
- (IBAction)plusButtonAction:(id)sender;
@property BOOL camera;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize :(UIImage *)image;
@property BOOL pickedImage;
@property UIImage *imageToBePosted;
@end
