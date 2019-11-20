//
//  FriendsTableViewCell.m
//  Buzzy
//
//  Created by Julien Levallois on 17-09-27.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell





- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        self.picture = [[PFImageView alloc]initWithFrame:CGRectMake(30, 30, 70, 70)];
        self.picture.layer.cornerRadius = 35;
        self.picture.layer.masksToBounds = YES;
        self.picture.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.picture];
        
        
        
        self.instaId = [[UILabel alloc]initWithFrame:CGRectMake(120, 43, 230, 26)];
        self.instaId.textColor = [UIColor whiteColor];
        self.instaId.textAlignment = NSTextAlignmentLeft;
        self.instaId.font =[UIFont HelveticaNeue:20];
        [self addSubview:self.instaId];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, 170, 22)];
        self.name.textColor = [UIColor whiteColor];
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.font =[UIFont HelveticaNeueLight:15];
        [self addSubview:self.name];
      
        
        
    }
    
    return self;
    
    
    
    
}

@end
