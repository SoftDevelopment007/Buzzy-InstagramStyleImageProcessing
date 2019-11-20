//
//  HomeViewController.m
//  Buzzy
//
//  Created by Julien Levallois on 17-05-31.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "FilterView.h"

#define TESTING_MODE YES

static const float MaxRecordingDuration = 8.0;

CGFloat lastRotation;


static float const LevelZoomCountryMax = 6.5;

static float const LevelZoomCityMin = 6.5;

static float const LevelZoomCityMax = 13;

static float const LevelZoomUniversityMin = 11.0;


static int const LargeurACountry = 50000;
static int const LargeurBCountry = 20000;

static int const LargeurACity = 600;
static int const LargeurBCity = 300;

static int const LargeurAUniversity = 65;
static int const LargeurBUniversity = 35;


@interface HomeViewController (){
    UISwipeGestureRecognizer *swipeGest;
    UITapGestureRecognizer *tapGesture1;
    UITapGestureRecognizer *tapGesture2;
    UIPinchGestureRecognizer *pgr1;
    UISwipeGestureRecognizer *swipeCancel;
    UILongPressGestureRecognizer *longPressGestureRecognizer;
    UIPanGestureRecognizer* panGesture;
    UIPinchGestureRecognizer *pgr;
    UIRotationGestureRecognizer *rotationRecognizer;
    UIRotationGestureRecognizer *rotationRecognizer2;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    self.markersCity = [[NSMutableArray alloc]init];
    self.markersCountry = [[NSMutableArray alloc]init];
    self.markersUniversity = [[NSMutableArray alloc]init];
    
    self.markersLionCountry = [[NSMutableArray alloc]init];
    
    appRegistredPush;
    
    appPlayLoading;
    
//    [self livequery];
    
    [[Following sharedInstance]updateFollowingCompletion:^(BOOL succeeded) {
        
        if (![PFUser currentUser]) return;
        
        [self refreshMapAction];
    }];
    

    [[Position sharedInstance]updatePositionCompletion:^(BOOL succeeded) {
        
        appStopLoading;
		
		if (![PFUser currentUser]) return;
		
		if ([[Position sharedInstance]currentCountry] == NULL) {
			
			[[Position sharedInstance]updatePositionCompletion:^(BOOL succeeded) {
				appStopLoading;
				
				if (![PFUser currentUser])  return;
				
				if ([[Position sharedInstance]currentCountry] == NULL) {
					
					[[Position sharedInstance]updatePositionCompletion:^(BOOL succeeded) {
						
						appStopLoading;
						
						if (![PFUser currentUser]) return;
						
						if ([[Position sharedInstance]currentCountry] == NULL && [[PFConfig currentConfig][@"blockLocation"] isEqual:@YES]) {
							
							
							self.comingSoon =[[ComingSoon alloc]initWithFrame:self.view.frame];
							self.view.layer.zPosition = MAXFLOAT - 5;
							[self.view addSubview:self.comingSoon];
						}else{
						}
						
						[self refreshMyBuzz];
						[self refreshMapAction];
						[self appBecomeActive];
					}];
					
				}else{
					[self refreshMyBuzz];
					[self refreshMapAction];
					[self appBecomeActive];
				}
			}];
			
		}else{
			[self refreshMyBuzz];
			[self refreshMapAction];
			[self appBecomeActive];
		}
	}];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(appBecomeActive)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecomeInactive)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
//    NSError *error;
//
//    AVAudioSession *aSession = [AVAudioSession sharedInstance];
//    [aSession setCategory:AVAudioSessionCategoryMultiRoute
//              withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
//                    error:&error];

//    [aSession setMode:AVAudioSessionModeDefault error:&error];
//    [aSession setActive: YES error: &error];

    
    // register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(interruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(routeChange:)
//                                                 name:AVAudioSessionRouteChangeNotification
//                                               object:nil];
//
//
    
    self.cameraView = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:LLCameraPositionRear
                                             videoEnabled:YES];
//    self.cameraView.mirror=LLCameraMirrorOn;
    
    self.cameraView.view.backgroundColor= [UIColor blackColor];
  
    self.videoFileURL = [[[self applicationDocumentsDirectory]
                          URLByAppendingPathComponent:@"Video"] URLByAppendingPathExtension:@"mov"];
    
    
    self.videoFileURLOut = [[[self applicationDocumentsDirectory]
                             URLByAppendingPathComponent:@"VideoExport"] URLByAppendingPathExtension:@"mov"];
    
    

    
    
    CALayer *focusBox = [[CALayer alloc] init];
    focusBox.cornerRadius = 30.0f;
    focusBox.bounds = CGRectMake(0.0f, 0.0f, 60, 60);
    focusBox.borderWidth = 3.0f;
    focusBox.borderColor = [[UIColor redBuzzy] CGColor];
    focusBox.opacity = 0.0f;
    [self.cameraView.view.layer addSublayer:focusBox];
    
    CABasicAnimation *focusBoxAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    focusBoxAnimation.duration = 0.75;
    focusBoxAnimation.autoreverses = NO;
    focusBoxAnimation.repeatCount = 0.0;
    focusBoxAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    focusBoxAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [self.cameraView alterFocusBox:focusBox animation:focusBoxAnimation];
    
    // attach to a view controller
    [self.cameraView attachToViewController:self withFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.cameraView.fixOrientationAfterCapture = YES;
	
    
    /// Afficher l'image prise
    self.photoImageView = [[UIImageView alloc] init];
    self.photoImageView.backgroundColor = [UIColor whiteColor];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.hidden =YES;
    self.photoImageView.layer.masksToBounds=YES;
    [self.photoImageView setFrame:CGRectMake(0,  0, largeurIphone,hauteurIphone)];
    self.photoImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.photoImageView];
    tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(actionDescriptionView)];
    
    [self.photoImageView addGestureRecognizer:tapGesture1];

//	Video View
    self.videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    self.videoView.backgroundColor = [UIColor blackColor];
    self.videoView.hidden=YES;
    self.videoView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.videoView];
    tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(actionDescriptionView)];
    [self.videoView addGestureRecognizer:tapGesture2];
    
    pgr1 = [[UIPinchGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.videoView addGestureRecognizer:pgr1];

//    Photo Filter
    
    self.filterView = [[FilterView alloc] initWithFrame:CGRectMake(0,  0, largeurIphone,hauteurIphone)];
    self.videoFilter = [[VideoFilterView alloc] initWithFrame:CGRectMake(0,  0, largeurIphone,hauteurIphone)];
    
    self.blur = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    
    self.blur.image = [UIImage imageNamed:@"Blur"];
    

//    [self.view addSubview:self.blur];
    
//    self.jot = [[JotView alloc]init];
//    self.jot.hidden = NO;
//    self.jot.userInteractionEnabled = false;
//    self.jot.frame = CGRectMake(0, 0, largeurIphone, hauteurIphone);
//    [self.jot setState:JotViewStateDrawing];
//    [self.jot setDrawingColor:[UIColor yellowBuzzy]];
//    [self.view addSubview:self.jot];
//    
//    
    
//    self.scrollFilter = [[scrollFilter alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
//    self.scrollFilter.hidden = YES;
//    [self.view addSubview:self.scrollFilter];

    
    
//    UITapGestureRecognizer *tapPhoto =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addTitleAction)];
//    [self.photoImageView addGestureRecognizer:tapPhoto];
//
    
    if (IS_IPHONEX) {
        
        self.btnCloseCamera = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2-50/2, 14+30, 50, 50)];

    }else{
        
        self.btnCloseCamera = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2-50/2, 14, 50, 50)];

    }
    
    [self.btnCloseCamera setBackgroundImage:[UIImage imageNamed:@"btnCloseCamera"] forState:UIControlStateNormal];
    [self.btnCloseCamera addTarget:self action:@selector(actionTakePhotoUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnCloseCamera];
    
    
    swipeCancel = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionTakePhotoUp)];
    [swipeCancel setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.btnCloseCamera addGestureRecognizer:swipeCancel];
    
    
    
    
    if (IS_IPHONEX) {
        
        self.btnSwitch = [[UIButton alloc]initWithFrame:CGRectMake(5, hauteurIphone-55-20, 50, 50)];

    }else{
        
        self.btnSwitch = [[UIButton alloc]initWithFrame:CGRectMake(5, hauteurIphone-55, 50, 50)];

    }
    
    [self.btnSwitch setBackgroundImage:[UIImage imageNamed:@"btnSwitch"] forState:UIControlStateNormal];
    [self.btnSwitch addTarget:self action:@selector(actionSwitchCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSwitch];
    
    
    
    if (IS_IPHONEX) {
        
        self.btnFlash = [[UIButton alloc]initWithFrame:CGRectMake(5+50, hauteurIphone-55-20, 50, 50)];

    }else{
        
        self.btnFlash = [[UIButton alloc]initWithFrame:CGRectMake(5+50, hauteurIphone-55, 50, 50)];

    }
    [self.btnFlash setBackgroundImage:[UIImage imageNamed:@"btnFlash"] forState:UIControlStateNormal];
    [self.btnFlash addTarget:self action:@selector(actionFlashCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnFlash];
    
    
    if (IS_IPHONEX) {
        
        self.btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2-50/2, 14+30, 50, 50)];

    }else{
        
        self.btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2-50/2, 14, 50, 50)];
    }
    [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btnCancel"] forState:UIControlStateNormal];
    self.btnCancel.hidden = YES;
    [self.btnCancel addTarget:self action:@selector(actionCancelPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnCancel];
    
    
    
    // Delete
    
    
//    if (IS_IPHONEX) {
//
//        self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(5+160, hauteurIphone-55-20, 40, 40)];
//
//    }else{
//
//        self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(5+160, hauteurIphone-55, 40, 40)];
//    }
	
	
	self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_white"] forState:UIControlStateNormal];
    self.deleteBtn.hidden = YES;
    [self.view addSubview:self.deleteBtn];
	[self setConstraintsToDeleteButton];
    
    if (IS_IPHONEX) {
        
        self.drawBtn = [[UIButton alloc]initWithFrame:CGRectMake(5+150, hauteurIphone-55-20, 50, 50)];
        
    }else{
        
        self.drawBtn = [[UIButton alloc]initWithFrame:CGRectMake(5+150, hauteurIphone-55, 50, 50)];
    }
    
    [self.drawBtn setBackgroundImage:[UIImage imageNamed:@"btnDraw"] forState:UIControlStateNormal];
    self.drawBtn.hidden = YES;
    [self.drawBtn addTarget:self action:@selector(actionDraw) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.drawBtn];
  
    
    if (IS_IPHONEX) {

        self.btnDescription = [[UIButton alloc]initWithFrame:CGRectMake(5+50, hauteurIphone-55-20, 50, 50)];

    }else{
        
        self.btnDescription = [[UIButton alloc]initWithFrame:CGRectMake(5+50, hauteurIphone-55, 50, 50)];

    }
    
    [self.btnDescription setBackgroundImage:[UIImage imageNamed:@"btnDescription"] forState:UIControlStateNormal];
    self.btnDescription.hidden = YES;
    [self.btnDescription addTarget:self action:@selector(actionDescriptionView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnDescription];

    if (IS_IPHONEX) {
        
        self.btnTime = [[UIButton alloc]initWithFrame:CGRectMake(5+50+50, hauteurIphone-55-3-20, 50, 50)];

    }else{
        
        self.btnTime = [[UIButton alloc]initWithFrame:CGRectMake(5+50+50, hauteurIphone-55-3, 50, 50)];

    }
    
    [self.btnTime setBackgroundImage:[UIImage imageNamed:@"btnTime-10"] forState:UIControlStateNormal];
    self.btnTime.hidden = YES;
    [self.btnTime addTarget:self action:@selector(actionSelectTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnTime];
    
//    self.btnDraw = [[UIButton alloc]initWithFrame:CGRectMake(5+50+50, hauteurIphone-55, 50, 50)];
//    [self.btnDraw setBackgroundImage:[UIImage imageNamed:@"btnDraw"] forState:UIControlStateNormal];
//    self.btnDraw.hidden = YES;
//    [self.btnDraw addTarget:self action:@selector(actionDraw) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.btnDraw];
    
    
    if (IS_IPHONEX) {
        
        self.btnSave = [[UIButton alloc]initWithFrame:CGRectMake(5, hauteurIphone-55-20, 50, 50)];

    }else{
        
        self.btnSave = [[UIButton alloc]initWithFrame:CGRectMake(5, hauteurIphone-55, 50, 50)];

    }
    
    [self.btnSave addTarget:self action:@selector(actionSavePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSave setBackgroundImage:[UIImage imageNamed:@"btnSavePhoto"] forState:UIControlStateNormal];
    self.btnSave.hidden = YES;
    [self.view addSubview:self.btnSave];
    
    
    if (IS_IPHONEX) {
        
        self.btnSendBuzz = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2-64/2, hauteurIphone-100-20+18-20, 64, 64)];

    }else{
        
        self.btnSendBuzz = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2-64/2, hauteurIphone-100-20+18, 64, 64)];

    }
    
    
    [self.btnSendBuzz setBackgroundImage:[UIImage imageNamed:@"btnSend"] forState:UIControlStateNormal];
    self.btnSendBuzz.backgroundColor = [UIColor redBuzzy];
    self.btnSendBuzz.hidden = YES;
    self.btnSendBuzz.layer.cornerRadius = 25;
    self.btnSendBuzz.layer.masksToBounds =YES;
    [self.btnSendBuzz addTarget:self action:@selector(actionSendBuzz) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSendBuzz];
    
    self.loadingSendBuzz = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loadingSendBuzz.frame =CGRectMake(0, 0, 50, 50);
    [self.loadingSendBuzz startAnimating];
    self.loadingSendBuzz.hidden = YES;
    [self.btnSendBuzz addSubview:self.loadingSendBuzz];
    
    
    self.containerMaps = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    [self.view addSubview:self.containerMaps];
    
    self.countryDisplayed =NO;
    self.cityDisplayed =YES;
    self.universityDisplayed =NO;
    self.cityDisplayed2 =NO;

    
//    if ([PFConfig currentConfig][KConfigDefaultLevelZoomMap]) {
//        
//        self.camera = [GMSCameraPosition cameraWithLatitude:0
//                                                  longitude:0
//                                                       zoom:[[PFConfig currentConfig][KConfigDefaultLevelZoomMap] integerValue]];
//
//    }else{
        self.camera = [GMSCameraPosition cameraWithLatitude:0
                                                  longitude:0
                                                       zoom:12];

        
//    }
   
    
    self.mapView = [GMSMapView mapWithFrame:self.containerMaps.frame camera:self.camera];
    self.mapView.tintColor = [UIColor redBuzzy];
    self.mapView.delegate = self;
    self.mapView.indoorEnabled = NO;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.scrollGestures = YES;
    self.mapView.settings.zoomGestures = YES;
    self.mapView.buildingsEnabled = NO;
    self.mapView.settings.compassButton = NO;
    self.mapView.settings.rotateGestures = NO;
    self.mapView.settings.tiltGestures = NO;

    
    if ([PFConfig currentConfig][KConfigMinLevelZoomMap]) {

        [self.mapView setMinZoom:[[PFConfig currentConfig][KConfigMinLevelZoomMap] integerValue] maxZoom:[[PFConfig currentConfig][KConfigMaxLevelZoomMap] integerValue]];

    }else{
        
        [self.mapView setMinZoom:2 maxZoom:30];

    }
    
    
    
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            
            
            self.currentLocation = geoPoint;

            self.camera = [GMSCameraPosition cameraWithLatitude:geoPoint.latitude
                                                      longitude:geoPoint.longitude
                                                           zoom:self.mapView.camera.zoom];
            
            
            [self.mapView setCamera:self.camera];
        }
        
        
    }];
    


    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *styleUrl = [mainBundle URLForResource:@"style" withExtension:@"json"];
    
    
