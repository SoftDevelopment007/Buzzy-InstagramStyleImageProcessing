//
//  DraggableCardView.m
//  Koloda-ObjC
//
//  Created by Vong on 15/8/17.
//  Copyright (c) 2015年 Vong. All rights reserved.
//

#import "DraggableCardView.h"
#import "OverlayView.h"
#import "POP.h"

//Drag animation constants
static const CGFloat kRotationMax                        = 1.0;
static const CGFloat kDefaultRotationAngle               = (M_PI) / 10.0;
static const CGFloat kScaleMin                           = 0.9;
static const CGFloat kCardSwipeActionAnimationDuration   = 0.33;

//Reset animation constants
static const CGFloat kCardResetAnimationSpringBounciness = 10.0;
static const CGFloat kCardResetAnimationSpringSpeed      = 20.0;
static NSString  *const  kCardResetAnimationKey          = @"resetPositionAnimation";
static const CGFloat kCardResetAnimationDuration         = 0.15;


@interface DraggableCardView ()

@property (nonatomic, assign) CGFloat actionMargin;
@property (nonatomic, assign) CGFloat xDistanceFromCenter;
@property (nonatomic, assign) CGFloat yDistanceFromCenter;
@property (nonatomic, assign) CGPoint originalLocation;
@property (nonatomic, assign) CGFloat animationDirection;
@property (nonatomic, assign) BOOL dragBegin;

@end

@implementation DraggableCardView

#pragma mark - Initializer

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectZero]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.actionMargin = frame.size.width / 3.6;
}

#pragma mark - Public

- (void)configWithContentView:(BbCardView *)content overlayView:(OverlayView *)overlay
{
    [self.overlayView removeFromSuperview];
    if (overlay) {
        self.overlayView = overlay;
        overlay.alpha = 0;
        [self addSubview:overlay];
        [self configureOverlayView];
        [self insertSubview:content belowSubview:overlay];
    } else {
        [self addSubview:content];
    }
    [self.contentView removeFromSuperview];
    self.contentView = content;
    [self configureContentView];
}

- (void)swipeLeft
{
    if (!self.dragBegin) {
        CGPoint finishPoint = CGPointMake(-CGRectGetWidth([UIScreen mainScreen].bounds), self.center.y);
        if ([self.delegate respondsToSelector:@selector(cardView:swippedInDirection:)]) {
            [self.delegate cardView:self swippedInDirection:SwipeDirectionLeft];
        }
        [UIView animateWithDuration:kCardResetAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.center = finishPoint;
            self.transform = CGAffineTransformMakeRotation(-M_PI_4);
        } completion:^(BOOL finished) {
            self.dragBegin = NO;
            [self removeFromSuperview];
        }];
    }
}

- (void)swipeRight
{
    if (!self.dragBegin) {
        
        CGPoint finishPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 2, self.center.y);
        if ([self.delegate respondsToSelector:@selector(cardView:swippedInDirection:)]) {
            [self.delegate cardView:self swippedInDirection:SwipeDirectionRight];
        }
        [UIView animateWithDuration:kCardResetAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.center = finishPoint;
            self.transform = CGAffineTransformMakeRotation(M_PI_4);
            return;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            return;
        }];
    }
}

#pragma mark - Private

- (void)commonInit
{
    
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowOffset = CGSizeMake(1, 4);
    
    
    
    self.animationDirection = 1.f;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(panGestureRecognized:)];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(tapRecognized:)];
    [self addGestureRecognizer:self.panGesture];
    [self addGestureRecognizer:self.tapGesture];
}

- (void)configureOverlayView
{
    self.overlayView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.overlayView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.0
                                                              constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.overlayView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0
                                                               constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.overlayView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.overlayView
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:0];
    [self addConstraints:@[width,height,top,leading]];
}

