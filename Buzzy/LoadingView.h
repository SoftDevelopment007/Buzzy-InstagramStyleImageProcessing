//
//  LoadingView.h
//  BottleBond
//
//  Created by Julien Levallois on 16-12-23.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"

@interface LoadingView : UIView



@property(nonatomic) UIImageView *emptyBottle;
@property(nonatomic) UIImageView *fullBottle;

@property(nonatomic)UIImageView *background;


@property(nonatomic)UIActivityIndicatorView *indicatorView;

-(void)play;
-(void)stop;

@end