//    [PFConfig getConfigInBackgroundWithBlock:^(PFConfig * _Nullable config, NSError * _Nullable error) {
//       
        NSError *error2;
//
//        if (error) {
//            
//            return;
//        }
//        if(config[@"map"]){
//
//            
//            GMSMapStyle *style = [GMSMapStyle styleWithJSONString:config[@"map"] error:&error2];
//            self.mapView.mapStyle = style;
//
//        }else{
    
            GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error2];
            self.mapView.mapStyle = style;
//
//        }
//
//        
//    }];
//    
//    
    
    
    
    [self.containerMaps addSubview:self.mapView];

 

    [self playTimer];
    
    
    
   
    self.btnFriends = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-50-14, 64, 50, 50)];
    [self.btnFriends addTarget:self action:@selector(actionButtonFriends) forControlEvents:UIControlEventTouchUpInside];
    [self.btnFriends setBackgroundImage:[UIImage imageNamed:@"btnFriends"] forState:UIControlStateNormal];
//    [self.containerMaps addSubview:self.btnFriends];
    
    self.btnSetting = [[UIButton alloc]initWithFrame:CGRectMake(14, 14, 50, 50)];
    [self.btnSetting addTarget:self action:@selector(actionButtonSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSetting setBackgroundImage:[UIImage imageNamed:@"btnSetting"] forState:UIControlStateNormal];
    [self.containerMaps addSubview:self.btnSetting];
    
    self.btnLocation = [[UIButton alloc]initWithFrame:CGRectMake(14, 64, 50, 50)];
    [self.btnLocation addTarget:self action:@selector(actionButtonLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLocation setBackgroundImage:[UIImage imageNamed:@"btnLocation"] forState:UIControlStateNormal];
//    [self.containerMaps addSubview:self.btnLocation];
    
    self.btnLiked = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-50-14, 14, 50, 50)];
    [self.btnLiked setBackgroundImage:[UIImage imageNamed:@"btnLike"] forState:UIControlStateNormal];
    [self.btnLiked addTarget:self action:@selector(actionButtonLike) forControlEvents:UIControlEventTouchUpInside];
    [self.containerMaps addSubview:self.btnLiked];
    
    if (IS_IPHONEX) {
        
        self.btnKing = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2-25, 14+30, 50, 50)];

        
    }else{
        
        self.btnKing = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2-25, 14, 50, 50)];

    }
    [self.btnKing setBackgroundImage:[UIImage imageNamed:@"btnKing"] forState:UIControlStateNormal];
    [self.btnKing addTarget:self action:@selector(actionButtonKing) forControlEvents:UIControlEventTouchUpInside];
    [self.containerMaps addSubview:self.btnKing];
    
    
    
    
    self.btnMyBuzz = [[BtnMyBuzz alloc]initWithFrame:CGRectMake(largeurIphone-50-14, 64, 50, 50)];
    [self.btnMyBuzz addTarget:self action:@selector(actionButtonMyBuzz) forControlEvents:UIControlEventTouchUpInside];
  
    if ([[PFUser currentUser] objectForKey:kUserProfilePicture]) {
        
        
        [[PFUser currentUser]fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            
            
        }];

        
        self.btnMyBuzz.image.file = [[PFUser currentUser] objectForKey:kUserProfilePicture];
        [self.btnMyBuzz.image loadInBackground];
        self.btnMyBuzz.image.layer.masksToBounds=YES;
        
        [PFCloud callFunctionInBackground:@"updateProfilePictureInsta" withParameters:@{@"userId":[PFUser currentUser].objectId  } block:^(NSDictionary *dic, NSError * _Nullable error){
            
            
            if ([dic  objectForKey:@"profile_picture"]) {
                
                NSLog(@"url %@",[dic  objectForKey:@"profile_picture"]);
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[dic  objectForKey:@"profile_picture"]]];
                    if ( data == nil )
                        return;
                    
                    
                    PFFile *profilePicture = [PFFile fileWithName:@"profilePicture.png" data:data];
                    [PFUser currentUser][kUserProfilePicture] = profilePicture;
                    [[PFUser currentUser]saveInBackground];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSLog(@"Goood");
                        //Your main thread code goes in here
                        self.btnMyBuzz.image.image = [UIImage imageWithData:data];

                        self.btnMyBuzz.image.layer.masksToBounds=YES;

                    });
                    
                    
                    
                });
                
            }
            
            
        }];
        


        
    }else{
        
        [[PFUser currentUser]fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            
            self.btnMyBuzz.image.file = [[PFUser currentUser] objectForKey:kUserProfilePicture];
            [self.btnMyBuzz.image loadInBackground];
            self.btnMyBuzz.image.layer.masksToBounds=YES;


        }];
    }
    
 
    [self.containerMaps addSubview:self.btnMyBuzz];
    
    
    self.pastille =[[UIImageView alloc]initWithFrame:CGRectMake(self.btnMyBuzz.frame.origin.x, self.btnMyBuzz.frame.origin.y+18, 14, 14)];
    self.pastille.layer.cornerRadius = 7;
    self.pastille.layer.masksToBounds = YES;
    self.pastille.hidden = YES;
    self.pastille.backgroundColor =[UIColor redBuzzy];
    [self.containerMaps addSubview:self.pastille];


    
    self.btnList = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-50-14, 64, 50, 50)];
    [self.btnList setBackgroundImage:[UIImage imageNamed:@"btnSword"] forState:UIControlStateNormal];
    [self.btnList addTarget:self action:@selector(actionButtonPretenders) forControlEvents:UIControlEventTouchUpInside];
//    [self.containerMaps addSubview:self.btnList];
    
    
   
    if (IS_IPHONEX) {
        
        self.btnTakePhotoDown = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2-100/2, hauteurIphone-100-20-40, 100, 100)];

    }else{
       
        self.btnTakePhotoDown = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2-100/2, hauteurIphone-100-20, 100, 100)];

        
    }
    
    [self.btnTakePhotoDown setBackgroundImage:[UIImage imageNamed:@"btnTakePhotoDown"] forState:UIControlStateNormal];
    [self.btnTakePhotoDown addTarget:self action:@selector(actionTakePhotoDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnTakePhotoDown];
    swipeGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionTakePhotoDown)];
    [swipeGest setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressRecordButton:)];
    longPressGestureRecognizer.minimumPressDuration = 0.20;
    longPressGestureRecognizer.cancelsTouchesInView = NO;
    [self.btnTakePhotoDown addGestureRecognizer:longPressGestureRecognizer];
    
    [self.btnTakePhotoDown addGestureRecognizer:swipeGest];
   
    
    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(7, 7, 86, 86)];
    self.progressView.roundedCorners = YES;
    self.progressView.userInteractionEnabled = FALSE;

    self.progressView.trackTintColor = [UIColor clearColor];
    [self.progressView setProgressTintColor:[UIColor redBuzzy]];
    [self.progressView setThicknessRatio:0.12f];
    [self.progressView setProgress:0];

    [self.btnTakePhotoDown addSubview:self.progressView];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(becomeActive)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(becomeInactive)
                                                name:UIApplicationDidEnterBackgroundNotification
                                              object:nil];
    
  
    
    self.selectTimeView = [[SelectTimeView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    [self.view addSubview:self.selectTimeView];
    self.selectTimeView.delegate = self;
    self.selectTimeView.hidden = YES;
    
	
    
    self.likedView = [[LikedView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    self.likedView.delegate=self;
    [self.view addSubview:self.likedView];
    
    self.kingsView = [[KingsView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    self.kingsView.delegate=self;
    [self.view addSubview:self.kingsView];

    
    
    
    self.myBuzzView = [[MyBuzzView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    self.myBuzzView.delegate=self;
    [self.view addSubview:self.myBuzzView];
 
    
    self.settingsView = [[SettingsView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    self.settingsView.delegate=self;
    [self.view addSubview:self.settingsView];
    
    self.friendsView = [[FriendsView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    self.friendsView.delegate=self;
    [self.view addSubview:self.friendsView];
  

    [self queryCity];
    [self queryUniversity];
    [self queryCountry];
    
    //	Discription Move
	panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(descriptionMove:)];
	[self.view addGestureRecognizer:panGesture];
    panGesture.enabled = NO;
    
    // Text resize and rotate
    [self.photoImageView setMultipleTouchEnabled:YES];
    [self.photoImageView setUserInteractionEnabled:YES];
    
    pgr = [[UIPinchGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.photoImageView addGestureRecognizer:pgr];
    
    rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateLbl:)];
    rotationRecognizer2 = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateLbl:)];
    [self.photoImageView addGestureRecognizer:rotationRecognizer];
	[self.videoView addGestureRecognizer:rotationRecognizer2];
}
     
 - (void)interruption:(NSNotification*)notification {
     // get the user info dictionary
     NSDictionary *interuptionDict = notification.userInfo;
     // get the AVAudioSessionInterruptionTypeKey enum from the dictionary
     NSInteger interuptionType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
     // decide what to do based on interruption type here...
     switch (interuptionType) {
         case AVAudioSessionInterruptionTypeBegan:
             NSLog(@"Audio Session Interruption case started.");
             // fork to handling method here...
             // EG:[self handleInterruptionStarted];
             [self.cameraView stopSound];

             break;
             
         case AVAudioSessionInterruptionTypeEnded:
             NSLog(@"Audio Session Interruption case ended.");
             // fork to handling method here...
             // EG:[self handleInterruptionEnded];
             [self.cameraView playSound];

             break;
             
         default:
             NSLog(@"Audio Session Interruption Notification case default.");
             break;
     } }


- (void)didLongPressRecordButton:(UIGestureRecognizer *)gesture
{
    
    if (self.containerMaps.frame.origin.y == 0) {

        return;
    }
    
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
    
        
        self.myBuzz = nil;

        self.myBuzz = [PFObject objectWithClassName:kBuzzClasseName];

        
        self.shouldIgnoreTouchUp = YES;
        
        self.btnFlash.hidden = YES;
        self.btnSwitch.hidden = YES;

//        [self toggleHideCaptureControls:YES animated:YES];
//        [self toggleHideProgressView:NO];
//        [self.progressView start];
        self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:MaxRecordingDuration target:self selector:@selector(recordTimerDidFire) userInfo:nil repeats:NO];
        self.isRecordingInProgress = YES;
        self.isVideoReady = NO;
        [self.cameraView startRecordingWithOutputUrl:_videoFileURL];
        
        [self.progressView setProgress:0.0];
        self.recordingProgres = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];

        if (self.cameraView.flash == LLCameraFlashOn && self.cameraView.position == LLCameraPositionFront) {
            
            self.flashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.cameraView.view.frame.size.width, self.cameraView.view.frame.size.height)];
            self.flashView.backgroundColor =[UIColor colorWithWhite:1 alpha:0.85];
            [self.cameraView.view addSubview:self.flashView];
            
            
        }
        
        //        [self startRecordingVideo];
    } else if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self stopRecordingVideo];
        
        [self.flashView removeFromSuperview];
        
        [self toggleHideCaptureControls:YES animated:YES];
        self.btnTime.hidden = YES;

        [self.progressView setProgress:0.0];
        [self.recordingProgres invalidate];
        

    }
}


-(void)incrementCounter{
    
    [self.progressView setProgress:self.progressView.progress + 0.0125/2];

}

- (void)recordTimerDidFire
{
    [self stopRecordingVideo];
}

- (void)stopRecordingVideo
{
    if (self.recordingTimer) {
        [self.recordingTimer invalidate];
        self.recordingTimer = nil;
    }
    
    if (!self.isRecordingInProgress) {
        return;
    }
    
    [self.btnSave setBackgroundImage:[UIImage imageNamed:@"btnSavePhoto"] forState:UIControlStateNormal];
    self.photoSaved = NO;
    
    self.btnSendBuzz.enabled = NO;
    self.loadingSendBuzz.hidden = NO;
	[self.btnSendBuzz setBackgroundImage:[UIImage imageNamed:@"btnSend"]
								forState:UIControlStateNormal];

    self.modeVideo = true;
	
	if (TESTING_MODE) {
		NSURL* url = [[NSBundle mainBundle] URLForResource:@"abc" withExtension:@"mov"];
		[self videoRecorded:nil url:url errro:nil];
	}
	
	__weak typeof(self) weakSelf = self;
	
    [self.cameraView stopRecording:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {
		
		[weakSelf videoRecorded:camera url:outputFileUrl errro:error];
   }];
}