- (void)configureContentView
{
    //    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    //    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView
    //                                                             attribute:NSLayoutAttributeWidth
    //                                                             relatedBy:NSLayoutRelationEqual
    //                                                                toItem:self
    //                                                             attribute:NSLayoutAttributeWidth
    //                                                            multiplier:1.0
    //                                                              constant:0];
    //    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView
    //                                                              attribute:NSLayoutAttributeHeight
    //                                                              relatedBy:NSLayoutRelationEqual
    //                                                                 toItem:self
    //                                                              attribute:NSLayoutAttributeHeight
    //                                                             multiplier:1.0
    //                                                               constant:0];
    //    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.contentView
    //                                                           attribute:NSLayoutAttributeTop
    //                                                           relatedBy:NSLayoutRelationEqual
    //                                                              toItem:self
    //                                                           attribute:NSLayoutAttributeTop
    //                                                          multiplier:1.0
    //                                                            constant:0];
    //    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.contentView
    //                                                               attribute:NSLayoutAttributeLeading
    //                                                               relatedBy:NSLayoutRelationEqual
    //                                                                  toItem:self
    //                                                               attribute:NSLayoutAttributeLeading
    //                                                              multiplier:1.0
    //                                                                constant:0];
    //    [self addConstraints:@[width,height,top,leading]];
    //
    //
    //    self.contentView.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    //    NSLayoutConstraint *width2 = [NSLayoutConstraint constraintWithItem:self.contentView.contentView
    //                                                             attribute:NSLayoutAttributeWidth
    //                                                             relatedBy:NSLayoutRelationEqual
    //                                                                toItem:self.contentView
    //                                                             attribute:NSLayoutAttributeWidth
    //                                                            multiplier:1.0
    //                                                              constant:0];
    //
    //    NSLayoutConstraint *leading2 = [NSLayoutConstraint constraintWithItem:self.contentView.contentView
    //                                                               attribute:NSLayoutAttributeLeading
    //                                                               relatedBy:NSLayoutRelationEqual
    //                                                                  toItem:self.contentView
    //                                                               attribute:NSLayoutAttributeLeading
    //                                                              multiplier:1.0
    //                                                                constant:0];
    //
    //
    //    NSLayoutConstraint *top2 = [NSLayoutConstraint constraintWithItem:self.contentView.contentView
    //                                                           attribute:NSLayoutAttributeTop
    //                                                           relatedBy:NSLayoutRelationEqual
    //                                                              toItem:self.contentView
    //                                                           attribute:NSLayoutAttributeTop
    //                                                          multiplier:1.0
    //                                                            constant:0.1*self.contentView.frame.size.height];
    //
    //
    //
    //    NSLayoutConstraint *height2 = [NSLayoutConstraint constraintWithItem:self.contentView.contentView
    //                                                              attribute:NSLayoutAttributeHeight
    //                                                              relatedBy:NSLayoutRelationEqual
    //                                                                 toItem:self.contentView
    //                                                              attribute:NSLayoutAttributeHeight
    //                                                             multiplier:1.0
    //                                                               constant:-0.2*self.contentView.frame.size.height];
    //
    //
    //    NSLog(@"hauteur totale : %f",self.contentView.contentView.frame.size.height);
    //
    //
    //    [self.contentView addConstraints:@[width2,height2,top2,leading2]];
    
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)pan
{
    
    if (self.contentView.blockDraggable == YES || self.contentView.blockSwipe == YES) {
        
        return;
    }
    
    self.xDistanceFromCenter = [pan translationInView:self].x;
    self.yDistanceFromCenter = [pan translationInView:self].y;
    CGPoint location = [pan locationInView:self];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.originalLocation = self.center;
            self.dragBegin = YES;
            
            self.animationDirection = location.y >= self.frame.size.height / 2 ? -1.0 : 1.0;
            
            self.layer.shouldRasterize = YES;
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat rotationStrength = MIN(self.xDistanceFromCenter / self.frame.size.width, kRotationMax);
            CGFloat rotationAngle = self.animationDirection * kDefaultRotationAngle * rotationStrength;
            CGFloat scaleStrength = 1 - ((1 - kScaleMin) * fabs(rotationStrength));
            CGFloat scale = MAX(scaleStrength, kScaleMin);
            
            self.layer.rasterizationScale = scale * [UIScreen mainScreen].scale;
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            self.transform = scaleTransform;
            self.center = CGPointMake(self.originalLocation.x + self.xDistanceFromCenter,
                                      self.originalLocation.y + self.yDistanceFromCenter);
            [self updateOverlayWithFinishPercent:self.xDistanceFromCenter / self.frame.size.width];
            if ([self.delegate respondsToSelector:@selector(cardView:draggedWithFinishPercent:)]) {
                [self.delegate cardView:self draggedWithFinishPercent:MIN(fabs(self.xDistanceFromCenter * 100 / self.frame.size.width), 100)];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self swipeMadeAction];
            self.layer.shouldRasterize = NO;
        }
            break;
        default:
            break;
    }
}




