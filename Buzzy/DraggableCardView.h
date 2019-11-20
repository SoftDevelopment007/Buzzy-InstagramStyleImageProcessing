//
//  DraggableCardView.h
//  BottleBond
//
//  Created by Julien Levallois on 16-10-31.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BbCardView.h"

typedef NS_ENUM(NSInteger, SwipeDirection) {
    SwipeDirectionNone = 0,
    SwipeDirectionLeft,
    SwipeDirectionRight
};

@protocol DraggableCardDelegate;
@class OverlayView;
@interface DraggableCardView : UIView


@property(nonatomic) BOOL modeDiscover;


@property (nonatomic, weak) id<DraggableCardDelegate>delegate;

- (void)configWithContentView:(UIView *)content overlayView:(OverlayView *)overlay;
- (void)swipeLeft;
- (void)swipeRight;

@property (nonatomic, strong) BbCardView *contentView;
@property (nonatomic, strong) OverlayView *overlayView;

@property(nonatomic)UIPanGestureRecognizer *panGesture;
@property(nonatomic)UITapGestureRecognizer *tapGesture;


@end

@protocol DraggableCardDelegate <NSObject>

- (void)cardView:(DraggableCardView *)cardView draggedWithFinishPercent:(CGFloat)percent;
- (void)cardView:(DraggableCardView *)cardView swippedInDirection:(SwipeDirection)direction;
- (void)cardViewReset:(DraggableCardView *)cardView;
- (void)cardViewTapped:(DraggableCardView *)cardView position:(NSInteger)position totalUsers:(NSInteger)totalUsers;

@end
