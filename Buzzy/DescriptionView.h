//
//  DescriptionView.h
//  Buzzy
//
//  Created by Julien Levallois on 17-06-24.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"

@interface DescriptionView : UIView  <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource> 
{
    UICollectionView* _colorView;
    UICollectionViewCell* prevCell;
    NSArray* colorArr;
}

@property (nonatomic) NSInteger heightKeyboard;
@property(nonatomic)UIImageView *background;
@property(nonatomic)UITextView *titleTextField;
@property (strong, nonatomic) void(^descriptionDone)(NSString* text, UIColor* color);

- (instancetype)initWithFrame:(CGRect)frame;

@end
