//
//  FclAPICleint.h
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/24/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"
@interface FclAPICleint : AFHTTPClient
+(FclAPICleint *)sharedClient;
@end
