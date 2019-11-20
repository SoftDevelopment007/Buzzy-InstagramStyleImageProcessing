//
//  SettingsView.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-11.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"

#import "SettingsTableViewCell.h"


@protocol SettingsViewDelegate <NSObject>


-(void)buzzMapLiked:(PFObject *)buzz;

-(void)openPrivacy;
-(void)openTerms;
-(void)openInviteFriends;
-(void)openHelpSupport;
-(void)openRateUs;
-(void)openLogout;
-(void)openTutorial;

-(void)openLegend;

@end
@interface SettingsView : UIView <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)id<SettingsViewDelegate>delegate;


@property(nonatomic)UIButton *btnClose;


@property(nonatomic)UILabel *titlePage;

@property(nonatomic)UIActivityIndicatorView *indicator;


@property(nonatomic)UITableView *tableView;

@property(nonatomic)UIView *containerTableView;

@property(nonatomic)NSMutableArray *content;


@property(nonatomic)UIView *headerView;


@property(nonatomic)PFImageView *profilePicture;
@property(nonatomic)UILabel *firstName;
@property(nonatomic)UILabel *username;


@property(nonatomic)UIButton *btnCancel;





-(void)show;
-(void)hide;


@end
