//
//  SelectTimeView.h
//  Buzzy
//
//  Created by Julien Levallois on 17-06-24.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"

#import "AKPickerView.h"


@protocol SelectTimeViewDelegate <NSObject>

-(void)updateTimeFromPicker:(int)duration;


@end

@interface SelectTimeView : UIView <AKPickerViewDelegate,AKPickerViewDataSource>


@property(nonatomic)id<SelectTimeViewDelegate>delegate;


@property(nonatomic) NSArray *romains;

@property(nonatomic) NSInteger time;


@property(nonatomic)AKPickerView *pickerView;



@property(nonatomic)UIImageView *background;


@property(nonatomic)UIButton *btnTime;

@property(nonatomic)UILabel *secondLabel;


@property(nonatomic)UIButton *zoneA;
@property(nonatomic)UIButton *zoneB;

@end
