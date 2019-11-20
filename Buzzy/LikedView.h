//
//  LikedView.h
//  Buzzy
//
//  Created by Julien Levallois on 17-06-27.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"

#import "BuzzTableViewCell.h"


@protocol LikeViewProtocol <NSObject>

-(void)launchBuzz:(PFObject *)buzz pretendantType:(BOOL)pretendant fromLiked:(BOOL)liked;
-(void)openBuzzWithArray:(NSArray *)buzzs andPretendant:(BOOL)pretendant;

@end

@interface LikedView : UIView <UITableViewDelegate,UITableViewDataSource>



@property(nonatomic)id<LikeViewProtocol>delegate;


-(void)hide;
-(void)showWithCurrentLocation:(PFGeoPoint *)currentLocation;;
-(void)refreshData;


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


@end