- (void)videoRecorded:(LLSimpleCamera*)camera url:(NSURL*)outputFileUrl errro:(NSError*)error {
	
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self toggleHideCaptureControls:YES animated:YES];
        self.btnSendBuzz.enabled = YES;
        self.loadingSendBuzz.hidden = YES;
    });
	
	UIImage *apercu = [self thumbnailFromVideoAtURL:outputFileUrl];
	NSLog(@"appp %@",apercu);
	[self saveFileImage:apercu];
	[self saveFileVideo:outputFileUrl];
	
	self.isRecordingInProgress = NO;
	self.isVideoReady = YES;
	
	NSLog(@"On est ici ! %@",outputFileUrl);
	
	self.video=YES;
	
	// the video player
	self.avPlayer = [AVPlayer playerWithURL:outputFileUrl];
	self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
	self.avPlayer.muted = NO;
	
	self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
	
	self.avPlayerLayer.frame = CGRectMake(0, 0, largeurIphone, hauteurIphone);
	[self.videoView.layer addSublayer:self.avPlayerLayer];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playerItemDidReachEnd:)
												 name:AVPlayerItemDidPlayToEndTimeNotification
											   object:[self.avPlayer currentItem]];
	
	__weak typeof(self) weakSelf = self;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		
		NSLog(@"Oui on est la fuck  !");
		
		weakSelf.videoView.hidden = NO;
        
		panGesture.enabled = YES;
        if(![weakSelf.videoView.subviews containsObject:weakSelf.videoFilter]) {
            [weakSelf.videoView addSubview:weakSelf.videoFilter];
        }
		
		weakSelf.scrollFilter.hidden = NO;
		[weakSelf.avPlayer play];
        [weakSelf.videoView bringSubviewToFront:weakSelf.videoFilter];
	});
}

#pragma mark - Camera controls

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

-(void)removeShowNewKing {
    self.showNewKing = NO;
}

-(void)refreshAllNewKing{
    
    if (![PFUser currentUser]) {
        return;
    }
    
    [self.likedView refreshData];
    [self.kingsView refreshData];
    [self.myBuzzView refreshData];
    [self refreshMapAction];
    [self refreshMyBuzz];
}



-(void)refreshNotifs{
    
    if (![PFUser currentUser]) {
        return;
    }
    
    [self.myBuzzView refreshData];
    [self refreshMyBuzz];
}


-(void)appBecomeInactive{
    
    
//    [self.session removeInput:_audioDeviceInput];

    
    if (self.avPlayer.rate !=0.0) {
        
        self.videoIsPlaying = YES;
        [self.avPlayer pause];
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
    if (self.avPlayer.rate !=0.0) {
        
        self.videoIsPlaying = YES;
        [self.avPlayer pause];
        
    }
    
}


-(void)appBecomeActive{
    

    
    [self.cameraView playingOtherSound];


    
    if (self.videoIsPlaying == YES) {
        
        [self updateSound];


        
        [self.avPlayer play];
        self.videoIsPlaying = NO;
        
        
    }
    
    
    if (self.showNewKing == YES || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto1"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto2"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto3"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto4"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto5"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto6"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto7"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto8"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto10"] ||  ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto11"]  || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto12"]  || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto13"]  || ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto14"]  ) {
     
        return;
    }
    
    
    self.showNewKing = YES;
    
    [[Following sharedInstance]updateFollowingCompletion:^(BOOL succeeded) {
        
    }];
    
    
    
    
    [self performSelector:@selector(removeShowNewKing) withObject:self afterDelay:3.0];
    
    
    
    if ([[Position sharedInstance]currentUniversity] != NULL) {
        
        
        NSLog(@"on show le new king!!!!!  1");

        PFQuery *query = [PFQuery queryWithClassName:kBuzzClasseName];
        
        NSDate *date =  [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];

        
        [query whereKey:kBuzzUniversity equalTo:[[Position sharedInstance]currentUniversity]];
        [query whereKey:kBuzzKingUniversity equalTo:@YES];
        
        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable king, NSError * _Nullable error) {
            

            king[@"type"] =@"University";

            if (!error && king) {
                
                NSMutableArray *buzzs = [[NSMutableArray alloc]initWithObjects:king, nil];

                
                if (![[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"KingUniversity%@-%d",king.objectId,[king[kBuzzKingNumber]intValue]]]) {
                    
                
                    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:[NSString stringWithFormat:@"seeKing-%@",king.objectId]];
                    [self refreshMap];

                    
                    [self openBuzzWithArray:buzzs andPretendant:NO];

                    
                    NSLog(@"Show univ");
                    
                    
                }
            }
            
            
            
        }];
        
        
    }else if([[Position sharedInstance]currentCity] != NULL){
        
        
        
        NSLog(@"on show le new king!!!!!  2");

        PFQuery *query = [PFQuery queryWithClassName:kBuzzClasseName];
        
        NSDate *date =  [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];

        
        [query whereKey:kBuzzCity equalTo:[[Position sharedInstance]currentCity]];
        [query whereKey:kBuzzKingCity equalTo:@YES];
        
        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable king, NSError * _Nullable error) {
            
            
            king[@"type"] =@"City";

            if (!error && king) {
                
                NSMutableArray *buzzs = [[NSMutableArray alloc]initWithObjects:king, nil];
                
                
                if (![[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"KingCity%@-%d",king.objectId,[king[kBuzzKingNumber]intValue]]]) {
                   
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:[NSString stringWithFormat:@"seeKing-%@",king.objectId]];
                    [self refreshMap];

                    
                    [self openBuzzWithArray:buzzs andPretendant:NO];

                    
                }
            }
            
            
            
        }];
        
        
        
    }else if([[Position sharedInstance]currentCountry] != NULL){
        
        NSLog(@"on show le new king!!!!!  3");

        PFQuery *query = [PFQuery queryWithClassName:kBuzzClasseName];
        
        NSDate *date =  [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];

        
        [query whereKey:kBuzzCountry equalTo:[[Position sharedInstance]currentCountry]];
        [query whereKey:kBuzzKingCountry equalTo:@YES];
        
        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable king, NSError * _Nullable error) {
            
            
            king[@"type"] =@"Country";
            
            
            if (!error && king) {
                
                NSMutableArray *buzzs = [[NSMutableArray alloc]initWithObjects:king, nil];
                
                
                if (![[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"KingCountry%@-%d",king.objectId,[king[kBuzzKingNumber]intValue]]]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:[NSString stringWithFormat:@"seeKing-%@",king.objectId]];
                    [self refreshMap];

                    
                    [self openBuzzWithArray:buzzs andPretendant:NO];
                    
                }
            }
            
            
            
        }];
        
        
        
        
    }
    
}

-(void)queryCountry{
    
    PFQuery *queryCountry = [PFQuery queryWithClassName:kCountryClasseName];
    [queryCountry whereKey:kCountryAvailable equalTo:@YES];
    [queryCountry includeKey:kCountryArea];
    
    [queryCountry findObjectsInBackgroundWithBlock:^(NSArray * _Nullable country, NSError * _Nullable error) {
        
        
        if (!error) {
            
            
            
            
            self.polylineCountry = [[NSMutableArray alloc]init];
            
            for (int i = 0; i<country.count; i++) {
                
                
                GMSMutablePath *rect = [GMSMutablePath path];
                
                NSArray *location = [[[country objectAtIndex:i] objectForKey:kCountryArea] objectForKey:kLocationLocation];
                
                for (int j = 0; j<location.count; j++) {
                    
                    [rect addCoordinate:
                     CLLocationCoordinate2DMake([[[location objectAtIndex:j] objectAtIndex:0] doubleValue], [[[location objectAtIndex:j] objectAtIndex:1] doubleValue])];
                    
                }
                
                
                GMSPolyline *polyline = [GMSPolyline polylineWithPath:rect];
                //            polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
                //            polyline.strokeColor = [UIColor colorForHex:@"AD5D42"];
                polyline.strokeWidth = 4;
                polyline.geodesic = YES;
                
                
                NSArray *styles = @[[GMSStrokeStyle solidColor:[UIColor colorForHex:[[PFConfig currentConfig] objectForKey:@"borderColor"]]],
                                    [GMSStrokeStyle solidColor:[UIColor colorForHex:[[PFConfig currentConfig] objectForKey:@"borderColor"]]]];
                
                //                    NSArray *styles = @[[GMSStrokeStyle solidColor:[UIColor colorForHex:@"AD5D42"]],
                //                                        [GMSStrokeStyle solidColor:[UIColor colorForHex:@"DEB8AC"]]];

                NSArray *lengths = @[@(LargeurACountry), @(LargeurBCountry)];
                polyline.spans = GMSStyleSpans(polyline.path, styles, lengths, kGMSLengthGeodesic);
                
                
                if (self.mapView.camera.zoom < LevelZoomCountryMax) {
                    
                    
                    polyline.map =self.mapView;
                    
                }
                
                
                [self.polylineCountry addObject:polyline];
                
            }
            
            
            
            
        }else{
            
            
            NSLog(@"error campus %@",error);
        }
        
    }];

}


-(void)queryUniversity{
    
    
    
    PFQuery *queryCampus = [PFQuery queryWithClassName:kCampusClasseName];
    [queryCampus whereKey:kCampusAvailable equalTo:@YES];
    [queryCampus includeKey:kCampusArea];

        [queryCampus findObjectsInBackgroundWithBlock:^(NSArray * _Nullable campus, NSError * _Nullable error) {
           
            
            if (!error) {
                
                
                
                self.polylineUniversity = [[NSMutableArray alloc]init];
                
                for (int i = 0; i<campus.count; i++) {
                    
                    
                    GMSMutablePath *rect = [GMSMutablePath path];
                    
                    NSArray *location = [[[campus objectAtIndex:i] objectForKey:kCampusArea] objectForKey:kLocationLocation];

                    for (int j = 0; j<location.count; j++) {
                        
                        [rect addCoordinate:
                         CLLocationCoordinate2DMake([[[location objectAtIndex:j] objectAtIndex:0] doubleValue], [[[location objectAtIndex:j] objectAtIndex:1] doubleValue])];
                        
                    }
                    
                    
                    GMSPolyline *polyline = [GMSPolyline polylineWithPath:rect];
                    //            polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
                    //            polyline.strokeColor = [UIColor colorForHex:@"AD5D42"];
                    polyline.strokeWidth = 6;
                    polyline.geodesic = YES;
                    
                    
                    NSArray *styles = @[[GMSStrokeStyle solidColor:[UIColor colorForHex:[[PFConfig currentConfig] objectForKey:@"borderColor"]]],
                                        [GMSStrokeStyle solidColor:[UIColor colorForHex:[[PFConfig currentConfig] objectForKey:@"borderColor"]]]];
                    
//                    NSArray *styles = @[[GMSStrokeStyle solidColor:[UIColor colorForHex:@"AD5D42"]],
//                                        [GMSStrokeStyle solidColor:[UIColor colorForHex:@"DEB8AC"]]];

                    NSArray *lengths = @[@(LargeurAUniversity), @(LargeurBUniversity)];
                    polyline.spans = GMSStyleSpans(polyline.path, styles, lengths, kGMSLengthGeodesic);
                    
                    
                    if (self.mapView.camera.zoom > LevelZoomUniversityMin ) {
                        
                        
                        polyline.map =self.mapView;
                        
                    }
                    
                    
                    [self.polylineUniversity addObject:polyline];
                    
                }

                
                
                
            }else{
                
                
                NSLog(@"error campus %@",error);
            }
            
        }];
        
    
}

