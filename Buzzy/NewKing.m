//
//  NewKing.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "NewKing.h"

@implementation NewKing

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        ///// 58 234
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.90];
        self.hidden = YES;
        
       
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(hide)];
        [self addGestureRecognizer:singleFingerTap];
        
        
        self.picture = [[PFImageView alloc]initWithFrame:CGRectMake((largeurIphone-160)/2, (hauteurIphone-160)/2-70, 160,160)];
        self.picture.layer.cornerRadius = 80;
        self.picture.layer.masksToBounds = YES;
        self.picture.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.picture];
        
        

        
        self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(self.picture.frame.origin.x-4, self.picture.frame.origin.y-4, self.picture.frame.size.width+8, self.picture.frame.size.height+8)];
        self.progressView.roundedCorners = YES;
        self.progressView.trackTintColor = [UIColor clearColor];
        [self.progressView setProgressTintColor:[UIColor yellowBuzzy]];
        [self.progressView setThicknessRatio:0.08f];
        
        [self addSubview:self.progressView];
        
        
        
        
        self.title =[[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, self.picture.frame.origin.y + self.picture.frame.size.height+40, largeurIphone, 30)];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = [UIColor whiteColor];
        self.title.numberOfLines = 2;
        self.title.font =[UIFont BerkshireSwash:20];
        [self addSubview:self.title];
        
        
        self.titleName =[[UILabel alloc]initWithFrame:CGRectMake(0, self.title.frame.origin.y + self.title.frame.size.height, largeurIphone, 60)];
        self.titleName.textAlignment = NSTextAlignmentCenter;
        self.titleName.textColor = [UIColor whiteColor];
        self.titleName.numberOfLines = 2;
        self.titleName.font =[UIFont BerkshireSwash:35];
        [self addSubview:self.titleName];
        
        
        self.likeImg =[[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone-16)/2, hauteurIphone-110, 16, 16)];
        self.likeImg.image =[UIImage imageNamed:@"like"];
        [self addSubview:self.likeImg];
        
        self.like = [[UILabel alloc]initWithFrame:CGRectMake(0, hauteurIphone -85, largeurIphone, 20)];
        self.like.textAlignment = NSTextAlignmentCenter;
        self.like.font =[UIFont BerkshireSwash:20];
        self.like.textColor  = [UIColor whiteColor];
        [self addSubview:self.like];
        
        
        self.couronneKing =[[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone-64)/2, self.picture.frame.origin.y-80, 64, 57)];
        self.couronneKing.image = [UIImage imageNamed:@"couronneKing"];
        [self addSubview:self.couronneKing];
        

        
    }
    return self;
}



