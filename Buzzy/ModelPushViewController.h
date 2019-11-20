//
//  ModelPushViewController.h
//  BottleBond
//
//  Created by Julien Levallois on 16-12-25.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"

typedef enum StyleBB : NSUInteger {
    kStyleBlack,
    kStyleWhite,
} StyleBB;

@interface ModelPushViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic)enum StyleBB style;

@property(nonatomic)UIView *navigationBarBB;

@property(nonatomic)UIButton *buttonMore;
@property(nonatomic)UIButton *buttonPrec;
@property(nonatomic)UIImageView *bottomLine;

-(instancetype)initWithStyle:(enum StyleBB )style;

-(void)popBBViewController;

@property(nonatomic)UIImageView *cacheTableView;

@end
