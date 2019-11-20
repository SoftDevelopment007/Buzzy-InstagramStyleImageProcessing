//
//  MMStylesheet.h
//  Memo
//
//  Created by Dany L'Hebreux on 2014-02-21.
//  Copyright (c) 2014 Mirego. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface Stylesheet : NSObject

@end

@interface UIColor (Stylesheet)

+ (UIColor *)redBuzzy;

+ (UIColor *)yellowBuzzy;
+ (UIColor *)yellowLikedBuzzy;
+ (UIColor *)redLikedBuzzy;
+ (UIColor *)orangeBuzzy;
+ (UIColor *)orangeLikedBuzzy;

@end


@interface UIFont (Stylesheet)
+ (UIFont *)HelveticaNeue:(CGFloat)size;
+ (UIFont *)HelveticaNeueMedium:(CGFloat)size;
+ (UIFont *)HelveticaNeueLight:(CGFloat)size;
+ (UIFont *)HelveticaNeueBold:(CGFloat)size ;
+ (UIFont *)BerkshireSwash:(CGFloat)size;
+ (UIFont *)Avenir:(CGFloat)size;

@end

