
//
//  LegendTableViewCell.m
//  Buzzy
//
//  Created by Julien Levallois on 17-09-13.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "LegendTableViewCell.h"

@implementation LegendTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(98, 0, largeurIphone-100, 55)];
        self.name.textColor = [UIColor whiteColor];
        self.name.font = [UIFont HelveticaNeueLight:18];
        [self addSubview:self.name];
        
        self.image =[[UIImageView alloc]initWithFrame:CGRectMake(35, 10, 40, 40)];
        [self addSubview:self.image];
        
        
    }
    
    
    return self;
}


@end
