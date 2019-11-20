//
//  LionView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-31.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "LionView.h"

@implementation LionView


- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 64, 64)]) {
        
        
        
        self.backgroundColor = [UIColor clearColor];
        //6
        
        
        self.lionImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,64,64)];
        self.lionImage.image =[[UIImage imageNamed:@"lionImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.lionImage.tintColor =[UIColor redBuzzy];
        [self addSubview:self.lionImage];
        
        
        
    }
    return self;
}

@end
