//
//  CustomOverlayView.m
//  BottleBond
//
//  Created by Julien Levallois on 16-10-31.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import "CustomOverlayView.h"

@interface CustomOverlayView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CustomOverlayView

- (void)setType:(OverlayType)type
{
    switch (type) {
        case OverlayTypeLeft:

//            self.imageView.image = [UIImage imageNamed:@"noOverlayImage"];
            break;
        case OverlayTypeRight:
//            self.imageView.image = [UIImage imageNamed:@"yesOverlayImage"];
            break;
        case OverlayTypeNone:
        default:
            self.imageView.image = nil;
            break;
    }
}

@end
