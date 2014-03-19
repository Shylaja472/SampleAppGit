//
//  HomeScreenViewController.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageViewModeScaleAspect.h"

@interface HomeScreenViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
//@property  UIImageViewModeScaleAspect *myImage;

@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *topHeader;
@property (strong, nonatomic) IBOutlet UIImageView *myPic;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *feedCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *composeBtn;
- (IBAction)composeBtnActn:(id)sender;

@property NSMutableDictionary *homeDict;


@property UILabel *quoteLabel;
@property UIImageView *quoteImageView;

@property (nonatomic, assign) NSInteger lastContentOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionVSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewVSpace;
@property BOOL dontset;
@property NSMutableArray *feedResponse;

@property (strong,nonatomic) UITapGestureRecognizer *tapOtherProfile;
@property  NSInteger selectedIndex;

@end
