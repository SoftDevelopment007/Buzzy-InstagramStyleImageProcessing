//
//  SettingsTableViewCell.m
//  BottleBond
//
//  Created by Julien Levallois on 17-01-28.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
      
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, largeurIphone-28-28-80, 77)];
        self.name.textColor = [UIColor whiteColor];
        self.name.font = [UIFont HelveticaNeueLight:18];
        [self addSubview:self.name];
        
        self.image =[[UIImageView alloc]initWithFrame:CGRectMake(largeurIphone-40-30, 55/2, 30, 30)];
        [self addSubview:self.image];
        
        self.line = [[UIImageView alloc]initWithFrame:CGRectMake(40, 73, largeurIphone-40-40, 1.2)];
        self.line.backgroundColor =[UIColor colorForHex:@"FFFFFF"];
        self.line.alpha = 0.71;
        [self addSubview:self.line];
        

    }
    
    
    return self;
}


@end
