//
//  MarkerView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-06-12.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "MarkerView.h"

@implementation MarkerView


- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 56, 96)]) {
        
      
        
        self.backgroundColor = [UIColor clearColor];
        //6
        
        self.country = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 56, 23)];
        self.country.font =[UIFont HelveticaNeue:17];
        self.country.textAlignment = NSTextAlignmentCenter;
        self.country.textColor =[UIColor whiteColor];
        [self.country setTransform:CGAffineTransformMakeRotation(M_PI / 7)];

        [self addSubview:self.country];
        
        self.couronne = [[UIImageView alloc]initWithFrame:CGRectMake((56-16)/2, 14, 16, 14)];
        self.couronne.image = [UIImage imageNamed:@"couronne"];
        [self addSubview:self.couronne];
        
        
        self.pin = [[UIImageView alloc]initWithFrame:CGRectMake(56/2-3, 84, 6, 6)];
        self.pin.backgroundColor = [UIColor whiteColor];
        self.pin.layer.cornerRadius = 3;
        self.pin.layer.masksToBounds = YES;
        [self addSubview:self.pin];
        
        self.picture = [[PFImageView alloc]initWithFrame:CGRectMake(6, 34, 44, 44)];
        self.picture.backgroundColor=[UIColor whiteColor];
        self.picture.layer.cornerRadius = 44/2;
        self.picture.layer.masksToBounds = YES;
        self.picture.contentMode = UIViewContentModeScaleAspectFill;

        [self addSubview:self.picture];
        
        self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(4, 32, 48, 48)];
        self.progressView.roundedCorners = YES;
        self.progressView.trackTintColor = [UIColor clearColor];
        [self.progressView setProgressTintColor:[UIColor yellowBuzzy]];
        [self.progressView setThicknessRatio:0.13f];

        [self addSubview:self.progressView];

        
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowOpacity = 0.3;

        
        self.iconFriend =[[UIImageView alloc]initWithFrame:CGRectMake(2.5, 20, 16, 16)];
        self.iconFriend.image = [UIImage imageNamed:@"iconFriendB"];
//        self.iconFriend.hidden = YES;
        [self addSubview:self.iconFriend];

        
    }
    return self;
}


@end
