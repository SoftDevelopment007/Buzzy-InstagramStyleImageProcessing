//
//  Position.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-24.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base.h"


@interface Position : NSObject

+(Position*)sharedInstance;

@property(nonatomic)PFObject *currentCountry;
@property(nonatomic)PFObject *currentCity;
@property(nonatomic)PFObject *currentUniversity;

@property(nonatomic)NSMutableArray *countries;
@property(nonatomic)NSMutableArray *cities;
@property(nonatomic)NSMutableArray *campus;

@property(nonatomic)PFGeoPoint *currentPosition;

-(void)updatePositionCompletion:(void (^) (BOOL succeeded))completion;



@end
