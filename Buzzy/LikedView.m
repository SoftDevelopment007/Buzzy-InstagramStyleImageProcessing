//
//  LikedView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-06-27.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "LikedView.h"
#import "Following.h"
#import "AppDelegate.h"


@implementation LikedView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        ///// 58 234
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.95];
        self.hidden = YES;
        
        
        
        
        self.indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(19, 19, 40, 40)];
        self.indicator.hidesWhenStopped=YES;
        [self addSubview:self.indicator];
        
        
        self.logoEmpty =[[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone-57)/2, (hauteurIphone-77)/2, 57, 77)];
        self.logoEmpty.image =[UIImage imageNamed:@"logoEmpty"];
        self.logoEmpty.hidden = YES;
        [self addSubview:self.logoEmpty];
        
        
        self.containerTableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        [self addSubview:self.containerTableView];
        
//        
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.containerTableView.bounds;
//        gradient.colors = @[(id)[UIColor clearColor].CGColor,
//                            (id)[UIColor blackColor].CGColor,
//                            (id)[UIColor blackColor].CGColor,
//                            (id)[UIColor clearColor].CGColor];
//        gradient.locations = @[@0.0, @0.20, @0.80, @1.0];
//        self.containerTableView.layer.mask = gradient;
         
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 80)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 200)];
        [self.containerTableView addSubview:self.tableView];

        if (IS_IPHONEX) {
            
            self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 75+25)];
            
        }else{
            
            self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 75)];
            
        }        self.navBar.backgroundColor =[UIColor blackColor];
        [self addSubview:self.navBar];
        
        
        self.btnClose = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-50-14, 14, 50, 50)];
        [self.btnClose setBackgroundImage:[UIImage imageNamed:@"btnCancel"] forState:UIControlStateNormal];
        [self.btnClose addTarget:self action:@selector(actionBtnClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnClose];
        
//        self.btnPlay = [[UIButton alloc]initWithFrame:CGRectMake(14, 14, 50, 50)];
//        [self.btnPlay setBackgroundImage:[UIImage imageNamed:@"btnPlay"] forState:UIControlStateNormal];
//        [self.btnPlay addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];
//        self.btnPlay.hidden = YES;
//        [self addSubview:self.btnPlay];
        

        


        if (IS_IPHONEX) {
            
            self.titlePage = [[UILabel alloc]initWithFrame:CGRectMake(0, 25+30, largeurIphone, 23)];
            
        }else{
            
            self.titlePage = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, largeurIphone, 23)];
            
        }        self.titlePage.textAlignment = NSTextAlignmentCenter;
        self.titlePage.font = [UIFont HelveticaNeue:20];
        self.titlePage.textColor = [UIColor whiteColor];
        self.titlePage.text = NSLocalizedString(@"Liked", nil);
        [self addSubview:self.titlePage];
        
        

        
        
    }
    return self;
}


-(void)actionPlay{

}

#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return self.buzzs.count;
}

