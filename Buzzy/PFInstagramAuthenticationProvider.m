/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "PFInstagramAuthenticationProvider.h"


NSString *const PFInstagramUserAuthenticationType = @"instagram";

@implementation NSError (ParseInstagramUtils)

+ (instancetype)pffb_invalidInstagramSessionError {
    return [NSError errorWithDomain:PFParseErrorDomain
                               code:kPFErrorFacebookInvalidSession
                           userInfo:@{ NSLocalizedDescriptionKey : @"Supplied access token is missing required data." }];
}

@end

@implementation PFInstagramAuthenticationProvider

///--------------------------------------
#pragma mark - Init
///--------------------------------------

- (instancetype)initWithApplication:(UIApplication *)application
                      launchOptions:(nullable NSDictionary *)launchOptions {
    self = [super init];
    if (!self) return self;


    return self;
}

+ (instancetype)providerWithApplication:(UIApplication *)application
                          launchOptions:(nullable NSDictionary *)launchOptions {
    return [[self alloc] initWithApplication:application launchOptions:launchOptions];
}

///--------------------------------------
#pragma mark - Authenticate
///--------------------------------------

- (BFTask<NSDictionary<NSString *, NSString *>*> *)authenticateAsyncWithReadPermissions:(nullable NSArray<NSString *> *)readPermissions
                                                                     publishPermissions:(nullable NSArray<NSString *> *)publishPermissions {
    return [self authenticateAsyncWithReadPermissions:readPermissions
                                   publishPermissions:publishPermissions
                                   fromViewComtroller:[self applicationTopViewController]];
}

- (BFTask<NSDictionary<NSString *, NSString *>*> *)authenticateAsyncWithReadPermissions:(nullable NSArray<NSString *> *)readPermissions
                                                                     publishPermissions:(nullable NSArray<NSString *> *)publishPermissions
                                                                     fromViewComtroller:(UIViewController *)viewController {
    return [BFTask taskWithError:[NSError pffb_invalidInstagramSessionError]];
}

- (UIViewController *)applicationTopViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}

///--------------------------------------
#pragma mark - PFUserAuthenticationDelegate
///--------------------------------------

- (BOOL)restoreAuthenticationWithAuthData:(nullable NSDictionary<NSString *, NSString *> *)authData {
    return YES;
}

@end
