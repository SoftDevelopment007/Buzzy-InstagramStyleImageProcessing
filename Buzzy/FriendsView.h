//
//  FriendsView.h
//  Buzzy
//
//  Created by Julien Levallois on 17-09-27.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "Base.h"

#import "BuzzTableViewCell.h"
#import "FriendsTableViewCell.h"


@protocol FriendsViewProtocol <NSObject>


@end

@interface FriendsView : UIView <UITableViewDelegate,UITableViewDataSource>



@property(nonatomic)id<FriendsViewProtocol>delegate;

@property(nonatomic)UIView *navBar;

-(void)hide;
-(void)show;
-(void)refreshData;



@property(nonatomic)NSMutableArray *friends;

@property(nonatomic)UIButton *btnClose;
@property(nonatomic)UIButton *btnAdd;


@property(nonatomic)UILabel *titlePage;

@property(nonatomic)UIActivityIndicatorView *indicator;


@property(nonatomic)UITableView *tableView;

@property(nonatomic)UIView *containerTableView;


@property(nonatomic)UIButton *addButton2;

@property(nonatomic)UIButton *btnPlay;

@end
