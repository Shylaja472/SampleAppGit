//
//  FclAPICleint.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/24/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "FclAPICleint.h"

#import "AFJSONRequestOperation.h"

static NSString * const kFCLBaseUrl = @"http://192.168.2.28:8080/RumorMill/";

@implementation FclAPICleint

+ (FclAPICleint *)sharedClient {
    static FclAPICleint *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[FclAPICleint alloc] initWithBaseURL:[NSURL URLWithString:kFCLBaseUrl]];
    });
    
    return _sharedClient;
}

//- (id)initWithBaseURL:(NSURL *)url {
//    self = [super initWithBaseURL:url];
//    if (!self) {
//        return nil;
//    }
//    
//    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    self.parameterEncoding = AFJSONParameterEncoding;
//    
//    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
//	[self setDefaultHeader:@"Accept" value:@"application/json"];
//    
//    return self;
//}


@end
