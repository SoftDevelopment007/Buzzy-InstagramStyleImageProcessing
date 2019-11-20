//
//  LoadingView.m
//  BottleBond
//
//  Created by Julien Levallois on 16-12-23.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        ///// 58 234
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        

        
        self.background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        self.background.image = [UIImage imageNamed:@"blackBackground"];
        [self addSubview:self.background];
        

        
        self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicatorView.center = CGPointMake(largeurIphone/2, hauteurIphone/2);
        [self.indicatorView startAnimating];
        [self addSubview:self.indicatorView];
        
        
    }
    return self;
}

-(void)play{
    
    
    
    
    self.hidden = NO;
    self.alpha =1;
        
    
    
}

-(void)stop{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self setHidden:YES];
        self.alpha = 1;
                
    }];
    
}

@end
