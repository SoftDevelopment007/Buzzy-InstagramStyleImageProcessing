//
//  Utils.m
//  thanks
//
//  Created by Julien Levallois on 16-07-07.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+(BOOL)languageFr{
    
    if ([[[NSLocale preferredLanguages] objectAtIndex:0] containsString:@"fr"]  ) {
        
        return YES;
    }else{
        
        return NO;
    }
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+ (CAGradientLayer *)gradientBBWhitewithFrame:(CGRect )frame
{
    
    
    
    UIColor *topColor = [UIColor colorForHex:@"FFFFFF"];
    UIColor *bottomColor = [UIColor colorForHex:@"FFFFFF"];
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0],[NSNumber numberWithInt:1.0], nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
    gradientLayer.frame = frame;
    
    return gradientLayer;
}


+(NSString *)capitalizedFirstLetterInString:(NSString*)string{
    
    
    NSString *newString = [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[string substringToIndex:1] capitalizedString]];
    
    return newString;
}


+(NSDateFormatter *)returnLocalFormatter{
    
    NSDateFormatter *dateFormatterA1 = [[NSDateFormatter alloc] init];
    [dateFormatterA1 setTimeZone:[NSTimeZone timeZoneWithName:@"America/Montreal"]];
    if ([Utils languageFr]) {
        
        [dateFormatterA1 setLocale:[NSLocale currentLocale]];
        
        
    }else{
        
        [dateFormatterA1 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        
    }
    
    return dateFormatterA1;
}

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize andImage:(UIImage *)sourceImage;
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


+ (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


+ (UIImage*)getFacebookProfilePictureData:(NSData *)newProfilePictureData {
    
    
    if (newProfilePictureData.length == 0) {
        NSLog(@"Profile picture did not download successfully.");
        return nil;
    }
    
    // The user's Facebook profile picture is cached to disk. Check if the cached profile picture data bondes the incoming profile picture. If it does, avoid uploading this data to Parse.
    
    NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]; // iOS Caches directory
    
    NSURL *profilePictureCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:@"FacebookProfilePicture.jpg"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[profilePictureCacheURL path]]) {
        // We have a cached Facebook profile picture
        
        NSData *oldProfilePictureData = [NSData dataWithContentsOfFile:[profilePictureCacheURL path]];
        
        if ([oldProfilePictureData isEqualToData:newProfilePictureData]) {
            NSLog(@"Cached profile picture bondes incoming profile picture. Will not update.");
            return nil;
        }
    }
    
    
    
    return [UIImage imageWithData:newProfilePictureData];
    
    
}


+(void)addBoldEffect:(UILabel *)label onText:(NSString *)text withPattern:(NSString*)pattern {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    //  enumerate bondes
    NSRange range = NSMakeRange(0,[text length]);
    
    [expression enumerateMatchesInString:text options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange jobRange = [result rangeAtIndex:0];
        [str addAttribute:NSFontAttributeName value:[UIFont HelveticaNeue:label.font.pointSize] range:jobRange];
        
        label.attributedText = str;

        
    }];
    
  
}

+(void)addBoldEffect:(UILabel *)label onText:(NSString *)text withPattern:(NSString*)pattern pattern2:(NSString *)pattern2 pattern3:(NSString *)pattern3{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSRegularExpression *expression2 = [NSRegularExpression regularExpressionWithPattern:pattern2 options:0 error:nil];
    NSRegularExpression *expression3 = [NSRegularExpression regularExpressionWithPattern:pattern3 options:0 error:nil];

    
    //  enumerate bondes
    NSRange range = NSMakeRange(0,[text length]);
    
    [expression enumerateMatchesInString:text options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange jobRange = [result rangeAtIndex:0];
        [str addAttribute:NSFontAttributeName value:[UIFont HelveticaNeue:label.font.pointSize] range:jobRange];
        
        
        [expression2 enumerateMatchesInString:text options:0 range:range usingBlock:^(NSTextCheckingResult *result2, NSMatchingFlags flags, BOOL *stop) {
            NSRange jobRange2 = [result2 rangeAtIndex:0];
            [str addAttribute:NSFontAttributeName value:[UIFont HelveticaNeue:label.font.pointSize] range:jobRange2];
            
            [expression3 enumerateMatchesInString:text options:0 range:range usingBlock:^(NSTextCheckingResult *result3, NSMatchingFlags flags, BOOL *stop) {
                NSRange jobRange3 = [result3 rangeAtIndex:0];
                [str addAttribute:NSFontAttributeName value:[UIFont HelveticaNeue:label.font.pointSize] range:jobRange3];
                label.attributedText = str;
                
            }];
            
        }];

        
    }];
    
    
}


+ (NSDate *)dateToTimeZone:(NSTimeZone *)toTimeZone fromTimeZone:(NSTimeZone *)fromTimeZone fromDate:(NSDate *)date{
    
    NSInteger fromTimeZoneSeconds = [fromTimeZone secondsFromGMTForDate:date];
    NSInteger toTimeZoneSeconds = [toTimeZone secondsFromGMTForDate:date];
    

    NSInteger timeZonesDiff = fromTimeZoneSeconds - toTimeZoneSeconds ;
    

    
    return [[NSDate alloc] initWithTimeInterval:timeZonesDiff sinceDate:date];
}




+ (void) buzzAnimation:(UIView*)view {
    //    CABasicAnimation* rotationAnimation;
    //    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations ];
    //    rotationAnimation.duration = duration;
    //    rotationAnimation.cumulative = YES;
    //    rotationAnimation.repeatCount = repeat ? HUGE_VALF : 0;
    //
    //    NSLog(@"rotatiooo");
    //    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    //
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:6];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([view center].x - 4.0f, [view center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([view center].x + 4.0f, [view center].y)]];
    [[view layer] addAnimation:animation forKey:@"position"];
    
}


+ (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat ? HUGE_VALF : 0;

    NSLog(@"rotatiooo");
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];


}

@end
