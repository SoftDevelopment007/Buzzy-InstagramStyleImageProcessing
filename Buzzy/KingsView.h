//
//  KingsView.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-11.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"

#import "BuzzTableViewCell.h"
#import "Position.h"


@protocol KingsViewProtocol <NSObject>

-(void)launchBuzz:(PFObject *)buzz pretendantType:(BOOL)pretendant;
-(void)openBuzzWithArray:(NSArray *)buzzs andPretendant:(BOOL)pretendant;

@end

@interface KingsView : UIView <UITableViewDelegate,UITableViewDataSource>



@property(nonatomic)id<KingsViewProtocol>delegate;


-(void)hide;
-(void)showWithCurrentLocation:(PFGeoPoint *)currentLocation;;
-(void)refreshData;

-(void)showWithBuzz:(PFObject *)buzz;

@property(nonatomic)UIView *navBar;


@property(nonatomic)NSMutableArray *buzzs;

@property(nonatomic)UIButton *btnClose;


@property(nonatomic)UILabel *titlePage;

@property(nonatomic)UIActivityIndicatorView *indicator;


@property(nonatomic)UITableView *tableView;

@property(nonatomic)UIView *containerTableView;


@property(nonatomic)PFGeoPoint *currentLocation;


@property(nonatomic)UIImageView *logoEmpty;

@property(nonatomic)UIButton *btnPlay;

-(void)selectFirst;
@end
