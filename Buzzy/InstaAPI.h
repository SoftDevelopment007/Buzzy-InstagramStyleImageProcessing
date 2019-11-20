//
//  InstaAPI.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-21.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base.h"


@interface InstaAPI : NSObject

+(InstaAPI*)sharedInstance;

@property(nonatomic)NSMutableArray *followers;


@end
