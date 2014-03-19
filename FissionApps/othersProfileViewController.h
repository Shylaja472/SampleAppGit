//
//  othersProfileViewController.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 3/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface othersProfileViewController : UIViewController<UIScrollViewDelegate>
@property (strong,nonatomic) NSString *userName;
@property (nonatomic,retain) UIImageView *friendPic;
@property (nonatomic,retain) UIButton *detailsBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *topScroll;
@property BOOL isShowingDetails;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *birdthdayLbl;
@property (strong,nonatomic) NSMutableDictionary *profileDetails;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UIButton *clickProfile;
- (IBAction)profile:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightCn;
@property (strong, nonatomic) IBOutlet UITextView *aboutText;
@property (strong, nonatomic) IBOutlet UILabel *designLbl;
@end
