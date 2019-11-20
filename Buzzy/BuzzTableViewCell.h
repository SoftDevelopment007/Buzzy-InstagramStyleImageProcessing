//
//  BuzzTableViewCell.h
//  Buzzy
//
//  Created by Julien Levallois on 17-06-27.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
#import "DACircularProgressView.h"


@interface BuzzTableViewCell : UITableViewCell


@property(nonatomic)PFImageView *picture;
@property(nonatomic)UIButton *btnInsta;

@property(nonatomic)UILabel *name;
@property(nonatomic)UILabel *distance;
@property(nonatomic)UILabel *like;
@property(nonatomic)UIImageView *likeImage;
@property(nonatomic)UIImageView *line;

@property(nonatomic)DACircularProgressView *progressView;

@property(nonatomic)PFFile *content;

@property(nonatomic)UIImageView *pastille;


@property(nonatomic)UIImageView *friendsLogo;

@property(nonatomic)PFObject *buzz;

@end
