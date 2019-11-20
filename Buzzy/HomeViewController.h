//
//  HomeViewController.h
//  Buzzy
//
//  Created by Julien Levallois on 17-05-31.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomActivityIndicator.h"

#import "FilterView.h"
#import "VideoFilterView.h"
#import "Base.h"

#import "MarkerView.h"

#import "LLSimpleCamera.h"


#import "SelectTimeView.h"
#import "DescriptionView.h"
#import "BuzzyMarker.h"
#import "LikedView.h"

#import "BtnMyBuzz.h"
#import "MyBuzzView.h"
#import "SettingsView.h"
#import "WebViewViewController.h"
#import "KingsView.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "BuzzViewController.h"
#import "Position.h"
#import "STHTTPRequest.h"

#import "ZFModalTransitionAnimator.h"

#import "Following.h"
#import "LionView.h"

//#import "ParseLiveQuery-Swift.h"
#import "ComingSoon.h"

#import "scrollFilter.h"
#import "jot.h"

#import "JotView.h"


#import "LegendViewController.h"
#import "FriendsView.h"
#import "DrawView.h"

@interface HomeViewController : UIViewController <GMSMapViewDelegate,SelectTimeViewDelegate,LikeViewProtocol,SettingsViewDelegate,KingsViewProtocol,FriendsViewProtocol>

//Drawing tools
@property DrawView* drawView;
@property(nonatomic)UIButton *drawBtn;

@property(nonatomic)BOOL modeVideo;




@property(nonatomic)UIButton *btnFriends;



@property(nonatomic)PFObject *tutoBuzz;
@property(nonatomic)JotView *jot;


@property(nonatomic)scrollFilter *scrollFilter;


@property (nonatomic, strong) ZFModalTransitionAnimator *animator;


@property(nonatomic)UIView *comingSoon;


@property(nonatomic)BOOL showNewKing;

@property(nonatomic)float oldZoom;

@property(nonatomic)NSMutableArray *markersCity;
@property(nonatomic)NSMutableArray *polylineCity;


@property(nonatomic)NSMutableArray *markersUniversity;
@property(nonatomic)NSMutableArray *polylineUniversity;

@property(nonatomic)NSMutableArray *markersCountry;
@property(nonatomic)NSMutableArray *polylineCountry;
@property(nonatomic)NSMutableArray *markersLionCountry;

@property(nonatomic)BOOL countryDisplayed;
@property(nonatomic)BOOL cityDisplayed;
@property(nonatomic)BOOL cityDisplayed2;
@property(nonatomic)BOOL universityDisplayed;


//@property(nonatomic)PFLiveQueryClient *client;

//@property (nonatomic) PFLiveQuerySubscription *subscriptionMap;
@property (nonatomic) PFQuery *liveQuery;

@property(nonatomic)UIView *flashView;

@property(nonatomic)GMSCameraPosition *camera;
@property(nonatomic)GMSMapView *mapView;

@property(nonatomic)NSTimer *refreshMap;

@property(nonatomic)PFGeoPoint *currentLocation;


@property(nonatomic)UIView *containerMaps;


@property(nonatomic)UIButton *btnSetting;
@property(nonatomic)UIButton *btnLiked;
@property(nonatomic)UIButton *btnKing;
@property(nonatomic)UIButton *btnList;
@property(nonatomic)UIButton *btnLocation;
@property(nonatomic)UIButton *btnTakePhotoDown;
@property(nonatomic)UIButton *deleteBtn;
@property(nonatomic)BtnMyBuzz *btnMyBuzz;

@property(nonatomic)DACircularProgressView *progressView;

@property(nonatomic)NSData *imageData;
@property(nonatomic)PFFile *fileImage;
@property(nonatomic)PFFile *fileVideo;


@property(nonatomic)UIImageView *blur;


@property(nonatomic)NSMutableArray *drawArray;
@property(nonatomic)CALayer *drawImageLayer;

@property(nonatomic)NSMutableArray *myBuzzs;
@property(nonatomic)UIImageView *pastille;

@property(nonatomic)AVAssetExportSession *exportSession;

-(void)addMap;
-(void)refreshNotifs;

-(void)actionButtonLike;


@property (nonatomic) NSURL *videoFileURL;
@property (nonatomic) NSURL *videoFileURLOut;
@property (nonatomic) UIView *videoView;
@property (nonatomic) BOOL videoIsPlaying;
@property(nonatomic)BOOL video;
@property (nonatomic) NSTimer *recordingTimer;
@property (nonatomic) NSTimer *recordingProgres;

@property (nonatomic) BOOL shouldIgnoreTouchUp;
@property (nonatomic) BOOL isRecordingInProgress;
@property (nonatomic) BOOL isVideoReady;

@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerLayer *avPlayerLayer;


///KingsView
@property(nonatomic)KingsView *kingsView;


///Setting view
@property(nonatomic)SettingsView *settingsView;


///Buzz View
@property(nonatomic)MyBuzzView *myBuzzView;


///Liked View
@property(nonatomic)LikedView *likedView;

/// Friends view
@property(nonatomic)FriendsView *friendsView;


-(void)actionTakePhotoDown;
-(void)actionButtonMyBuzz;
-(void)actionButtonKing;

///Camera


@property(nonatomic)PFObject *myBuzz;



@property(nonatomic)BOOL photoSaved;

@property(nonatomic)UILabel* selectedLbl;
@property(strong, nonatomic) UILabel* currentMovingLabel;
@property CGPoint lastPoint;

@property(nonatomic)UIButton *btnCloseCamera;
@property(nonatomic)UIButton *btnFlash;
@property(nonatomic)UIButton *btnSwitch;
@property(nonatomic)UIButton *btnDescription;
@property(nonatomic)UIButton *btnCancel;
@property(nonatomic)UIButton *btnTime;
@property(nonatomic)UIButton *btnDraw;
@property(nonatomic)UIButton *btnSave;
@property(nonatomic)UIButton *btnSendBuzz;
@property(nonatomic)UIActivityIndicatorView *loadingSendBuzz;

@property (strong, nonatomic) FilterView* filterView;
@property (strong, nonatomic) VideoFilterView* videoFilter;
@property (nonatomic) UIImageView *photoImageView;
@property (nonatomic) UIView *whiteOverlayView;
@property (nonatomic) SelectTimeView *selectTimeView;
@property (nonatomic) LLSimpleCamera *cameraView;

-(void)refreshAllNewKing;
-(void)refreshMapAction;


//	Description

@property (strong, nonatomic) NSMutableArray* descriptionsArray;
@property (strong, nonatomic) DescriptionView* descView;

@end
