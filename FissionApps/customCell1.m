//
//  customCell1.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/13/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "customCell1.h"

@implementation customCell1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#define inset 10.0f

- (void)setFrame:(CGRect)frame
{
    // To bring about the rounded corner radius in iOS7
    //    if (IOS_VERSION>=7.0)
    //    {
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
    
    super.layer.cornerRadius = 5.0f;
    [super setClipsToBounds:YES];
    //}
}

@end
