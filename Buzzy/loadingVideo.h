//
//  loadingVideo.h
//  Buzzy
//
//  Created by Julien Levallois on 17-09-07.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"


@interface loadingVideo : UIView

@property(nonatomic)UIActivityIndicatorView *loading;

-(void)hide;

@end
