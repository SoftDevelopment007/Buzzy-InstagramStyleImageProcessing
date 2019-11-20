//
//  CustomActivityIndicator.h
//  CustomIndicator
//
//  Created by Naheed Shamim on 12/05/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActivityIndicator : UIView

@property UIActivityIndicatorView* indicatorView;
@property UILabel* myLabel;
@property UIView* myView;

+ (CustomActivityIndicator*)sharedInstance;

-(void)showIndicatorWithText:(NSString*)text fromVC:(UIViewController*)vc;
-(void)hideIndicator;


@end
