//
//  FCLUtilities.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/24/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "FCLUtilities.h"

@implementation FCLUtilities

+(FCLUtilities *)getUtils{
    static FCLUtilities *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FCLUtilities alloc] init];
        
    });
    return sharedInstance;
}

#pragma mark - userManagement

+(NSString *)getPassWord{
    return [[PDKeychainBindingsController sharedKeychainBindingsController] stringForKey:@"FCLpassword"];
}


+(NSString *)getUserName{
    return [[PDKeychainBindingsController sharedKeychainBindingsController] stringForKey:@"FCLusername"];;
}

+(void)setUserName:(NSString *)username{
    [[PDKeychainBindingsController sharedKeychainBindingsController] storeString:username forKey:@"FCLusername"];
}

+(void)setPassWord:(NSString *)password{
    
    [[PDKeychainBindingsController sharedKeychainBindingsController] storeString:password forKey:@"FCLpassword"];

}

#pragma mark - myProfileStuff
-(NSMutableDictionary *)getMyProfile{
   return self.myProfileData;
}

-(void)setMyProfile:(NSMutableDictionary *)profile{
    _myProfileData=profile;
}

#pragma mark -  feedStuff
-(NSMutableArray *)getMyFeed
{
    return _feedArray;
    
}
-(void)setMyFeed:(NSMutableArray *)feed{
    
    _feedArray=feed;
    
}
@end
