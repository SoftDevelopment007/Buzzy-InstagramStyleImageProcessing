//
//  BbCardView.m
//  BottleBond
//
//  Created by Julien Levallois on 16-10-31.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//
#import "BbCardView.h"
#import "AppDelegate.h"
#import "Following.h"


#define METERS_CUTOFF   1000


@implementation BbCardView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        ///// 58 234
        
        self.layer.cornerRadius = 16;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor blackColor];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(reportBuzz:)];
        [longPress setDelegate:self];
        [self addGestureRecognizer:longPress];

        
        self.videoView = [[UIView alloc]initWithFrame:CGRectMake(-5, -5, frame.size.width+10, frame.size.height+10)];
        self.videoView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.videoView];
        
        
        // the video player
        self.videoPlayer = [[PBJVideoPlayerController alloc] init];
        self.videoPlayer.delegate = self;
        self.videoPlayer.view.frame = CGRectMake(0,0, self.videoView.frame.size.width,self.videoView.frame.size.height);
        self.videoPlayer.playbackLoops = YES;
        [self.videoPlayer setMuted:NO];
        
        
        
        [self.videoView addSubview:self.videoPlayer.view];
        
        self.image = [[PFImageView alloc]initWithFrame:frame];
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.image];

        
        
        self.loading =[[loadingVideo alloc]initWithFrame:self.videoView.frame];
        self.loading.hidden = YES;
        [self addSubview:self.loading];
        

    
        
        
        self.romains = [NSArray arrayWithObjects:@"",@"I",@"II",@"III",@"IV",@"V",@"VI",@"VII",@"VIII",@"IX",@"X", nil];
        
        
        self.filterImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-216, self.frame.size.width, 216)];
        self.filterImage.image = [UIImage imageNamed:@"filterImage"];
        [self addSubview:self.filterImage];
        
        
        self.viewTutoSwipe = [[UIView alloc]initWithFrame:frame];
        self.viewTutoSwipe.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        self.viewTutoSwipe.hidden = YES;
        [self addSubview:self.viewTutoSwipe];
        
        
        
        self.likeImage = [[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone+10)/2-80, self.frame.size.height/2-77.5, 160, 145)];
        self.likeImage.alpha =0;
        self.likeImage.image = [UIImage imageNamed:@"heart"];
        [self addSubview:self.likeImage];
        
        self.dislikeImage = [[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone+10)/2-77.5, self.frame.size.height/2-77.5, 145, 145)];
        self.dislikeImage.alpha =0;
        self.dislikeImage.image = [UIImage imageNamed:@"cross"];
        [self addSubview:self.dislikeImage];
        
        
        UIImageView *imgTutoSwipe = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-214/2, frame.size.height/2-220/2-30, 214, 220)];
        imgTutoSwipe.image = [UIImage imageNamed:@"infoSwipe"];
        [self.viewTutoSwipe addSubview:imgTutoSwipe];
     
        

       

        self.container = [[UIView alloc]initWithFrame:CGRectMake(5, 5, largeurIphone, hauteurIphone)];
        self.container.backgroundColor =[UIColor clearColor];
        [self addSubview:self.container];

        
        
        self.timeFrameBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 8)];
        self.timeFrameBackground.backgroundColor =[UIColor blackColor];
        self.timeFrameBackground.alpha = 0.47;
        [self addSubview:self.timeFrameBackground];
        
        self.timeFrame = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 8)];
        self.timeFrame.layer.cornerRadius = 4;
        [self addSubview:self.timeFrame];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(hideTap)];
        [self addGestureRecognizer:singleFingerTap];
        
        
        self.timerView = [[UIView alloc]initWithFrame:CGRectMake(16, 24, 24, 24)];
        self.timerView.layer.cornerRadius =8;
        [self.container addSubview:self.timerView];
        
        self.timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        self.timerLabel.font = [UIFont HelveticaNeue:13];
        self.timerLabel.textColor = [UIColor whiteColor];
        self.timerLabel.textAlignment = NSTextAlignmentCenter;
        [self.timerView addSubview:self.timerLabel];
        
        
        if (IS_IPHONEX) {
            
            self.heart1 = [[UIImageView alloc] initWithFrame:CGRectMake(largeurIphone-30-75+40,hauteurIphone-67-20, 75, 52)];

            
        }else{
            
            self.heart1 = [[UIImageView alloc] initWithFrame:CGRectMake(largeurIphone-30-75+40,hauteurIphone-67, 75, 52)];

        }
        
        self.heart1.hidden=YES;
        [self.heart1 setImage:[[UIImage imageNamed:@"btnBuzzLike"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        self.heart1.tintColor=[UIColor redBuzzy];
        
        
        if (IS_IPHONEX) {
            
            self.heart2 = [[UIImageView alloc] initWithFrame:CGRectMake(largeurIphone-30-75+40, hauteurIphone-67-20, 75, 52)];

            
        }else{
            
            self.heart2 = [[UIImageView alloc] initWithFrame:CGRectMake(largeurIphone-30-75+40, hauteurIphone-67, 75, 52)];

        }
        [self.heart2 setImage:[[UIImage imageNamed:@"btnBuzzLike"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        self.heart2.hidden=YES;
        self.heart2.tintColor=[UIColor redBuzzy];
        
        [self.container addSubview:self.heart1];
        
        [self.container addSubview:self.heart2];
        
        
        if (IS_IPHONEX) {
            
            self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(30, hauteurIphone-67-20, largeurIphone-60, 52)];

            
        }else{
            
            self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(30, hauteurIphone-67, largeurIphone-60, 52)];

        }
        self.bottomView.backgroundColor = [UIColor redBuzzy];
        self.bottomView.layer.cornerRadius = 10;
        self.bottomView.layer.masksToBounds =YES;
        
        [self.container addSubview:self.bottomView];
        
        
        
        self.profilePicture = [[PFImageView alloc]initWithFrame:CGRectMake(0, 0, 52, 52)];
        self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
        [self.bottomView addSubview:self.profilePicture];
        
        
        
        if (IS_IPHONEX) {

            self.openMyLike = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-120, hauteurIphone-67-20,100, self.profilePicture.frame.size.height)];

        }else{
            self.openMyLike = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-120, hauteurIphone-67,100, self.profilePicture.frame.size.height)];

            
        }
        [self.openMyLike addTarget:self action:@selector(openMyLikes) forControlEvents:UIControlEventTouchUpInside];
        self.openMyLike.hidden = YES;
        [self.container addSubview:self.openMyLike];
        
        
        
        if (IS_IPHONEX) {
            
            self.openProfileInsta = [[UIButton alloc]initWithFrame:CGRectMake(0, hauteurIphone-67-20, 30+220, self.profilePicture.frame.size.height)];

        }else{
            self.openProfileInsta = [[UIButton alloc]initWithFrame:CGRectMake(0, hauteurIphone-67, 30+220, self.profilePicture.frame.size.height)];

            
        }
        [self.openProfileInsta addTarget:self action:@selector(openInstaProfile) forControlEvents:UIControlEventTouchUpInside];
        [self.container addSubview:self.openProfileInsta];
        
        
        if (IS_IPHONEX) {
            
            self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, hauteurIphone-67-50-20, largeurIphone-60, 50)];

        }else{
            self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, hauteurIphone-67-50, largeurIphone-60, 50)];

            
        }
        
        self.descriptionLabel.font = [UIFont BerkshireSwash:22];
        self.descriptionLabel.textColor = [UIColor whiteColor];
        self.descriptionLabel.numberOfLines = 0 ;
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.container addSubview:self.descriptionLabel];
        
        
        
        self.detail1 = [[UILabel alloc]initWithFrame:CGRectMake(63, 6, 200, 21)];
        self.detail1.textColor = [UIColor whiteColor];
        self.detail1.font = [UIFont HelveticaNeue:18];
        [self.bottomView addSubview:self.detail1];
        
        
        
        self.detail2 = [[UILabel alloc]initWithFrame:CGRectMake(63, 31, 200, 15)];
        self.detail2.textColor = [UIColor whiteColor];
        self.detail2.font = [UIFont HelveticaNeue:13];
        [self.bottomView addSubview:self.detail2];
        
        
        self.likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, self.bottomView.frame.size.width-50, 18)];
        self.likeLabel.textColor = [UIColor whiteColor];
        self.likeLabel.font = [UIFont HelveticaNeue:16];
        self.likeLabel.textAlignment = NSTextAlignmentRight;
        [self.bottomView addSubview:self.likeLabel];
        
        
        self.likeButton = [[LikeButton alloc]initWithFrame:CGRectMake(self.bottomView.frame.size.width-75,0, 75, 52)];
        [self.likeButton addTarget:self action:@selector(actionLikeButton) forControlEvents:UIControlEventTouchUpInside];
        self.likeButton.tintColor = [UIColor redBuzzy];
        [self.likeButton setBackgroundImage:[[UIImage imageNamed:@"btnBuzzLike"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.bottomView addSubview:self.likeButton];
        
        
        
        self.statsView = [[UIView alloc]initWithFrame:CGRectMake(52, 0, self.bottomView.frame.size.width-52, self.bottomView.frame.size.height)];
        self.statsView.hidden = YES;
        [self.bottomView addSubview:self.statsView];
        
        
        
        self.statsLikeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, self.statsView.frame.size.width-50, 18)];
        self.statsLikeLabel.textColor = [UIColor whiteColor];
        self.statsLikeLabel.font = [UIFont HelveticaNeue:16];
        self.statsLikeLabel.textAlignment = NSTextAlignmentRight;
        [self.statsView addSubview:self.statsLikeLabel];
        
        
        self.statsLikeImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.statsView.frame.size.width-75,0, 75, 52)];
        self.statsLikeImage.image = [[UIImage imageNamed:@"btnBuzzLike"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.statsLikeImage.tintColor = [UIColor whiteColor];
        [self.statsView addSubview:self.statsLikeImage];
        
        
        
        
        self.statsViewImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.statsView.frame.size.width/2,18, 23, 16)];
        self.statsViewImage.image = [[UIImage imageNamed:@"imageView"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.statsViewImage.tintColor = [UIColor whiteColor];
        [self.statsView addSubview:self.statsViewImage];
        
        
        self.statsViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, self.statsView.frame.size.width/2-5, 18)];
        self.statsViewLabel.textColor = [UIColor whiteColor];
        self.statsViewLabel.font = [UIFont HelveticaNeue:16];
        self.statsViewLabel.textAlignment = NSTextAlignmentRight;
        [self.statsView addSubview:self.statsViewLabel];
        
        
        self.statsScreenImage = [[UIImageView alloc]initWithFrame:CGRectMake(47,14, 25, 24)];
        self.statsScreenImage.image = [[UIImage imageNamed:@"imageScreen"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.statsScreenImage.tintColor = [UIColor whiteColor];
        [self.statsView addSubview:self.statsScreenImage];
        
        
        self.statsScreenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, 40, 18)];
        self.statsScreenLabel.textColor = [UIColor whiteColor];
        self.statsScreenLabel.font = [UIFont HelveticaNeue:16];
        self.statsScreenLabel.textAlignment = NSTextAlignmentRight;
        [self.statsView addSubview:self.statsScreenLabel];
        
        
        
        if (IS_IPHONEX) {
            
            self.btnSword = [[UIButton alloc]initWithFrame:CGRectMake((largeurIphone/2-25),24+30, 50, 50)];

        }else{
            
            self.btnSword = [[UIButton alloc]initWithFrame:CGRectMake((largeurIphone/2-25),24, 50, 50)];

        }
        
        [self.btnSword setBackgroundImage:[UIImage imageNamed:@"btnSword"] forState:UIControlStateNormal];
        [self.btnSword addTarget:self action:@selector(openSwordFromKing) forControlEvents:UIControlEventTouchUpInside];
        self.btnSword.hidden = YES;
        
        
        [self.container addSubview:self.btnSword];
        
        
        if (IS_IPHONEX) {
            
            self.btnFlag = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-50-14-5,24+55+30, 50, 50)];

        }else{
            
            self.btnFlag = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-50-14-5,24+55, 50, 50)];

        }
        
        [self.btnFlag setBackgroundImage:[UIImage imageNamed:@"btnFlag"] forState:UIControlStateNormal];
        [self.btnFlag addTarget:self action:@selector(reportBuzz) forControlEvents:UIControlEventTouchUpInside];
        self.btnFlag.hidden = YES;
        
        if ([PFConfig currentConfig][@"btnFlag"]) {
            
            if ([[PFConfig currentConfig][@"btnFlag"] isEqual:@YES]) {
                
                    self.btnFlag.hidden = NO;

            }
            
        }
        
        [self.container addSubview:self.btnFlag];
        
        self.flag = [[UILabel alloc]initWithFrame:CGRectMake(self.btnSword.frame.origin.x-22, self.btnSword.frame.origin.y -1, 56, 23)];
        self.flag.font =[UIFont HelveticaNeue:25];
        self.flag.textAlignment = NSTextAlignmentCenter;
        self.flag.textColor =[UIColor whiteColor];
        [self.flag setTransform:CGAffineTransformMakeRotation(-M_PI / 7)];
        
        
        
        [self.container addSubview:self.flag];
        
        
        
        
        if (IS_IPHONEX) {
            
            self.pretendantView = [[UIView alloc]initWithFrame:CGRectMake(largeurIphone/2-12, 62+30, 24, 24)];

        }else{
            
            self.pretendantView = [[UIView alloc]initWithFrame:CGRectMake(largeurIphone/2-12, 62, 24, 24)];

        }
        
        self.pretendantView.layer.cornerRadius =12;
        self.pretendantView.backgroundColor =[UIColor redBuzzy];
        self.pretendantView.hidden = YES;

        [self.container addSubview:self.pretendantView];
        
        self.pretendantLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        self.pretendantLabel.font = [UIFont HelveticaNeue:13];
        self.pretendantLabel.textColor = [UIColor whiteColor];
        self.pretendantLabel.textAlignment = NSTextAlignmentCenter;
        self.pretendantLabel.text = @"0";
        [self.pretendantView addSubview:self.pretendantLabel];


        
        
        self.btnComment = [[UIButton alloc]initWithFrame:CGRectMake(14,24, 50, 50)];
        [self.btnComment setBackgroundImage:[UIImage imageNamed:@"btnComment"] forState:UIControlStateNormal];
        [self.btnComment addTarget:self action:@selector(openComment) forControlEvents:UIControlEventTouchUpInside];
        self.btnComment.hidden = YES;
        [self.container addSubview:self.btnComment];
        
        self.btnExit = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-50-14,24, 50, 50)];
        [self.container addSubview:self.btnExit];
        [self.btnExit setBackgroundImage:[UIImage imageNamed:@"btnCancel"] forState:UIControlStateNormal] ;
        [self.btnExit addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];


        
        self.pastille =[[UIImageView alloc]initWithFrame:CGRectMake(self.btnComment.frame.origin.x+45-7, self.btnComment.frame.origin.y+25-7, 14, 14)];
        self.pastille.layer.cornerRadius = 7;
        self.pastille.layer.masksToBounds = YES;
        self.pastille.hidden = YES;
        self.pastille.backgroundColor =[UIColor redBuzzy];
        [self.container addSubview:self.pastille];

        
        