// the cell will be returned to the tableView
- (BuzzTableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BuzzCell";
    
    // Similar to UITableViewCell, but
    BuzzTableViewCell *cell = (BuzzTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[BuzzTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.picture.file = [[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUser] objectForKey:kUserProfilePicture];
    [cell.picture loadInBackground];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      
        if (self.buzzs.count > indexPath.row) {

        cell.content = [[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzPhoto];
        [cell.content getDataInBackground];
            
        }
    });
    
    cell.btnInsta.hidden = NO;
    cell.btnInsta.tag = indexPath.row;
    
    
    [cell.btnInsta addTarget:self action:@selector(yourButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    cell.buzz = [self.buzzs objectAtIndex:indexPath.row];
    
    
    
    cell.name.text = [[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUser] objectForKey:kUserFirstName];
    
    
    if ([Utils languageFr]) {
        
        
        if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUniversity]) {
            
            cell.distance.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUniversity] objectForKey:kUniversityNameFr]];

        }else if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCity]){
            
            cell.distance.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCity] objectForKey:kCityNameFr]];

        }else if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry]){
            
            cell.distance.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryNameFr]];

        }

    }else{
        
        if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUniversity]) {
            
            cell.distance.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUniversity] objectForKey:kUniversityName]];
            
        }else if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCity]){
            
            cell.distance.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCity] objectForKey:kCityName]];
            
        }else if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry]){
            
            cell.distance.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryName]];
            
        }

        
    }
    
    
    cell.friendsLogo.hidden = YES;

    NSArray *likes = [[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzLike];
    
    
    cell.like.text = [NSString stringWithFormat:@"%lu",(unsigned long)likes.count];
    
    if (likes.count > 9) {
        
        
        cell.friendsLogo.frame = CGRectMake(largeurIphone-12-68-8, 62+3+7, 16, 16);
        
        
    }else if (likes.count > 99){
        
        cell.friendsLogo.frame = CGRectMake(largeurIphone-12-68-8-8, 62+3+7, 16, 16);
        
    }else if (likes.count > 999){
        
        cell.friendsLogo.frame = CGRectMake(largeurIphone-12-68-8-8-8, 62+3+7, 16, 16);
        
    }else{
        
        cell.friendsLogo.frame = CGRectMake(largeurIphone-12-68, 62+3+7, 16, 16);
        
    }
    
    
    
//    if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]] && ![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"seeLiked-%@",cell.buzz.objectId]]){
    if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){

        
        cell.friendsLogo.hidden = NO;

    }else{
        
        cell.friendsLogo.hidden = YES;

    }


    
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:[self.buzzs objectAtIndex:indexPath.row] [kBuzzWhen]];

    float progress = 1-(secondsBetween / ( 24 * 60 * 60));
    
    [cell.progressView setProgress:progress animated:NO];

    
    if ([self.buzzs objectAtIndex:indexPath.row] [kBuzzKingCity]  || [self.buzzs objectAtIndex:indexPath.row] [kBuzzKingUniversity] || [self.buzzs objectAtIndex:indexPath.row] [kBuzzKingCountry]  ) {
        
        [cell.progressView setProgressTintColor:[UIColor yellowBuzzy]];

    }else if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){
      
        [cell.progressView setProgressTintColor:[UIColor redBuzzy]];
        
    }else{
        
        [cell.progressView setProgressTintColor:[UIColor orangeBuzzy]];
    }
    

    
    
    if ([cell.buzz[@"tutoriel"] isEqual:@YES]) {
        
        
        if ([cell.buzz[@"fakeKing"] isEqual:@YES]) {
            
            [cell.progressView setProgress:0.7];
            [cell.progressView setProgressTintColor:[UIColor yellowBuzzy]];

        }else{
            
            [cell.progressView setProgress:0.3];
            [cell.progressView setProgressTintColor:[UIColor redBuzzy]];

        }
        
        if ([Utils languageFr]) {
            
            cell.distance.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:@"fakeCountry"] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:@"fakeCountry"] objectForKey:kCountryNameFr]];
            
        }else{
            
            cell.distance.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:@"fakeCountry"] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:@"fakeCountry"] objectForKey:kCountryName]];
            
        }
        
    }

    
    return cell;
}


-(void)yourButtonClicked:(UIButton*)sender{
    
    
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@",[self.buzzs objectAtIndex:sender.tag][kBuzzUser][kUserInstaUsername]]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
        
    }else{
        
        
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 100;
    
}




#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.delegate) {
        
//        PFObject *buzz = [self.buzzs objectAtIndex:indexPath.row];
        
//        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:[NSString stringWithFormat:@"seeLiked-%@",buzz.objectId]];
        
        [self.delegate launchBuzz:[self.buzzs objectAtIndex:indexPath.row] pretendantType:NO fromLiked:YES];
        
//        [self.tableView reloadData];
        
    }

}


-(NSString *)getDistance:(PFGeoPoint *)buzzLocation andCurrentLocation:(PFGeoPoint *)currentLocation{
    
    
    CLLocation *location1 = [[CLLocation alloc]
                             initWithLatitude:buzzLocation.latitude
                             longitude:buzzLocation.longitude];
    
    CLLocation *location2 = [[CLLocation alloc]
                             initWithLatitude:currentLocation.latitude
                             longitude:currentLocation.longitude];
    
    
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    
    
    return [self stringWithDistance:distance];
    
}


- (NSString *)stringWithDistance:(double)distance {
    
    NSString *format;
   
    if (distance < 130) {
        
        return NSLocalizedString(@"0-100m",nil);
        
    }else if (distance < 1000) {
        format = @"%@m";
    } else {
        format = @"%@km";
        distance = distance / 1000;
    }
    
    return [NSString stringWithFormat:format, [self stringWithDouble:distance]];
}

// Return a string of the number to one decimal place and with commas & periods based on the locale.
- (NSString *)stringWithDouble:(double)value {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:0];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
}





-(void)actionBtnClose{
    
    [self hide];
    
}






-(void)showWithCurrentLocation:(PFGeoPoint *)currentLocation{
    
    
    self.currentLocation = currentLocation;
    
    if (self.buzzs.count == 0) {
        
        [self.indicator startAnimating];

    }
    
    [self refreshData];
    
    
    
    self.hidden = NO;
    self.alpha = 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
    
}

