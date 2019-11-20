//
//  BtnMyBuzz.h
//  Buzzy
//
//  Created by Julien Levallois on 17-06-28.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"


@interface BtnMyBuzz : UIButton

@property(nonatomic)UIImageView *background;

@property(nonatomic)PFImageView *image;
@property(nonatomic)UILabel *number;
@property(nonatomic)UIImageView *filter;


@end

