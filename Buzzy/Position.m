//
//  Position.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-24.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "Position.h"

@implementation Position


+(Position*)sharedInstance
{
    // 1
    static Position *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Position alloc] init];
    });
    return _sharedInstance;
}


- (id)init{
    
    
    self = [super init];
    if (self) {
        
             
        
    }
    return self;
}

-(void)updatePositionCompletion:(void (^) (BOOL succeeded))completion{
    
    
//    
//    NSLog(@"A");
//    
//    PFQuery *currentCountry = [PFQuery queryWithClassName:kCountryClasseName];
//    [currentCountry whereKey:@"objectId" equalTo:@"Bl370sUzox"];
//    [currentCountry getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable country, NSError * _Nullable error) {
//       
//        NSLog(@"B");
//        self.currentCountry = country;
//
//        PFQuery *currentCountry = [PFQuery queryWithClassName:kCityClasseName];
//        [currentCountry whereKey:@"objectId" equalTo:@"ttP53RfCLU"];
//        [currentCountry getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable city, NSError * _Nullable error) {
//            
//            NSLog(@"C");
//            
//            self.currentCity = city;
////
////            PFQuery *currentUniv = [PFQuery queryWithClassName:kUniversityClasseName];
////            [currentUniv whereKey:@"objectId" equalTo:@"pGCB2Xe6Ph"];
////            [currentUniv getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable univ, NSError * _Nullable error) {
////                
////                NSLog(@"C");
//            
//                self.currentUniversity = nil;
//                completion(YES);
//                
//                
////            }];
//
//            
//        }];
//
//        
//        
//    }];
//
//    
//    return;
    
    
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint * _Nullable geoPoint, NSError * _Nullable error) {
       
        //geoPoint.latitude = 51.384800;
        //geoPoint.longitude = 0.151080;

        self.currentPosition = geoPoint;
        
        NSLog(@"curent geopoint : %@",self.currentPosition);
        
        PFQuery *currentCountry = [PFQuery queryWithClassName:kCountryClasseName];
        [currentCountry whereKey:kCountryAvailable equalTo:@YES];
        [currentCountry includeKey:kCountryArea];
        [currentCountry findObjectsInBackgroundWithBlock:^(NSArray * _Nullable countries, NSError * _Nullable error) {

            
                self.countries = [[NSMutableArray alloc]initWithArray:countries];
                self.currentCountry = nil;
                for (int i = 0; i<self.countries.count; i++) {
                    
                    PFObject *country = [self.countries objectAtIndex:i];
                    PFObject *area = [country objectForKey:kCountryArea];
                    NSArray *location = [area objectForKey:kLocationLocation];
                    
                    if ([self isPointContained:CGPointMake(self.currentPosition.latitude, self.currentPosition.longitude) array:location]) {
                        
                        self.currentCountry = country;
                        
                        [PFInstallation currentInstallation][@"country"]=self.currentCountry;
                        
                    }
                    
                }
                
            
                if(self.currentCountry == NULL){

                    self.currentCity= nil;
                    self.currentUniversity= nil;
                    self.currentCountry= nil;
                    
                    [[PFInstallation currentInstallation]removeObjectForKey:@"country"];
                    [[PFInstallation currentInstallation]removeObjectForKey:@"city"];
                    [[PFInstallation currentInstallation]removeObjectForKey:@"university"];

                    [[PFInstallation currentInstallation]saveInBackground];
                    
                    completion(YES);

                }else{

                    
                        ///Next
                        PFQuery *currentCity = [PFQuery queryWithClassName:kCityClasseName];
                        [currentCity whereKey:kCityAvailable equalTo:@YES];
                        [currentCity whereKey:kCityCountry equalTo:self.currentCountry];
                        [currentCity includeKey:kCityArea];
                        [currentCity findObjectsInBackgroundWithBlock:^(NSArray * _Nullable countries, NSError * _Nullable error) {
                            
                                self.cities = [[NSMutableArray alloc]initWithArray:countries];
                                self.currentCity = nil;

                                for (int i = 0; i<self.cities.count; i++) {
                                    
                                    PFObject *city = [self.cities objectAtIndex:i];
                                    PFObject *area = [city objectForKey:kCountryArea];
                                    NSArray *location = [area objectForKey:kLocationLocation];
                                    
                                    if ([self isPointContained:CGPointMake(self.currentPosition.latitude, self.currentPosition.longitude) array:location]) {
                                        
                                        self.currentCity = city;
                                        
                                        [PFInstallation currentInstallation][@"city"]=self.currentCountry;

                                    }
                                    
                                }
                                
                                if (self.currentCity == NULL) {
                                    
                                    self.currentCity= nil;
                                    self.currentUniversity= nil;
                                   
                                    [[PFInstallation currentInstallation]removeObjectForKey:@"city"];
                                    [[PFInstallation currentInstallation]removeObjectForKey:@"university"];
                                    
                                    [[PFInstallation currentInstallation]saveInBackground];
                    
                                    
                                    completion(YES);

                                }else{
                                    
                                    
                                    
                                    ///Next
                                    PFQuery *currentCampus = [PFQuery queryWithClassName:kCampusClasseName];
                                    [currentCampus whereKey:kCampusAvailable equalTo:@YES];
                                    [currentCampus whereKey:kCampusCity equalTo:self.currentCity];
                                    [currentCampus includeKey:kCampusArea];
                                    [currentCampus findObjectsInBackgroundWithBlock:^(NSArray * _Nullable campus, NSError * _Nullable error) {
                                        
                                        self.campus = [[NSMutableArray alloc]initWithArray:campus];
                                        self.currentUniversity = nil;
                                        
                                        for (int i = 0; i<self.campus.count; i++) {
                                            
                                            PFObject *campus = [self.campus objectAtIndex:i];
                                            PFObject *area = [campus objectForKey:kCampusArea];
                                            NSArray *location = [area objectForKey:kLocationLocation];
                                            
                                            if ([self isPointContained:CGPointMake(self.currentPosition.latitude, self.currentPosition.longitude) array:location]) {
                                                
                                                self.currentUniversity =[campus objectForKey:kCampusUniversity];
                                                
                                                [PFInstallation currentInstallation][@"university"]=self.currentCountry;

                                            }
                                            
                                        }
                                        
                                        if (self.currentUniversity == NULL) {
                                            
                                            
                                            [[PFInstallation currentInstallation]removeObjectForKey:@"university"];
                                            
                                            
                                        }
                                        
                                        [[PFInstallation currentInstallation]saveInBackground];

                                        completion(YES);

                                        
                                    }];

                                    
                                    
                                    
                                    
                                    
                                }
                      
                        
                        
                        
                        }];
                
               
                
                }
                
                
            
            
        }];
        
    }];
}

- (BOOL)isPointContained:(CGPoint)point array:(NSArray*)array
{
    BOOL result = NO;
    
    int i = 0;
    int j = (int)array.count - 1;
    
    for (; i < array.count; j = i++) {
        

        CGPoint iPoint = CGPointMake([[[array objectAtIndex:i] objectAtIndex:0] floatValue],[[[array objectAtIndex:i] objectAtIndex:1] floatValue]);
        CGPoint jPoint = CGPointMake([[[array objectAtIndex:j] objectAtIndex:0] floatValue],[[[array objectAtIndex:j] objectAtIndex:1] floatValue]);
        
        
        if (((iPoint.y > point.y) != (jPoint.y > point.y)) && (point.x < (jPoint.x - iPoint.x) * (point.y - iPoint.y) / (jPoint.y - iPoint.y) + iPoint.x))
            result = !result;
    }
    return result;
}



@end