//        self.btnTrash = [[UIButton alloc]initWithFrame:CGRectMake(14,24, 50, 50)];
//        [self.btnTrash setBackgroundImage:[UIImage imageNamed:@"btnTrash"] forState:UIControlStateNormal];
//        [self.btnTrash addTarget:self action:@selector(deleteBuzz) forControlEvents:UIControlEventTouchUpInside];
//        self.btnTrash.hidden = YES;
//        [self.container addSubview:self.btnTrash];
//        
        self.tutoView = [[TutorielView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        self.tutoView.hidden = YES;
        [self.tutoView.nextButton addTarget:self action:@selector(nextTuto) forControlEvents:UIControlEventTouchUpInside];
        [self.container addSubview:self.tutoView];

        
        
        self.kingNew =[[NewKing alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        [self.container addSubview:self.kingNew];
        
        
        
        //    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto16"]) {
        
        
        //    }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(becomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];

    }
    return self;
}


-(void)updateAudio{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    AVAudioSession *session1 = [AVAudioSession sharedInstance];
    [session1 setCategory:AVAudioSessionCategoryAmbient error:nil];
    [session1 setActive:TRUE error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
    });

}
-(void)becomeActive{
    
    if (self.dead == true) {
        
        [self.videoPlayer setMuted:YES];
    }
    if (self.modeVideo == YES && self.hidden == NO && self.dead != true) {
        [self updateAudio];
        [self.videoPlayer playFromCurrentTime];

    }
}

-(void)nextTuto{
    
    
    if (self.tutoView.currentStep == 6) {
        
        self.blockDraggable = NO;
        [self actionLikeButton];

    }
    
    if (self.tutoView.currentStep == 7) {
        
        [self openSwordFromKing];
        self.blockDraggable = NO;
    }

    
    
}


-(void)openMyLikes{
    
    [self.delegate buzzOpenLikes:self.currentBuzz];

}
-(void)openInstaProfile{
    
    
    NSLog(@"open profil!!");
    
    PFUser *user = self.currentBuzz[kBuzzUser];
    
    if ([user.objectId isEqualToString:[PFUser currentUser].objectId] && self.currentBuzz[kBuzzLike]) {
        
        
        
        return;
    }
    
    
    if (self.openInsta == false) {
        
        CABasicAnimation *animation =
        [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setDuration:0.05];
        [animation setRepeatCount:2];
        [animation setAutoreverses:YES];
        [animation setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake([self.bottomView center].x - 8.0f, [self.bottomView center].y)]];
        [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake([self.bottomView center].x + 8.0f, [self.bottomView center].y)]];
        [[self.bottomView layer] addAnimation:animation forKey:@"position"];
        
        return;
    }
    
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@",self.currentBuzz[kBuzzUser][kUserInstaUsername]]];
    NSLog(@"urll %@",self.currentBuzz[kBuzzUser]);
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
  
    }else{
        
        
    }
    
    
}


