//
//  OverLayView.h
//  BottleBond
//
//  Created by Julien Levallois on 16-10-31.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OverlayType) {
    OverlayTypeNone = 0,
    OverlayTypeLeft,
    OverlayTypeRight,
    OverlayTypeDown
};

@interface OverlayView : UIView

@property (nonatomic, assign) OverlayType type;

@end
