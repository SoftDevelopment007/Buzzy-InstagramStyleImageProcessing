//
//  CommentTableViewCell.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.backgroundColor =[UIColor clearColor];
        
        
        self.pastille = [[UIImageView alloc]initWithFrame:CGRectMake(16, 17, 6, 6)];
        self.pastille.layer.cornerRadius = 3;
        self.pastille.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pastille];
        
        
        self.profilePicture = [[PFImageView alloc]initWithFrame:CGRectMake(32, 0, 40, 40)];
        self.profilePicture.clipsToBounds = YES;
        self.profilePicture.layer.masksToBounds = YES;
        self.profilePicture.layer.cornerRadius = 20;
        self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.profilePicture];
        
        self.content = [[HTCopyableLabel alloc]initWithFrame:CGRectMake(84, 10, (largeurIphone-84)-16, 20)];
        self.content.textAlignment=NSTextAlignmentLeft;
        self.content.font = [UIFont HelveticaNeue:15];
        self.content.textColor=[UIColor whiteColor];
        self.content.numberOfLines=0;// This will make the label multiline
        self.content.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.content];
        
                
    }
    return self;
}



-(void)adjustBubbleWithText:(NSString *)text{
    
    
    self.content.text = text;
    
    CGSize sizeOfText = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.content.font} context:nil].size;
    
    CGFloat width = MIN((largeurIphone-84)-16, sizeOfText.width);
    width = MAX(width, 30);
    
    self.content.frame = CGRectMake(84, 10, width, 17);
    [self.content sizeToFit];

}


@end