-(void)actionButtonKing{
    
    if (self.delegate) {
        
        [self.delegate buzzOpenKing:self.currentBuzz];
    }
}
-(void)openComment{
    
 
    self.pastille.hidden = YES;
    
    
    PFUser *user = self.currentBuzz[kBuzzUser];
    
    
    if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@([self.currentBuzz[kBuzzMessageNumber]integerValue]) forKey:[NSString stringWithFormat:@"nbMess-%@",self.currentBuzz.objectId]];
        
    }
    
    if (self.delegate) {
        

        
        [self.delegate buzzOpenComment:self.currentBuzz];
    }
    
    
}

-(void)openSwordFromKing{
    
    
    if (self.delegate) {
        NSLog(@"open swoprd");
        
        if ([self.pretendantLabel.text isEqualToString:@"0"]) {
            
            [Utils buzzAnimation:self.btnSword];

        }else{
            
            [Utils runSpinAnimationOnView:self.btnSword duration:0.5 rotations:1 repeat:NO];

        }

        [self.delegate buzzOpenPretendant:self.currentBuzz];
    }
    
    
}

-(void)actionViewBuzz{
    
    
    NSMutableArray *view = [[NSMutableArray alloc]init];
    
    if ([self.currentBuzz objectForKey:kBuzzView]) {
        
        view = [[NSMutableArray alloc]initWithArray:[self.currentBuzz objectForKey:kBuzzView]];
        
    }
    
    PFUser *user = [self.currentBuzz objectForKey:kBuzzUser];
    
    
    
    if ([view containsObject:[PFUser currentUser].objectId] ||  [user.objectId isEqual:[PFUser currentUser].objectId]) {
        
        return;
        
    }else{
        
        [PFCloud callFunctionInBackground:@"viewBuzz" withParameters:@{@"buzzId":self.currentBuzz.objectId,@"userId":[PFUser currentUser].objectId} block:^(PFObject *city, NSError * _Nullable error){
            
           
            
        }];
        
        
    }
    
    
}


-(void)actionDisLikeButton{
    
    if ([self.currentBuzz[@"tutoriel"] isEqual:@YES]) {
        
    
        
        return;
    }
    
    
    
    //// ENVOYER UN LIKE TO CLOUD CODE
    [PFCloud callFunctionInBackground:@"dislikeBuzz" withParameters:@{@"buzzId":self.currentBuzz.objectId,@"userId":[PFUser currentUser].objectId} block:^(PFObject *buzz, NSError * _Nullable error){
        
    
    }];
    
}
-(void)actionLikeButton{
    
    
    if ([self.currentBuzz[@"tutoriel"] isEqual:@YES]) {
        
        
        NSLog(@"Yolo1");
        
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:self.currentBuzz.objectId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"Yolo2");
        
        [self performSelector:@selector(animateHeart) withObject:self afterDelay:0.2];
        
        return;
    }

    
    if (self.likeButton.liked == NO) {
        
        self.detail1.font = [UIFont HelveticaNeue:18];
        self.detail1.text = [[self.currentBuzz objectForKey:kBuzzUser] objectForKey:kUserFirstName];
        self.likeButton.tintColor = self.likedColor;
        self.likeButton.liked = YES;
        
        self.openInsta = true;
        
        
        NSMutableArray *likes = [[NSMutableArray alloc]init];
        
        if ([self.currentBuzz objectForKey:kBuzzLike]) {
            
            likes = [self.currentBuzz objectForKey:kBuzzLike];
            
        }
        
        
        self.likeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)likes.count+1];
        self.likeLabel.hidden = NO;
        
        
        
        
        //// ENVOYER UN LIKE TO CLOUD CODE
        [PFCloud callFunctionInBackground:@"likeBuzz" withParameters:@{@"buzzId":self.currentBuzz.objectId,@"userId":[PFUser currentUser].objectId} block:^(PFObject *buzz, NSError * _Nullable error){
            
            
            NSLog(@"Done Liked %@",buzz);
            
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshAllNewKing];

           
            if (error) {
                
                NSLog(@"errro %@",error);
                
            }else{
                
                
                
                if (buzz != NULL) {
                    
                    
                    self.currentBuzz = buzz;
                    
                    [self.timer invalidate];
                    self.timerView.hidden = YES;
                    self.timeFrame.hidden = YES;
                    self.timeFrameBackground.hidden = YES;
                    
                    
                    self.detail1.text = [[buzz objectForKey:kBuzzUser] objectForKey:kUserFirstName];
                    self.detail1.font = [UIFont HelveticaNeue:18];
                    
                    self.likeLabel.hidden=NO;
                    
                    
                    self.btnSword.hidden = NO;
                    self.pretendantView.hidden = NO;
                    [self updatePretendantsNumber];

                    self.btnComment.hidden = NO;
                    self.btnKing.hidden = NO;

                    self.likedColor = [UIColor yellowLikedBuzzy];
                    self.likeButton.tintColor = self.likedColor;
                    self.bottomView.backgroundColor = [UIColor yellowBuzzy];
                    
                    self.heart2.tintColor=[UIColor yellowLikedBuzzy];
                    self.heart1.tintColor=[UIColor yellowLikedBuzzy];
                    self.timeFrame.backgroundColor = [UIColor yellowBuzzy];
                    self.timerView.backgroundColor = [UIColor yellowBuzzy];
                    
//                    self.kingNew.hidden = NO;
//                    
//                    [self.kingNew showWithBuzz:self.currentBuzz andType:<#(NSString *)#>];
                    
                    
                }
                
            }
            
            
            
            
            
        }];
        
        
        self.timeFrame.hidden = YES;
        self.timeFrameBackground.hidden = YES;
        self.timerView.hidden =YES;
        [self.timer invalidate];
        
        
    }
    
    [self performSelector:@selector(animateHeart) withObject:self afterDelay:0.2];
    
    
    if (self.pretendant == TRUE || (![self.currentBuzz[kBuzzKingCountry] isEqual:@YES] && ![self.currentBuzz[kBuzzKingCity] isEqual:@YES] && ![self.currentBuzz[kBuzzKingUniversity] isEqual:@YES] && ![self.currentBuzz[@"fakeKing"] isEqual:@YES])) {

        
        [self.delegate likeAction];

    }
    
}

