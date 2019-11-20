//
//  ComingSoon.m
//  Buzzy
//
//  Created by Julien Levallois on 17-08-09.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "ComingSoon.h"
#import "AppDelegate.h"


@implementation ComingSoon

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        ///// 58 234
        
        
        
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
           
            self.backgroundColor = [UIColor clearColor];
            
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurEffectView.frame = self.bounds;
            blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [self addSubview:blurEffectView];
        } else {
            self.backgroundColor = [UIColor blackColor];
        }
        
        
        self.logo = [[UIImageView alloc]initWithFrame:CGRectMake(largeurIphone/2-77/2, 90, 77, 104)];
        self.logo.image = [UIImage imageNamed:@"logo"];
        self.logo.alpha = 0.05;
        [self addSubview:self.logo];
        
        self.backgroundV =[[UIView alloc]initWithFrame:CGRectMake(60, hauteurIphone/2-60+20, largeurIphone-120, 120)];
        self.backgroundV.layer.cornerRadius = 13;
        self.backgroundV.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.backgroundV];
        
        
        self.coming = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.backgroundV.frame.size.width, 120)];
        self.coming.textColor = [UIColor blackColor];
        self.coming.textAlignment = NSTextAlignmentCenter;
        self.coming.font =[UIFont HelveticaNeue:18];
        self.coming.numberOfLines =2;
        self.coming.text = NSLocalizedString(@"Buzzy is coming soon\nin your country", nil);
        

        [self.backgroundV addSubview:self.coming];

        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = 0.9;
        scaleAnimation.repeatCount = HUGE_VAL;
        scaleAnimation.autoreverses = YES;
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.8];
        
        [self.backgroundV.layer addAnimation:scaleAnimation forKey:@"scale"];
        
        
        
        self.logout =[[UIButton alloc]initWithFrame:CGRectMake(0, hauteurIphone-110, largeurIphone, 70)];
        [self.logout setTitle:NSLocalizedString(@"Log Out", nil) forState:UIControlStateNormal];
        [self.logout.titleLabel setFont:[UIFont HelveticaNeue:18]];
        [self.logout.titleLabel setTextColor:[UIColor whiteColor]];
        self.logout.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.logout.alpha = 0.7;
        [self addSubview:self.logout];
        [self.logout addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

-(void)logoutAction{
    
    
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate logout];
        
        
   
}



@end
