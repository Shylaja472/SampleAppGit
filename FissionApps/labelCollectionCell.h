//
//  labelCollectionCell.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/17/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface labelCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *namelabel3;
@property (strong, nonatomic) IBOutlet UILabel *postLabel3;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl3;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;
@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthImage;
@end
