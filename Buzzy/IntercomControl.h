//
//  Intercom.h
//  BottleBond
//
//  Created by Julien Levallois on 17-02-02.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import "Utils.h"
#import "Intercom/intercom.h"

@interface IntercomControl : NSObject

+(IntercomControl*)sharedInstance;


-(void)intercomReset;
- (void)loginIntercomWithId:(NSString *)objectId;

-(void)intercomSetUserData;

-(void)updateIntercomAttribute:(NSString *)attribute withvalue:(NSString *)value;

-(void)setIntercomEvent:(NSString *)tag;

-(void)setIntercomEvent:(NSString *)tag properties:(NSDictionary *)dictionary;


@end
