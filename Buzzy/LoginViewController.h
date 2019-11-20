//
//  LoginViewController.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-18.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
#import "InstagramAuthController.h"
#import "PFInstagramUtils.h"


@interface LoginViewController : UIViewController <InstagramAuthDelegate>


@property(nonatomic)InstagramAuthController *instagramVC;


@property(nonatomic)UIButton *btnLogin;
@property(nonatomic)UIImageView *imgLogo;

@property(nonatomic)UILabel *name;

@property(nonatomic)UIImageView *line;

@property(nonatomic)UIButton *terms;


@property(nonatomic)TTTAttributedLabel *genderLabel;
@property(nonatomic)UIImageView *couronne;


@property(nonatomic)UIButton *queen;
@property(nonatomic)UIButton *king;


@end
