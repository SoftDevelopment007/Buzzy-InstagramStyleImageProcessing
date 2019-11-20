//
//  BbCardView.h
//  BottleBond
//
//  Created by Julien Levallois on 16-10-31.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Base.h"
#import "OverlayView.h"
#import "TTTAttributedLabel.h"
#import <QuartzCore/QuartzCore.h>

#import <AVFoundation/AVFoundation.h>

#import <UIKit/UIKit.h>
#import "Base.h"
#import "LikeButton.h"

#import "NewKing.h"
#import "Position.h"


#import "TutorielView.h"

#import <PBJVideoPlayer/PBJVideoPlayer.h>

#import "loadingVideo.h"


@protocol BbCardViewDelegate <NSObject>

-(void)buzzMapLiked:(PFObject *)buzz;
-(void)buzzOpenPretendant:(PFObject *)buzz;
-(void)preloadPretenders:(PFObject *)buzz;
-(void)refreshAllNewKing;

-(void)cardPassed;
-(void)buzzOpenComment:(PFObject *)buzz;
-(void)buzzOpenKing:(PFObject *)buzz;
-(void)buzzOpenLikes:(PFObject *)buzz;
- (void)likeAction;

-(void)reportBuzz:(PFObject *)buzz liked:(BOOL)liked;

-(void)ignoreAction;

@end





@interface BbCardView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,PBJVideoPlayerControllerDelegate,UIGestureRecognizerDelegate>



@property(nonatomic)BOOL dead;

@property(nonatomic)loadingVideo *loading;


@property(nonatomic)BOOL modeVideo;

@property(nonatomic)BOOL pretendant;

@property(nonatomic)BOOL blockSwipe;

@property(nonatomic)BOOL blockDraggable;

@property(nonatomic)TutorielView *tutoView;

@property(nonatomic)UIButton *openMyLike;

@property(nonatomic)BOOL openInsta;

@property(nonatomic)UIView *container;


@property(nonatomic)id<BbCardViewDelegate>delegate;

@property(nonatomic) NSArray *romains;


@property(nonatomic)PFObject *currentBuzz;
@property(nonatomic)int currentBuzzDuration;


@property(nonatomic)UIButton *openProfileInsta;
@property(nonatomic)PFImageView *image;
@property(nonatomic)UIView *bottomView;
@property(nonatomic)PFImageView *profilePicture;

@property(nonatomic)UILabel *descriptionLabel;
@property(nonatomic)UIImageView *filterImage;

@property(nonatomic)UILabel *detail2;
@property(nonatomic)UILabel *detail1;
@property(nonatomic)UILabel *likeLabel;

@property(nonatomic)UIImageView *heart1;
@property(nonatomic)UIImageView *heart2;

@property(nonatomic)LikeButton *likeButton;

@property(nonatomic)UIColor *likedColor;

@property(nonatomic)UIImageView *timeFrameBackground;
@property(nonatomic)UIImageView *timeFrame;

@property(nonatomic)UIView *timerView;
@property(nonatomic)UILabel *timerLabel;

@property(nonatomic)NSTimer *timer;

@property(nonatomic)UIView *pretendantView;
@property(nonatomic)UILabel *pretendantLabel;

@property(nonatomic)UIView *statsView;

@property(nonatomic)UIView *viewTutoSwipe;

@property(nonatomic)UILabel *statsLikeLabel;
@property(nonatomic)UIImageView *statsLikeImage;

@property(nonatomic)UILabel *statsViewLabel;
@property(nonatomic)UIImageView *statsViewImage;

@property(nonatomic)UILabel *statsScreenLabel;
@property(nonatomic)UIImageView *statsScreenImage;

@property(nonatomic)UIView *videoView;

@property(nonatomic)PBJVideoPlayerController *videoPlayer;


@property(nonatomic)UIButton *btnExit;
@property(nonatomic)UIButton *btnFlag;

@property(nonatomic)UIButton *btnSword;
@property(nonatomic)UIImageView *sword;
@property(nonatomic)UILabel *flag;

@property(nonatomic)UIButton *btnComment;
@property(nonatomic)UIButton *btnTrash;
@property(nonatomic)UIButton *btnKing;

@property(nonatomic)UIImageView *pastille;
@property(nonatomic)UIImageView *likeImage;
@property(nonatomic)UIImageView *dislikeImage;


@property(nonatomic)NewKing *kingNew;

-(void)openComment;

-(void)getRelationInsta;

-(void)actionLikeButton;
-(void)actionDisLikeButton;

-(void)show;
-(void)hide;

-(void)openSwordFromKing;


-(void)launchBuzz:(PFObject *)buzz pretendantType:(BOOL)pretendant fromLiked:(BOOL)fromliked;

-(void)launchTimer;

-(void)openInstaProfile;



@end
