//
//  PFInstagramUtils.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-18.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "PFInstagramUtils.h"



@implementation BFTask (PFInstagramUtils)

- (instancetype)pffb_continueWithMainThreadUserBlock:(PFUserResultBlock)block {
    return [self pffb_continueWithMainThreadBlock:^id(BFTask *task) {
        if (block) {
            block(task.result, task.error);
        }
        return nil;
    }];
}

- (instancetype)pffb_continueWithMainThreadBooleanBlock:(PFBooleanResultBlock)block {
    return [self pffb_continueWithMainThreadBlock:^id(BFTask *task) {
        if (block) {
            block([task.result boolValue], task.error);
        }
        return nil;
    }];
}

- (instancetype)pffb_continueWithMainThreadBlock:(BFContinuationBlock)block {
    return [self continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:block];
}

@end

@implementation PFInstagramUtils


///--------------------------------------
#pragma mark - Authentication Provider
///--------------------------------------

static PFInstagramAuthenticationProvider *authenticationProvider_;

+ (void)_assertInstagramInitialized {
    if (!authenticationProvider_) {
        [NSException raise:NSInternalInconsistencyException format:@"You must initialize PFInstagramUtils with a call to +initializeInstagramWithApplicationLaunchOptions"];
    }
}

+ (PFInstagramAuthenticationProvider *)_authenticationProvider {
    return authenticationProvider_;
}

+ (void)_setAuthenticationProvider:(PFInstagramAuthenticationProvider *)provider {
    authenticationProvider_ = provider;
}


+(void)initializeInstagramWithApplicationLaunchOptions:(NSDictionary * _Nullable)launchOptions {
    
    
    
    
    PFInstagramAuthenticationProvider *provider = [PFInstagramAuthenticationProvider providerWithApplication:[UIApplication sharedApplication]
                                                                                               launchOptions:launchOptions];
    
    [PFUser registerAuthenticationDelegate:provider forAuthType:PFInstagramUserAuthenticationType];
    
    [PFInstagramUtils _setAuthenticationProvider:provider];
    
    
    
}




+ (nullable NSDictionary *)userAuthenticationDataFromAccessToken:(NSString *)token instaId:(NSString *)instaId {
    
    
    return @{ @"id" : instaId,
              @"access_token" : token,
              };
    
    
    
}


+ (BFTask<PFUser *> *)logInInBackgroundWithAccessToken:(NSString *)accessToken instaId:(NSString *)instaId{
    
    
    NSDictionary *authData = [self userAuthenticationDataFromAccessToken:accessToken instaId:instaId];
    
    
    
    return [[PFUser logInWithAuthTypeInBackground:PFInstagramUserAuthenticationType
                                         authData:authData] continueWithSuccessBlock:^id(BFTask *task) {
        
        return task; // Return the same result.
    }];
}



+ (void)logInInBackgroundWithAccessToken:(NSString *_Nonnull)accessToken instaId:(NSString *_Nonnull)instaId
                                   block:(nullable PFUserResultBlock)block{
    
    [[self logInInBackgroundWithAccessToken:accessToken instaId:instaId ] pffb_continueWithMainThreadUserBlock:block];
}



+ (BOOL)isLinkedWithUser:(PFUser *)user {
    return [user isLinkedWithAuthType:PFInstagramUserAuthenticationType];
}




@end
