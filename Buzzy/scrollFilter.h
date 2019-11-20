//
//  scrollFilter.h
//  Buzzy
//
//  Created by Julien Levallois on 17-09-06.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
#import "GBInfiniteScrollView/GBInfiniteScrollView.h"



@interface scrollFilter : UIView<GBInfiniteScrollViewDelegate,GBInfiniteScrollViewDataSource>

@property(nonatomic)GBInfiniteScrollView *scroll;

@property(nonatomic)NSMutableArray *data;

@property(nonatomic)UIImageView *v1;
@property(nonatomic)UIImageView *v2;
@property(nonatomic)UIImageView *v3;

@end