-(void)showWithBuzz:(PFObject *)buzz andType:(NSString *)type{
    
    
    
    
    
    NSLog(@"type ::: %@",type);
    
    

    
    
    self.picture.file = [[buzz objectForKey:kBuzzUser] objectForKey:kUserProfilePicture];
    [self.picture loadInBackground];
    
    if ([buzz objectForKey:kBuzzLikeNumber]) {
        
        
        self.like.text = [NSString stringWithFormat:@"%d",[[buzz objectForKey:kBuzzLikeNumber]intValue]];
        
        
    }
    
    
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:buzz[kBuzzWhen]];
    
    float progress = 1-(secondsBetween / ( 24 * 60 * 60));
    
    [self.progressView setProgress:progress animated:NO];

    
    NSString *king = NSLocalizedString(@"King",nil);
    
    
    NSString *hasANew = NSLocalizedString(@"%@ has a new1 %@", nil);

    if ([buzz[kBuzzUser] objectForKey:kUserGender]) {
        
        
        if ([[buzz[kBuzzUser] objectForKey:kUserGender] isEqualToString:@"female"]) {
            
            
            king = NSLocalizedString(@"Queen", nil);
            hasANew = NSLocalizedString(@"%@ has a new2 %@", nil);
            
        }
    }

    
    
    
    
    
    if ([[buzz objectForKey:kBuzzKingCountry] isEqual:@YES] && [type isEqualToString:@"Country"]){
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:[NSString stringWithFormat:@"KingCountry%@-%d",buzz.objectId,[buzz[kBuzzKingNumber] intValue]]];
        
        
        if ([Utils languageFr]) {
            
            [self.title setText:[NSString stringWithFormat:hasANew, [[buzz objectForKey:kBuzzCountry] objectForKey:kCountryNameFr],king] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange range = [[mutableAttributedString string] rangeOfString:[[buzz objectForKey:kBuzzCountry] objectForKey:kCountryNameFr] options:NSCaseInsensitiveSearch];
                
                UIFont *customSize = [UIFont BerkshireSwash:30];
                
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)customSize.fontName, customSize.pointSize, NULL);
                if (font) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                    
                    CFRelease(font);
                }
                
                return mutableAttributedString;
            }];
            
            
            
            if ([[buzz objectForKey:kBuzzCountry] objectForKey:kCountryIconFr]) {
                
                
                
                [self.title setText:[NSString stringWithFormat:hasANew, [[buzz objectForKey:kBuzzCountry] objectForKey:kCountryIconFr],king] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    NSRange range = [[mutableAttributedString string] rangeOfString:[[buzz objectForKey:kBuzzCountry] objectForKey:kCountryIconFr] options:NSCaseInsensitiveSearch];
                    
                    UIFont *customSize = [UIFont BerkshireSwash:30];
                    
                    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)customSize.fontName, customSize.pointSize, NULL);
                    if (font) {
                        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                        
                        CFRelease(font);
                    }
                    
                    return mutableAttributedString;
                }];
                
                
                
            }
            
            
            
        }else{
            
            
            
            [self.title setText:[NSString stringWithFormat:hasANew, [[buzz objectForKey:kBuzzCountry] objectForKey:kCountryName],king] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange range = [[mutableAttributedString string] rangeOfString:[[buzz objectForKey:kBuzzCountry] objectForKey:kCountryName] options:NSCaseInsensitiveSearch];
                
                UIFont *customSize = [UIFont BerkshireSwash:30];
                
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)customSize.fontName, customSize.pointSize, NULL);
                if (font) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                    
                    CFRelease(font);
                }
                
                return mutableAttributedString;
            }];
            
            
            
            if ([[buzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon]) {
                
                NSLog(@"Avec icon!!!");
                
                [self.title setText:[NSString stringWithFormat:hasANew, [[buzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon],king] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    NSRange range = [[mutableAttributedString string] rangeOfString:[[buzz objectForKey:kBuzzCountry] objectForKey:kCountryIcon] options:NSCaseInsensitiveSearch];
                    
                    UIFont *customSize = [UIFont BerkshireSwash:30];
                    
                    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)customSize.fontName, customSize.pointSize, NULL);
                    if (font) {
                        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                        
                        CFRelease(font);
                    }
                    
                    return mutableAttributedString;
                }];
                
                
                
            }
            
            
        }
        
        
        
        

        
    }else if ([[buzz objectForKey:kBuzzKingCity] isEqual:@YES] && [type isEqualToString:@"City"]){
        
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:[NSString stringWithFormat:@"KingCity%@-%d",buzz.objectId,[buzz[kBuzzKingNumber] intValue]]];
        
        
        if ([Utils languageFr]) {
            
            [self.title setText:[NSString stringWithFormat:hasANew, [[buzz objectForKey:kBuzzCity] objectForKey:kCityNameFr],king] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange range = [[mutableAttributedString string] rangeOfString:[[buzz objectForKey:kBuzzCity] objectForKey:kCityNameFr] options:NSCaseInsensitiveSearch];
                
                UIFont *customSize = [UIFont BerkshireSwash:30];
                
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)customSize.fontName, customSize.pointSize, NULL);
                if (font) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                    
                    CFRelease(font);
                }
                
                return mutableAttributedString;
            }];
            
            
        }else{
            
            [self.title setText:[NSString stringWithFormat:hasANew, [[buzz objectForKey:kBuzzCity] objectForKey:kCityName],king] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange range = [[mutableAttributedString string] rangeOfString:[[buzz objectForKey:kBuzzCity] objectForKey:kCityName] options:NSCaseInsensitiveSearch];
                
                UIFont *customSize = [UIFont BerkshireSwash:30];
                
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)customSize.fontName, customSize.pointSize, NULL);
                if (font) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                    
                    CFRelease(font);
                }
                
                return mutableAttributedString;
            }];
            
        }
        
        
        
        
        
        
        
        if ([[buzz objectForKey:kBuzzCity] objectForKey:kCityIcon]) {
            
            
            
            [self.title setText:[NSString stringWithFormat:hasANew, [[buzz objectForKey:kBuzzCity] objectForKey:kCityIcon],king] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange range = [[mutableAttributedString string] rangeOfString:[[buzz objectForKey:kBuzzCity] objectForKey:kCityIcon] options:NSCaseInsensitiveSearch];
                
                UIFont *customSize = [UIFont BerkshireSwash:30];
                
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)customSize.fontName, customSize.pointSize, NULL);
                if (font) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                    
                    CFRelease(font);
                }
                
                return mutableAttributedString;
            }];
            
            
            
            
        }
        
        
    }else if ([[buzz objectForKey:kBuzzKingUniversity] isEqual:@YES] && [type isEqualToString:@"University"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:[NSString stringWithFormat:@"KingUniversity%@-%d",buzz.objectId,[buzz[kBuzzKingNumber] intValue]]];
        
        if ([Utils languageFr]) {
            
            [self.title setText:[NSString stringWithFormat:hasANew, [[buzz objectForKey:kBuzzUniversity] objectForKey:kUniversityNameFr],king] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange range = [[mutableAttributedString string] rangeOfString:[[buzz objectForKey:kBuzzUniversity] objectForKey:kUniversityName] options:NSCaseInsensitiveSearch];
                
                UIFont *customSize = [UIFont BerkshireSwash:30];
                
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)customSize.fontName, customSize.pointSize, NULL);
                if (font) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                    
                    CFRelease(font);
                }
                
                return mutableAttributedString;
            }];
            
            
        }else{
            
            [self.title setText:[NSString stringWithFormat:hasANew, [[buzz objectForKey:kBuzzUniversity] objectForKey:kUniversityName],king] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange range = [[mutableAttributedString string] rangeOfString:[[buzz objectForKey:kBuzzUniversity] objectForKey:kUniversityName] options:NSCaseInsensitiveSearch];
                
                UIFont *customSize = [UIFont BerkshireSwash:30];
                
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)customSize.fontName, customSize.pointSize, NULL);
                if (font) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                    
                    CFRelease(font);
                }
                
                return mutableAttributedString;
            }];
            
            
        }
        
        
        if ([[buzz objectForKey:kBuzzUniversity] objectForKey:kUniversityIcon]) {
            
            
            
            
            [self.title setText:[NSString stringWithFormat:hasANew, [[buzz objectForKey:kBuzzUniversity] objectForKey:kUniversityIcon],king] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange range = [[mutableAttributedString string] rangeOfString:[[buzz objectForKey:kBuzzUniversity] objectForKey:kUniversityIcon] options:NSCaseInsensitiveSearch];
                
                UIFont *customSize = [UIFont BerkshireSwash:30];
                
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)customSize.fontName, customSize.pointSize, NULL);
                if (font) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
                    
                    CFRelease(font);
                }
                
                return mutableAttributedString;
            }];
            
            
        }

        
    }
    

    
   
    
    
    self.titleName.text = [Utils capitalizedFirstLetterInString:[NSString stringWithFormat:@"%@",[[buzz objectForKey:kBuzzUser] objectForKey:kUserFirstName ] ]];

    
    
    self.alpha = 1;
    self.hidden = NO;
    
//    [self performSelector:@selector(hide) withObject:nil afterDelay:2.5];
    
}

-(void)hide{
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    
    self.alpha = 1;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        self.alpha = 1;

        
    }];
    
    
}


@end