-(void)updatePretendantsNumber{
    
    self.pretendantLabel.text = [NSString stringWithFormat:@"%d",0];

    NSLog(@"XXX");
    if (self.currentBuzz[@"tutoriel"]) {

        self.pretendantLabel.text = [NSString stringWithFormat:@"%d",3];
        NSLog(@"GOOO");

        return;
    }
    
    if ([self.currentBuzz[kBuzzKingCountry] isEqual:@YES]) {
        
        
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
        
        
        [query whereKey:kBuzzCountry equalTo:self.currentBuzz[kBuzzCountry]];
        [query whereKey:@"objectId" notEqualTo:self.currentBuzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];
        
        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
      
        [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
            //
            //            if (self.swipeView.visibleCardsCount > 0) {
            //
            //                DraggableCardView *card = self.swipeView.visibleCardsViewArray[0];
            //                [card.contentView.btnSword.layer removeAllAnimations];
            //            }
            //
            
            
            
            if (!error) {
                
                self.pretendantLabel.text = [NSString stringWithFormat:@"%d",number];
            }else{
                
                self.pretendantLabel.text = [NSString stringWithFormat:@"%d",0];

            }
            
            
            
        }];
        
        
    }else if([self.currentBuzz[kBuzzKingCity] isEqual:@YES]){
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
        //
        //        PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
        //        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
        //
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        
        
        [query whereKey:kBuzzCity equalTo:self.currentBuzz[kBuzzCity]];
        [query whereKey:@"objectId" notEqualTo:self.currentBuzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];
        
        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {

            
            if (!error) {
                
                self.pretendantLabel.text = [NSString stringWithFormat:@"%d",number];
            }else{
                
                self.pretendantLabel.text = [NSString stringWithFormat:@"%d",0];
                
            }
            
            
            
            
            
        }];
        
        
        
        
    }else if([self.currentBuzz[kBuzzKingUniversity] isEqual:@YES]){
        
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
        //
        //        PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
        //        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
        
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        
        //        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
        
        [query whereKey:kBuzzUniversity equalTo:self.currentBuzz[kBuzzUniversity]];
        [query whereKey:@"objectId" notEqualTo:self.currentBuzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];
        
        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {

            
            
            if (!error) {
                
                self.pretendantLabel.text = [NSString stringWithFormat:@"%d",number];
            }else{
                
                self.pretendantLabel.text = [NSString stringWithFormat:@"%d",0];
                
            }
            
            
            
            
        }];
        
    }
        
}


