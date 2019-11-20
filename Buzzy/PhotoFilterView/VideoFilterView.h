//
//  PhotoFilterView.h
//  Buzzy
//
//  Created by Shamshad Khan on 31/10/17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Filters.h"

@interface VideoFilterView : UIView
{
	NSMutableArray* _filterViewArray;
	CGFloat _firstCenterX;
	CGFloat _lastCenterX;
}

//- (void)setUpImage:(UIImage*)image;
- (void)removeFromSuperview;
- (void)moveFilterBy:(CGFloat)distance shouldAnimation:(BOOL)isAnimation;
- (void)setFilter;

@end
