//
//  OverLayView.m
//  BottleBond
//
//  Created by Julien Levallois on 16-10-31.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

- (instancetype)init
{
    if (self = [super init]) {
        self.type = OverlayTypeNone;
    }
    return self;
}

@end
