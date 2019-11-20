//
//  PFInstagramUtils.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-18.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <Parse/PFConstants.h>
#import <Parse/PFUser.h>


#import <Bolts/BFExecutor.h>
#import <Bolts/BFTask.h>
#import <UIKit/UIKit.h>

#import "PFInstagramAuthenticationProvider.h"

@interface PFInstagramUtils : NSObject


+ (void)logInInBackgroundWithAccessToken:(NSString *_Nonnull)accessToken instaId:(NSString *_Nonnull)instaId
                                   block:(nullable PFUserResultBlock)block;



+ (void)initializeInstagramWithApplicationLaunchOptions:(NSDictionary *_Nullable)launchOptions;

+ (BOOL)isLinkedWithUser:(PFUser *_Nonnull)user;

@end
