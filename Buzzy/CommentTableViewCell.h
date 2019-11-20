//
//  CommentTableViewCell.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"

#import "HTCopyableLabel.h"

@interface CommentTableViewCell : UITableViewCell



@property(nonatomic)PFImageView *profilePicture;

@property(nonatomic)HTCopyableLabel *content;
@property(nonatomic)PFUser *user;

@property(nonatomic)UIImageView *pastille;


-(void)adjustBubbleWithText:(NSString *)text;

@end
