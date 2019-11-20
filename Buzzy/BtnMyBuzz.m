//
//  BtnMyBuzz.m
//  Buzzy
//
//  Created by Julien Levallois on 17-06-28.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "BtnMyBuzz.h"

@implementation BtnMyBuzz


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        
        
        self.background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.background.image = [UIImage imageNamed:@"btnLike"];
        [self addSubview:self.background];
        

        
        self.image = [[PFImageView alloc]initWithFrame:CGRectMake(8, 8, 34, 34)];
        self.image.layer.cornerRadius = 17;
        self.image.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.image];
        
        
        self.filter = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 34, 34)];
        self.filter.layer.cornerRadius = 17;
        self.filter.backgroundColor = [UIColor blackColor];
        self.filter.alpha = 0;
        [self addSubview:self.filter];
        

        
        
        self.number = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.number.textAlignment = NSTextAlignmentCenter;
        self.number.font = [UIFont HelveticaNeue:16];
        self.number.textColor = [UIColor whiteColor];
        [self addSubview:self.number];
        
        
        
        

        [self addTarget:self action:@selector(showAlpha) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(hideAlpha) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(hideAlpha) forControlEvents:UIControlEventTouchUpOutside];

        
        
        
    }
    return self;
}

-(void)showAlpha{
    
    self.filter.alpha = 0.5;
    
}

-(void)hideAlpha{

    self.filter.alpha = 0.0;

}
@end
