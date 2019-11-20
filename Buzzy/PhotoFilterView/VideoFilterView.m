//
//  VideoFilterView.m
//  Buzzy
//
//  Created by Shamshad Khan on 31/10/17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "VideoFilterView.h"

@implementation VideoFilterView

- (instancetype)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
        [self setUpViews];
    
		_firstCenterX = self.center.x - 3*self.frame.size.width;
		_lastCenterX = self.center.x + 3*self.frame.size.width;
	}
	return self;
}

//- (void)setUpImage:(UIImage*)image {
//    [_filterViewArray removeAllObjects];
//    [self setUpViews:image];
//}

- (void)moveFilterBy:(CGFloat)distance shouldAnimation:(BOOL)isAnimation {

    if (isAnimation) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf moveFilterBy:distance];
        } completion:^(BOOL finished) {
            [weakSelf shiftEndFilter];
        }];
    } else {
        
        [self moveFilterBy:distance];
        [self shiftEndFilter];
    }
}

- (void)moveFilterBy:(CGFloat)distance {
    
    for (UIImageView* v in _filterViewArray) {
        CGPoint p = v.center;
        p.x += distance;
        v.center = p;
    }
}

- (void)shiftEndFilter {
    
    UIImageView* firstView = [_filterViewArray firstObject];
    UIImageView* lastView = [_filterViewArray lastObject];
    CGFloat w = self.frame.size.width;
    
    if (firstView.center.x < _firstCenterX - w) {
        
        [_filterViewArray removeObject:firstView];
        firstView.center = CGPointMake(lastView.center.x + w, lastView.center.y);
        [_filterViewArray addObject:firstView];
        return;
    }
    
    if (lastView.center.x > _lastCenterX + w) {
        
        [_filterViewArray removeObject:lastView];
        lastView.center = CGPointMake(firstView.center.x - w, firstView.center.y);
        [_filterViewArray insertObject:lastView atIndex:0];
        return;
    }
}

- (void)setFilter {
	
	for (UIImageView * v in _filterViewArray) {
		
		if ([self isPoint:v.center closeTo:self.center]) {
			CGFloat diffrence = self.center.x - v.center.x;
            
            [UIView animateWithDuration:0.2 animations:^{
                [self moveFilterBy:diffrence shouldAnimation:YES];
            }];
            return;
		}
	}
}


-(void)setUpViews {
    
    
    
    CGFloat w = self.frame.size.width;
    CGFloat x = self.center.x;
    CGFloat y = self.center.y;
    
    UIView* view;
    _filterViewArray = [[NSMutableArray alloc] init];

    view = [[UIView alloc] initWithFrame:self.frame];
    view.center = CGPointMake(x - 3*w, y);
    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
    view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.15];
    [_filterViewArray addObject:view];
    
    view = [[UIView alloc] initWithFrame:self.frame];
    view.center = CGPointMake(x - 2*w, y);
    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
    view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.15];
    [_filterViewArray addObject:view];
    
    view = [[UIView alloc] initWithFrame:self.frame];
    view.center = CGPointMake(x - w, y);
    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
    view.backgroundColor = [UIColor colorWithRed:169/255 green:169/255 blue:169/225 alpha:0.50];
    [_filterViewArray addObject:view];
    
    view = [[UIView alloc] initWithFrame:self.frame];
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
    [_filterViewArray addObject:view];
    
    view = [[UIView alloc] initWithFrame:self.frame];
    view.center = CGPointMake(x + w, y);
    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
    view.backgroundColor = [UIColor colorWithRed:1 green:165/255 blue:0 alpha:0.15];
    [_filterViewArray addObject:view];
    
    view = [[UIView alloc] initWithFrame:self.frame];
    view.center = CGPointMake(x + 2*w, y);
    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
    view.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.15];
    [_filterViewArray addObject:view];

//    view = [[UIView alloc] initWithFrame:self.frame];
//    view.center = CGPointMake(x + 3*w, y);
//    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
//    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.30];
//    [_filterViewArray addObject:view];
    
    for (UIView* v in _filterViewArray) {
        [self addSubview:v];
    }
}

- (void)removeFromSuperview {
	
	for (UIView* v in _filterViewArray) {
		[v removeFromSuperview];
	}
	
	[self setUpViews];
	
	[super removeFromSuperview];
}

#pragma mark - Utility

- (BOOL)isPoint:(CGPoint)a closeTo:(CGPoint)b {
	
	if ( fabs(a.x - b.x) <= self.frame.size.width/2)
		return YES;
	return NO;
}

@end