-(void)refreshData{
    
    
    
    self.logoEmpty.hidden = YES;
    [self.indicator startAnimating];

    [self.tableView setContentOffset:CGPointZero];
    
    self.btnPlay.hidden = YES;

    
    
//    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"fakeLikedTuto"]) {
//
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"fakeLikedTuto"];
    
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshMapAction];
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:@"tutoriel" equalTo:@YES];
        
        [query1 includeKey:kBuzzUser];
        [query1 includeKey:kBuzzCity];
        [query1 includeKey:kBuzzCountry];
        [query1 includeKey:kBuzzUniversity];
        [query1 includeKey:@"fakeCountry"];
        
        [query1 orderByDescending:@"fakeCountry"];
        
        [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            
            NSMutableArray *buzzs = [[NSMutableArray alloc]init];
            
            
                for (int i = 0; i<objects.count; i++) {
                    
                    PFObject *buzz = objects[i];
                    
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:buzz.objectId]) {
                        
                        [buzzs addObject:buzz];
                        
                    }
                }
            
            
            [self.indicator stopAnimating];
            
            if (buzzs != NULL && buzzs.count > 0) {
                
                self.btnPlay.hidden = NO;
                
                self.buzzs = [[NSMutableArray alloc]initWithArray:buzzs];
                [self.tableView scrollsToTop];

                [self.tableView reloadData];
                
            }else{
                
                self.buzzs = [[NSMutableArray alloc]init];
                [self.tableView scrollsToTop];

                [self.tableView reloadData];
                
                self.logoEmpty.hidden = NO;
                self.btnPlay.hidden = YES;
                
            }
            
            
            for (int i = 0; i<buzzs.count; i++) {
                
                PFObject *buzz = [buzzs objectAtIndex:i];
                
                if (buzz[kBuzzPhoto]) {
                    
                    PFFile *photo = buzz[kBuzzPhoto];
                    [photo getDataInBackground];
                }
                
                if (buzz[kBuzzVideo]) {
                    
                    PFFile *video = buzz[kBuzzVideo];
                    [video getDataInBackground];
                    
                }
            }
            

            
            
            
        }];
        

        return;
        
    }

    PFQuery *query = [PFQuery queryWithClassName:kBuzzClasseName];

    NSDate *date = [NSDate date];
    NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
    
    

    [query whereKey:kBuzzWhen greaterThan:yesterday];
    [query whereKey:kBuzzDeleted notEqualTo:@YES];

    
    [query whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
    [query includeKey:kBuzzUser];
    [query includeKey:kBuzzCity];
    [query includeKey:kBuzzCountry];
    [query includeKey:kBuzzUniversity];
    
    [query orderByDescending:kBuzzKingCountry];
    [query addDescendingOrder:kBuzzKingCity];
    [query addDescendingOrder:kBuzzKingUniversity];
    [query addDescendingOrder:kBuzzLikeNumber];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
       

       NSArray * arrSorted = [objects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
           

           NSArray *array1 = [obj1 valueForKey:kBuzzLikeDate];
           NSArray *array2 = [obj2 valueForKey:kBuzzLikeDate];

           NSDate *d1 = [NSDate dateWithTimeIntervalSince1970:0];
           NSDate *d2 = [NSDate dateWithTimeIntervalSince1970:0];

    
           
           for (int i = 0; i<array1.count; i++) {
               
               NSDictionary *dic = array1[i];
               
               if ([dic objectForKey:[PFUser currentUser].objectId]) {
                   
                   
                   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                   [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                   
                                      
                   if ([[dic objectForKey:[PFUser currentUser].objectId] isKindOfClass:[NSDate class]]) {
                    
                  
                       d1 =[dic objectForKey:[PFUser currentUser].objectId];
                       
                   }else{
                       
                       d1 = [dateFormatter dateFromString:[dic objectForKey:[PFUser currentUser].objectId]];

                   }

                   
               }
           }
           
           
           for (int i = 0; i<array2.count; i++) {
               
               NSDictionary *dic = array2[i];
               
               if ([dic objectForKey:[PFUser currentUser].objectId]) {
                   
                   
                   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                   [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];

                   NSLog(@"dic %@",[dic objectForKey:[PFUser currentUser].objectId]);

                   if ([[dic objectForKey:[PFUser currentUser].objectId] isKindOfClass:[NSDate class]]) {
                      
                       d2 =[dic objectForKey:[PFUser currentUser].objectId];

                   }else{
                       
                       d2 = [dateFormatter dateFromString:[dic objectForKey:[PFUser currentUser].objectId]];
 
                   }

                   
                   
               }
           }

        
           
           return [d2 compare: d1];

        }];
        
        NSMutableArray *buzzs = [[NSMutableArray alloc]initWithArray:arrSorted];
        
        
        [self.indicator stopAnimating];
        
        if (buzzs != NULL && buzzs.count > 0) {
            
            self.btnPlay.hidden = NO;

            self.buzzs = [[NSMutableArray alloc]initWithArray:buzzs];
            [self.tableView scrollsToTop];

            [self.tableView reloadData];
            
        }else{
            
            self.buzzs = [[NSMutableArray alloc]init];
            [self.tableView scrollsToTop];

            [self.tableView reloadData];

            self.logoEmpty.hidden = NO;
            self.btnPlay.hidden = YES;

        }

        

    }];

  }


-(void)hide{
    
    self.alpha = 1;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        
    }];
    
    
}


@end
