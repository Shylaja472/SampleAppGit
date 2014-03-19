//
//  FCLUtilities.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/24/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDKeychainBindings.h"
#import "PDKeychainBindingsController.h"

@interface FCLUtilities : NSObject

@property (nonatomic,strong) NSMutableDictionary *myProfileData;
@property (nonatomic,strong) NSMutableArray *feedArray;

+(FCLUtilities *)getUtils;

#pragma mark - UserNamePassword
+(NSString *)getUserName;
+(void)setUserName:(NSString *)username;
+(NSString *)getPassWord;
+(void)setPassWord:(NSString *)password;


#pragma mark - myProfileStuff
-(NSMutableDictionary *)getMyProfile;
-(void)setMyProfile:(NSMutableDictionary *)profile;

#pragma mark -  feedStuff
-(NSMutableArray *)getMyFeed;
-(void)setMyFeed:(NSMutableArray *)feed;


@end
