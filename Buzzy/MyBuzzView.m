//
//  MyBuzzView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-06-29.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "MyBuzzView.h"
#import "Following.h"
#import "AppDelegate.h"


@implementation MyBuzzView

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
        
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.containerTableView.bounds;
//        gradient.colors = @[(id)[UIColor clearColor].CGColor,
//                            (id)[UIColor blackColor].CGColor,
//                            (id)[UIColor blackColor].CGColor,
//                            (id)[UIColor clearColor].CGColor];
//        gradient.locations = @[@0.0, @0.20, @0.80, @1.0];
//        self.containerTableView.layer.mask = gradient;
//        

        
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
        
        

        if (IS_IPHONEX) {
            
            self.titlePage = [[UILabel alloc]initWithFrame:CGRectMake(0, 25+30, largeurIphone, 23)];
            
        }else{
            
            self.titlePage = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, largeurIphone, 23)];
            
        }        self.titlePage.textAlignment = NSTextAlignmentCenter;
        self.titlePage.font = [UIFont HelveticaNeue:20];
        self.titlePage.textColor = [UIColor whiteColor];
        self.titlePage.text = NSLocalizedString(@"My BUZZs", nil);
        [self addSubview:self.titlePage];
        
        

//        self.btnPlay = [[UIButton alloc]initWithFrame:CGRectMake(14, 14, 50, 50)];
//        [self.btnPlay setBackgroundImage:[UIImage imageNamed:@"btnPlay"] forState:UIControlStateNormal];
//        [self.btnPlay addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];
//        self.btnPlay.hidden = YES;
//        [self addSubview:self.btnPlay];
//        
        
        
        
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
    
    NSLog(@"counnnn %lu",(unsigned long)self.buzzs.count);
    
    
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
    
    
    cell.picture.file = [[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzPhoto];
    [cell.picture loadInBackground];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        if (self.buzzs.count > indexPath.row) {
            
            cell.content = [[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzPhoto];
            [cell.content getDataInBackground];

        }
    });
    
    
    
    cell.pastille.hidden = YES;

    

//    cell.name.text = [[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzStreet];
//    cell.name.font = [UIFont HelveticaNeue:17];
    
    cell.distance.text = [NSString stringWithFormat:@"%@",[self getDistance:[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzLocation] andCurrentLocation:self.currentLocation]];
    
    
    
    if ([Utils languageFr]) {
        
        
        if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUniversity]) {
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUniversity] objectForKey:kUniversityNameFr]];
            
        }else if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCity]){
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCity] objectForKey:kCityNameFr]];
            
        }else if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry]){
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryNameFr]];
            
        }
        
        
    }else{
        
        
        
        
        if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUniversity]) {
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUniversity] objectForKey:kUniversityName]];
            
        }else if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCity]){
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCity] objectForKey:kCityName]];
            
        }else if ([[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry]){
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryName]];
            
        }
        
        
    }
    
    
    
    NSArray *likes = [[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzLike];
    
    
    cell.like.text = [NSString stringWithFormat:@"%lu",(unsigned long)likes.count];
    
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:[self.buzzs objectAtIndex:indexPath.row] [kBuzzWhen]];
    
    float progress = 1-(secondsBetween / ( 24 * 60 * 60));
    
    [cell.progressView setProgress:progress animated:NO];
    
    

    PFObject *buzz = [self.buzzs objectAtIndex:indexPath.row];
    
   
    if ([[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzKingCity] isEqual:@YES] || [[self.buzzs objectAtIndex:indexPath.row] [kBuzzKingUniversity] isEqual:@YES] || [[self.buzzs objectAtIndex:indexPath.row][kBuzzKingCountry] isEqual:@YES] ){
        

        
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"nbMess-%@",buzz.objectId]]) {
            
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"nbMess-%@",buzz.objectId]]integerValue] != [buzz[kBuzzMessageNumber]integerValue]) {
                
                
                cell.pastille.hidden = NO;
                
            }
            
        }else{
            
            ////
            if ([buzz[kBuzzMessageNumber]integerValue] > 0) {
                
                cell.pastille.hidden = NO;
                
            }
            
        }

        

        [cell.progressView setProgressTintColor:[UIColor yellowBuzzy]];
        
        
    }else if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){
        
        [cell.progressView setProgressTintColor:[UIColor redBuzzy]];
        
    }else{
        
        [cell.progressView setProgressTintColor:[UIColor orangeBuzzy]];
    }
    
    

    
    
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete; //if you don't want to show delete button
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; // allow that row to swipe
    //return NO; // not allow that row to swipe
}

// Override to support editing/deleteing the table view cell on swipe.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //--- your code for delete -----
        NSLog(@"delee");
        MMPopupItemHandler blockNO = ^(NSInteger index){
            
            
        };
        
        
        
        MMPopupItemHandler blockYES = ^(NSInteger index){
            
          
            
            PFObject *buzz = [self.buzzs objectAtIndex:indexPath.row];
            
            
            [self.buzzs removeObjectAtIndex:indexPath.row];
            [self.tableView scrollsToTop];

            [self.tableView reloadData];

            
            buzz[kBuzzDeleted] = @YES;
            [buzz saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                
                
                
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshAllNewKing];
                
                if ([buzz[kBuzzKingCountry] isEqual:@YES] || [buzz[kBuzzKingCity] isEqual:@YES] || [buzz[kBuzzKingUniversity] isEqual:@YES]) {
                    
                    [PFCloud callFunctionInBackground:@"loopKing" withParameters:@{} block:^(id  _Nullable result, NSError * _Nullable error){
                        
                        
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshAllNewKing];
                        
                        
                    }];
                    
                    
                    
                }
                
                
            }];
            
        };
        
        
        NSArray *items = @[MMItemMake(NSLocalizedString(@"NO", nil), MMItemTypeNormal, blockNO),MMItemMake(NSLocalizedString(@"YES", nil), MMItemTypeNormal, blockYES)];
        
        NSString *message = NSLocalizedString(@"Are you sure you want to delete this BUZZ?",nil);
        
        
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:NSLocalizedString(@"Delete", nil) detail:message items:items];
        alertView.attachedView = self;
        alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
        alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
        [alertView show];

        
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
        
        [self.delegate launchBuzz:[self.buzzs objectAtIndex:indexPath.row] pretendantType:NO];
        
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






-(void)showMyBuzz:(NSMutableArray *)myBuzzs WithCurrentLocation:(PFGeoPoint *)currentLocation{

    
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

    
    PFQuery *query = [PFQuery queryWithClassName:kBuzzClasseName];
    
    NSDate *date = [NSDate date];
    NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
    
    [query whereKey:kBuzzWhen greaterThan:yesterday];
    [query whereKey:kBuzzDeleted notEqualTo:@YES];

    
    [query whereKey:kBuzzUser equalTo:[PFUser currentUser]];
    [query includeKey:kBuzzUser];
    [query includeKey:kBuzzCity];
    [query includeKey:kBuzzCountry];
    [query includeKey:kBuzzUniversity];
    
    [query orderByDescending:kBuzzKingCountry];
    [query addDescendingOrder:kBuzzKingCity];
    [query addDescendingOrder:kBuzzKingUniversity];
    [query addDescendingOrder:kBuzzLikeNumber];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzs, NSError * _Nullable error) {
        
        
        
        [self.indicator stopAnimating];
        
        if (buzzs != NULL && buzzs.count > 0) {
            
            self.buzzs = [[NSMutableArray alloc]initWithArray:buzzs];
            [self.tableView scrollsToTop];

            [self.tableView reloadData];
            
            self.btnPlay.hidden = NO;

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