-(void)launchBuzz:(PFObject *)buzz pretendantType:(BOOL)pretendant fromLiked:(BOOL)fromliked{

    
    
    if (fromliked == true) {
        
        self.btnSword.alpha = 0;
        self.flag.alpha = 0;
        self.pretendantView.alpha = 0;

    }
    self.timerView.hidden = YES;
    self.timeFrame.hidden = YES;
    self.timeFrameBackground.hidden = YES;
    
    self.likeImage.hidden =NO;

    self.image.image = nil;
    self.profilePicture.image = nil;
    self.descriptionLabel.text=@"";
    self.detail2.text=@"";
    self.detail1.text=@"";
    self.likeLabel.text=@"";
    
    self.likeButton.liked = NO;
    self.likeLabel.hidden=YES;
    
    self.statsView.hidden = YES;
    
    self.kingNew.hidden = YES;
    
    self.pretendantView.hidden = YES;

    self.btnSword.hidden = YES;
    self.btnComment.hidden = YES;
    self.btnKing.hidden = YES;

    self.btnTrash.hidden = YES;

    
    self.currentBuzz = buzz;

    self.loading.hidden = YES;

    self.openInsta = FALSE;

    self.openMyLike.hidden = YES;

    self.image.file = self.currentBuzz[kBuzzPhoto];
    
    [self.image loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        
        
        self.image.image = image;
    }];
    
  
    self.image.hidden = NO;
    
    self.filterImage.hidden = NO;
    
    self.loading.hidden = YES;

    if (self.currentBuzz[kBuzzVideo]) {
       
        self.filterImage.hidden = YES;

        
        self.modeVideo = YES;
        
         self.loading.hidden = NO;

        
        
        PFFile *video = self.currentBuzz[kBuzzVideo];
        
        if ([video isDataAvailable]) {
            
        }else{
            
            [video getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                
                
                
                
                
                
            }];

        }
       
        
    }

    
    self.currentBuzzDuration = [self.currentBuzz[kBuzzDuration] intValue];
    self.timerLabel.text  = [NSString stringWithFormat:@"%@",[self.romains objectAtIndex:self.currentBuzzDuration]];

    
    self.pretendant = pretendant;
    
    
    
    NSLog(@"laucnn pretendant type : %d",pretendant);

    
    if (pretendant != YES) {
        
        self.blockSwipe = YES;
        
        self.videoPlayer.playbackLoops = YES;

    }else{
        
        self.videoPlayer.playbackLoops = NO;

        NSLog(@"So gooo");
        
        self.likeButton.hidden = YES;
        self.likeLabel.hidden = YES;

        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto8"] && self.currentBuzz[@"tutoriel"]) {
        
        
             self.tutoView.frame = CGRectMake(-10, -10, largeurIphone+20, hauteurIphone+20);

        
            [self.tutoView setStep:8];
            self.currentBuzzDuration = 60;
            
            
            
        }
        

    }
    
    self.pastille.hidden = YES;

    
    

    
    
    PFUser *user = [self.currentBuzz objectForKey:kBuzzUser];
    
    if ([self.currentBuzz[kBuzzKingCountry] isEqual:@YES]) {
        
        self.flag.hidden = NO;
        
        
        self.flag.text= self.currentBuzz[kBuzzCountry][kCountryIcon];

        
//        if ([[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryFlag]) {
//
////            self.flag.file = [[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryFlag];
////            [self.flag loadInBackground];
//
//        }
        
    }else{
        self.flag.hidden = YES;

        
        if ([self.currentBuzz[@"fakeKing"] isEqual:@YES]) {
            
            self.flag.hidden = NO;
            
            
            self.flag.text= self.currentBuzz[@"fakeCountry"][kCountryIcon];
            

        }
        
    }
    
    
    
    if ( [user.objectId isEqual:[PFUser currentUser].objectId]) {
        
        
        if(IS_IPHONEX){
            
            self.openProfileInsta.frame = CGRectMake(0, hauteurIphone-67-20,100, self.profilePicture.frame.size.height);

        }else{
            self.openProfileInsta.frame = CGRectMake(0, hauteurIphone-67,100, self.profilePicture.frame.size.height);

        }
        
        
        
    }
    

    
    if ([[self.currentBuzz objectForKey:kBuzzKingUniversity] isEqual:@YES] && [[self.currentBuzz objectForKey:kBuzzKingCity] isEqual:@YES] && [[self.currentBuzz objectForKey:kBuzzKingCountry] isEqual:@YES]){
        
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:[NSString stringWithFormat:@"seeKing-%@",self.currentBuzz.objectId]];

    }

    


    if (self.pretendant == NO) {
        
        NSLog(@"current buzz %@",self.currentBuzz);
        
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto5"]) {
            
            self.kingNew.hidden = NO;
            
            [self.kingNew showWithBuzz:self.currentBuzz  andType:@"Country"];
            
            [self.tutoView setStep:5];
            

            
        }else{
            
            if ([[self.currentBuzz objectForKey:kBuzzKingUniversity] isEqual:@YES] &&
                ![[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"KingUniversity%@-%d",self.currentBuzz.objectId,[self.currentBuzz[kBuzzKingNumber] intValue] ]] && [[self.currentBuzz objectForKey:@"type"] isEqualToString:@"University"]) {
                
                self.kingNew.hidden = NO;
                
                [self.kingNew showWithBuzz:self.currentBuzz andType:@"University"];
                
                
                
            }
            
            if ([[self.currentBuzz objectForKey:kBuzzKingCity] isEqual:@YES] && ![[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"KingCity%@-%d",self.currentBuzz.objectId,[self.currentBuzz[kBuzzKingNumber] intValue] ]] && [[self.currentBuzz objectForKey:@"type"] isEqualToString:@"City"]) {
                self.kingNew.hidden = NO;
                
                [self.kingNew showWithBuzz:self.currentBuzz  andType:@"City"];
                
                
            }
            
            if ([[self.currentBuzz objectForKey:kBuzzKingCountry] isEqual:@YES] && ![[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"KingCountry%@-%d",self.currentBuzz.objectId,[self.currentBuzz[kBuzzKingNumber] intValue] ]] && [[self.currentBuzz objectForKey:@"type"] isEqualToString:@"Country"]) {
                
                
                self.kingNew.hidden = NO;
                
                [self.kingNew showWithBuzz:self.currentBuzz  andType:@"Country"];
                
                
            }
            

        }
    
    
    
    }
    

    
    
    
    
    if ( [user.objectId isEqual:[PFUser currentUser].objectId]) {
        
        
        self.likeImage.hidden =YES;
        self.dislikeImage.hidden =YES;

        
        self.openMyLike.hidden = NO;

        self.likedColor = [UIColor redLikedBuzzy];
        self.bottomView.backgroundColor = [UIColor redBuzzy];
        self.heart2.tintColor=[UIColor redBuzzy];
        self.heart1.tintColor=[UIColor redBuzzy];
        self.timeFrame.backgroundColor = [UIColor redBuzzy];
        self.timerView.backgroundColor = [UIColor redBuzzy];
        
        self.statsView.hidden = NO;
        
        self.btnTrash.hidden = NO;

        
        
        if ([self.currentBuzz objectForKey:kBuzzLike]) {
            
            NSArray *likes = [self.currentBuzz objectForKey:kBuzzLike];
            self.statsLikeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)likes.count];
            
        }else{
            
            self.statsLikeLabel.text = [NSString stringWithFormat:@"%d",0];
            
        }
        
        if ([self.currentBuzz objectForKey:kBuzzScreenShot]) {
            
            NSArray *screenShot = [self.currentBuzz objectForKey:kBuzzScreenShot];
            self.statsScreenLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)screenShot.count];
            
        }else{
            
            self.statsScreenLabel.text = [NSString stringWithFormat:@"%d",0];
            
        }
        
        
        if ([self.currentBuzz objectForKey:kBuzzView]) {
            
            NSArray *view = [self.currentBuzz objectForKey:kBuzzView];
            self.statsViewLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)view.count];
            
        }else{
            
            self.statsViewLabel.text = [NSString stringWithFormat:@"%d",0];
            
        }
        
        
    }
    
    
    
    if (([[self.currentBuzz objectForKey:kBuzzKingCity] isEqual:@YES] || [self.currentBuzz[kBuzzKingUniversity] isEqual:@YES] || [self.currentBuzz[kBuzzKingCountry] isEqual:@YES] || [self.currentBuzz[@"fakeKing"] isEqual:@YES] ) && self.pretendant == false ){
        
        
        
        if ( [user.objectId isEqual:[PFUser currentUser].objectId]) {

        
            if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"nbMess-%@",self.currentBuzz.objectId]]) {
                
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"nbMess-%@",self.currentBuzz.objectId]]integerValue] != [self.currentBuzz[kBuzzMessageNumber]integerValue]) {
                    
                    
                    self.pastille.hidden = NO;
                    
                }
                
            }else{
                
                ////
                
                if ([self.currentBuzz[kBuzzMessageNumber]integerValue] > 0) {
                    
                    self.pastille.hidden = NO;

                }
                
                
            }

            
        }
        
        
        self.openInsta = TRUE;

        
        self.likedColor = [UIColor yellowLikedBuzzy];
        self.bottomView.backgroundColor = [UIColor yellowBuzzy];
        
        self.heart2.tintColor=[UIColor yellowLikedBuzzy];
        self.heart1.tintColor=[UIColor yellowLikedBuzzy];
        self.timeFrame.backgroundColor = [UIColor yellowBuzzy];
        self.timerView.backgroundColor = [UIColor yellowBuzzy];
        
    }else if ([[[Following sharedInstance]following] containsObject:self.currentBuzz[kBuzzInstaUsername]]){
    
        
        self.likedColor = [UIColor redLikedBuzzy];
        self.bottomView.backgroundColor = [UIColor redBuzzy];
        
        self.heart2.tintColor=[UIColor redLikedBuzzy];
        self.heart1.tintColor=[UIColor redLikedBuzzy];
        self.timeFrame.backgroundColor = [UIColor redBuzzy];
        self.timerView.backgroundColor = [UIColor redBuzzy];
        

        
    }else{
        
        self.likedColor = [UIColor orangeLikedBuzzy];
        self.bottomView.backgroundColor = [UIColor orangeBuzzy];
        
        self.heart2.tintColor=[UIColor orangeLikedBuzzy];
        self.heart1.tintColor=[UIColor orangeLikedBuzzy];
        self.timeFrame.backgroundColor = [UIColor orangeBuzzy];
        self.timerView.backgroundColor = [UIColor orangeBuzzy];
        
    }
    
    
    
    
    
    
    
    
    self.profilePicture.file = [[self.currentBuzz objectForKey:kBuzzUser] objectForKey:kUserProfilePicture];
    [self.profilePicture loadInBackground];
    
    self.descriptionLabel.text = [self.currentBuzz objectForKey:kBuzzDescription];
    [self.descriptionLabel sizeToFit];
    
    
    if(IS_IPHONEX){
        
        self.descriptionLabel.frame = CGRectMake(30, hauteurIphone-67-20-10-self.descriptionLabel.frame.size.height, largeurIphone-60, self.descriptionLabel.frame.size.height);

    }else{
        self.descriptionLabel.frame = CGRectMake(30, hauteurIphone-67-10-self.descriptionLabel.frame.size.height, largeurIphone-60, self.descriptionLabel.frame.size.height);

    }
    
    
    
    if (![user.objectId isEqual:[PFUser currentUser].objectId]) {
        
        
        
        self.detail2.text = [NSString stringWithFormat:@"%@ - %@",[self getLocalTime:[self.currentBuzz objectForKey:kBuzzWhen]],[self getDistance:[self.currentBuzz objectForKey:kBuzzLocation]]];
        
        
        self.detail1.hidden = NO;
        self.detail2.hidden = NO;
        self.likeLabel.hidden = NO;
        
        if (self.pretendant == false) {
            
            self.likeButton.hidden = NO;

        }
        
        
    }else{
        
        self.openInsta = true;

        self.heart1.hidden = YES;
        self.heart2.hidden = YES;
        self.detail1.hidden = YES;
        self.detail2.hidden = YES;
        self.likeLabel.hidden = YES;
        self.likeButton.hidden = YES;
        
    }
    
    [self getNameOrAdress:self.currentBuzz];
    
    
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}



