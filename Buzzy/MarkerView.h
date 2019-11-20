//
//  MarkerView.h
//  Buzzy
//
//  Created by Julien Levallois on 17-06-12.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
#import "DACircularProgressView.h"

@interface MarkerView : UIView

@property(nonatomic)UIImageView *couronne;

@property(nonatomic)UIImageView *pin;

@property(nonatomic)PFImageView *picture;

@property(nonatomic)DACircularProgressView *progressView;

@property(nonatomic)UILabel *country;

@property(nonatomic)UIImageView *iconFriend;

@end
