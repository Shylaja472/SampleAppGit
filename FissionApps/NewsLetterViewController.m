//
//  NewsLetterViewController.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "NewsLetterViewController.h"

@interface NewsLetterViewController ()

@end
UIDocumentInteractionController *documentController;
@implementation NewsLetterViewController

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
    _showPDF.delegate=self;
    
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"TGIF- 4" ofType:@"pdf"];
    
    [_showPDF loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    
    if (IOS_VERSION>=7.0) {
        _VSpaceDownload.constant=412;
    }else{
        _VSpaceDownload.constant=300;
    }
    _showPDF.userInteractionEnabled=YES;
    _showPDF.scalesPageToFit = YES;
    
    
    _showPDF.scrollView.bounces=YES;
    _showPDF.scrollView.alwaysBounceHorizontal=YES;
    _showPDF.scrollView.alwaysBounceVertical=NO;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loadAct stopAnimating];
    [_loadAct setHidesWhenStopped:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [_loadAct startAnimating];
    
    
}


//======pdf files=======
-(void)openDocumentIn {
    NSString * filePath =
    [[NSBundle mainBundle]
     pathForResource:@"TGIF- 4" ofType:@"pdf"];
    documentController =
    [UIDocumentInteractionController
     interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentController.delegate = self;
    documentController.UTI = @"com.adobe.pdf";
    [documentController presentOpenInMenuFromRect:CGRectZero
                                           inView:self.view
                                         animated:YES];
    
}

-(void)documentInteractionControllerWillPresentOptionsMenu:(UIDocumentInteractionController *)controller{
    
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller
       willBeginSendingToApplication:(NSString *)application {
    
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller
          didEndSendingToApplication:(NSString *)application {
    
}

-(void)documentInteractionControllerDidDismissOpenInMenu:
(UIDocumentInteractionController *)controller {
    
}

- (IBAction)downloadPdf:(id)sender {
    [self openDocumentIn];
}
@end
