//
//  InstaAPI.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-21.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "InstaAPI.h"

@implementation InstaAPI

+(InstaAPI*)sharedInstance
{
    // 1
    static InstaAPI *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[InstaAPI alloc] init];
    });
    return _sharedInstance;
}


- (id)init{
    
    
    self = [super init];
    if (self) {
        
        self.followers = [[NSMutableArray alloc]init];
        
    }
    return self;
}


-(void)updateFollowers:(void (^) (BOOL succeeded, NSError *error))completion{

    
    [PFCloud callFunctionInBackground:@"getFollowers" withParameters:@{@"userId":[PFUser currentUser].objectId} block:^(id  _Nullable objects, NSError * _Nullable error) {
        
                                                                       
        
        
        if (!error) {
            
            NSLog(@"results ;   %@",objects);
            
        }
        
                                                                       
                                                                       
                                                                       
    }];
    

};





@end
