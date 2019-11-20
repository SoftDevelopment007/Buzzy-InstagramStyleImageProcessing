//
//  AppDelegate.m
//  Buzzy
//
//  Created by Julien Levallois on 17-05-31.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// define macro
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


   
    AVAudioSession *session1 = [AVAudioSession sharedInstance];
    [session1 setCategory:AVAudioSessionCategoryAmbient error:nil];
    [session1 setActive:TRUE error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    
    
    
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration
                                        configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
                                            configuration.applicationId = @"hWyTlRLYsr3gReqoNy1BkfLuJPJPU6zUNiHsOkVl";
                                            configuration.clientKey = @"D7xQDcl3284eJ2lJ9GOx2FUYPisRlKUJHSVJPUzU";
                                            configuration.server = @"https://pg-app-unuan133rrtsfyfx5fg6e1rxdxcghe.scalabl.cloud/1/";
                                        }]];

    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    
    MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
    
    alertConfig.defaultTextOK = NSLocalizedString(@"OK",nil);
    alertConfig.defaultTextCancel = NSLocalizedString(@"Cancel",nil);
    alertConfig.defaultTextConfirm = NSLocalizedString(@"Confirm",nil);
//    alertConfig.itemNormalColor =[UIColor blackColor];
//    alertConfig.itemPressedColor =[UIColor blackColor];
//    alertConfig.itemHighlightColor =[UIColor blackColor];

    
//    [PFUser logInWithUsernameInBackground:@"julien" password:@"123456"
//                                    block:^(PFUser *user, NSError *error) {
//                                        if (user) {
//                                            
//                                            NSLog(@"yep user :%@",user);
//                                            
//                                            
//                                            // Do stuff after successful login.
//                                        } else {
//                                            // The login failed. Check error to see why.
//                                        }
//                                    }];
//
    
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[UIColor blackColor]];

    
    [PFInstagramUtils initializeInstagramWithApplicationLaunchOptions:launchOptions];

    
//    NSLog(@"uuuu %@",[PFUser currentUser]);
    
    
    [PFConfig getConfigInBackgroundWithBlock:^(PFConfig * _Nullable config, NSError * _Nullable error) {
        
    }  ];
    
    
    
    /// On load les images des fakes kings pour le tutoriel
    PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
    [query1 whereKey:@"tutoriel" equalTo:@YES];
    [query1 includeKey:kBuzzUser];
    [query1 includeKey:kBuzzCity];
    [query1 includeKey:kBuzzCountry];
    [query1 includeKey:kBuzzUniversity];
    
    [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzs, NSError * _Nullable error) {
        
       
        for (int i = 0; i<buzzs.count; i++) {
            
            
            PFObject *buzz = buzzs[i];
            PFUser *user = buzz[kBuzzUser];
            
            PFFile *picUser = user[kUserProfilePicture];
            [picUser getDataInBackground];
            
            
            PFFile *picBuzz = buzz[kBuzzPhoto];
            [picBuzz getDataInBackground];

            
        }
        
        
    }];

    

    

    [GMSServices provideAPIKey:@"AIzaSyAp8pH_9YcahZHqrMfmFWMHaKj3sPfxazE"];
    
//    [[IntercomControl sharedInstance]ini] ;

  
    if (![PFUser currentUser] || ![PFUser currentUser][kUserGender]) {
   
        
        self.loading = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
        
        self.loginViewController = [[LoginViewController alloc] init];
        
        self.navLogin = [[BNavigationController alloc] initWithRootViewController:self.loginViewController];
        self.navLogin.navigationBarHidden = YES;
        self.navLogin.interactivePopGestureRecognizer.enabled = YES;
        
        
        self.window.rootViewController = self.navLogin;
        
  

        
        [self.window addSubview:self.loading];

        
    }else{
        
        
        
        
        [[IntercomControl sharedInstance] loginIntercomWithId:[PFUser currentUser].objectId];

        
        self.loading = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
        
        self.homeViewController = [[HomeViewController alloc] init];
        
        self.navController = [[BNavigationController alloc] initWithRootViewController:self.homeViewController];
        self.navController.navigationBarHidden = YES;
        self.navController.interactivePopGestureRecognizer.enabled = YES;
        
        
        self.window.rootViewController = self.navController;
        
        
        
        self.tutoView = [[TutorielView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto11"] ) {
            [self.tutoView setStep:1];
            
        }
        
        
        [self.tutoView.nextButton addTarget:self action:@selector(nextTuto) forControlEvents:UIControlEventTouchUpInside];
        
        [self.window addSubview:self.tutoView];
        
        

        
        
        [self.window addSubview:self.loading];
        
        
        

        
        NSDictionary *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (localNotif) {
            
            
            [self pushViewNotifStep1:localNotif];
            
            
            
            
            
            
            
            
            // Parse your string to dictionary
        }

        
    }
    

    

    

    
    
    return YES;
}

