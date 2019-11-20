//
//  BuzzViewController.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-14.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelPushViewController.h"
#import "BuzzTableViewCell.h"
#import "BbCardView.h"


#import "SwipeView.h"
#import "CustomOverlayView.h"
#import "ZFModalTransitionAnimator.h"
#import "CommentView.h"
#import "KingsView.h"

#import "MyBuzzLikesView.h"

#import "UIActionSheet+Blocks.h"


@interface BuzzViewController : UIViewController<UIGestureRecognizerDelegate,SwipeDelegate,SwipeViewDataSource,BbCardViewDelegate,KingsViewProtocol,UIActionSheetDelegate>


@property(nonatomic)BOOL pretendant;

@property(nonatomic)BOOL fromLiked;

-(void)setback:(UIImage *)image;

@property(nonatomic)UIImage *myImage;

@property(nonatomic)UIImageView *backgroundImage;

@property(nonatomic)CommentView *commentView;


@property(nonatomic)MyBuzzLikesView *mybuzzlikesview;

@property(nonatomic)ZFModalTransitionAnimator *animator;


@property(nonatomic)SwipeView *swipeView;


@property(nonatomic)NSMutableArray *buzzs;


@property(nonatomic)UILabel *titlePage;

@property(nonatomic)UIActivityIndicatorView *indicator;



@property(nonatomic)UIView *containerTableView;


@property(nonatomic)PFGeoPoint *currentLocation;


-(instancetype)initWithBuzzs:(NSArray *)buzzs andPretendant:(BOOL)pretendant fromLiked:(BOOL)liked;

-(instancetype)initWithBuzzs:(NSArray *)buzzs andPretendant:(BOOL)pretendant;

-(instancetype)initWithBuzzs:(NSArray *)buzzs andimage:(UIImage *)image andPretendant:(BOOL)pretendant;

@property(nonatomic)UIImageView *logoEmpty;

@property(nonatomic)KingsView *kingsView;


@end