-(void)deleteBuzz{
    
    MMPopupItemHandler blockNO = ^(NSInteger index){
        
        
    };
    
    
    
    MMPopupItemHandler blockYES = ^(NSInteger index){
        
        
        appPlayLoading;
        
        self.currentBuzz[kBuzzDeleted] = @YES;
        [self.currentBuzz saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            [self hide];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshAllNewKing];
            
            if ([self.currentBuzz[kBuzzKingCountry] isEqual:@YES] || [self.currentBuzz[kBuzzKingCity] isEqual:@YES] || [self.currentBuzz[kBuzzKingUniversity] isEqual:@YES]) {
                
                [PFCloud callFunctionInBackground:@"loopKing" withParameters:@{} block:^(id  _Nullable result, NSError * _Nullable error){
                    
                  
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshAllNewKing];

                    
                }];

            
            
            }
            appStopLoading;
            
        }];
        
    };
    
    
    NSArray *items = @[MMItemMake(NSLocalizedString(@"NO", nil), MMItemTypeNormal, blockNO),MMItemMake(NSLocalizedString(@"YES", nil), MMItemTypeNormal, blockYES)];
    
    NSString *message = NSLocalizedString(@"Are you sure you want to delete this BUZZ?",nil);
    
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:NSLocalizedString(@"Delete", nil) detail:message items:items];
    alertView.attachedView = self;
    alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
    alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
    [alertView show];
    
    
    
}


-(void)launchTimer{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"fakeLikedTuto"] && self.currentBuzz[@"tutoriel"]) {
        
        [self.timer invalidate];
        self.timerView.hidden = YES;
        self.timeFrame.hidden = YES;
        self.timeFrameBackground.hidden = YES;
        return;
        
    }
    
    
    
    if (self.currentBuzz[kBuzzVideo]) {
        
        self.filterImage.hidden = YES;
        
        
        self.modeVideo = YES;
        
        self.loading.hidden = NO;
        
        
        
        PFFile *video = self.currentBuzz[kBuzzVideo];
        
        if ([video isDataAvailable]) {
            
            NSData *data = [video getData];
            
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:@"story.mp4"];
            
            [data writeToFile:path atomically:YES];
            NSURL *moveUrl = [NSURL fileURLWithPath:path];
            
            
            //            self.videoPlayer.asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:video.url] options:nil];
            [self updateAudio];

            self.videoPlayer.asset = [[AVURLAsset alloc] initWithURL:moveUrl options:nil];
            [self.videoPlayer playFromBeginning];
            
            
            [self performSelector:@selector(hideImage) withObject:self afterDelay:0.2];
            
            
            
            [self.loading hide];
            
            
            
            
        }else{
            
            [video getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                
                
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *path = [documentsDirectory stringByAppendingPathComponent:@"story.mp4"];
                
                [data writeToFile:path atomically:YES];
                NSURL *moveUrl = [NSURL fileURLWithPath:path];
                
                
                //            self.videoPlayer.asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:video.url] options:nil];
                
                [self updateAudio];

                self.videoPlayer.asset = [[AVURLAsset alloc] initWithURL:moveUrl options:nil];
                [self.videoPlayer playFromBeginning];
                
                
                [self performSelector:@selector(hideImage) withObject:self afterDelay:0.2];
                
                
                
                [self.loading hide];
                
                
                
            }];
            
        }
        
        
    }


    
    [self actionViewBuzz];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    

    
    
    self.timeFrame.frame = CGRectMake(0, 0, largeurIphone , 8);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerBuzz) userInfo:nil repeats:YES];

    BOOL liked = false;
    
    
    if ([self.currentBuzz objectForKey:kBuzzLike]) {
        
        if ([[self.currentBuzz objectForKey:kBuzzLike] containsObject:[PFUser currentUser].objectId]) {
            
            
            liked = true;
            
            
        }
        
    }
    PFUser *user = [self.currentBuzz objectForKey:kBuzzUser];


    if ( (self.pretendant == false && ([user.objectId isEqual:[PFUser currentUser].objectId] || [[self.currentBuzz objectForKey:kBuzzKingCity] isEqual:@YES] || [self.currentBuzz[kBuzzKingUniversity] isEqual:@YES] || [self.currentBuzz[kBuzzKingCountry] isEqual:@YES] || [self.currentBuzz[@"fakeKing"] isEqual:@YES]) )|| liked == true || self.modeVideo == YES) {
        
      
        [self.timer invalidate];
        self.timerView.hidden = YES;
        self.timeFrame.hidden = YES;
        self.timeFrameBackground.hidden = YES;
    }else{
        
        self.timerView.hidden = NO;
        self.timeFrame.hidden = NO;
        self.timeFrameBackground.hidden = NO;
        
        
        
          if (![[NSUserDefaults standardUserDefaults]objectForKey:@"swipeTutoDone1"]) {
        
              [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"swipeTutoDone1"];

              self.timerView.hidden = YES;
              self.timeFrame.hidden = YES;
              [self.timer invalidate];
              self.timeFrameBackground.hidden = NO;

              self.viewTutoSwipe.alpha = 0;
              self.viewTutoSwipe.hidden = NO;
              [UIView animateWithDuration:0.5 animations:^{
                  
                  
                  self.viewTutoSwipe.alpha = 1;
                  
              } completion:^(BOOL finished) {
                  
                  
                  
                  
              }];
        
         }
      

    }
    

    
    

    
}
-(void)userDidTakeScreenshot{
    
    
    NSMutableArray *screenShot = [[NSMutableArray alloc]init];
    
    if ([self.currentBuzz objectForKey:kBuzzScreenShot]) {
        
        screenShot = [[NSMutableArray alloc]initWithArray:[self.currentBuzz objectForKey:kBuzzScreenShot]];
        
    }
    
    PFUser *user = [self.currentBuzz objectForKey:kBuzzUser];
    
    
    
    if ([screenShot containsObject:[PFUser currentUser].objectId] ||  [user.objectId isEqual:[PFUser currentUser].objectId]) {
        
        return;
        
    }else{
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        if (self.hidden == NO && self.currentBuzz) {
            
            //// ENVOYER UN LIKE TO CLOUD CODE
            [PFCloud callFunctionInBackground:@"screenShotBuzz" withParameters:@{@"buzzId":self.currentBuzz.objectId,@"userId":[PFUser currentUser].objectId} block:^(PFObject *city, NSError * _Nullable error){
                
                
                
            }];
            
        }
        
    }
    
    
}