-(void)replayTuto{
    
    
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fakeLikedTuto"];

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto1"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto2"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto3"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto5"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto6"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto7"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto8"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto9"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto10"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto11"];

    [self.homeViewController refreshMapAction];
    
    [self.tutoView.nextButton addTarget:self action:@selector(nextTuto) forControlEvents:UIControlEventTouchUpInside];
        [self.tutoView setStep:1];
            
    
}

- (void)cleanUpPFFileCacheDirectory
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cacheDirectoryURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *PFFileCacheDirectoryURL = [cacheDirectoryURL URLByAppendingPathComponent:@"Parse/PFFileCache" isDirectory:YES];
    NSArray *PFFileCacheDirectory = [fileManager contentsOfDirectoryAtURL:PFFileCacheDirectoryURL includingPropertiesForKeys:nil options:0 error:&error];
    
    if (!PFFileCacheDirectory || error) {
        if (error && error.code != NSFileReadNoSuchFileError) {
            NSLog(@"Error : Retrieving content of directory at URL %@ failed with error : %@", PFFileCacheDirectoryURL, error);
        }
        return;
    }
    
    for (NSURL *fileURL in PFFileCacheDirectory) {
        BOOL success = [fileManager removeItemAtURL:fileURL error:&error];
        if (!success || error) {
            NSLog(@"Error : Removing item at URL %@ failed with error : %@", fileURL, error);
            error = nil;
        }
    }
}

-(void)showTutoStep:(int)step{
    
    [self.tutoView setStep:step];
}
-(void)nextTuto{
    
    
    if (self.tutoView.currentStep == 3 && self.homeViewController.tutoBuzz) {
        
        [self.homeViewController launchBuzz:self.homeViewController.tutoBuzz pretendantType:NO];
        
    }
    
    
    
    
    /////
    /////
    
    
  
    
    if (self.tutoView.currentStep  == 11) {
        
        [self.homeViewController actionButtonLike];
        
        
    }
    

}




-(void)addMap{
    
    [self.homeViewController addMap];
    
}
-(void)loginVCCustomer{
    
    self.homeViewController = [[HomeViewController alloc] init];
    self.homeViewController.view.alpha=0;
    
    
    self.navController = [[BNavigationController alloc] initWithRootViewController:self.homeViewController];
    self.navController.navigationBarHidden = YES;
    self.navController.interactivePopGestureRecognizer.enabled = YES;
    
    self.window.rootViewController = self.navController;

    self.tutoView = [[TutorielView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];

    [self.tutoView.nextButton addTarget:self action:@selector(nextTuto) forControlEvents:UIControlEventTouchUpInside];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto11"] ) {
        [self.tutoView setStep:1];
        
    }
    
    [self.window addSubview:self.tutoView];
    [self.window bringSubviewToFront:self.loading];
    
    [UIView animateWithDuration:1
     animations:^{
         
         
         self.homeViewController.view.alpha=1;
         
         
     }
     completion:^(BOOL finished){
         
         appStopLoading;
         
         
         self.loginViewController = nil;

         
     }];
    
    
}


-(void)logout{
    
    
    appPlayLoading;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.homeViewController];

    
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation removeObjectForKey:@"user"];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
       
        
        
        self.loginViewController = [[LoginViewController alloc] init];
        
        
        self.navLogin = [[BNavigationController alloc] initWithRootViewController:self.loginViewController];
        self.navLogin.navigationBarHidden = YES;
        
        self.window.rootViewController = self.navLogin;
        
        
        self.loginViewController.view.alpha=0;
        
        [PFUser logOut];
        [Intercom reset];

        
        [UIView animateWithDuration:1
                         animations:^{
                             
                             
                             self.loginViewController.view.alpha=1;
                             
                             
                         }
                         completion:^(BOOL finished){
                             
                             appStopLoading;
                             
                             
                             self.homeViewController = nil;
                             
                             
                         }];

        
        
        
    }];
    
    
    
    
}



