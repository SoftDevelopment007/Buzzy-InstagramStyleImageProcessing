//
//  CustomActivityIndicator.m
//  CustomIndicator
//
//  Created by Naheed Shamim on 12/05/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

#import "CustomActivityIndicator.h"
#import <UIKit/UIKit.h>
#import "Base.h"

#define kWidth 100
#define kHeight 20
#define kDisplaceHeight 30
#define kZero 0

    static CustomActivityIndicator *myClass;

@implementation CustomActivityIndicator

+ (CustomActivityIndicator*)sharedInstance
{
    static dispatch_once_t once;

    dispatch_once(&once, ^ {
        myClass = [[self alloc] init];
        myClass.indicatorView = [[ UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        myClass.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(kZero,kZero,kWidth,kHeight)];
        myClass.myView = [[UIView alloc] initWithFrame:CGRectMake(kZero,kZero,largeurIphone,hauteurIphone)];
    });
    
    return myClass;
}

-(void)showIndicatorWithText:(NSString*)text fromVC:(UIViewController*)vc
{
    self.myView.backgroundColor = [UIColor blackColor];
    self.myView.alpha = 0.3;
    self.myView.center = CGPointMake(vc.view.center.x,vc.view.center.y+10);
    self.myView.layer.cornerRadius = 8;
    
    self.myLabel.text = text;
    self.myLabel.textColor = [UIColor whiteColor];
    self.myLabel.center = CGPointMake(self.myView.center.x,self.myView.center.y + kDisplaceHeight);
    self.myLabel.textAlignment = NSTextAlignmentCenter;
    
//    self.indicatorView.color = [UIColor blueColor];
    [self.indicatorView startAnimating];
    self.indicatorView.center=vc.view.center;
    
    [self addSubview:self.myView];
    [self addSubview:self.myLabel];
    [self addSubview:self.indicatorView];

    [vc.view addSubview:self];
}

-(void)hideIndicator
{
//    [self.indicatorView stopAnimating];
    [self removeFromSuperview];
}

@end