-(void)timerBuzz{
    
    
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(4.f, 4.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 16.0f;
    scaleAnimation.springSpeed = 8;
    
    [self.timerView.layer pop_addAnimation:scaleAnimation forKey:@"likeAction"];
    
    
    self.currentBuzzDuration = self.currentBuzzDuration - 1;
 
    self.viewTutoSwipe.hidden = YES;

    if (self.currentBuzzDuration == 0) {
        
        [self.timer invalidate];

//        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"swipeTutoDone"]) {
//
//
//            if (self.delegate) {
//
//                [self.delegate ignoreAction];
//
//            }
//
//
//        }else{
        
        self.timerView.hidden = YES;
        self.timeFrame.hidden = YES;
        
//            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"swipeTutoDone"];
        
            self.viewTutoSwipe.alpha = 0;
            self.viewTutoSwipe.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                
                
                self.viewTutoSwipe.alpha = 1;

            } completion:^(BOOL finished) {
                
                
                
                
            }];
            

//        }
//
        
    }else{
        
        if (self.currentBuzzDuration> 9) {
            
            self.timerLabel.text  = [NSString stringWithFormat:@"%d",self.currentBuzzDuration];
            
            self.timeFrame.frame = CGRectMake(0, 0, self.frame.size.width * ((float)self.currentBuzzDuration/ 60), 8);

        }else{
            
            self.timerLabel.text  = [NSString stringWithFormat:@"%@",[self.romains objectAtIndex:self.currentBuzzDuration]];
            
            self.timeFrame.frame = CGRectMake(0, 0, self.frame.size.width * ((float)self.currentBuzzDuration/ [self.currentBuzz[kBuzzDuration] floatValue]), 8);

        }
        
        
    }
    
}


-(void)getNameOrAdress:(PFObject *)buzz{
    
    if ([buzz objectForKey:kBuzzLike]) {
        
        
        NSArray *likes = [buzz objectForKey:kBuzzLike];
        self.likeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)likes.count];
        
        
        
        if ([[buzz objectForKey:kBuzzLike] containsObject:[PFUser currentUser].objectId] || ([[NSUserDefaults standardUserDefaults]objectForKey:@"fakeLikedTuto"] && buzz[@"tutoriel"])) {
            
            
            
            
            self.openInsta = true;

            self.detail1.text = [[buzz objectForKey:kBuzzUser] objectForKey:kUserFirstName];
            self.detail1.font = [UIFont HelveticaNeue:18];
            self.likeButton.tintColor = self.likedColor;
            self.likeButton.liked = YES;
            self.likeLabel.hidden=NO;
            
            
            self.likeImage.hidden =YES;
            self.dislikeImage.hidden =YES;

        }else{
            
            
            
            if ([Utils languageFr]) {
                
                
                if ([self.currentBuzz objectForKey:kBuzzUniversity]) {
                    
                    self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzUniversity] objectForKey:kUniversityNameFr]];
                    
                }else if ([self.currentBuzz objectForKey:kBuzzCity]){
                    
                    self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzCity] objectForKey:kCityNameFr]];
                    
                }else if ([self.currentBuzz objectForKey:kBuzzCountry]){
                    
                    self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryNameFr]];
                    
                }
                
                
            }else{
                
                
                
                
                if ([self.currentBuzz objectForKey:kBuzzUniversity]) {
                    
                    self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzUniversity] objectForKey:kUniversityName]];
                    
                }else if ([self.currentBuzz objectForKey:kBuzzCity]){
                    
                    self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzCity] objectForKey:kCityName]];
                    
                }else if ([self.currentBuzz objectForKey:kBuzzCountry]){
                    
                    self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryName]];
                    
                }
                
                
            }
            

            self.detail1.font = [UIFont HelveticaNeue:15];
            
            self.likeButton.tintColor = [UIColor whiteColor];
            self.likeButton.liked = NO;
            self.likeLabel.hidden=YES;
            
            
        }
        
        
        
    }else{
        
        
        if ([Utils languageFr]) {
            
            
            if ([self.currentBuzz objectForKey:kBuzzUniversity]) {
                
                self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzUniversity] objectForKey:kUniversityNameFr]];
                
            }else if ([self.currentBuzz objectForKey:kBuzzCity]){
                
                self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzCity] objectForKey:kCityNameFr]];
                
            }else if ([self.currentBuzz objectForKey:kBuzzCountry]){
                
                self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryNameFr]];
                
            }
            
            
        }else{
            
            
            
            
            if ([self.currentBuzz objectForKey:kBuzzUniversity]) {
                
                self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzUniversity] objectForKey:kUniversityName]];
                
            }else if ([self.currentBuzz objectForKey:kBuzzCity]){
                
                self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzCity] objectForKey:kCityName]];
                
            }else if ([self.currentBuzz objectForKey:kBuzzCountry]){
                
                self.detail1.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[self.currentBuzz objectForKey:kBuzzCountry] objectForKey:kCountryName]];
                
            }
            
            
        }
        
        
        self.likeButton.tintColor = [UIColor whiteColor];
        self.detail1.font = [UIFont HelveticaNeue:15];
        
        self.likeButton.liked = NO;
        self.likeLabel.hidden=YES;
        
        
    }
    
    
    
    if (([[self.currentBuzz objectForKey:kBuzzKingCity] isEqual:@YES] || [self.currentBuzz[kBuzzKingUniversity] isEqual:@YES] || [self.currentBuzz[kBuzzKingCountry] isEqual:@YES] || [self.currentBuzz[@"fakeKing"] isEqual:@YES] ) && self.pretendant == false){
        
        
        self.openInsta = true;

        
        [self.timer invalidate];
        self.timerView.hidden = YES;
        self.timeFrame.hidden = YES;
        self.timeFrameBackground.hidden = YES;
        
        
        self.detail1.text = [[buzz objectForKey:kBuzzUser] objectForKey:kUserFirstName];
        self.detail1.font = [UIFont HelveticaNeue:18];
        
        self.likeLabel.hidden=NO;
        
        
        self.btnSword.hidden = NO;
        self.btnComment.hidden = NO;
        self.pretendantView.hidden = NO;
        [self updatePretendantsNumber];

        if (self.delegate) {
            
            [self.delegate preloadPretenders:self.currentBuzz];

        }
        
        
        if ([[self.currentBuzz objectForKey:kBuzzKingCity] isEqual:@YES] || [self.currentBuzz[kBuzzKingCountry] isEqual:@YES]) {
            
            self.btnKing.hidden = NO;

        }
    }
    
    
    
}


-(NSString *)getLocalTime:(NSDate*)sourceDate{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    return [formatter stringFromDate:sourceDate];
}

-(NSString *)getDistance:(PFGeoPoint *)buzzLocation{
    
    
    CLLocation *location1 = [[CLLocation alloc]
                             initWithLatitude:buzzLocation.latitude
                             longitude:buzzLocation.longitude];
    
    CLLocation *location2 = [[CLLocation alloc]
                             initWithLatitude:[[Position sharedInstance]currentPosition].latitude
                             longitude:[[Position sharedInstance]currentPosition].longitude];
    
    
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    
    
    return [self stringWithDistance:distance];
    
}


-(void)show{
    
    
    
    self.hidden = NO;
    self.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
    
}

-(void)hideTap{
    
    
}
-(void)hide{
    
    self.dead = YES;
    
    if (self.blockDraggable == TRUE) {
        
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];

    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    [self.videoPlayer setMuted:YES];
    self.videoPlayer.delegate = nil;
    self.videoPlayer = nil;
    
    NSLog(@"invalidate timer!");
    
    [self.timer invalidate];
    self.hidden = YES;

    if (self.delegate) {
        
        
        [self.delegate cardPassed];
    }
    
}


