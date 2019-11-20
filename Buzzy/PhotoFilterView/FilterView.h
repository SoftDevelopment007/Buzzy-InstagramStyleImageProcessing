//
//  FilterView.h
//  Buzzy
//
//  Created by Chandan Makhija on 04/11/17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterView : UIView

- (void)setUpImage:(UIImage*)image;
- (void)enablePanGesture:(BOOL)state;
- (void)removeImagesFromFilter;

@end