-(void)queryCity{
    
    PFQuery *queryCity = [PFQuery queryWithClassName:kCityClasseName];
    [queryCity whereKey:kCityAvailable equalTo:@YES];
    [queryCity includeKey:kCityArea];

    [queryCity findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        
        
        if (!error) {
            
            
        
                    self.polylineCity = [[NSMutableArray alloc]init];
                    
                    for (int i = 0; i<objects.count; i++) {
                        
                        
                        GMSMutablePath *rect = [GMSMutablePath path];
                        
                        NSArray *location = [[[objects objectAtIndex:i] objectForKey:kCityArea] objectForKey:kLocationLocation];
                        
                        for (int j = 0; j<location.count; j++) {
                            
                            [rect addCoordinate:
                             CLLocationCoordinate2DMake([[[location objectAtIndex:j] objectAtIndex:0] doubleValue], [[[location objectAtIndex:j] objectAtIndex:1] doubleValue])];
                            
                        }

                        
                        GMSPolyline *polyline = [GMSPolyline polylineWithPath:rect];
            //            polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
            //            polyline.strokeColor = [UIColor colorForHex:@"AD5D42"];
                        polyline.strokeWidth = 8;
                        polyline.geodesic = YES;
                       
                        
                        NSArray *styles = @[[GMSStrokeStyle solidColor:[UIColor colorForHex:[[PFConfig currentConfig] objectForKey:@"borderColor"]]],
                                            [GMSStrokeStyle solidColor:[UIColor colorForHex:[[PFConfig currentConfig] objectForKey:@"borderColor"]]]];
                        
                        //                    NSArray *styles = @[[GMSStrokeStyle solidColor:[UIColor colorForHex:@"AD5D42"]],
                        //                                        [GMSStrokeStyle solidColor:[UIColor colorForHex:@"DEB8AC"]]];
                        NSArray *lengths = @[@(LargeurACity), @(LargeurBCity)];
                        polyline.spans = GMSStyleSpans(polyline.path, styles, lengths, kGMSLengthGeodesic);

                        
                        if (self.mapView.camera.zoom > LevelZoomCityMin && self.mapView.camera.zoom < LevelZoomCityMax ) {
                            
                            
                            polyline.map =self.mapView;
                            
                        }
                        
                        
                        [self.polylineCity addObject:polyline];
                        
                    }
            
        }
        
    }];
}
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{

    
    
    
    if ([PFConfig currentConfig][@"centerPositionMapLat"] && [PFConfig currentConfig][@"centerPositionMapLong"]  && [PFConfig currentConfig][@"distanceMaxMap"] && [[PFConfig currentConfig][@"limitZone"] isEqual:@YES]) {
        
        
        int radius = [[PFConfig currentConfig][@"distanceMaxMap"] intValue] *1000;
        
        float latitude =  [[PFConfig currentConfig][@"centerPositionMapLat"] floatValue];
        float longitude =  [[PFConfig currentConfig][@"centerPositionMapLong"] floatValue];

        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
        
        CLLocation *targetLoc = [[CLLocation alloc] initWithLatitude:position.target.latitude longitude:position.target.longitude];
        CLLocation *centerLoc = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
        

        if ([targetLoc distanceFromLocation:centerLoc] > radius  || ![[NSUserDefaults standardUserDefaults]objectForKey:@"fakeLikedTuto"] ) {
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:center.latitude
                                                                    longitude:center.longitude
                                                                         zoom:[[PFConfig currentConfig][KConfigMinLevelZoomMap] integerValue]];
            
            [mapView animateToCameraPosition: camera];
        }
        
    }
    
    
    if (self.mapView.camera.zoom != self.oldZoom) {
        
            //// CITY
        
        
            if(self.cityDisplayed2 == NO && self.mapView.camera.zoom > LevelZoomCityMin ){

            
                for (int i = 0; i<self.markersCity.count; i++) {
                
                
                    BuzzyMarker *marker = (BuzzyMarker *)[self.markersCity objectAtIndex:i];
                    marker.map = self.mapView;
                
                }
                
                
              
                
               
                self.cityDisplayed2 =YES;

            }else if(self.cityDisplayed2 == YES && self.mapView.camera.zoom < LevelZoomCityMin ){
                
                
                for (int i = 0; i<self.markersCity.count; i++) {
                    
                    
                    BuzzyMarker *marker = (BuzzyMarker *)[self.markersCity objectAtIndex:i];
                    marker.map = nil;
                    
                }
                
                
                
                self.cityDisplayed2 =NO;


            }
        
        
        
        
        
        
        
        
        
            if(self.cityDisplayed == NO && self.mapView.camera.zoom > LevelZoomCityMin && self.mapView.camera.zoom < LevelZoomCityMax){
                
                

                
               
                
                
                for (int i = 0; i<self.polylineCity.count; i++) {
                    
                    
                    GMSPolyline *polyline = (GMSPolyline *)[self.polylineCity objectAtIndex:i];
                    polyline.map = self.mapView;
                    
                }
                
                
                self.cityDisplayed =YES;

           
            } else if (self.cityDisplayed == YES && (self.mapView.camera.zoom < LevelZoomCityMin || self.mapView.camera.zoom > LevelZoomCityMax )) {
                
                
                
                
                for (int i = 0; i<self.polylineCity.count; i++) {
                    
                    
                    GMSPolyline *polyline = (GMSPolyline *)[self.polylineCity objectAtIndex:i];
                    polyline.map = nil;
                    
                }
                
                
                
                self.cityDisplayed =NO;
                
                
            }

        
        
        
        //// Univeristy
        if (self.mapView.camera.zoom < LevelZoomUniversityMin && self.universityDisplayed == YES) {
            
            
            
            for (int i = 0; i<self.markersUniversity.count; i++) {
                
                
                BuzzyMarker *marker = (BuzzyMarker *)[self.markersUniversity objectAtIndex:i];
                marker.map = nil;
                
            }
            
            
            for (int i = 0; i<self.polylineUniversity.count; i++) {
                
                
                GMSPolyline *polyline = (GMSPolyline *)[self.polylineUniversity objectAtIndex:i];
                polyline.map = nil;
                
            }
            
            
            
            self.universityDisplayed =NO;

            
        }else if(self.mapView.camera.zoom > LevelZoomUniversityMin && self.universityDisplayed == NO){
            
            
            
            
            for (int i = 0; i<self.markersUniversity.count; i++) {
                
                
                BuzzyMarker *marker = (BuzzyMarker *)[self.markersUniversity objectAtIndex:i];
                marker.map = self.mapView;
                
            }
            
            
            
            for (int i = 0; i<self.polylineUniversity.count; i++) {
                
                
                GMSPolyline *polyline = (GMSPolyline *)[self.polylineUniversity objectAtIndex:i];
                polyline.map = self.mapView;
                
            }
            
            self.universityDisplayed =YES;

            
        }

        
        
        //// Country
        if (self.mapView.camera.zoom < LevelZoomCountryMax && self.countryDisplayed == NO) {
            

//            
//            for (int i = 0; i<self.markersCountry.count; i++) {
//                
//                
//                BuzzyMarker *marker = (BuzzyMarker *)[self.markersCountry objectAtIndex:i];
//                marker.map = self.mapView;
//                
//            }
            
            
            for (int i = 0; i<self.polylineCountry.count; i++) {
                
                
                GMSPolyline *polyline = (GMSPolyline *)[self.polylineCountry objectAtIndex:i];
                polyline.map = self.mapView;
                
            }
            
            self.countryDisplayed =YES;

        }else if(self.mapView.camera.zoom > LevelZoomCountryMax && self.countryDisplayed == YES){

            
//            for (int i = 0; i<self.markersCountry.count; i++) {
//                
//                
//                BuzzyMarker *marker = (BuzzyMarker *)[self.markersCountry objectAtIndex:i];
//                marker.map = nil;
//                
//            }
//            
            for (int i = 0; i<self.polylineCountry.count; i++) {
                
                
                GMSPolyline *polyline = (GMSPolyline *)[self.polylineCountry objectAtIndex:i];
                polyline.map = nil;
                
            }

            
            self.countryDisplayed =NO;

            
        }

        
        
        
        
        
    
    }
    
    
    self.oldZoom = self.mapView.camera.zoom;
    



}

- (void)changeGestureState:(BOOL)state {
    
    swipeGest.enabled = state;
    tapGesture1.enabled= state;
    tapGesture2.enabled= state;
    pgr1.enabled= state;
    swipeCancel.enabled= state;
    longPressGestureRecognizer.enabled= state;
    panGesture.enabled= state;
    pgr.enabled= state;
    rotationRecognizer.enabled= state;
}

- (void)actionDraw {
    [self.filterView enablePanGesture:NO];
    DrawView* drawView = [[DrawView alloc] initWithFrame:self.view.frame imageArr:_drawArray];
    [self.drawImageLayer removeFromSuperlayer];
    
    __weak typeof(self) weakSelf = self;
    
    drawView.drawDone = ^(CALayer* imageLayer, NSMutableArray* imageArr){
        if (imageLayer) {
            weakSelf.drawImageLayer = imageLayer;
            
            if (imageArr.count != 0) {
                if (_modeVideo) {
                    [weakSelf.videoFilter.layer addSublayer:weakSelf.drawImageLayer];
                } else {
                    [weakSelf.filterView.layer addSublayer:weakSelf.drawImageLayer];
                }
            }
            weakSelf.drawArray = imageArr;
        }
        [weakSelf changeGestureState:YES];
        [weakSelf ShouldhideAllBottomButton:NO];
        [self.filterView enablePanGesture:YES];
    };
    if (_modeVideo) {
        drawView.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
        [self.videoFilter addSubview:drawView];
    } else {
        [self.filterView addSubview:drawView];
    }
    [self ShouldhideAllBottomButton:YES];
    [self changeGestureState:NO];
}

-(void)actionButtonLocation{
    
    
    [self.mapView animateToLocation:CLLocationCoordinate2DMake(self.currentLocation.latitude, self.currentLocation.longitude)];

    
    if ([PFConfig currentConfig][KConfigDefaultLevelZoomMap]) {

        
        
        [self.mapView animateToZoom:[[PFConfig currentConfig][KConfigDefaultLevelZoomMap] integerValue]];

    }else{
        
        
        [self.mapView animateToZoom:12];

    }

}


-(void)refreshMyBuzz{
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:kBuzzClasseName];
    
    NSDate *date =  [NSDate date];
    NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
    
    [query whereKey:kBuzzWhen greaterThan:yesterday];
    [query whereKey:kBuzzDeleted notEqualTo:@YES];

    
    [query whereKey:kBuzzUser equalTo:[PFUser currentUser]];
    [query includeKey:kBuzzUser];
    [query includeKey:kBuzzCity];
    [query includeKey:kBuzzCountry];
    [query includeKey:kBuzzUniversity];
    
    [query orderByDescending:kBuzzKingCountry];
    [query addDescendingOrder:kBuzzKingCity];
    [query addDescendingOrder:kBuzzKingUniversity];
    [query addDescendingOrder:kBuzzLikeNumber];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzs, NSError * _Nullable error) {

        
        
        
        if (buzzs != NULL) {
            
            
            BOOL showNotif = false;
            
            for (int i = 0; i<buzzs.count; i++) {
                
                PFObject *b = buzzs[i];
                PFUser *user = b[kBuzzUser];

                if ([user.objectId isEqualToString:[PFUser currentUser].objectId] && [b[kBuzzMessageNumber]integerValue] != 0
                    &&([b[kBuzzKingCity] isEqual:@YES]
                       || [b[kBuzzKingCountry] isEqual:@YES]
                       || [b[kBuzzKingUniversity] isEqual:@YES])) {
                    
                        
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"nbMess-%@",b.objectId]]) {
                        
                        NSLog(@"b");

                        
                        if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"nbMess-%@",b.objectId]]integerValue] != [b[kBuzzMessageNumber]integerValue]) {
                            
                            
                            showNotif = true;

                        }
                        
                    }else{
                       
                        ////
                        
                        if ([b[kBuzzMessageNumber]integerValue] > 0) {
                            
                            showNotif = true;
                            
                        }
                        
                        
                    }
                    
                }
                
            }
            
            
            
            
            
            
            self.myBuzzs = [[NSMutableArray alloc]initWithArray:buzzs];
            
            if (self.myBuzzs.count > 0) {
                
                self.btnMyBuzz.number.text =[NSString stringWithFormat:@"%lu",(unsigned long)self.myBuzzs.count];
                
                if (showNotif == true) {
                    
                    self.pastille.hidden = NO;
                    NSLog(@"shoo %d",showNotif);


                }else{
                    
                    self.pastille.hidden = YES;

                }
                
            }else{
                
                self.btnMyBuzz.number.text =@"0";
                
                self.pastille.hidden = YES;

            }
            
            
        }else{
            
            
            self.btnMyBuzz.number.text =@"0";
            
            self.pastille.hidden = YES;

        }
        
        
        
        
    }];
    
    
    
}


-(void)actionButtonMyBuzz{
    
    [self.myBuzzView showMyBuzz:self.myBuzzs WithCurrentLocation:self.currentLocation];

}


-(void)actionButtonPretenders{
    
    
//    [self.pretendersView showWithCurrentLocation:self.currentLocation];
 
//    [Utils runSpinAnimationOnView:self.btnList duration:5.0 rotations:3 repeat:NO];
    
    if ([[Position sharedInstance]currentUniversity] != NULL) {
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];

        
        
//        PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
//        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];

        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];

        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];

        
        [query whereKey:kBuzzUniversity equalTo:[[Position sharedInstance]currentUniversity]];
        [query whereKey:kBuzzKingUniversity notEqualTo:@YES];
        
        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzs, NSError * _Nullable error) {
            
            
            
            [self.btnList.layer removeAllAnimations];
            
            if (buzzs != NULL && buzzs.count> 0) {
                
                [self openBuzzWithArray:buzzs andPretendant:YES];

            }else{
                
                
            }
            
            
            
        }];
        
        
    }else if([[Position sharedInstance]currentCity] != NULL){
        

        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
        
//        PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
//        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
        
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        
        
        [query whereKey:kBuzzCity equalTo:[[Position sharedInstance]currentCity]];
        [query whereKey:kBuzzKingCity notEqualTo:@YES];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];

        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzs, NSError * _Nullable error) {
            
            
            
            [self.btnList.layer removeAllAnimations];

            if (buzzs != NULL && buzzs.count> 0) {
                
                [self openBuzzWithArray:buzzs andPretendant:YES];

                
            }else{
                
                
            }
            
            
            
        }];
        
        
        
        
    }else if([[Position sharedInstance]currentCountry] != NULL){
        
        

        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
        
        PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
        
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        
        
        [query whereKey:kBuzzCountry equalTo:[[Position sharedInstance]currentCountry]];
        [query whereKey:kBuzzKingCountry notEqualTo:@YES];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];

        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzs, NSError * _Nullable error) {
            
            NSLog(@"Stop!");
            
            [self.btnList.layer removeAllAnimations];

            if (buzzs != NULL && buzzs.count> 0) {
                
                [self openBuzzWithArray:buzzs andPretendant:YES];

            }else{
                
                
            }
            
            
        }];
        
        
    }else{
        
        
        [self.btnList.layer removeAllAnimations];

    }
    
}

-(void)actionButtonLike{
    
    
    [self.likedView showWithCurrentLocation:self.currentLocation];
    
    
    
}

-(void)actionButtonKing{
    

    [self.kingsView showWithCurrentLocation:self.currentLocation];
    
}

-(void)actionButtonSetting{
    
    
    [self.settingsView show];

}

-(void)actionButtonFriends{
    
    [self.friendsView show];

}
-(void)actionTakePhotoUp{
    
    

    
  
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.containerMaps setFrame:CGRectMake(0,0, self.containerMaps.frame.size.width, self.containerMaps.frame.size.height)];
        
        
    } completion:^(BOOL finished) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        AVAudioSession *session1 = [AVAudioSession sharedInstance];
        [session1 setCategory:AVAudioSessionCategoryAmbient error:nil];
        [session1 setActive:TRUE error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
            
        });
        

    }];
    
    
    [self.btnTakePhotoDown setBackgroundImage:[UIImage imageNamed:@"btnTakePhotoDown"] forState:UIControlStateNormal];

    

    

    
}
-(void)actionTakePhotoDown{
    
    
    if (self.containerMaps.frame.origin.y == 0) {
        
        
        if ([[AVAudioSession sharedInstance] isOtherAudioPlaying]) {
            
            self.cameraView.needToStopSound = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                AVAudioSession *session1 = [AVAudioSession sharedInstance];
                [session1 setCategory:AVAudioSessionCategoryAmbient  error:nil];
                [session1 setActive:TRUE error:nil];
                
                
            });
            
        }else{
            
            self.cameraView.needToStopSound = NO;
            [self updateSound];

        }

        [self.cameraView start];
        
        
        [self.btnTakePhotoDown setBackgroundImage:[UIImage imageNamed:@"btnTakePhoto"] forState:UIControlStateNormal];
        
        
        self.btnTakePhotoDown.alpha = 0.2;
       

        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.containerMaps setFrame:CGRectMake(0,-hauteurIphone, self.containerMaps.frame.size.width, self.containerMaps.frame.size.height)];
            
            
        } completion:^(BOOL finished) {
            

            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.btnTakePhotoDown.alpha = 1;

                
            } completion:^(BOOL finished) {
                
                
                
            }];

            
            
        }];

        
        
     
        
    }else{
        
        [self actionTakePhoto];
        
        
        
    }

    
    
}

-(void)updateSound{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    AVAudioSession *session1 = [AVAudioSession sharedInstance];
    [session1 setCategory:AVAudioSessionCategoryPlayAndRecord  withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDefaultToSpeaker|AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    [session1 setActive:TRUE error:nil];
        
        
    });

//    AVAudioSession *session1 = [AVAudioSession sharedInstance];
//    [session1 setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDefaultToSpeaker|AVAudioSessionCategoryOptionAllowBluetooth error:nil];
//    [session1 setActive:TRUE error:nil];
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

}

