//
//  UIPlaceHolderTextView.h
//  GrassRush
//
//  Created by Julien Levallois on 16-04-09.
//  Copyright © 2016 Levallois Julien. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>


@interface UIPlaceHolderTextView : UITextView

@property (nonatomic)  NSString *placeholder;
@property (nonatomic)  UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