//// Convert
- (NSString *)stringWithDistance:(double)distance {
    
    NSString *format;
    
    if (distance < 130) {
        
        return NSLocalizedString(@"0-100m",nil);
        
    }else
        if (distance < METERS_CUTOFF) {
            format = @"%@m";
        } else {
            format = @"%@km";
            distance = distance / 1000;
        }
    
    return [NSString stringWithFormat:format, [self stringWithDouble:distance]];
}

// Return a string of the number to one decimal place and with commas & periods based on the locale.
- (NSString *)stringWithDouble:(double)value {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:0];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
}



-(void)animateHeart {
    
    self.heart1.hidden=NO;
    self.heart2.hidden=NO;
    
    
    [CATransaction begin];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.3;
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    animation.fillMode = kCAFillModeBoth;
    ///  [box addAnimation:animation forKey:@"j"]; Animation will not work if added here. Need to add this only after the completion block.
    
    
    CAKeyframeAnimation *animationY = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    animationY.duration = 2.0f;
    animationY.repeatCount = 3;
    animationY.removedOnCompletion = NO;
    animationY.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.heart1.frame.origin.y], [NSNumber numberWithFloat:self.heart1.frame.origin.y-80], nil];
    animationY.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil];
    
    
    CAKeyframeAnimation *animationO = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animationO.duration = 2.0f;
    animationO.repeatCount = 3;
    animationO.removedOnCompletion = NO;
    animationO.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:0.0f], nil];
    animationO.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.90f], nil];
    animationO.fillMode = kCAFillModeForwards;
    
    
    CAKeyframeAnimation *animationX = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    animationX.duration = 2.0f;
    animationX.repeatCount = 3;
    animationX.removedOnCompletion = NO;
    animationX.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.heart1.frame.origin.x], [NSNumber numberWithFloat:self.heart1.frame.origin.x-30], nil];
    animationX.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f],nil];
    
    CAKeyframeAnimation *animationS = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animationS.duration = 2.0f;
    animationS.timingFunctions = [NSArray arrayWithObjects:
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  nil];
    
    animationS.repeatCount = 3;
    animationS.removedOnCompletion = NO;
    animationS.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],nil];
    
    animationS.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.10f],nil];
    
    
    CAKeyframeAnimation *animationR = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animationR.duration = 2.0;
    animationR.repeatCount = 3;
    animationR.removedOnCompletion = NO;
    animationR.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-M_PI/12],[NSNumber numberWithFloat:-M_PI],nil];
    animationR.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:1.0f],nil];
    
    
    
    CAKeyframeAnimation *animationY2 = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    animationY2.duration = 3.0f;
    animationY2.repeatCount = 3;
    animationY2.removedOnCompletion = NO;
    animationY2.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.heart2.frame.origin.y], [NSNumber numberWithFloat:self.heart2.frame.origin.y-90], nil];
    animationY2.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.20f], [NSNumber numberWithFloat:1.0f], nil];
    
    
    CAKeyframeAnimation *animationO2 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animationO2.duration = 3.0f;
    animationO2.repeatCount = 3;
    animationO2.removedOnCompletion = NO;
    animationO2.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:0.0f], nil];
    animationO2.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.20f],[NSNumber numberWithFloat:0.20f], [NSNumber numberWithFloat:0.90f], nil];
    animationO2.fillMode = kCAFillModeForwards;
    
    
    CAKeyframeAnimation *animationX2 = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    animationX2.duration = 3.0f;
    animationX2.repeatCount = 3;
    animationX2.removedOnCompletion = NO;
    animationX2.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.heart2.frame.origin.x], [NSNumber numberWithFloat:self.heart2.frame.origin.x+80], nil];
    animationX2.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.20f], [NSNumber numberWithFloat:1.0f],nil];
    
    CAKeyframeAnimation *animationS2 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animationS2.duration = 3.0f;
    animationS2.repeatCount = 3;
    animationS2.removedOnCompletion = NO;
    animationS2.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],nil];
    
    animationS2.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.20f], [NSNumber numberWithFloat:0.30f],nil];
    animationS2.fillMode = kCAFillModeForwards;
    
    animationS2.timingFunctions = [NSArray arrayWithObjects:
                                   [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                   [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                   nil];
    
    
    CAKeyframeAnimation *animationR2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animationR2.duration = 3.0f;
    animationR2.repeatCount = 3;
    animationR2.fillMode = kCAFillModeForwards;
    
    animationR2.removedOnCompletion = NO;
    animationR2.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI/8],[NSNumber numberWithFloat:M_PI*2],nil];
    animationR2.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.20f],[NSNumber numberWithFloat:1.0f],nil];
    
    [CATransaction setCompletionBlock:^{
        
        
        self.heart1.hidden=YES;
        self.heart2.hidden=YES;
        
        [self.heart1.layer removeAllAnimations];
        [self.heart2.layer removeAllAnimations];
        
        
        
        
    }];
    
    
    
    [self.heart2.layer addAnimation:animationY2 forKey:nil];
    [self.heart2.layer addAnimation:animationO2 forKey:nil];
    [self.heart2.layer addAnimation:animationX2 forKey:nil];
    [self.heart2.layer addAnimation:animationS2 forKey:nil];
    [self.heart2.layer addAnimation:animationR2 forKey:nil];
    
    
    [self.heart1.layer addAnimation:animationY forKey:nil];
    [self.heart1.layer addAnimation:animationO forKey:nil];
    [self.heart1.layer addAnimation:animationX forKey:nil];
    [self.heart1.layer addAnimation:animationS forKey:nil];
    [self.heart1.layer addAnimation:animationR forKey:nil];
    
    
    [CATransaction commit];
    
    
    
}



#pragma mark - PBJVideoPlayerControllerDelegate

- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer
{
    //NSLog(@"Max duration of the video: %f", videoPlayer.maxDuration);
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
}

- (void)videoPlayerBufferringStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
    switch (videoPlayer.bufferingState) {
     case PBJVideoPlayerBufferingStateUnknown:
     NSLog(@"Buffering state unknown!");
     break;
     
     case PBJVideoPlayerBufferingStateReady:
     NSLog(@"Buffering state Ready! Video will start/ready playing now.");
     break;
     
     case PBJVideoPlayerBufferingStateDelayed:
     NSLog(@"Buffering state Delayed! Video will pause/stop playing now.");
     break;
     default:
     break;
     }
}

-(void)hideImage{
    
    self.image.hidden = YES;

}
- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer
{
    
    
    [self performSelector:@selector(hideImage) withObject:self afterDelay:0.2];
    
    //    _playButton.alpha = 1.0f;
    //    _playButton.hidden = NO;
    //
    //    [UIView animateWithDuration:0.1f animations:^{
    //        _playButton.alpha = 0.0f;
    //    } completion:^(BOOL finished) {
    //        _playButton.hidden = YES;
    //    }];
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer
{
    
    self.image.hidden = YES;
    [self.videoPlayer setMuted:YES];
    [self.videoPlayer stop];
    
    self.viewTutoSwipe.alpha = 0;
    self.viewTutoSwipe.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        
        
        self.viewTutoSwipe.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
    //    _playButton.hidden = NO;
    //
    //    [UIView animateWithDuration:0.1f animations:^{
    //        _playButton.alpha = 1.0f;
    //    } completion:^(BOOL finished) {
    //    }];
}

-(void)reportBuzz:(UILongPressGestureRecognizer *)sender{
    
    
    if (sender.state == UIGestureRecognizerStateBegan){
        
        if (self.delegate) {
            
        
            [self.delegate reportBuzz:self.currentBuzz liked:self.timerView.hidden];
        }
    }
    
}

-(void)reportBuzz{
    
    if (self.delegate) {
        
        [self.delegate reportBuzz:self.currentBuzz liked:self.timerView.hidden];
    }
}

@end