-(void)playTimer{
    
    
    [self.refreshMap invalidate];
    
    
    self.refreshMap = [NSTimer scheduledTimerWithTimeInterval: 10.0
                                                       target: self
                                                     selector: @selector(refreshLocation)
                                                     userInfo: nil
                                                      repeats: YES];

}
-(void)becomeActive{
    

    
    [self playTimer];
    
}

-(void)becomeInactive{
    
    [self.refreshMap invalidate];

}




-(void)viewWillAppear:(BOOL)animated{
    
       
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    
    if (self.videoIsPlaying == YES) {
        
        
        
        
        [self updateSound];


        [self.avPlayer play];
        self.videoIsPlaying = NO;
        
        
    }

}

-(void)refreshLocation{
    
    [[Position sharedInstance]updatePositionCompletion:^(BOOL succeeded) {
        
        appStopLoading;
        
        
        if (![PFUser currentUser]) {
            
            return;
            
        }
        
        NSLog(@"refresh map!");
        
        [self refreshMapAction];
        
    }];

    
}

//
//-(void)livequery{
//    
//    self.client = [[PFLiveQueryClient alloc] initWithServer:@"https://pg-app-unuan133rrtsfyfx5fg6e1rxdxcghe.scalabl.cloud/1/"
//                                              applicationId:@"hWyTlRLYsr3gReqoNy1BkfLuJPJPU6zUNiHsOkVl"
//                                                  clientKey:@"D7xQDcl3284eJ2lJ9GOx2FUYPisRlKUJHSVJPUzU"];
//    
//   
//    NSLog(@"Live queries open");
//    
////    [queryCountry whereKey:kBuzzKingCountry equalTo:@YES];
////    
////    PFQuery *queryCity = [PFQuery queryWithClassName:kBuzzClasseName];
////    [queryCity whereKey:kBuzzKingCity equalTo:@YES];
////    
////    PFQuery *queryUniv = [PFQuery queryWithClassName:kBuzzClasseName];
////    [queryUniv whereKey:kBuzzKingUniversity equalTo:@YES];
////    
////    
////    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryCountry,queryCity,queryUniv]];
////    
////    NSDate *date =  [NSDate date];
////    NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
////    
////    
////    [query whereKey:kBuzzWhen greaterThan:yesterday];
////    [query whereKey:kBuzzDeleted notEqualTo:@YES];
////    
//    
////    self.subscriptionMap = [self.client subscribeToQuery:queryCountry];
////    
////    [self.subscriptionMap addErrorHandler:^(PFQuery*query, NSError * _Nonnull) {
////       
////        NSLog(@"error handeler'");
////        
////    }];
////    
////    [self.subscriptionMap addUpdateHandler:^(PFQuery *query, PFObject *activityObject){
////        
////        NSLog(@"receive Update livquery");
////        
////        
////        
////    }];
////    
////    [self.subscriptionMap addCreateHandler:^(PFQuery *query, PFObject *activityObject){
////        
////        NSLog(@"receive Delete livquery");
////        
////        
////    }];
////    
//    
//    self.liveQuery = [PFQuery queryWithClassName:kBuzzClasseName];
//    [self.liveQuery whereKey:kBuzzDeleted notEqualTo:@YES];
//    
//    self.subscriptionMap = [self.client subscribeToQuery:self.liveQuery];
//    [self.subscriptionMap addCreateHandler:^(PFQuery<PFObject *> * _Nonnull query, PFObject * _Nonnull object) {
//
//        
//        NSLog(@"add cretadd");
//        
//    }];
//
//    
//    
//    
//    
//}
-(void)refreshMapAction{
    
    
    self.tutoBuzz = nil;
    
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"fakeLikedTuto"]) {

    
    PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];

    [query1 whereKey:@"tutoriel" equalTo:@YES];
    [query1 whereKey:@"fakeKing" equalTo:@YES];
    
    [query1 includeKey:kBuzzUser];
    [query1 includeKey:kBuzzCity];
    [query1 includeKey:kBuzzCountry];
    [query1 includeKey:kBuzzUniversity];
    [query1 includeKey:@"fakeCountry"];
    [query1 orderByDescending:kBuzzKingCountry];
    [query1 addDescendingOrder:kBuzzKingCity];
    [query1 addDescendingOrder:kBuzzKingUniversity];
    [query1 addDescendingOrder:kBuzzLikeNumber];
    
    
    [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable kings, NSError * _Nullable error) {

        if (kings.count>0) {
            
            self.tutoBuzz = kings[0];

        }
        
        
        for (int i = 0; i<kings.count; i++) {
            
            
            NSLog(@"on get les kings!!");
            
            
            
            PFObject *buzz = kings[i];
            
            if (buzz[kBuzzPhoto]) {
                
                NSLog(@"phoo");
                
                
                PFFile *photo = buzz[kBuzzPhoto];
                [photo getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                    
                    NSLog(@"Photo got");
                    
                }];
            }
            
            if (buzz[kBuzzVideo]) {
                
                PFFile *video = buzz[kBuzzVideo];
                [video getDataInBackground];
                
            }
            
        }
        
        if (kings != NULL) {
            
            for (int i = 0; i<self.markersCity.count; i++) {
                
                BuzzyMarker *marker = (BuzzyMarker *)[self.markersCity objectAtIndex:i];
                marker.map = nil;
                marker=nil;
                
            }
            
            
            for (int i = 0; i<self.markersCountry.count; i++) {
                
                BuzzyMarker *marker = (BuzzyMarker *)[self.markersCountry objectAtIndex:i];
                marker.map = nil;
                marker=nil;
                
            }
            
            
            
            for (int i = 0; i<self.markersUniversity.count; i++) {
                
                BuzzyMarker *marker = (BuzzyMarker *)[self.markersUniversity objectAtIndex:i];
                marker.map = nil;
                marker=nil;
                
            }
            
            
            
            
            NSMutableArray *kingsArray = [[NSMutableArray alloc]initWithArray:kings];
            
            self.markersCity = [[NSMutableArray alloc]init];
            self.markersCountry = [[NSMutableArray alloc]init];
            self.markersUniversity = [[NSMutableArray alloc]init];
            
            
            //                            [self.mapView clear];
            
            
            
            for (int i = 0; i<kingsArray.count; i++) {
                
                PFObject *king = [kingsArray objectAtIndex:i];
                PFGeoPoint *location = [king objectForKey:kBuzzLocation];
                
                
                ////// SI
                
                if ([king[kBuzzKingCountry] isEqual:@YES]) {
                    
                    
                    BuzzyMarker *markerGoogle = [[BuzzyMarker alloc]init];
                    [markerGoogle setPosition:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
                    markerGoogle.buzz = king;
                    
                    
                    PFFile *content = [king objectForKey:kBuzzPhoto];
                    [content getDataInBackground];
                    
                    MarkerView *marker = [[MarkerView alloc]init];
                    marker.picture.file = [[king objectForKey:kBuzzUser] objectForKey:kUserProfilePicture];
                    
                    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:king[kBuzzWhen]];
                    
                    float progress = 1-(secondsBetween / ( 24 * 60 * 60));
                    
                    
                    
                    [marker.progressView setProgress:progress animated:NO];
                    
                    [marker.picture loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        
                        markerGoogle.tracksViewChanges = NO;
                        
                    }];
                    
                    
                    if ([king[kBuzzCountry] objectForKey:kCountryIcon]) {
                        
                        marker.country.text = [king[kBuzzCountry] objectForKey:kCountryIcon];
                        
                    }else{
                        
                        marker.country.text =@"";
                    }
                    
                    markerGoogle.iconView = marker;
                    
                    
                    if ([[[Following sharedInstance]following] containsObject:king[kBuzzInstaUsername]] && ![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"seeKing-%@",king.objectId]]){
                        //    if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){
                        
                        
                        marker.iconFriend.hidden = NO;
                        
                    }else{
                        
                        marker.iconFriend.hidden = YES;
                        
                        //                        [self checkPretendersWithBuzz:king];
                        
                    }
                    
                    
                    
                    [self.markersCountry addObject:markerGoogle];
                    
                    //                    if (self.mapView.camera.zoom < LevelZoomCountryMax) {
                    
                    
                    markerGoogle.map =self.mapView;
                    
                    // }
                    
                    
                    
                    
                }else if ([king[kBuzzKingCity] isEqual:@YES]){
                    
                    
                    
                    BuzzyMarker *markerGoogle = [[BuzzyMarker alloc]init];
                    [markerGoogle setPosition:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
                    markerGoogle.buzz = king;
                    
                    
                    
                    MarkerView *marker = [[MarkerView alloc]init];
                    marker.picture.file = [[king objectForKey:kBuzzUser] objectForKey:kUserProfilePicture];
                    
                    PFFile *content = [king objectForKey:kBuzzPhoto];
                    [content getDataInBackground];
                    
                    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:king[kBuzzWhen]];
                    
                    float progress = 1-(secondsBetween / ( 24 * 60 * 60));
                    
                    
                    
                    [marker.progressView setProgress:progress animated:NO];
                    
                    [marker.picture loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        
                        markerGoogle.tracksViewChanges = NO;
                        
                    }];
                    
                    
                    markerGoogle.iconView = marker;
                    
                    
                    if ([king[kBuzzCity] objectForKey:kCityIcon]) {
                        
                        marker.country.text = [king[kBuzzCity] objectForKey:kCityIcon];
                        
                    }else{
                        
                        marker.country.text =@"";
                    }
                    
                    
                    if ([[[Following sharedInstance]following] containsObject:king[kBuzzInstaUsername]] && ![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"seeKing-%@",king.objectId]]){
                        //    if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){
                        
                        
                        marker.iconFriend.hidden = NO;
                        
                    }else{
                        
                        marker.iconFriend.hidden = YES;
                        
                    }
                    
                    
                    
                    
                    [self.markersCity addObject:markerGoogle];
                    
                    if (self.mapView.camera.zoom > LevelZoomCityMin ) {
                        
                        markerGoogle.map =self.mapView;
                        
                        
                    }
                    
                    
                }else if ([king[kBuzzKingUniversity] isEqual:@YES]){
                    
                    
                    
                    
                    BuzzyMarker *markerGoogle = [[BuzzyMarker alloc]init];
                    [markerGoogle setPosition:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
                    markerGoogle.buzz = king;
                    
                    
                    PFFile *content = [king objectForKey:kBuzzPhoto];
                    [content getDataInBackground];
                    
                    MarkerView *marker = [[MarkerView alloc]init];
                    marker.picture.frame = CGRectMake(11, 44, 34, 34);
                    marker.progressView.frame = CGRectMake(9, 42, 38, 38);
                    marker.couronne.frame = CGRectMake((56-16)/2, 14+10, 16, 14);
                    marker.iconFriend.frame = CGRectMake(3,30, 16, 16);
                    
                    
                    
                    marker.picture.file = [[king objectForKey:kBuzzUser] objectForKey:kUserProfilePicture];
                    
                    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:king[kBuzzWhen]];
                    
                    float progress = 1-(secondsBetween / ( 24 * 60 * 60));
                    
                    
                    
                    [marker.progressView setProgress:progress animated:NO];
                    
                    [marker.picture loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        
                        markerGoogle.tracksViewChanges = NO;
                        
                    }];
                    
                    
                    if ([king[kBuzzUniversity] objectForKey:kUniversityIcon]) {
                        
                        marker.country.text = [king[kBuzzUniversity] objectForKey:kUniversityIcon];
                        
                    }else{
                        
                        marker.country.text =@"";
                    }
                    
                    markerGoogle.iconView = marker;
                    
                    
                    if ([[[Following sharedInstance]following] containsObject:king[kBuzzInstaUsername]] && ![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"seeKing-%@",king.objectId]]){
                        //    if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){
                        
                        
                        marker.iconFriend.hidden = NO;
                        
                    }else{
                        
                        marker.iconFriend.hidden = YES;
                        
                    }
                    
                    
                    
                    
                    [self.markersUniversity addObject:markerGoogle];
                    
                    
                    if (self.mapView.camera.zoom > LevelZoomUniversityMin ) {
                        
                        
                        markerGoogle.map =self.mapView;
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
                
                
            }
            
        }else{
            
            
            /// Aucune photos
            
        }
        
        
        
        

        
    }];
    
    
    return;
    
    }
    
    PFQuery *queryCountry = [PFQuery queryWithClassName:kBuzzClasseName];
    [queryCountry whereKey:kBuzzKingCountry equalTo:@YES];
    
    PFQuery *queryCity = [PFQuery queryWithClassName:kBuzzClasseName];
    [queryCity whereKey:kBuzzKingCity equalTo:@YES];
    
    PFQuery *queryUniv = [PFQuery queryWithClassName:kBuzzClasseName];
    [queryUniv whereKey:kBuzzKingUniversity equalTo:@YES];
    
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryCountry,queryCity,queryUniv]];
    
    NSDate *date =  [NSDate date];
    NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
    
    
    [query whereKey:kBuzzWhen greaterThan:yesterday];
    [query whereKey:kBuzzDeleted notEqualTo:@YES];

    
    [query includeKey:kBuzzUser];
    [query includeKey:kBuzzCity];
    [query includeKey:kBuzzCountry];
    [query includeKey:kBuzzUniversity];
    
    [query orderByDescending:kBuzzKingCountry];
    [query addDescendingOrder:kBuzzKingCity];
    [query addDescendingOrder:kBuzzKingUniversity];
    [query addDescendingOrder:kBuzzLikeNumber];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable kings, NSError * _Nullable error) {
        
        
        
        for (int i = 0; i<kings.count; i++) {

            
            NSLog(@"on get les kings!!");
            
            
            
                PFObject *buzz = kings[i];
            
                if (buzz[kBuzzPhoto]) {
                    
                    NSLog(@"phoo");
                    
                    
                    PFFile *photo = buzz[kBuzzPhoto];
                    [photo getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                        
                        NSLog(@"Photo got");

                    }];
                }
                
                if (buzz[kBuzzVideo]) {
                    
                    PFFile *video = buzz[kBuzzVideo];
                    [video getDataInBackground];
                    
                }

        }

        if (kings != NULL) {
            
            for (int i = 0; i<self.markersCity.count; i++) {
                
                BuzzyMarker *marker = (BuzzyMarker *)[self.markersCity objectAtIndex:i];
                marker.map = nil;
                marker=nil;
                
            }
            
            
            for (int i = 0; i<self.markersCountry.count; i++) {
                
                BuzzyMarker *marker = (BuzzyMarker *)[self.markersCountry objectAtIndex:i];
                marker.map = nil;
                marker=nil;
                
            }
            
            
            
            for (int i = 0; i<self.markersUniversity.count; i++) {
                
                BuzzyMarker *marker = (BuzzyMarker *)[self.markersUniversity objectAtIndex:i];
                marker.map = nil;
                marker=nil;
                
            }
            
            
            
            
            NSMutableArray *kingsArray = [[NSMutableArray alloc]initWithArray:kings];
            
            self.markersCity = [[NSMutableArray alloc]init];
            self.markersCountry = [[NSMutableArray alloc]init];
            self.markersUniversity = [[NSMutableArray alloc]init];
            
            
            //                            [self.mapView clear];
            
            
            
            for (int i = 0; i<kingsArray.count; i++) {
                
                PFObject *king = [kingsArray objectAtIndex:i];
                PFGeoPoint *location = [king objectForKey:kBuzzLocation];
                
                
                ////// SI
                
                if ([king[kBuzzKingCountry] isEqual:@YES]) {
                    
                    
                    BuzzyMarker *markerGoogle = [[BuzzyMarker alloc]init];
                    [markerGoogle setPosition:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
                    markerGoogle.buzz = king;
                    
                    
                    PFFile *content = [king objectForKey:kBuzzPhoto];
                    [content getDataInBackground];
                    
                    MarkerView *marker = [[MarkerView alloc]init];
                    marker.picture.file = [[king objectForKey:kBuzzUser] objectForKey:kUserProfilePicture];
                    
                    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:king[kBuzzWhen]];
                    
                    float progress = 1-(secondsBetween / ( 24 * 60 * 60));
                    
                    
                    
                    [marker.progressView setProgress:progress animated:NO];
                    
                    [marker.picture loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        
                        markerGoogle.tracksViewChanges = NO;
                        
                    }];
                    
                    
                    if ([king[kBuzzCountry] objectForKey:kCountryIcon]) {
                        
                        marker.country.text = [king[kBuzzCountry] objectForKey:kCountryIcon];
                 
                    }else{
                        
                        marker.country.text =@"";
                    }
                    
                    markerGoogle.iconView = marker;
                    
                    
                    if ([[[Following sharedInstance]following] containsObject:king[kBuzzInstaUsername]] && ![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"seeKing-%@",king.objectId]]){
                        //    if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){
                        
                        
                        marker.iconFriend.hidden = NO;
                        
                    }else{
                        
                        marker.iconFriend.hidden = YES;
                        
//                        [self checkPretendersWithBuzz:king];

                    }

                    
                    
                    [self.markersCountry addObject:markerGoogle];
                    
//                    if (self.mapView.camera.zoom < LevelZoomCountryMax) {
                    
                        
                    markerGoogle.map =self.mapView;
                        
                   // }
                    
                    
                    
                    
                }else if ([king[kBuzzKingCity] isEqual:@YES]){
                    

                    
                    BuzzyMarker *markerGoogle = [[BuzzyMarker alloc]init];
                    [markerGoogle setPosition:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
                    markerGoogle.buzz = king;
                    
                    
                    
                    MarkerView *marker = [[MarkerView alloc]init];
                    marker.picture.file = [[king objectForKey:kBuzzUser] objectForKey:kUserProfilePicture];
                    
                    PFFile *content = [king objectForKey:kBuzzPhoto];
                    [content getDataInBackground];
                    
                    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:king[kBuzzWhen]];
                    
                    float progress = 1-(secondsBetween / ( 24 * 60 * 60));
                    
                    
                    
                    [marker.progressView setProgress:progress animated:NO];
                    
                    [marker.picture loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        
                        markerGoogle.tracksViewChanges = NO;
                        
                    }];
                    
                    
                    markerGoogle.iconView = marker;
                    
                    
                    if ([king[kBuzzCity] objectForKey:kCityIcon]) {
                        
                        marker.country.text = [king[kBuzzCity] objectForKey:kCityIcon];
                        
                    }else{
                        
                        marker.country.text =@"";
                    }
                    
                    
                    if ([[[Following sharedInstance]following] containsObject:king[kBuzzInstaUsername]] && ![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"seeKing-%@",king.objectId]]){
                        //    if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){
                        
                        
                        marker.iconFriend.hidden = NO;
                        
                    }else{
                        
                        marker.iconFriend.hidden = YES;
                        
                    }
                    
                    

                    
                    [self.markersCity addObject:markerGoogle];
                    
                    if (self.mapView.camera.zoom > LevelZoomCityMin ) {
                        
                        markerGoogle.map =self.mapView;
                        
                        
                    }
                    
                    
                }else if ([king[kBuzzKingUniversity] isEqual:@YES]){
                    
                    

                    
                    BuzzyMarker *markerGoogle = [[BuzzyMarker alloc]init];
                    [markerGoogle setPosition:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
                    markerGoogle.buzz = king;
                    
                    
                    PFFile *content = [king objectForKey:kBuzzPhoto];
                    [content getDataInBackground];
                    
                    MarkerView *marker = [[MarkerView alloc]init];
                    marker.picture.frame = CGRectMake(11, 44, 34, 34);
                    marker.progressView.frame = CGRectMake(9, 42, 38, 38);
                    marker.couronne.frame = CGRectMake((56-16)/2, 14+10, 16, 14);
                    marker.iconFriend.frame = CGRectMake(3,30, 16, 16);


                    
                    marker.picture.file = [[king objectForKey:kBuzzUser] objectForKey:kUserProfilePicture];
                    
                    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:king[kBuzzWhen]];
                    
                    float progress = 1-(secondsBetween / ( 24 * 60 * 60));
                    
                    
                    
                    [marker.progressView setProgress:progress animated:NO];
                    
                    [marker.picture loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        
                        markerGoogle.tracksViewChanges = NO;
                        
                    }];
                    
                    
                    if ([king[kBuzzUniversity] objectForKey:kUniversityIcon]) {
                        
                        marker.country.text = [king[kBuzzUniversity] objectForKey:kUniversityIcon];
                        
                    }else{
                        
                        marker.country.text =@"";
                    }

                    markerGoogle.iconView = marker;
                    
                    
                    if ([[[Following sharedInstance]following] containsObject:king[kBuzzInstaUsername]] && ![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"seeKing-%@",king.objectId]]){
                        //    if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){
                        
                        
                        marker.iconFriend.hidden = NO;
                        
                    }else{
                        
                        marker.iconFriend.hidden = YES;
                        
                    }
                    
                    

                    
                    [self.markersUniversity addObject:markerGoogle];
                    
                    
                    if (self.mapView.camera.zoom > LevelZoomUniversityMin ) {
                        
                        
                        markerGoogle.map =self.mapView;
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
                
                
            }
            
        }else{
            
            
            /// Aucune photos
            
        }

        
    }];
    
    
    
    
    //// QUery Lion
    
    
