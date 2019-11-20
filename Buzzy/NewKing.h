//
//  NewKing.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
#import "DACircularProgressView.h"



@interface NewKing : UIView


@property(nonatomic)PFImageView *picture;

@property(nonatomic)DACircularProgressView *progressView;


@property(nonatomic)UIImageView *couronneKing;


@property(nonatomic)UILabel *titleName;
@property(nonatomic)TTTAttributedLabel *title;
@property(nonatomic)UILabel *like;
@property(nonatomic)UIImageView *likeImg;

-(void)showWithBuzz:(PFObject *)buzz andType:(NSString *)type;


@end
