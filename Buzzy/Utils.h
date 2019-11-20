//
//  Utils.h
//  thanks
//
//  Created by Julien Levallois on 16-07-07.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Stylesheet.h"
#import <MCUIColorUtils/UIColor+MCUIColorsUtils.h>

@interface Utils : NSObject

+(BOOL)languageFr;
+(NSString *)capitalizedFirstLetterInString:(NSString*)string;
+(NSDateFormatter *)returnLocalFormatter;
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize andImage:(UIImage *)sourceImage;
+ (BOOL)validateEmail:(NSString *)emailStr;
+ (UIImage*)getFacebookProfilePictureData:(NSData *)newProfilePictureData;
+(void)addBoldEffect:(UILabel *)label onText:(NSString *)text withPattern:(NSString*)pattern;
+(void)addBoldEffect:(UILabel *)label onText:(NSString *)text withPattern:(NSString*)pattern pattern2:(NSString *)pattern2 pattern3:(NSString *)pattern3;
+(UIColor*)colorWithHexString:(NSString*)hex;
+ (CAGradientLayer *)gradientBBwithFrame:(CGRect )frame;
+ (CAGradientLayer *)gradientBB2withFrame:(CGRect )frame;
+ (CAGradientLayer *)gradientBBWhitewithFrame:(CGRect )frame;
+ (NSDate *)dateToTimeZone:(NSTimeZone *)toTimeZone fromTimeZone:(NSTimeZone *)fromTimeZone fromDate:(NSDate *)date;

+ (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;

+ (void) buzzAnimation:(UIView*)view;


@end