//    
//    
//    
//    PFQuery *queryLion = [PFQuery queryWithClassName:kBuzzClasseName];
//   
//    
//    [queryLion whereKey:kBuzzKingCountry notEqualTo:@YES];
//    [queryLion whereKey:kBuzzKingUniversity notEqualTo:@YES];
//    [queryLion whereKey:kBuzzKingCity notEqualTo:@YES];
//
//
//    [queryLion whereKeyExists:kBuzzCountry];
//
//    [queryLion whereKey:kBuzzInstaUsername containedIn:[[Following sharedInstance] following]];
//    [queryLion whereKey:kBuzzInstaUsername notEqualTo:[PFUser currentUser][kUserInstaUsername]];
//    
//   
//    [queryLion whereKey:kBuzzWhen greaterThan:yesterday];
//    [queryLion whereKey:kBuzzDeleted notEqualTo:@YES];
//    
//    [queryLion includeKey:kBuzzUser];
//    [queryLion includeKey:kBuzzCity];
//    [queryLion includeKey:kBuzzCountry];
//    [queryLion includeKey:kBuzzUniversity];
//    
//    [queryLion orderByDescending:kBuzzKingCountry];
//    [queryLion addDescendingOrder:kBuzzKingCity];
//    [queryLion addDescendingOrder:kBuzzKingUniversity];
//    [queryLion addDescendingOrder:kBuzzLikeNumber];
//    [queryLion findObjectsInBackgroundWithBlock:^(NSArray * _Nullable lions, NSError * _Nullable error) {
//       
//        NSLog(@"lions %@",lions);
//        
//        
//        if (lions != NULL) {
//            
//        
//            
//            
//            for (int i = 0; i<self.markersLionCountry.count; i++) {
//                
//                BuzzyMarker *marker = (BuzzyMarker *)[self.markersLionCountry objectAtIndex:i];
//                marker.map = nil;
//                marker=nil;
//                
//            }
//            
//            
//            
//          
//            
//            NSMutableArray *lionsArray = [[NSMutableArray alloc]initWithArray:lions];
//            
//            self.markersLionCountry = [[NSMutableArray alloc]init];
//            
//            
//            //                            [self.mapView clear];
//            
//    
//            
//            for (int i = 0; i<lionsArray.count; i++) {
//                
//                PFObject *lion = [lionsArray objectAtIndex:i];
//                PFGeoPoint *location = [lion objectForKey:kBuzzLocation];
//                
//                
//                    
//                    BuzzyMarker *markerGoogle = [[BuzzyMarker alloc]init];
//                    [markerGoogle setPosition:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
//                    markerGoogle.buzz = lion;
//                    markerGoogle.tracksViewChanges = NO;
//
//                
//                    LionView *marker = [[LionView alloc]init];
//                    
//                 
//                    markerGoogle.iconView = marker;
//                    
//                    
//                    [self.markersLionCountry addObject:markerGoogle];
//                    
//                    markerGoogle.map =self.mapView;
//                    
//                    
//                    
//            }
//            
//        }else{
//            
//            
//            /// Aucune photos
//            
//        }
//
//        
//        
//    }];
//   
                    
}


- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

-(void)addMap{
    
    
    [self.containerMaps addSubview:self.mapView];
    [self.containerMaps sendSubviewToBack:self.mapView];
    
    
}
-(BOOL) mapView:(GMSMapView *) mapView didTapMarker:(BuzzyMarker *)marker
{
    
    if (self.mapView.camera.zoom > LevelZoomCityMax && [[marker.buzz objectForKey:kBuzzKingUniversity] isEqual:@YES]) {
        
        
        marker.buzz[@"type"] = @"University";
        
    }else if (self.mapView.camera.zoom > LevelZoomCountryMax  && [[marker.buzz objectForKey:kBuzzKingCity] isEqual:@YES] ){
        
        marker.buzz[@"type"] = @"City";


    }else if ([[marker.buzz objectForKey:kBuzzKingCountry] isEqual:@YES]){
        
        marker.buzz[@"type"] = @"Country";

    }
    
//    marker.buzz[@"type"] =@""
    
    NSArray *buzzs = [[NSArray alloc]initWithObjects:marker.buzz, nil];

    [self openBuzzWithArray:buzzs andPretendant:NO];

    
    marker.tracksViewChanges = YES;

    MarkerView *markerViewB = (MarkerView*)marker.iconView;
    markerViewB.iconFriend.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:[NSString stringWithFormat:@"seeKing-%@",marker.buzz.objectId]];

    marker.iconView = markerViewB;
    
    marker.map =self.mapView;
    marker.tracksViewChanges = NO;

    

    
    return YES;
}


-(void)launchBuzz:(PFObject *)buzz pretendantType:(BOOL)pretendant{
    
    
    NSArray *buzzs = [[NSArray alloc]initWithObjects:buzz, nil];

    [self openBuzzWithArray:buzzs andPretendant:pretendant];
}


-(void)launchBuzz:(PFObject *)buzz pretendantType:(BOOL)pretendant fromLiked:(BOOL)liked{
    
    NSArray *buzzs = [[NSArray alloc]initWithObjects:buzz, nil];
    
    
    BuzzViewController *buzzVC = [[BuzzViewController alloc]initWithBuzzs:buzzs andPretendant:pretendant fromLiked:liked];
    
    buzzVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:buzzVC];
    //    self.animator.dragable = YES;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 1.0f;
    self.animator.behindViewScale = 1.0f;
    self.animator.transitionDuration = 0.7f;
    
    
    
    buzzVC.transitioningDelegate = self.animator;
    [self presentViewController:buzzVC animated:YES completion:nil];
    
    
}

-(void)openBuzzWithArray:(NSArray *)buzzs andPretendant:(BOOL)pretendant{
    
    
    BuzzViewController *buzzVC = [[BuzzViewController alloc]initWithBuzzs:buzzs andPretendant:pretendant];
    
    buzzVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:buzzVC];
//    self.animator.dragable = YES;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 1.0f;
    self.animator.behindViewScale = 1.0f;
    self.animator.transitionDuration = 0.7f;


    
    buzzVC.transitioningDelegate = self.animator;
    [self presentViewController:buzzVC animated:YES completion:nil];
    
    
    
}


-(UIImage*) makeImage {
    
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    return viewImage;
}




#pragma mark - Camera


