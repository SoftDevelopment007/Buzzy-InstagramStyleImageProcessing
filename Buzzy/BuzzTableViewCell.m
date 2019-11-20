//
//  BuzzTableViewCell.m
//  Buzzy
//
//  Created by Julien Levallois on 17-06-27.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "BuzzTableViewCell.h"

@implementation BuzzTableViewCell




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
        
        
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(120, 43, 230, 26)];
        self.name.textColor = [UIColor whiteColor];
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.font =[UIFont HelveticaNeue:20];
        [self addSubview:self.name];

        self.distance = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, 170, 22)];
        self.distance.textColor = [UIColor whiteColor];
        self.distance.textAlignment = NSTextAlignmentLeft;
        self.distance.font =[UIFont HelveticaNeueLight:15];
        [self addSubview:self.distance];

        self.like = [[UILabel alloc]initWithFrame:CGRectMake(0, 62+9, largeurIphone-47, 18)];
        self.like.textColor = [UIColor whiteColor];
        self.like.textAlignment = NSTextAlignmentRight;
        self.like.font =[UIFont HelveticaNeue:16];
        [self addSubview:self.like];

        
        self.likeImage = [[UIImageView alloc]initWithFrame:CGRectMake(largeurIphone-12-30, 62+3+9, 12, 12)];
        self.likeImage.image = [[UIImage imageNamed:@"like"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.likeImage.tintColor =[UIColor whiteColor];
        [self addSubview:self.likeImage];
        
        
        self.line = [[UIImageView alloc]initWithFrame:CGRectMake(120, 99, largeurIphone-30-120, 1)];
        self.line.backgroundColor = [UIColor whiteColor];
        self.line.alpha = 0.08;
        [self addSubview:self.line];

        
        self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(28, 28, 74, 74)];
        self.progressView.roundedCorners = YES;
        self.progressView.trackTintColor = [UIColor clearColor];
        [self.progressView setProgressTintColor:[UIColor yellowBuzzy]];
        [self.progressView setThicknessRatio:0.10f];
        
        [self addSubview:self.progressView];
        
        self.pastille =[[UIImageView alloc]initWithFrame:CGRectMake(23, 58, 14, 14)];
        self.pastille.layer.cornerRadius = 7;
        self.pastille.layer.masksToBounds = YES;
        self.pastille.hidden = YES;
        self.pastille.backgroundColor =[UIColor redBuzzy];
        [self addSubview:self.pastille];

        
        
        self.friendsLogo =[[UIImageView alloc]initWithFrame:CGRectMake(largeurIphone-12-68, 62+3+7, 16, 16)];
        self.friendsLogo.image = [UIImage imageNamed:@"iconFriendA"];
        self.friendsLogo.hidden = YES;
        [self addSubview:self.friendsLogo];
        
        self.btnInsta =[[UIButton alloc]initWithFrame:self.picture.frame];
        self.btnInsta.layer.cornerRadius = 35;
        self.btnInsta.hidden=YES;
        [self addSubview:self.btnInsta];
        


    }
    
    return self;
    
    
    
    
}




@end
