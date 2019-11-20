//
//  Constant.h
//  Buzzy
//
//  Created by Julien Levallois on 2015-04-01.
//  Copyright (c) 2015 Memo App. All rights reserved.
//


#ifndef Buzzy_Constants_h
#define Buzzy_Constants_h



#pragma mark - Largeur device 

#define largeurIphone [[UIScreen mainScreen]bounds].size.width
#define hauteurIphone [[UIScreen mainScreen]bounds].size.height
#define degreesToRadians(x) (M_PI * x / 180.0)


#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height-812)?NO:YES)




#define kCorrespondanceKMDecimalGPS                       0.00833333 /// 60m

#define appPlayLoading        [(AppDelegate*)[[UIApplication sharedApplication] delegate] playLoading]
#define appStopLoading        [(AppDelegate*)[[UIApplication sharedApplication] delegate] stopLoading]
#define appRegistredPush        [(AppDelegate*)[[UIApplication sharedApplication] delegate] registredPush]

#define appLogout        [(AppDelegate*)[[UIApplication sharedApplication] delegate] logout]

#define appRefreshTableViewGroup        [(AppDelegate*)[[UIApplication sharedApplication] delegate] refreshTableViewGroup]
#define appRefreshTableViewBond        [(AppDelegate*)[[UIApplication sharedApplication] delegate] refreshTableViewBond]





#define kConfigTerms                             @"TermsUrl"
#define kConfigPrivacy                            @"PrivacyUrl"
#define kConfigIdApp                                @"idApp"

#define KConfigShareText                            @"shareText"
#define KConfigShareTextFr                            @"shareTextFr"
#define KConfigShareUrl                            @"shareUrl"

#define KConfigDefaultLevelZoomMap                           @"defaultLevelZoomMap"
#define KConfigMaxLevelZoomMap                            @"maxLevelZoomMap"
#define KConfigMinLevelZoomMap                            @"minLevelZoomMap"


//// Followers

#define kFollowersClasseName                                @"Followers"

#define kFollowersFrom                                 @"from"
#define kFollowersTo                                 @"to"


//// User

#define kUserClasseName                                     @"_User"

#define kUserProfilePicture                                 @"profilePicture"
#define kUserFirstName                                 @"instaUsername"
#define kUserInstaUsername                                @"instaUsername"
#define kUserIdInsta                                @"idInsta"
#define kUserGender                                @"gender"
#define kUserLanguage                                @"language"



//// Buzz

#define kBuzzClasseName                                     @"Buzz"
#define kBuzzUser                                           @"user"
#define kBuzzCity                                           @"city"
#define kBuzzUniversity                                     @"university"
#define kBuzzCountry                                           @"country"
#define kBuzzPhoto                                          @"photo"
#define kBuzzVideo                                          @"video"
#define kBuzzLocation                                       @"location"
#define kBuzzWhen                                           @"when"
#define kBuzzLike                                           @"like"
#define kBuzzLikeDate                                           @"likeDate"
#define kBuzzView                                           @"view"
#define kBuzzScreenShot                                     @"screenShot"
#define kBuzzDescription                                    @"description"
#define kBuzzDuration                                       @"duration"
#define kBuzzStreet                                         @"street"
#define kBuzzKingUniversity                                 @"kingUniversity"
#define kBuzzKingCity                                           @"kingCity"
#define kBuzzKingCountry                                           @"kingCountry"
#define kBuzzLikeNumber                                           @"likeNumber"
#define kBuzzKingNumber                                           @"kingNumber"
#define kBuzzDeleted                                           @"deleted"
#define kBuzzMessageNumber                                           @"messageNumber"
#define kBuzzInstaUsername                                           @"instaUsername"

//// University

#define kUniversityClasseName                                     @"University"
#define kUniversityName                                           @"name"
#define kUniversityNameFr                                           @"nameFr"
#define kUniversityCity                                           @"city"
#define kUniversityAvailable                                         @"available"
#define kUniversityIcon                                        @"icon"


/// Campus

#define kCampusClasseName                                     @"Campus"
#define kCampusName                                     @"name"
#define kCampusLocation                                     @"location"
#define kCampusUniversity                                     @"university"
#define kCampusAvailable                                    @"available"
#define kCampusArea                                        @"area"
#define kCampusCity                                        @"city"
#define kCampusFlag                                        @"flag"


//// City

#define kCityClasseName                                     @"City"
#define kCityName                                           @"name"
#define kCityNameFr                                           @"nameFr"
#define kCityCountry                                          @"country"
#define kCityAvailable                                         @"available"
#define kCityLocation                                         @"location"
#define kCityIcon                                        @"icon"
#define kCityArea                                        @"area"
#define kCityFlag                                        @"flag"


//// Country

#define kCountryClasseName                                     @"Country"
#define kCountryName                                           @"name"
#define kCountryNameFr                                           @"nameFr"

#define kCountryAvailable                                         @"available"
#define kCountryLocation                                         @"location"
#define kCountryIcon                                        @"icon"
#define kCountryIconFr                                        @"iconFr"
#define kCountryArea                                        @"area"
#define kCountryFlag                                        @"flag"

#define kCountryCenter                                        @"center"

//// Comments


#define kCommentClasseName                                     @"Comment"
#define kCommentMessage                                         @"message"
#define kCommentUser                                         @"user"
#define kCommentBuzz                                         @"buzz"


/// Location

#define kLocationClasseName             @"Location"
#define kLocationLocation               @"location"



#endif