- (void)actionTakePhoto
{
    
    if (self.shouldIgnoreTouchUp) {
        
        self.shouldIgnoreTouchUp = NO;
        return;
    }
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        // do your logic
    } else if(authStatus == AVAuthorizationStatusDenied){
        return;
        // denied
    } else if(authStatus == AVAuthorizationStatusRestricted){
        // restricted, normally won't happen
        return;

    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access to %@", mediaType);
            } else {
                NSLog(@"Not granted access to %@", mediaType);
            }
        }];
    } else {
        // impossible, unknown authorization status
        return;
        
    }
    
    
    self.myBuzz = nil;
    self.myBuzz = [PFObject objectWithClassName:kBuzzClasseName];
    
    
    [self updateTime];

    
    
    self.photoImageView.image = nil;
	
	if (TESTING_MODE) {
		self.photoImageView.hidden = NO;
        panGesture.enabled = YES;
		self.photoImageView.image = [UIImage imageNamed:@"baby.jpg"];
		
        [self.photoImageView addSubview:self.filterView];
        [self.filterView setUpImage:self.photoImageView.image];
	}
    
    [self.btnSave setBackgroundImage:[UIImage imageNamed:@"btnSavePhoto"] forState:UIControlStateNormal];
    self.photoSaved = NO;

    [self.btnDescription setBackgroundImage:[UIImage imageNamed:@"btnDescription"] forState:UIControlStateNormal];


    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //Your main thread code goes in here
        
        [self.btnSendBuzz setBackgroundImage:nil forState:UIControlStateNormal];
        self.btnSendBuzz.enabled = NO;
        self.loadingSendBuzz.hidden = NO;
    });
    
    self.modeVideo = NO;
    __weak typeof(self) weakSelf = self;
    
    [self.cameraView capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            
            weakSelf.photoImageView.image = image;

            weakSelf.photoImageView.hidden = NO;
            panGesture.enabled = YES;
            if(![weakSelf.photoImageView.subviews containsObject:weakSelf.filterView]) {
                [weakSelf.photoImageView addSubview:weakSelf.filterView];
                [weakSelf.filterView setUpImage:image];
            }
			
            weakSelf.scrollFilter.hidden = NO;

            [weakSelf saveFileImage:image];
            
            self.imageData = UIImageJPEGRepresentation([Utils imageByScalingAndCroppingForSize:CGSizeMake(720, 1280) andImage:image],0.8);
            self.fileImage =[PFFile fileWithName:@"buzz.jpg" data:self.imageData];
            
            
            [self.fileImage saveInBackground];
            
            [self.cameraView stop];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //Your main thread code goes in here
                
                self.btnSendBuzz.enabled = YES;
                [self.btnSendBuzz setBackgroundImage:[UIImage imageNamed:@"btnSend"] forState:UIControlStateNormal];
                self.loadingSendBuzz.hidden = YES;
            });
            
            
        }
        else {
            
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
    
    
    
    [self toggleHideCaptureControls:YES animated:YES];
    
    //
    
    
}

- (void)saveFileImage:(UIImage*)image {
    
    self.imageData = UIImageJPEGRepresentation([Utils imageByScalingAndCroppingForSize:CGSizeMake(720, 1280) andImage:image],0.8);
    self.fileImage = [PFFile fileWithName:@"buzz.jpg" data:self.imageData];
    [self.fileImage saveInBackground];
}

- (void)saveFileVideo:(NSURL*)videoUrl {
	
	NSData *video = [NSData dataWithContentsOfURL:videoUrl];
	
	self.videoFileURL = videoUrl;
	self.fileVideo = [PFFile fileWithName:@"video.mov" data:video];
	
	[self.fileVideo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
		NSLog(@"url %@",self.fileVideo.url);
	}];
	
}

-(void)actionSavePhoto {
    
    if (self.photoSaved == YES) return;
    
    self.photoSaved = YES;
    [self.btnSave setBackgroundImage:[UIImage imageNamed:@"btnSavedPhoto"] forState:UIControlStateNormal];
    
    NSLog(@"A");
    
    if (self.modeVideo != true) {
        UIImage* editedImage = [self getEditedPhoto];
        UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil);
        NSLog(@"B");
        
    }else{
        [self videoOutputCompletionBlock:^(NSURL* url) {
            
            if (url != nil) {
                NSLog(@"xoxo %@",url.path);
                UISaveVideoAtPathToSavedPhotosAlbum(url.path,nil,nil,nil);
            }
        }];
        
    }
}

#pragma mark - Video Process

- (CALayer*)getLayerOnVideo:(CGSize)size {
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.videoFilter.layer renderInContext:context];
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
//	Scaling image
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	UIGraphicsBeginImageContext( rect.size );
	[image drawInRect:rect];
	UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	NSData *imageData = UIImagePNGRepresentation(picture1);
	UIImage *img=[UIImage imageWithData:imageData];
	
//	Creating imageView with the scaled image
	UIImageView * imageView = [[UIImageView alloc] initWithImage:img];
	imageView.contentMode = UIViewContentModeScaleToFill;
	imageView.backgroundColor = [UIColor clearColor];
	
	return imageView.layer;
}


- (void)videoOutputCompletionBlock:(void(^)(NSURL*))completion
{
    AVAsset *videoAsset = [AVAsset assetWithURL:self.videoFileURL];

    // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];

    // 3 - Video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];

    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);

    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];

    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];

    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];

    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }

    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);

    [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize];

    // 4 - Get path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mov",arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];

    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [[CustomActivityIndicator sharedInstance] showIndicatorWithText:@"Processing..." fromVC:self];
    [self changeGestureState:NO];
     [self shouldShowDeleteButton:YES];
     self.deleteBtn.hidden = YES;
     [self.videoView bringSubviewToFront:self.videoFilter];
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSURL* outputUrl = [self exportDidFinish:exporter];
            completion(outputUrl);
        });
    }];
}

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
   // size = CGSizeMake(largeurIphone, hauteurIphone);
    
    // 1 - set up the overlay
    CALayer *overlayLayer = [CALayer layer];
	overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
	[overlayLayer setMasksToBounds:YES];
    CALayer* layer = [self getLayerOnVideo:size];
	[overlayLayer addSublayer:layer];

    // 2 - set up the parent layer
	CALayer *videoLayer = [CALayer layer];
	[videoLayer addSublayer:self.avPlayerLayer];
	videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
	
	CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
	
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];

    // 3 - apply magic
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    if(![self.videoView.layer.sublayers containsObject:self.avPlayerLayer]) {
        self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
        self.avPlayerLayer.frame = CGRectMake(0, 0, largeurIphone, hauteurIphone);
        [self.videoView.layer addSublayer:self.avPlayerLayer];
        [self.avPlayer pause];
    }

}

- (NSURL*)exportDidFinish:(AVAssetExportSession*)session {
    
    if (session.status == AVAssetExportSessionStatusCompleted) {
       
        NSURL *outputURL = session.outputURL;
        [self changeGestureState:YES];
        [[CustomActivityIndicator sharedInstance] hideIndicator];
        [self shouldShowDeleteButton:NO];
        self.deleteBtn.hidden = YES;
        [self.avPlayer play];
        [self saveFileVideo:outputURL];
        return outputURL;
    }
    return nil;
}

#pragma mark - Image Process

- (UIImage *)getEditedPhoto {
    
    [self shouldShowDeleteButton:YES];
    self.deleteBtn.hidden = YES;
    //
    // Create a "canvas" (image context) to draw in.
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    
    // Make the CALayer to draw in our "canvas".
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Fetch an UIImage of our "canvas".
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Stop the "canvas" from accepting any input.
    UIGraphicsEndImageContext();
    
    [self shouldShowDeleteButton:NO];
    // Return the image.
    return image;
}

-(UIImage *)thumbnailFromVideoAtURL:(NSURL *)contentURL {
    UIImage *theImage = nil;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:contentURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
    
    theImage = [[UIImage alloc] initWithCGImage:imgRef];
    
    CGImageRelease(imgRef);
    
    return theImage;
}

-(void)actionCancelPhoto {
    
    [self.filterView removeImagesFromFilter];
    
    for (UILabel* label in self.descriptionsArray) {
        [label removeFromSuperview];
    }
    self.selectedLbl = nil;
    self.descriptionsArray = nil;
    
    if ([[AVAudioSession sharedInstance] isOtherAudioPlaying]) {
        
        self.cameraView.needToStopSound = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            AVAudioSession *session1 = [AVAudioSession sharedInstance];
            [session1 setCategory:AVAudioSessionCategoryAmbient  error:nil];
            [session1 setActive:TRUE error:nil];
            
            
        });
    }else{
        
        self.cameraView.needToStopSound = NO;
        [self updateSound];

    }
    
    [self.cameraView start];
    
    if(self.modeVideo) {
        [self.avPlayerLayer removeFromSuperlayer];
        [self.videoFilter removeFromSuperview];
    } else {
        [self.filterView removeFromSuperview];
    }
    
    self.modeVideo = false;

    [self.drawImageLayer removeFromSuperlayer];
    
   
    self.photoImageView.hidden = YES;
    panGesture.enabled = NO;
    self.drawArray = nil;
	
    self.photoImageView.image = nil;
    self.fileVideo =nil;
    
    self.scrollFilter.hidden = YES;

    
    [self toggleHideCaptureControls:NO animated:YES];

    self.myBuzz = nil;
    self.videoView.hidden = YES;
    [self.filterView enablePanGesture:YES];
    panGesture.enabled = NO;
    [self.avPlayer pause];
    self.isVideoReady = NO;
}

- (void)toggleHideCaptureControls:(BOOL)hideCaptureControls animated:(BOOL)animated
{
    self.btnFlash.hidden = hideCaptureControls;
    self.btnSwitch.hidden = hideCaptureControls;
    self.btnTakePhotoDown.hidden = hideCaptureControls;
    
    self.btnCancel.hidden = !hideCaptureControls;
    self.btnDescription.hidden = !hideCaptureControls;
    self.drawBtn.hidden = !hideCaptureControls;
    self.btnTime.hidden = !hideCaptureControls;
    self.btnSave.hidden = !hideCaptureControls;
    self.btnSendBuzz.hidden = !hideCaptureControls;
    self.btnDraw.hidden = !hideCaptureControls;

    if (hideCaptureControls == YES) {
        
        if (IS_IPHONEX) {
            
            self.btnSendBuzz.frame = CGRectMake(largeurIphone/2-64/2, hauteurIphone-100-20+18-20, 64, 64);

        }else{
            self.btnSendBuzz.frame = CGRectMake(largeurIphone/2-64/2, hauteurIphone-100-20+18, 64, 64);
        }
		
        [UIView animateWithDuration:0.2 animations:^{
            
            if (IS_IPHONEX) {
                self.btnSendBuzz.frame = CGRectMake(largeurIphone-46-19, hauteurIphone-46-17-20, 50, 50);
            }else{
                self.btnSendBuzz.frame = CGRectMake(largeurIphone-46-19, hauteurIphone-46-17, 50, 50);
            }
        } completion:nil];
    }
}



-(void)actionSwitchCamera{
    
    [self.cameraView togglePosition ];
    [self.btnFlash setBackgroundImage:[UIImage imageNamed:@"btnFlash"] forState:UIControlStateNormal];

    if(self.cameraView.flash == LLCameraFlashOff) {
        
            [self.btnFlash setBackgroundImage:[UIImage imageNamed:@"btnFlash"] forState:UIControlStateNormal];
            
    }
    else {

        
            [self.btnFlash setBackgroundImage:[UIImage imageNamed:@"btnFlashOn"] forState:UIControlStateNormal];
            
    }

}

-(void)actionFlashCamera{
    
    if(self.cameraView.flash == LLCameraFlashOff) {
        BOOL done = [self.cameraView updateFlashMode:LLCameraFlashOn];
        if(done) {
            
            [self.btnFlash setBackgroundImage:[UIImage imageNamed:@"btnFlashOn"] forState:UIControlStateNormal];
            
            
        }
    }
    else {
        BOOL done = [self.cameraView updateFlashMode:LLCameraFlashOff];
        if(done) {
            
            [self.btnFlash setBackgroundImage:[UIImage imageNamed:@"btnFlash"] forState:UIControlStateNormal];
            
            
        }
    }
    
    
}

//-(void)actionDraw{
//    
//    if (self.jot.userInteractionEnabled == true) {
//      
//        self.jot.userInteractionEnabled = false;
//        
//    }else{
//        
//        self.jot.userInteractionEnabled = true;
//
//    }
//}

-(void)actionSelectTime{
    
    
    
    [self updateTime];
    
    self.selectTimeView.hidden = NO;

}

-(void)updateTime{
    
    if (self.myBuzz[kBuzzDuration]) {
        
        NSInteger value = [self.myBuzz[kBuzzDuration] integerValue];
        
        [self.selectTimeView.pickerView selectItem:value-1 animated:NO];
        [self.btnTime setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btnTime-%ld",(long)value]] forState:UIControlStateNormal];

        
    }else if ([[NSUserDefaults standardUserDefaults] stringForKey:@"buzzDuration"]){
        
        NSInteger value = [[[NSUserDefaults standardUserDefaults] stringForKey:@"buzzDuration"] integerValue];
        
        
        [self.selectTimeView.pickerView selectItem:value-1 animated:NO];
        [self.btnTime setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btnTime-%ld",(long)value]] forState:UIControlStateNormal];

    }else{
        
        [self.selectTimeView.pickerView selectItem:10-1 animated:NO];
        [self.btnTime setBackgroundImage:[UIImage imageNamed:@"btnTime-10"] forState:UIControlStateNormal];

    }
    
}

-(void)updateTimeFromPicker:(int)duration{
    
    
    self.myBuzz[kBuzzDuration] = @(duration);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger: duration] forKey:@"buzzDuration"];
    
    
    if (self.myBuzz[kBuzzDuration]) {
        
        
        NSInteger value = [self.myBuzz[kBuzzDuration] integerValue];
        
        [self.btnTime setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btnTime-%ld",(long)value]] forState:UIControlStateNormal];
        
        
    }else if ([[NSUserDefaults standardUserDefaults] stringForKey:@"buzzDuration"]){
        
        NSInteger value = [[[NSUserDefaults standardUserDefaults] stringForKey:@"buzzDuration"] integerValue];
        
        
        [self.btnTime setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btnTime-%ld",(long)value]] forState:UIControlStateNormal];
        
    }else{
        
        [self.btnTime setBackgroundImage:[UIImage imageNamed:@"btnTime-10"] forState:UIControlStateNormal];
        
    }
    

}

#pragma mark - Description
- (void)actionDescriptionView{
	
	self.descView = [[DescriptionView alloc] initWithFrame:self.view.frame];
	
	[self.view addSubview:_descView];
	[self.descView.titleTextField becomeFirstResponder];
	
	__weak typeof(self) weakSelf = self;
	
	_descView.descriptionDone = ^(NSString *text, UIColor* color) {
		[weakSelf.descView removeFromSuperview];
		
		if (text != nil && text.length > 0) {
			UILabel* label = [weakSelf getLabelForDescription:text textColor:color];
            label.adjustsFontSizeToFitWidth = YES;
            weakSelf.selectedLbl = label;
            label.textColor = color;
			label.center = weakSelf.view.center;
            if (weakSelf.modeVideo) {
                [weakSelf.videoFilter addSubview:label];
            } else {
                [weakSelf.photoImageView addSubview:label];
            }
			
			if (weakSelf.descriptionsArray == nil) {
				weakSelf.descriptionsArray = [[NSMutableArray alloc] init];
			}
			[weakSelf.descriptionsArray addObject:label];
		}
	};
}

- (UILabel*)getLabelForDescription:(NSString*)text textColor:(UIColor*)color {
	
	UILabel* label = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, _descView.titleTextField.frame.size.height)];
	label.font = [UIFont Avenir:30];
	label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0 ;
	label.lineBreakMode = NSLineBreakByWordWrapping;
	label.text = text;
    label.textColor = color;
	[label sizeToFit];
	[label setUserInteractionEnabled:YES];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    label.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
	
	UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(descriptionClick:)];
	[label addGestureRecognizer:gesture];
	
	return label;
}

