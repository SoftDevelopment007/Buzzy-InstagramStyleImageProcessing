//
//  Intercom.m
//  BottleBond
//
//  Created by Julien Levallois on 17-02-02.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "IntercomControl.h"

@implementation IntercomControl

+(IntercomControl*)sharedInstance
{
    // 1
    static IntercomControl *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[IntercomControl alloc] init];
    });
    return _sharedInstance;
}


- (id)init{
    
    
    self = [super init];
    if (self) {
        
        

        
        [Intercom setApiKey:@"ios_sdk-36958591d80d3f421e12d62f6a048d5972a4b687" forAppId:@"uew7hw35"];

        
//        [PFConfig getConfigInBackgroundWithBlock:^(PFConfig *config, NSError *error) {
//            
//            NSString *apiKey = config[@"apiKeyIntercom"];
//            NSString *appId = config[@"appIdIntercom"];
//
//            
//            [Intercom setApiKey:apiKey forAppId:appId];
//            
//        }];
        
        
        
    }
    return self;
}

- (void)loginIntercomWithId:(NSString *)objectId {
    // For best results, use a unique user_id if you have one.
    [Intercom registerUserWithUserId:objectId];
}



-(void)intercomReset{
    
    [Intercom logout];

}

-(void)updateIntercomAttribute:(NSString *)attribute withvalue:(NSString *)value {
    

    ICMUserAttributes *attrs = [[ICMUserAttributes alloc] init];
    attrs.customAttributes =@{ attribute : value};
    
    [Intercom updateUser:attrs];
    
}


-(void)setIntercomEvent:(NSString *)tag{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [Intercom logEventWithName:tag ];
        
        
    });
    
    
    
}


-(void)setIntercomEvent:(NSString *)tag properties:(NSDictionary *)dictionary{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [Intercom logEventWithName:tag metaData:dictionary];
        
    });
    
    
    
}




-(void)intercomSetUserData{
        
    
 
    
}







@end
