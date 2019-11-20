//
//  loadingVideo.m
//  Buzzy
//
//  Created by Julien Levallois on 17-09-07.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "loadingVideo.h"

@implementation loadingVideo

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        

        
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
        
        self.loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.loading.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self.loading startAnimating];
        [self addSubview:self.loading];
    }
    return self;
}


-(void)hide{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        
        self.hidden = YES;
        self.alpha = 1;

        
    }];
    

}

@end
