//
//  SwipeView.h
//  BottleBond
//
//  Created by Julien Levallois on 16-10-31.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "POP.h"
#import "DraggableCardView.h"
#import "BbCardView.h"


@class OverlayView;
@protocol SwipeDelegate, SwipeViewDataSource;

@interface SwipeView : UIView

@property (nonatomic, weak) IBOutlet id<SwipeDelegate> delegate;
@property (nonatomic, weak) IBOutlet id<SwipeViewDataSource> dataSource;

@property (nonatomic, readonly) NSUInteger visibleCardsCount;
@property (nonatomic, readonly) NSUInteger cardsCount;
@property (nonatomic, readonly) NSUInteger currentCardNum;


- (CGRect)frameForCardAtIndex:(NSUInteger)index;
- (void)reloadData;
- (void)applyAppearAnimation;
- (void)applyRevertAnimationForCard:(DraggableCardView *)card;
- (void)swipeDirection:(SwipeDirection)direction;
- (void)revertAction;
- (void)resetCurrentCardNumber;

@property (nonatomic, strong) NSMutableArray *visibleCardsViewArray;

@end

@protocol SwipeViewDataSource <NSObject>

@required
- (NSUInteger)swipeViewNumberOfCards:(SwipeView *)swipeView;
- (BbCardView *)swipeView:(SwipeView *)swipeView
          cardAtIndex:(NSUInteger)index;

- (OverlayView *)swipeView:(SwipeView *)swipeView
        cardOverlayAtIndex:(NSUInteger)index;

@end

@protocol SwipeDelegate <NSObject>

- (void)swipeView:(SwipeView *)swipeView didSwipeCardAtIndex:(NSUInteger)index inDirection:(SwipeDirection)direction;
- (void)swipeViewDidRunOutOfCards:(SwipeView *)swipeView;
- (void)swipeView:(SwipeView *)swipeView didSelectCardAtIndex:(NSUInteger)index position:(NSInteger)position totalUsers:(NSInteger)totalUsers;
- (BOOL)swipeViewShouldApplyAppearAnimation:(SwipeView *)swipeView;
- (BOOL)swipeViewShouldMoveBackgroundCard:(SwipeView *)swipeView;
- (BOOL)swipeViewShouldTransparentizeNextCard:(SwipeView *)swipeView;
- (POPPropertyAnimation *)swipeViewBackgroundCardAnimation:(SwipeView *)swipeView;

@end