-(void)playLoading{
    
    [self.loading play];
    
}

-(void)stopLoading{
    
    [self.loading stop];
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.badge = 0;
    [currentInstallation saveInBackground];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
   
    
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveInBackground];
        
    }

    
    if ([PFInstagramUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        
        ///Get token !
        
        
        [PFCloud callFunctionInBackground:@"checkMyToken" withParameters:@{@"userId":[PFUser currentUser].objectId} block:^(id  _Nullable object, NSError * _Nullable error) {
           
            if (error) {
                
                [self logout];

                
            }else{
                
                
            }
        }];
        
//        [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//            
//            if (error) {
//                
//                if (error.code == 8) {
//                    
//                    NSLog(@"ici");
//                    
//                    
//                    [self logout];
//                    
//                    
//                }
//                
//                
//                return ;
//            }
//            
//            
//            
//        }];
        
    }

    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/////BEGIN PUSHS

//// Result of calling registerForRemoteNotifications

-(void)registredPush{
    
    
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        
    }else{
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate =self ;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             
             
             if( !error )
             {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //Your main thread code goes in here
                     [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                 });
                 
                 
                 
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
                 
                 
             }
         }];
        
        
        
    }
    
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    
    
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [currentInstallation setObject:language forKey:@"language"];
    
    currentInstallation.channels = @[ @"Global" ];
    [currentInstallation saveInBackground];
    
    [PFUser currentUser][kUserLanguage] = language;
    [[PFUser currentUser]saveInBackground];
    
//    [Intercom setDeviceToken:deviceToken];
    
    
}

////// BEFORE IOS 10 METHODS

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler
{
    // iOS 10 will handle notifications through other methods
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO( @"10.0" ) )
    {
        NSLog( @"iOS version >= 10. Let NotificationCenter handle this one." );
        // set a member variable to tell the new delegate that this is background
        return;
    }
    
    
    // custom code to handle notification content
    if ( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive || [UIApplication sharedApplication].applicationState == UIApplicationStateBackground  ){
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        
        currentInstallation.badge = 0;
        [currentInstallation saveInBackground];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        completionHandler( UIBackgroundFetchResultNewData );
        
    }
    else
    {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        
        currentInstallation.badge = 0;
        [currentInstallation saveInBackground];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

        completionHandler( UIBackgroundFetchResultNewData );
    }
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
        
        
    }];
}


//// IOS 10 METHODS

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    
    
    NSLog(@"On est ici push notifs");
    
    
    // custom code to handle push while app is in the foreground


    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.badge = 0;
    [currentInstallation saveInBackground];
    
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    
    if (self.homeViewController) {
        
        [self pushViewNotifStep1:response.notification.request.content.userInfo];
        
        
    }
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    currentInstallation.badge = 0;
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
    }];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    completionHandler( UIBackgroundFetchResultNewData );
}


-(void)pushViewNotifStep1:(NSDictionary *)content{
    
   
    appPlayLoading;
    
    
    
    
            if ([content objectForKey:@"buzzId"]) {
                
                
                PFQuery *query = [PFQuery queryWithClassName:kBuzzClasseName];
                
              
                [query whereKey:@"objectId" equalTo:[content objectForKey:@"buzzId"]];
                
                [query includeKey:kBuzzUser];
                [query includeKey:kBuzzCity];
                [query includeKey:kBuzzCountry];
                [query includeKey:kBuzzUniversity];
                
                [query orderByDescending:kBuzzKingCountry];
                [query addDescendingOrder:kBuzzKingCity];
                [query addDescendingOrder:kBuzzKingUniversity];
                [query addDescendingOrder:kBuzzLikeNumber];
                
                [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable king, NSError * _Nullable error) {
                    
                    
                    appStopLoading;

                    
                    if (!error && king) {
                        
                        NSMutableArray *buzzs = [[NSMutableArray alloc]initWithObjects:king, nil];
                        
                        
                            
                        [self.homeViewController openBuzzWithArray:buzzs andPretendant:NO];
                        
                            
                    
                    }
                    
                    
                    
                }];

                
                
                
                
                
            }else{
                
                appStopLoading;
                
            }
      
            

    
}



- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

/////////
///////// END PUSHS




@end
