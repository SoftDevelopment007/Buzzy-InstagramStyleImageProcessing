//
//  Following.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-31.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "Following.h"

@implementation Following


+(Following*)sharedInstance
{
    // 1
    static Following *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Following alloc] init];
    });
    return _sharedInstance;
}


- (id)init{
    
    
    self = [super init];
    if (self) {
        
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Following"]) {
            
            self.following = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Following"]];
            
            
        }else{
            
            self.following = [[NSMutableArray alloc]init];
            //[self.following addObject:[PFUser currentUser][kUserInstaUsername]];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.following forKey:@"Following"];

        }
        
        NSLog(@"content :: %@",self.following);
        
    }
    return self;
}

-(void)updateFollowingCompletion:(void (^) (BOOL succeeded))completion{
    
    
    
    PFQuery *followers = [PFQuery queryWithClassName:kFollowersClasseName];
    [followers whereKey:kFollowersFrom equalTo:[PFUser currentUser]];
    
    followers.limit=10000;
    [followers includeKey:kFollowersTo];
    
    
    [followers findObjectsInBackgroundWithBlock:^(NSArray * _Nullable following, NSError * _Nullable error) {
        
    
//    [PFCloud callFunctionInBackground:@"getMyFollowing" withParameters:@{@"userId":[PFUser currentUser].objectId} block:^(NSMutableArray   * _Nullable following, NSError * _Nullable error) {
       
        if (error) {
            
            NSLog(@"error followil %@",error);
            return;
        }
        if ( following.count > 0) {
            
            NSMutableArray *replace = [[NSMutableArray alloc]init];
            
//            [replace addObject:[PFUser currentUser][kUserInstaUsername]];

            for (int i = 0; i< following.count; i++) {
                
                
                if ([[following objectAtIndex:i] objectForKey:kFollowersTo]) {
                    
                    [replace addObject:[Utils capitalizedFirstLetterInString:[[[following objectAtIndex:i] objectForKey:kFollowersTo] objectForKey:kUserInstaUsername]]];

                }
                
            }
            
            self.following = [[NSMutableArray alloc]initWithArray:replace];
            
            
            
            [[NSUserDefaults standardUserDefaults] setObject:self.following forKey:@"Following"];
            
            NSLog(@"result following : %@",self.following);
            
            completion(YES);
            
      
        }else{
            
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Following"];

            
            completion(NO);

        }
        
        
        
        
    }];
    
}
@end
