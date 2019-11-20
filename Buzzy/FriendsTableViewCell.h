//
//  FriendsTableViewCell.h
//  Buzzy
//
//  Created by Julien Levallois on 17-09-27.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"

@interface FriendsTableViewCell : UITableViewCell


@property(nonatomic)PFImageView *picture;

@property(nonatomic)UILabel *instaId;
@property(nonatomic)UILabel *name;



@end
