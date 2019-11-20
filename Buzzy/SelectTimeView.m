//
//  SelectTimeView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-06-24.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "SelectTimeView.h"

@implementation SelectTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        
        self.backgroundColor = [UIColor clearColor];
        
        
        self.background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        self.background.image = [UIImage imageNamed:@"blackBackground"];
        [self addSubview:self.background];
        
        self.zoneA = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone/2-70)];
        [self addSubview:self.zoneA];
        [self.zoneA addTarget:self action:@selector(actionDeselectTime) forControlEvents:UIControlEventTouchUpInside];
        

        self.zoneB = [[UIButton alloc]initWithFrame:CGRectMake(0, hauteurIphone/2+70, largeurIphone, hauteurIphone/2-70)];
        [self addSubview:self.zoneB];
        [self.zoneB addTarget:self action:@selector(actionDeselectTime) forControlEvents:UIControlEventTouchUpInside];

        
        self.pickerView = [[AKPickerView alloc]initWithFrame:CGRectMake(0, hauteurIphone/2-70, largeurIphone, 140)];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        self.pickerView.interitemSpacing = 40;
        self.pickerView.textColor = [UIColor colorWithWhite:1 alpha:0.3];
        self.pickerView.font = [UIFont HelveticaNeue:100];
        self.pickerView.highlightedTextColor = [UIColor whiteColor];
        self.pickerView.highlightedFont = [UIFont HelveticaNeue:100];
        self.pickerView.fisheyeFactor = 0.00005;
        self.pickerView.pickerViewStyle = AKPickerViewStyleFlat;
        [self addSubview:self.pickerView];
        [self.pickerView reloadData];
        
        
        if (IS_IPHONEX) {
            self.btnTime = [[UIButton alloc]initWithFrame:CGRectMake(5, hauteurIphone-55-3-20, 50, 50)];

        }else{
            
            self.btnTime = [[UIButton alloc]initWithFrame:CGRectMake(5, hauteurIphone-55-3, 50, 50)];

        }
        [self.btnTime setBackgroundImage:[UIImage imageNamed:@"btnTime-10"] forState:UIControlStateNormal];
        [self.btnTime addTarget:self action:@selector(actionDeselectTime) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnTime];
        
        
        self.secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, hauteurIphone/2+55, largeurIphone, 30)];
        self.secondLabel.font = [UIFont HelveticaNeue:20];
        self.secondLabel.textColor = [UIColor whiteColor];
        self.secondLabel.textAlignment = NSTextAlignmentCenter;
        self.secondLabel.text = NSLocalizedString(@"seconds", nil);
        [self addSubview:self.secondLabel];
        
        self.romains = [NSArray arrayWithObjects:@"I",@"II",@"III",@"IV",@"V",@"VI",@"VII",@"VIII",@"IX",@"X", nil];
        
    }
    return self;
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView{
    
    return 10;
    
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item{
    
    return [NSString stringWithFormat:@"%@",[self.romains objectAtIndex:item]];
    
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item{
    
    UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
    [myGen notificationOccurred:UINotificationFeedbackTypeSuccess];
    myGen = NULL;
    
    
    self.time = item +1;
    
  
    
    [self.btnTime setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btnTime-%ld",(long)self.time]] forState:UIControlStateNormal];

    if (item+1 > 1) {
        
        self.secondLabel.text = NSLocalizedString(@"seconds", nil);

    }else{
        
        self.secondLabel.text = NSLocalizedString(@"second", nil);

    }
    
    if (self.delegate) {
        
        [self.delegate updateTimeFromPicker:(int)self.time];
        
    }
    
}




-(void)actionDeselectTime{
    
    self.hidden = YES;

}

@end
