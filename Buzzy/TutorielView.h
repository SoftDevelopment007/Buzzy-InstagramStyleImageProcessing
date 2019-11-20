//
//  TutorielView.h
//  Buzzy
//
//  Created by Julien Levallois on 17-08-10.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"

@interface TutorielView : UIView


@property(nonatomic)int currentStep;


-(void)setStep:(int)step;


@property(nonatomic)UILabel *info;
@property(nonatomic)UILabel *titleTuto;

@property(nonatomic)UIButton *nextButton;

@property(nonatomic)UIBezierPath *path;
@property(nonatomic)CAShapeLayer *fillLayer;

@end
