//
//  MMStylesheet.m
//  Memo
//
//  Created by Dany L'Hebreux on 2014-02-21.
//  Copyright (c) 2014 Mirego. All rights reserved.
//

#import "Stylesheet.h"
#import <MCUIColorUtils/UIColor+MCUIColorsUtils.h>

@implementation Stylesheet

@end

@implementation UIColor (Stylesheet)




+ (UIColor *)orangeBuzzy {
    //    return [UIColor colorForHex:@"052B57"];
    
//    return [UIColor colorForHex:@"FF8704"];
    return [UIColor colorForHex:@"F54353"];

}

+ (UIColor *)orangeLikedBuzzy {
    //    return [UIColor colorForHex:@"052B57"];
    
//    return [UIColor colorForHex:@"E86C0C"];
    return [UIColor colorForHex:@"C60618"];

}



+ (UIColor *)redLikedBuzzy {
    //    return [UIColor colorForHex:@"052B57"];
    
    return [UIColor colorForHex:@"C60618"];
    
}

+ (UIColor *)redBuzzy {
    //    return [UIColor colorForHex:@"052B57"];
    
    return [UIColor colorForHex:@"F54353"];
    
}



+ (UIColor *)yellowBuzzy {
    //    return [UIColor colorForHex:@"052B57"];
    
    return [UIColor colorForHex:@"FFC108"];
    
}

+ (UIColor *)yellowLikedBuzzy {
    //    return [UIColor colorForHex:@"052B57"];
    
    return [UIColor colorForHex:@"F29F00"];
    
}



/////
/////





@end

@implementation UIFont (Stylesheet)


+ (UIFont *)BerkshireSwash:(CGFloat)size {
    return [UIFont fontWithName:@"BerkshireSwash-Regular" size:size];
}



+ (UIFont *)HelveticaNeue:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue" size:size];

}

+ (UIFont *)HelveticaNeueMedium:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *)HelveticaNeueLight:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];

}

+ (UIFont *)HelveticaNeueBold:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];

}

+ (UIFont *)Avenir:(CGFloat)size {
    return [UIFont fontWithName:@"Avenir-Medium" size:size];
}


@end

