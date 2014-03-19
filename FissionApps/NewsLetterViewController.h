//
//  NewsLetterViewController.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface NewsLetterViewController : UIViewController<UIWebViewDelegate,UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *VSpaceDownload;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadAct;
@property (strong, nonatomic) IBOutlet UIWebView *showPDF;
- (IBAction)downloadPdf:(id)sender;
@end