-(void)rotateLbl:(UIRotationGestureRecognizer*)sender {
    //UILabel* label = (UILabel*)sender.view;
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = self.selectedLbl.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [self.selectedLbl setTransform:newTransform];
    
    lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer {
    self.selectedLbl.numberOfLines = 0;
    self.selectedLbl.adjustsFontSizeToFitWidth = YES;
    
    UIGestureRecognizerState state = [gestureRecognizer state];

    if (state == UIGestureRecognizerStateBegan || state ==    UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [gestureRecognizer scale];
        CGPoint centerPoint = self.selectedLbl.center;
        CGFloat radians = atan2f(self.selectedLbl.transform.b, self.selectedLbl.transform.a);
        
        self.selectedLbl.transform = CGAffineTransformIdentity;
        self.selectedLbl.frame = CGRectMake(self.selectedLbl.frame.origin.x, self.selectedLbl.frame.origin.y, self.selectedLbl.frame.size.width*scale, self.selectedLbl.frame.size.height*scale);
        self.selectedLbl.center = centerPoint;
        self.selectedLbl.font = [UIFont fontWithName:self.selectedLbl.font.fontName size:self.selectedLbl.font.pointSize*scale];
        self.selectedLbl.transform = CGAffineTransformMakeRotation(radians);
        
        [gestureRecognizer setScale:1.0];
    }
}

- (void)descriptionClick:(UITapGestureRecognizer*)gesture {
	
	UILabel* label = (UILabel*)gesture.view;
    self.selectedLbl = label;
	
	if (label != nil) {
	
		_descView = [[DescriptionView alloc] initWithFrame:self.view.frame];
		
		[self.view addSubview:_descView];
		[_descView.titleTextField becomeFirstResponder];
        
		_descView.titleTextField.text = label.text;
        _descView.titleTextField.textColor = label.textColor;
        
        CGFloat fixedWidth = _descView.titleTextField.frame.size.width;
        CGSize newSize = [_descView.titleTextField sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = _descView.titleTextField.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        _descView.titleTextField.frame = newFrame;
		
		__weak typeof(self) weakSelf = self;
		
		_descView.descriptionDone = ^(NSString *text, UIColor* color) {
			
			[weakSelf.descView removeFromSuperview];
			weakSelf.descView = nil;
			
			if (text != nil && text.length > 0){
                
                CGFloat width = ceil([text sizeWithAttributes:@{NSFontAttributeName: label.font}].width);
                CGPoint centerPoint = label.center;
                CGFloat radians = atan2f(label.transform.b, label.transform.a);
                label.transform = CGAffineTransformIdentity;
                
                if (width > self.view.frame.size.width - 20 ){
                    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, self.view.frame.size.width - 20, label.frame.size.height);
                } else {
                    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, width, label.frame.size.height);
                }
                
                label.transform = CGAffineTransformMakeRotation(radians);
				label.text = text;
                label.center = centerPoint;
                label.textColor = color;
				[label sizeToFit];
			}
            else {
                
                [weakSelf.descriptionsArray removeObject:label];
                [label removeFromSuperview];
            }
		};
	}
}

- (void)descriptionMove:(UIPanGestureRecognizer*)gesture {
    
    UIGestureRecognizerState state = [gesture state];
	UIView* view = gesture.view;
	CGPoint loc = [gesture locationInView:view];
	
    if (state == UIGestureRecognizerStateBegan) {
		
		UILabel* label = [self getDescriptionAtPoint:loc];
        
		if (label != nil) {
			self.currentMovingLabel = label;
			self.selectedLbl = label;
			[self shouldShowDeleteButton:YES];
			return;
		}
		self.lastPoint = loc;
    }
    
    if (state == UIGestureRecognizerStateEnded) {
        if( CGRectContainsPoint(self.selectedLbl.frame, self.deleteBtn.center) ) {
            [self.selectedLbl removeFromSuperview];
            self.selectedLbl = nil;
        }
        [self shouldShowDeleteButton:NO];
		
		if (self.currentMovingLabel != nil) {
			self.currentMovingLabel = nil;
			return;
		}
        if (_modeVideo) {
            [self.videoFilter setFilter];
        }
    }
	
	if (self.currentMovingLabel != nil) {
		self.currentMovingLabel.center = loc;
        [self.view setNeedsLayout];
        return;
	}
	
    CGFloat vx = fabs([gesture velocityInView:view].x/ self.view.frame.size.width);
    
    if (vx < 1) vx = 1;
    if (vx > 2.5) vx = 2.5;
    
    if(_modeVideo) {
        [self.videoFilter moveFilterBy:vx*( loc.x - self.lastPoint.x )shouldAnimation:NO] ;
    }
	self.lastPoint = loc;
    [self.view setNeedsLayout];
}

- (void)shouldShowDeleteButton:(BOOL)shouldShow {
	
    self.btnCloseCamera.hidden = shouldShow;
    self.btnCancel.hidden = shouldShow;
    self.btnDescription.hidden = shouldShow;
    self.deleteBtn.hidden = !shouldShow;
    self.btnTime.hidden = shouldShow;
    self.btnSave.hidden = shouldShow;
    self.btnSendBuzz.hidden = shouldShow;
    self.drawBtn.hidden = shouldShow;
}

- (void)ShouldhideAllBottomButton:(BOOL)shouldHide {
    self.btnDescription.hidden = shouldHide;
    self.btnCancel.hidden = shouldHide;
    self.drawBtn.hidden = shouldHide;
    self.btnTime.hidden = shouldHide;
    self.btnSave.hidden = shouldHide;
    self.btnSendBuzz.hidden = shouldHide;
    self.btnCloseCamera.hidden = shouldHide;
}

- (UILabel*)getDescriptionAtPoint:(CGPoint)p {
	
	if (self.descriptionsArray.count == 0) return nil;
	
	for (UILabel* label in self.descriptionsArray) {
		
		CGFloat x = label.frame.origin.x;
		CGFloat y = label.frame.origin.y;
		CGFloat w = label.frame.size.width;
		CGFloat h = label.frame.size.height;
        
        if ( (p.x > x && p.x < x+w) && (p.y > y && p.y < y+h))
			return label;
	}
	return nil;
}

- (void)setConstraintsToDeleteButton {
	
	self.deleteBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.deleteBtn.heightAnchor constraintEqualToConstant:40] setActive:YES];
    [[self.deleteBtn.widthAnchor constraintEqualToConstant:40] setActive:YES];
    [[self.deleteBtn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[self.deleteBtn.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant: -50] setActive:YES];
    
    [self.view layoutIfNeeded];
}

-(void)actionSendBuzz{
    
    __weak typeof(self) weakSelf = self;
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint* geoPoint, NSError* error) {
        
        if (!error) {
            
           
            
            weakSelf.myBuzz[kBuzzUser] = [PFUser currentUser];
            weakSelf.myBuzz[kBuzzMessageNumber] = @0;
            
            if ([PFUser currentUser][kUserInstaUsername]) {
                weakSelf.myBuzz[kBuzzInstaUsername] = [PFUser currentUser][kUserInstaUsername];
            }
            
            weakSelf.myBuzz[kBuzzWhen] = [NSDate date];
            weakSelf.myBuzz[kBuzzLocation] = geoPoint;
            //            self.myBuzz[kBuzzStreet] = @"Blainville sur mer";
            weakSelf.myBuzz[kBuzzKingNumber] =@0;
            weakSelf.myBuzz[kBuzzLikeNumber] =@0;
            //
            UIImage* image = [weakSelf getEditedPhoto];
            [weakSelf saveFileImage:image];
            
            weakSelf.myBuzz[kBuzzPhoto] = weakSelf.fileImage;
            weakSelf.myBuzz[kBuzzDuration] =@([weakSelf.myBuzz[kBuzzDuration] intValue]);
            
            if ([[Position sharedInstance]currentCountry] != NULL) {
                weakSelf.myBuzz[kBuzzCountry] =[[Position sharedInstance]currentCountry];
            }
            
            if ([[Position sharedInstance]currentCity] != NULL) {
                weakSelf.myBuzz[kBuzzCity] =[[Position sharedInstance]currentCity];
            }
            
            if ([[Position sharedInstance]currentUniversity] != NULL) {
                weakSelf.myBuzz[kBuzzUniversity] =[[Position sharedInstance]currentUniversity];
            }
            
            NSLog(@"On va savee %@",weakSelf.myBuzz);
            
            if (self.fileVideo) {
                
                [weakSelf videoOutputCompletionBlock:^(NSURL* url) {
                    
                    if (url != nil) {
                        
                        self.myBuzz[kBuzzVideo] = self.fileVideo;
                        NSLog(@"video !! %@",self.myBuzz[kBuzzVideo]);
                        [weakSelf saveBuzzInBackground];
                    }
                    
                }];
                
            }else{
                [self saveBuzzInBackground];
                NSLog(@"pas de video");
            }
            
        }else{
            NSLog(@"error de location !!! Afficher POPUP");
        }
    }];
}

- (void)saveBuzzInBackground {
    
    [self.myBuzz saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        NSLog(@"Saved");
        
        if (error) {
            
        }else{
            
            NSLog(@"successs %d",succeeded);
            
            [PFCloud callFunctionInBackground:@"loopKing" withParameters:@{} block:^(id object, NSError* error) {
                
                [self refreshMapAction];
                [self refreshMyBuzz];
                
            }];
            [self refreshMapAction];
            [self refreshMyBuzz];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self actionCancelPhoto];
        [self actionTakePhotoUp];
    });
}


#pragma mark - BuzzViewDelegate;

-(void)buzzMapLiked:(PFObject *)buzz{
    
    [self refreshMapAction];
    [self.likedView refreshData];
    [self.kingsView refreshData];   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - SettingsDelegate;


-(void)openPrivacy{
    
    [self.navigationController pushViewController:[[WebViewViewController alloc]initWithStyle:kStyleWhite type:kTypeText title:NSLocalizedString(@"Privacy Policy", nil)
                                                   
                                                                                          url:[NSURL URLWithString:[PFConfig currentConfig][kConfigPrivacy]]] animated:YES];
    
    
}
-(void)openTerms{
    
    [self.navigationController pushViewController:[[WebViewViewController alloc]initWithStyle:kStyleWhite type:kTypeText title:NSLocalizedString(@"Terms & Conditions", nil)
                                                                                          url:[NSURL URLWithString:[PFConfig currentConfig][kConfigTerms]]] animated:YES];

}


-(void)openLegend{
    
    [self.navigationController pushViewController:[[LegendViewController alloc]initWithStyle:kStyleBlack type:kTypeText] animated:YES];
    
}

-(void)openInviteFriends{
    
    
    if ([PFConfig currentConfig][KConfigShareText]) {
        
        
        
        if ([PFConfig currentConfig][KConfigShareUrl]) {
            
            NSString *textToShare =[PFConfig currentConfig][KConfigShareText];
            NSURL *shareURL = [NSURL URLWithString:[PFConfig currentConfig][KConfigShareUrl]];
            
            if ([Utils languageFr]) {
                
                textToShare =[PFConfig currentConfig][KConfigShareTextFr];
                
            }
            NSArray *objectsToShare = @[shareURL,textToShare];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            
            
            [self presentViewController:activityVC animated:YES completion:nil];
            
            

        }else{
            
            NSString *textToShare =[PFConfig currentConfig][KConfigShareText];
            
            if ([Utils languageFr]) {
                
                textToShare =[PFConfig currentConfig][KConfigShareTextFr];
                
            }
            NSArray *objectsToShare = @[textToShare];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            
            
            [self presentViewController:activityVC animated:YES completion:nil];
            
            

        }
        
    }

    
}
-(void)openHelpSupport{
    
            [Intercom presentMessageComposer];

}
-(void)openRateUs{
    
    NSString *idApp = [PFConfig currentConfig][kConfigIdApp];
    
    NSURL *rating = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",idApp]];
    
    [[UIApplication sharedApplication] openURL:rating];
    

}

-(void)openTutorial{
    
    

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate replayTuto];
}


-(void)openLogout{
    
    
            MMPopupItemHandler blockNO = ^(NSInteger index){
    
    
            };
    
    
    
            MMPopupItemHandler blockYES = ^(NSInteger index){
    
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate logout];
    
    
            };
    
    
            NSArray *items = @[MMItemMake(NSLocalizedString(@"NO", nil), MMItemTypeNormal, blockNO),MMItemMake(NSLocalizedString(@"YES", nil), MMItemTypeNormal, blockYES)];
    
            NSString *message = NSLocalizedString(@"Are you sure you want to log out?",nil);
    
    
            MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:NSLocalizedString(@"Log Out", nil) detail:message items:items];
            alertView.attachedView = self.view;
            alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
            [alertView show];
            
            
    
}


-(void)checkPretendersWithBuzz:(PFObject *)buzz{
    
    if ([buzz[kBuzzKingCountry] isEqual:@YES]) {
        
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        
        
        [query whereKey:kBuzzCountry equalTo:buzz[kBuzzCountry]];
        [query whereKey:@"objectId" notEqualTo:buzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzsA, NSError * _Nullable error) {
        
            
            
            if (buzzsA != NULL && buzzsA.count > 0) {
                
                
                
                
            }else{
                
                
            }
            
            
            
            
            
        }];
        
        
    }else if([buzz[kBuzzKingCity] isEqual:@YES]){
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        
        
        [query whereKey:kBuzzCity equalTo:buzz[kBuzzCity]];
        [query whereKey:@"objectId" notEqualTo:buzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzsA, NSError * _Nullable error) {
            
            
            if (buzzsA != NULL && buzzsA.count > 0) {
                
                
            }else{
                
                
            }
            
            
            
            
        }];
        
        
        
        
    }else if([buzz[kBuzzKingUniversity] isEqual:@YES]){
        
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        
        
        [query whereKey:kBuzzUniversity equalTo:buzz[kBuzzUniversity]];
        [query whereKey:@"objectId" notEqualTo:buzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];
      
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzsA, NSError * _Nullable error) {
            
            
            
            if (buzzsA != NULL && buzzsA.count > 0) {
                
                
                
            }else{
                
                
            }
            
            
            
        }];
        
        
        
        
    }else{
        
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
