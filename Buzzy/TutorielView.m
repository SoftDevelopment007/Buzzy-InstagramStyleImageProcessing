//
//  TutorielView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-08-10.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "TutorielView.h"

@implementation TutorielView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        ///// 58 234
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        
        self.userInteractionEnabled = true;
        
        self.fillLayer = [CAShapeLayer layer];
        self.fillLayer.fillRule = kCAFillRuleEvenOdd;
        self.fillLayer.fillColor = [UIColor blackColor].CGColor;
        self.fillLayer.opacity = 0.8;
        [self.layer addSublayer:self.fillLayer];
        
        self.info =[[UILabel alloc]initWithFrame:CGRectMake(0, hauteurIphone/2-100, largeurIphone, 200)];
        self.info.textAlignment = NSTextAlignmentCenter;
        self.info.font = [UIFont BerkshireSwash:19];
        self.info.textColor =[UIColor whiteColor];
        self.info.numberOfLines = 10;
        [self addSubview:self.info];
        
        self.nextButton = [[UIButton alloc]init];
        [self.nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextButton];
        
      
        self.titleTuto = [[UILabel alloc]initWithFrame:CGRectMake(0,  hauteurIphone/2-90,largeurIphone, 50)];
        self.titleTuto.font = [UIFont BerkshireSwash:40];
        self.titleTuto.text = NSLocalizedString(@"Tutorial", nil);
        self.titleTuto.textAlignment = NSTextAlignmentCenter;
        self.titleTuto.textColor = [UIColor whiteColor];
        self.titleTuto.hidden = YES;
        [self addSubview:self.titleTuto];
        
        
        
    }
    return self;
}

-(void)next{
    
    
    [self setStep:self.currentStep+1];
    
}

-(void)maskFrame:(CGRect)frame andRadius:(CGFloat)radius{
    
    self.path = [UIBezierPath bezierPathWithRoundedRect:self.frame cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius];
    [self.path appendPath:circlePath];
    [self.path setUsesEvenOddFillRule:YES];
    
    self.fillLayer.path = self.path.CGPath;

}
-(void)setStep:(int)step{
    
    self.currentStep = step;
    
    NSLog(@"oiuhygkihlodihugyjvaukihdijhuagsvjdas");
    

    if (self.hidden == YES) {
        
        
        self.alpha = 0;
        self.hidden = NO;

        [UIView animateWithDuration:0.5 animations:^{
            
            self.alpha = 1;
            
            
        } completion:^(BOOL finished) {
            
            
        }];

    }else{
        
        self.alpha = 1;
  
    }
    

    for (UIGestureRecognizer *recognizer in self.gestureRecognizers)
    {
        recognizer.enabled = NO;
        [self removeGestureRecognizer:recognizer];
    }
    
    
    self.info.font = [UIFont BerkshireSwash:22];
    self.info.frame = CGRectMake(0, hauteurIphone/2-100, largeurIphone, 200);

    self.titleTuto.hidden = YES;

    if (step == 1) {
        
        
        self.titleTuto.text = NSLocalizedString(@"Tutorial", nil);
        self.titleTuto.frame = CGRectMake(0,  hauteurIphone/2-90,largeurIphone, 50);
        self.titleTuto.font = [UIFont BerkshireSwash:40];

        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"Tuto1"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto2"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto3"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto5"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto6"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto7"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto8"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto9"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto10"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Tuto11"];

        
        if ([[PFUser currentUser][kUserGender] isEqualToString:@"male"]) {
            
            self.info.text = NSLocalizedString(@"Be ready to\nbecome a King!", nil);

        }else{
            
            self.info.text = NSLocalizedString(@"Be ready to\nbecome a Queen!", nil);

        }
        
        self.titleTuto.hidden = NO;

        self.nextButton.frame = CGRectMake(0, 0, largeurIphone, hauteurIphone);
        
        [self maskFrame:CGRectZero andRadius:0];

    }else if (step == 2) {
        

        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"Tuto2"];

        self.info.frame = CGRectMake(0, hauteurIphone/2-20, largeurIphone, 200);

        self.info.text = NSLocalizedString(@"Tap on the Queen\nof France", nil);

        [self maskFrame:CGRectMake(largeurIphone/2-60, hauteurIphone/2-60-43, 120, 120) andRadius:60];

        self.nextButton.frame = CGRectMake(largeurIphone/2-60, hauteurIphone/2-60-43, 120, 120);

    }else if (step == 3){
        

        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"Tuto3"];

        [self hide];
   
    
    }else if (step == 5){
       
        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"Tuto5"];

        
        self.info.text = NSLocalizedString(@"Tap on the heart\nto like the BUZZ", nil);
        
        if (IS_IPHONEX) {
            
            [self maskFrame:CGRectMake(largeurIphone-105,hauteurIphone-67-10-20, 52+20+15, 52+20) andRadius:15];

        }else{
            [self maskFrame:CGRectMake(largeurIphone-105,hauteurIphone-67-10, 52+20+15, 52+20) andRadius:15];

        }
        
        self.nextButton.frame = CGRectMake(largeurIphone-105,hauteurIphone-67-10, 52+20+15, 52+20);

    }else if (step == 6){
        
        
        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"Tuto6"];

        self.info.text = NSLocalizedString(@"Tap on the sword to view\nthe pretenders BUZZ’s", nil);
        
        if (IS_IPHONEX) {
            
            [self maskFrame:CGRectMake((largeurIphone/2-25)-12,24-12+30, 60+14, 60+14) andRadius:42];

        }else{
            
            [self maskFrame:CGRectMake((largeurIphone/2-25)-12,24-12, 60+14, 60+14) andRadius:42];

        }
        
        
        self.nextButton.frame = CGRectMake((largeurIphone/2-25)-12,24-12, 60+14, 60+14) ;
        
    }else if (step == 7){
        
        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"Tuto7"];

        [self hide];

    }else if(step == 8){
        
        
        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"Tuto8"];

    
        self.info.text = NSLocalizedString(@"Swipe on the right to\nlike and swipe on the left\nto pass on another BUZZ", nil);
        
        [self maskFrame:CGRectZero andRadius:30];
        
        self.nextButton.frame = CGRectMake(0,0,largeurIphone,hauteurIphone)  ;
        
    }else if (step == 9){
        
        
        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"Tuto9"];

        [self hide];
        
    }
    
    else if (step == 10){
        
        
            
        self.titleTuto.hidden = NO;

        self.titleTuto.text = NSLocalizedString(@"End of Tutorial", nil);
        self.titleTuto.frame = CGRectMake(0,  hauteurIphone/2-120,largeurIphone, 50);

        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"Tuto10"];
        
            self.info.font = [UIFont BerkshireSwash:20];
            self.info.text = NSLocalizedString(@"For the buzz that you liked, find\nthe corresponding Instagram\nprofile in the like box\nby touching their Instagram picture", nil);
        
            
            
            
            [self maskFrame:CGRectMake(largeurIphone-50-14-5, 14-5, 60, 60)andRadius:30];
            
            self.nextButton.frame = CGRectMake(largeurIphone-50-14-5, 14-5, 60, 60);
            
            
            
    }else if (step == 11){
        
        
        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"Tuto11"];

        [self hide];
   
    }
}

-(void)hide{
    
    
    self.alpha = 1;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        
    }];

}
@end
