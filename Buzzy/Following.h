//
//  Following.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-31.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base.h"


@interface Following : NSObject

+(Following*)sharedInstance;


@property(nonatomic)NSMutableArray *following;

-(void)updateFollowingCompletion:(void (^) (BOOL succeeded))completion;



@end
