//
//  AppDelegate.h
//  Buzzy
//
//  Created by Julien Levallois on 17-05-31.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
#import "HomeViewController.h"
#import "BNavigationController.h"

#import "LoadingView.h"

#import "PFInstagramUtils.h"

#import "LoginViewController.h"
#import <UserNotifications/UserNotifications.h>

#import "TutorielView.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;



@property(nonatomic)LoginViewController *loginViewController;

@property(nonatomic)HomeViewController *homeViewController;
@property (nonatomic) BNavigationController *navController;
@property (nonatomic) BNavigationController *navLogin;

@property(nonatomic)TutorielView *tutoView;

@property(nonatomic)LoadingView *loading;

-(void)playLoading;
-(void)stopLoading;

-(void)loginVCCustomer;

-(void)logout;
-(void)registredPush;

-(void)addMap;


-(void)showTutoStep:(int)step;

-(void)replayTuto;


@end

