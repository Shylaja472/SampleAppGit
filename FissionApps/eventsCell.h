//
//  eventsCell.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/10/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *DOBLabel;
@end
