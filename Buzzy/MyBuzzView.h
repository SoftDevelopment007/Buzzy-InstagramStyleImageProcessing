//
//  MyBuzzView.h
//  Buzzy
//
//  Created by Julien Levallois on 17-06-29.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Base.h"

#import "BuzzTableViewCell.h"


@protocol LikeViewProtocol <NSObject>

-(void)launchBuzz:(PFObject *)buzz pretendantType:(BOOL)pretendant;
-(void)openBuzzWithArray:(NSArray *)buzzs andPretendant:(BOOL)pretendant;

@end

@interface MyBuzzView : UIView <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)id<LikeViewProtocol>delegate;


-(void)hide;
-(void)showMyBuzz:(NSMutableArray *)myBuzzs WithCurrentLocation:(PFGeoPoint *)currentLocation;;
-(void)refreshData;

@property(nonatomic)UIView *navBar;

@property(nonatomic)UIView *containerTableView;

@property(nonatomic)NSMutableArray *buzzs;

@property(nonatomic)UIButton *btnClose;


@property(nonatomic)UILabel *titlePage;

@property(nonatomic)UIActivityIndicatorView *indicator;


@property(nonatomic)UITableView *tableView;


@property(nonatomic)PFGeoPoint *currentLocation;

@property(nonatomic)UIImageView *logoEmpty;


@property(nonatomic)UIButton *btnPlay;

@end