- (void)updateOverlayWithFinishPercent:(CGFloat)percent
{
    
    
//    self.contentView.viewTutoSwipe.hidden = YES;
    
    self.overlayView.type = percent > 0.0 ? OverlayTypeRight : OverlayTypeLeft;
    
    CGFloat overlayStrength = MIN(fabs(3.6 * percent), 1.0);
    
    if (percent > 0.0) {
        
        self.contentView.likeImage.alpha =overlayStrength;
        self.contentView.dislikeImage.alpha =0;
        if (self.contentView.tutoView.hidden == false) {
            self.contentView.tutoView.alpha = -overlayStrength;
            
        }
    }else{
        
        self.contentView.likeImage.alpha =0;
        self.contentView.dislikeImage.alpha = overlayStrength;
        
        if (self.contentView.tutoView.hidden == false) {
            self.contentView.tutoView.alpha = -overlayStrength;

        }

    }
}

- (void)swipeMadeAction
{
    if (self.xDistanceFromCenter > self.actionMargin) {
        [self rightAction];
    } else if (self.xDistanceFromCenter < -self.actionMargin) {
        [self leftAction];
    } else {
        [self resetViewPositionAndTransformations];
    }
}

- (void)rightAction
{
    CGFloat finishY = self.originalLocation.y + self.yDistanceFromCenter;
    CGPoint finishPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 2, finishY);
    self.overlayView.type = OverlayTypeRight;
    self.overlayView.alpha = 1.0;
    if ([self.delegate respondsToSelector:@selector(cardView:swippedInDirection:)]) {
        [self.delegate cardView:self swippedInDirection:SwipeDirectionRight];
    }
    
    [self.contentView actionLikeButton];
    [self.contentView.timer invalidate];

    [UIView animateWithDuration:kCardSwipeActionAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.center = finishPoint;
    } completion:^(BOOL finished) {
        self.dragBegin = NO;
        [self removeFromSuperview];
    }];
}

- (void)leftAction
{
    CGFloat finishY = self.originalLocation.y + self.yDistanceFromCenter;
    CGPoint finishPoint = CGPointMake(-CGRectGetWidth([UIScreen mainScreen].bounds), finishY);
    
    self.overlayView.type = OverlayTypeLeft;
    self.overlayView.alpha = 1.0;
    if ([self.delegate respondsToSelector:@selector(cardView:swippedInDirection:)]) {
        [self.delegate cardView:self swippedInDirection:SwipeDirectionLeft];
    }
    
    [self.contentView actionDisLikeButton];

    [self.contentView.timer invalidate];
    
    [UIView animateWithDuration:kCardResetAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.center = finishPoint;
    } completion:^(BOOL finished) {
        self.dragBegin = NO;
        [self removeFromSuperview];
    }];
}

- (void)resetViewPositionAndTransformations
{
    //    self.userInteractionEnabled = NO;
    if ([self.delegate respondsToSelector:@selector(cardViewReset:)]) {
        [self.delegate cardViewReset:self];
    }
    
    POPSpringAnimation *resetPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    
    resetPositionAnimation.toValue = [NSValue valueWithCGPoint:self.originalLocation];
    resetPositionAnimation.springBounciness = kCardResetAnimationSpringBounciness;
    resetPositionAnimation.springSpeed = kCardResetAnimationSpringSpeed;
    [resetPositionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        //        self.userInteractionEnabled = YES;
        self.dragBegin = NO;
    }];
    
    [self pop_addAnimation:resetPositionAnimation forKey:kCardResetAnimationKey];
    [UIView animateWithDuration:kCardResetAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.contentView.likeImage.alpha = 0;
        self.contentView.tutoView.alpha = 0;

        self.contentView.dislikeImage.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
    }];
}

@end
