//
//  KingsView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-11.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "KingsView.h"
#import "AppDelegate.h"
#import "Following.h"


@implementation KingsView


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

        }
        self.navBar.backgroundColor =[UIColor blackColor];
        self.navBar.alpha = 0.5;
        [self addSubview:self.navBar];
        
        
        self.btnClose = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-50-14, 14, 50, 50)];
        [self.btnClose setBackgroundImage:[UIImage imageNamed:@"btnCancel"] forState:UIControlStateNormal];
        [self.btnClose addTarget:self action:@selector(actionBtnClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnClose];
        
        
        if (IS_IPHONEX) {
            
            self.titlePage = [[UILabel alloc]initWithFrame:CGRectMake(0, 25+30, largeurIphone, 23)];

        }else{
            
            self.titlePage = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, largeurIphone, 23)];

        }
        self.titlePage.textAlignment = NSTextAlignmentCenter;
        self.titlePage.font = [UIFont HelveticaNeue:20];
        self.titlePage.textColor = [UIColor whiteColor];
        self.titlePage.text = NSLocalizedString(@"Kingdoms", nil);
        [self addSubview:self.titlePage];
        
        
//        
//        self.btnPlay = [[UIButton alloc]initWithFrame:CGRectMake(14, 14, 50, 50)];
//        [self.btnPlay setBackgroundImage:[UIImage imageNamed:@"btnPlay"] forState:UIControlStateNormal];
//        [self.btnPlay addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.btnPlay];
        
        
    }
    return self;
}



-(void)actionPlay{
    
//    if (self.delegate) {
//        
//        
//    }
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



-(void)yourButtonClicked:(UIButton*)sender{
    
    
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@",[self.buzzs objectAtIndex:sender.tag][kBuzzUser][kUserInstaUsername]]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
        
    }else{
        
        
    }
    
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
    
    
    cell.btnInsta.hidden = NO;
    cell.btnInsta.tag = indexPath.row;
    
    
    [cell.btnInsta addTarget:self action:@selector(yourButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       
        if (self.buzzs.count > indexPath.row) {

        cell.content = [[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzPhoto];
        [cell.content getDataInBackground];
            
        }
    });
    
    
    
//    cell.name.text = [[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUser] objectForKey:kUserFirstName];
    
    
    
    if ([[self.buzzs objectAtIndex:indexPath.row][kBuzzKingCountry] isEqual:@YES] && [[self.buzzs objectAtIndex:indexPath.row][@"type"] isEqualToString:@"Country"]) {
        
        
        if ([Utils languageFr]) {
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryNameFr]];
            
        }else{
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryName]];
            
        }

        
    }else if ([[self.buzzs objectAtIndex:indexPath.row][kBuzzKingCity] isEqual:@YES]&& [[self.buzzs objectAtIndex:indexPath.row][@"type"] isEqualToString:@"City"]) {
        
       
        if ([Utils languageFr]) {
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCity] objectForKey:kCityNameFr]];
            
        }else{
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCity] objectForKey:kCityName]];
            
        }

        
    }else if ([[self.buzzs objectAtIndex:indexPath.row][kBuzzKingUniversity] isEqual:@YES]&& [[self.buzzs objectAtIndex:indexPath.row][@"type"] isEqualToString:@"University"]) {
        
        
        if ([Utils languageFr]) {
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUniversity] objectForKey:kUniversityNameFr]];

        }else{
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzCountry] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUniversity] objectForKey:kUniversityName]];

        }

    }
    
    cell.distance.text = [[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzUser] objectForKey:kUserFirstName];

//    cell.distance.text = [NSString stringWithFormat:@"%@",[self getDistance:[[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzLocation] andCurrentLocation:self.currentLocation]];
 
    
    
    NSArray *likes = [[self.buzzs objectAtIndex:indexPath.row] objectForKey:kBuzzLike];
    
    
    cell.like.text = [NSString stringWithFormat:@"%lu",(unsigned long)likes.count];
    
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
    
    
    
    cell.friendsLogo.hidden = YES;
    
    
    if (likes.count > 9) {
        
        
        cell.friendsLogo.frame = CGRectMake(largeurIphone-12-68-8, 62+3+7, 16, 16);
        
        
    }else if (likes.count > 99){
        
        cell.friendsLogo.frame = CGRectMake(largeurIphone-12-68-8-8, 62+3+7, 16, 16);
        
    }else if (likes.count > 999){
        
        cell.friendsLogo.frame = CGRectMake(largeurIphone-12-68-8-8-8, 62+3+7, 16, 16);
        
    }else{
        
        cell.friendsLogo.frame = CGRectMake(largeurIphone-12-68, 62+3+7, 16, 16);
        
    }
    
    cell.buzz = [self.buzzs objectAtIndex:indexPath.row];
    

    
        if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]] && ![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"seeKing-%@",cell.buzz.objectId]]){
//    if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){
        
        
            cell.friendsLogo.hidden = NO;
        
        }else{
            
            cell.friendsLogo.hidden = YES;

        }

    
    
    if ([cell.buzz[@"tutoriel"] isEqual:@YES]) {
        
        [cell.progressView setProgress:0.7];
        [cell.progressView setProgressTintColor:[UIColor yellowBuzzy]];
        
        
        if ([Utils languageFr]) {
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:@"fakeCountry"] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:@"fakeCountry"] objectForKey:kCountryNameFr]];
            
        }else{
            
            cell.name.text = [NSString stringWithFormat:NSLocalizedString(@"%@, kingdom of %@",nil),[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:@"fakeCountry"] objectForKey:kCountryIcon],[[[self.buzzs objectAtIndex:indexPath.row] objectForKey:@"fakeCountry"] objectForKey:kCountryName]];
            
        }

    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 100;
    
}



-(void)selectFirst{
    
    
    if (self.delegate) {
        
        
        PFObject *buzz = [self.buzzs objectAtIndex:0];
        
        
        [self.delegate launchBuzz:[self.buzzs objectAtIndex:0] pretendantType:NO];
        
        
        if ([[[Following sharedInstance]following] containsObject:buzz[kBuzzInstaUsername]] && ![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"seeKing-%@",buzz.objectId]]){
            //    if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){
            
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshMapAction];
            
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:[NSString stringWithFormat:@"seeKing-%@",buzz.objectId]];
            
        }
        
        
        
        [self.tableView scrollsToTop];

        [self.tableView reloadData];
        
    }
    
}
#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.delegate) {
        
        
        PFObject *buzz = [self.buzzs objectAtIndex:indexPath.row];
        

        [self.delegate launchBuzz:[self.buzzs objectAtIndex:indexPath.row] pretendantType:NO];

        
        if ([[[Following sharedInstance]following] containsObject:buzz[kBuzzInstaUsername]] && ![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"seeKing-%@",buzz.objectId]]){
            //    if ([[[Following sharedInstance]following] containsObject:[self.buzzs objectAtIndex:indexPath.row][kBuzzInstaUsername]]){
            
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshMapAction];

            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:[NSString stringWithFormat:@"seeKing-%@",buzz.objectId]];

            
        }

        
        
        [self.tableView scrollsToTop];

        [self.tableView reloadData];

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




-(void)showWithBuzz:(PFObject *)buzz{

    
    self.btnPlay.hidden = YES;

//    [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] animator] setDragable:NO];

    
    if ([buzz[kBuzzKingCountry] isEqual:@YES]) {
        
        PFQuery *queryCity = [PFQuery queryWithClassName:kBuzzClasseName];
        [queryCity whereKey:kBuzzKingCity equalTo:@YES];
        [queryCity whereKey:kBuzzCountry equalTo:buzz[kBuzzCountry]];
        
        NSDate *date =[NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [queryCity whereKey:kBuzzWhen greaterThan:yesterday];
        [queryCity whereKey:kBuzzDeleted notEqualTo:@YES];
        
        
        [queryCity includeKey:kBuzzUser];
        [queryCity includeKey:kBuzzCity];
        [queryCity includeKey:kBuzzCountry];
        [queryCity includeKey:kBuzzUniversity];
        
        [queryCity orderByDescending:kBuzzKingCountry];
        [queryCity addDescendingOrder:kBuzzKingCity];
        [queryCity addDescendingOrder:kBuzzKingUniversity];
        [queryCity addDescendingOrder:kBuzzLikeNumber];
        
        [queryCity findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzs, NSError * _Nullable error) {
            
            [self.indicator stopAnimating];
            
            if (buzzs != NULL && buzzs.count > 0) {
                
                
                self.btnPlay.hidden = NO;
                
                self.buzzs = [[NSMutableArray alloc]initWithArray:buzzs];
                [self.tableView scrollsToTop];

                [self.tableView reloadData];
                
                
                
            }else{
                
                self.btnPlay.hidden = YES;
                
                self.buzzs = [[NSMutableArray alloc]init];
                [self.tableView scrollsToTop];

                [self.tableView reloadData];
                
                self.logoEmpty.hidden = NO;
                
            }
            
            
            
            
        }];
        

        
        
    }else if ([buzz[kBuzzKingCity] isEqual:@YES]){
        
        PFQuery *queryUniv = [PFQuery queryWithClassName:kBuzzClasseName];
        [queryUniv whereKey:kBuzzKingUniversity equalTo:@YES];
        [queryUniv whereKey:kBuzzCity equalTo:buzz[kBuzzCity]];
        
        NSDate *date =[NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [queryUniv whereKey:kBuzzWhen greaterThan:yesterday];
        [queryUniv whereKey:kBuzzDeleted notEqualTo:@YES];
        
        
        [queryUniv includeKey:kBuzzUser];
        [queryUniv includeKey:kBuzzCity];
        [queryUniv includeKey:kBuzzCountry];
        [queryUniv includeKey:kBuzzUniversity];
        
        [queryUniv orderByDescending:kBuzzKingCountry];
        [queryUniv addDescendingOrder:kBuzzKingCity];
        [queryUniv addDescendingOrder:kBuzzKingUniversity];
        [queryUniv addDescendingOrder:kBuzzLikeNumber];
        
        [queryUniv findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzs, NSError * _Nullable error) {
            
            [self.indicator stopAnimating];
            
            if (buzzs != NULL && buzzs.count > 0) {
                
                
                self.btnPlay.hidden = NO;
                
                self.buzzs = [[NSMutableArray alloc]initWithArray:buzzs];
                [self.tableView scrollsToTop];

                [self.tableView reloadData];
                
                
            }else{
                
                self.btnPlay.hidden = YES;
                
                self.buzzs = [[NSMutableArray alloc]init];
                [self.tableView scrollsToTop];

                [self.tableView reloadData];
                
                self.logoEmpty.hidden = NO;
                
            }
            
            
            
            
        }];
        
        
    }else{
        
        self.btnPlay.hidden = YES;
        
        self.buzzs = [[NSMutableArray alloc]init];
        [self.tableView scrollsToTop];

        [self.tableView reloadData];
        
        self.logoEmpty.hidden = NO;

    }
    
    self.hidden = NO;
    self.alpha = 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
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
    
    [self.tableView scrollsToTop];

    self.btnPlay.hidden = YES;

    [self.indicator startAnimating];
    self.logoEmpty.hidden = YES;

    ///in city == king city + univ + country
    ///in country = king country
    
//     if([[Position sharedInstance]currentCity] != NULL){
//                
//         
//         PFQuery *queryCountry = [PFQuery queryWithClassName:kBuzzClasseName];
//        [queryCountry whereKey:kBuzzKingCountry equalTo:@YES];
//        [queryCountry whereKey:kBuzzCountry equalTo:[[Position sharedInstance]currentCountry]];
//        
//         PFQuery *queryCity = [PFQuery queryWithClassName:kBuzzClasseName];
//         [queryCity whereKey:kBuzzKingCity equalTo:@YES];
//         [queryCity whereKey:kBuzzCity equalTo:[[Position sharedInstance]currentCity]];
//
//         PFQuery *queryUniv = [PFQuery queryWithClassName:kBuzzClasseName];
//         [queryUniv whereKey:kBuzzKingUniversity equalTo:@YES];
//         [queryUniv whereKey:kBuzzCity equalTo:[[Position sharedInstance]currentCity]];
//         
//         
//        PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryCountry,queryCity,queryUniv]];
//
//        NSDate *date =[NSDate date];
//        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
//         
//        [query whereKey:kBuzzWhen greaterThan:yesterday];
//        [query whereKey:kBuzzDeleted notEqualTo:@YES];
//
//         
//        [query includeKey:kBuzzUser];
//        [query includeKey:kBuzzCity];
//        [query includeKey:kBuzzCountry];
//        [query includeKey:kBuzzUniversity];
//        
//        [query orderByDescending:kBuzzKingCountry];
//        [query addDescendingOrder:kBuzzKingCity];
//        [query addDescendingOrder:kBuzzKingUniversity];
//        [query addDescendingOrder:kBuzzLikeNumber];
//        
//        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzs, NSError * _Nullable error) {
//            
//            
//            
//            [self.indicator stopAnimating];
//            
//            if (buzzs != NULL && buzzs.count > 0) {
//                
//
//                self.btnPlay.hidden = NO;
//
//                self.buzzs = [[NSMutableArray alloc]initWithArray:buzzs];
//                [self.tableView reloadData];
//                
//                
//            }else{
//                
//                self.btnPlay.hidden = YES;
//
//                self.buzzs = [[NSMutableArray alloc]init];
//                [self.tableView reloadData];
//
//                self.logoEmpty.hidden = NO;
//                
//            }
//            
//            
//            
//        }];
//        
//        
//        
//        
//    }else if([[Position sharedInstance]currentCountry] != NULL){
    
    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto8"]) {
//    
//        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
//        [query1 whereKey:@"tutoriel" equalTo:@YES];
//        [query1 whereKey:@"fakeKing" equalTo:@YES];
//
//        [query1 includeKey:kBuzzUser];
//        [query1 includeKey:kBuzzCity];
//        [query1 includeKey:kBuzzCountry];
//        [query1 includeKey:kBuzzUniversity];
//        [query1 includeKey:@"fakeCountry"];
//        
//        [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzs, NSError * _Nullable error) {
//            
//            [self.indicator stopAnimating];
//            
//            if (buzzs != NULL && buzzs.count > 0) {
//                
//                
//                self.btnPlay.hidden = NO;
//                
//                self.buzzs = [[NSMutableArray alloc]initWithArray:buzzs];
//                [self.tableView scrollsToTop];
//
//                [self.tableView reloadData];
//                
//                
//            }else{
//                
//                self.btnPlay.hidden = YES;
//                
//                self.buzzs = [[NSMutableArray alloc]init];
//                [self.tableView scrollsToTop];
//
//                [self.tableView reloadData];
//                
//                self.logoEmpty.hidden = NO;
//            }
//            
//            for (int i = 0; i<buzzs.count; i++) {
//                
//                PFObject *buzz = [buzzs objectAtIndex:i];
//                
//                if (buzz[kBuzzPhoto]) {
//                    
//                    PFFile *photo = buzz[kBuzzPhoto];
//                    [photo getDataInBackground];
//                }
//                
//                if (buzz[kBuzzVideo]) {
//                    
//                    PFFile *video = buzz[kBuzzVideo];
//                    [video getDataInBackground];
//                    
//                }
//            }
//            
//
//
//            
//            
//        }];
//        
//
//        
//        return;
//         
//        
//    }
//
//    
//    
    NSLog(@"on arrive la!");
    
    NSDate *date = [NSDate date];
    NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];

    
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzKingCountry equalTo:@YES];
    
    
        [query1 whereKey:kBuzzWhen greaterThan:yesterday];
        [query1 whereKey:kBuzzDeleted notEqualTo:@YES];

        
        [query1 includeKey:kBuzzUser];
        [query1 includeKey:kBuzzCity];
        [query1 includeKey:kBuzzCountry];
        [query1 includeKey:kBuzzUniversity];
    
    
        [query1 orderByDescending:kBuzzKingCountry];
        [query1 addDescendingOrder:kBuzzKingCity];
        [query1 addDescendingOrder:kBuzzKingUniversity];
        [query1 addDescendingOrder:kBuzzLikeNumber];
        
        [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects1, NSError * _Nullable error) {
            

            for (int i = 0; i<objects1.count; i++) {
                
                PFObject *king = (PFObject *)[objects1 objectAtIndex:i];
                king[@"type"] =@"Country";
            }
            
            PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
            [query2 whereKey:kBuzzKingCity equalTo:@YES];

            
            [query2 whereKey:kBuzzWhen greaterThan:yesterday];
            [query2 whereKey:kBuzzDeleted notEqualTo:@YES];
            
            
            [query2 includeKey:kBuzzUser];
            [query2 includeKey:kBuzzCity];
            [query2 includeKey:kBuzzCountry];
            [query2 includeKey:kBuzzUniversity];
            
            
            [query2 orderByDescending:kBuzzKingCountry];
            [query2 addDescendingOrder:kBuzzKingCity];
            [query2 addDescendingOrder:kBuzzKingUniversity];
            [query2 addDescendingOrder:kBuzzLikeNumber];
            [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects2, NSError * _Nullable error) {
                
                for (int i = 0; i<objects2.count; i++) {
                    
                    PFObject *king = (PFObject *)[objects2 objectAtIndex:i];
                    king[@"type"] =@"City";
                }
                    NSArray *newArray=[objects1 arrayByAddingObjectsFromArray:objects2];

                
                
                    PFQuery *query3 = [PFQuery queryWithClassName:kBuzzClasseName];
                    [query3 whereKey:kBuzzKingUniversity equalTo:@YES];

                
                    [query3 whereKey:kBuzzWhen greaterThan:yesterday];
                    [query3 whereKey:kBuzzDeleted notEqualTo:@YES];
                    
                    
                    [query3 includeKey:kBuzzUser];
                    [query3 includeKey:kBuzzCity];
                    [query3 includeKey:kBuzzCountry];
                    [query3 includeKey:kBuzzUniversity];
                    
                    
                    [query3 orderByDescending:kBuzzKingCountry];
                    [query3 addDescendingOrder:kBuzzKingCity];
                    [query3 addDescendingOrder:kBuzzKingUniversity];
                    [query3 addDescendingOrder:kBuzzLikeNumber];
                    [query3 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects3, NSError * _Nullable error) {
                        
                        
                        
                        for (int i = 0; i<objects3.count; i++) {
                            
                            PFObject *king = (PFObject *)[objects3 objectAtIndex:i];
                            king[@"type"] =@"University";
                        }
                        
                        NSMutableArray *objects=[[NSMutableArray alloc]initWithArray:[newArray arrayByAddingObjectsFromArray:objects3]];
                        
                       
                        


                        
                        NSSortDescriptor *country = [[NSSortDescriptor alloc] initWithKey:@"country.name" ascending:YES];
                        NSSortDescriptor *city = [[NSSortDescriptor alloc] initWithKey:@"city.name" ascending:YES];
                        NSMutableArray *objectsSortedB = [[NSMutableArray alloc]initWithArray:[objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects: country, city, nil]]];
                        
                        
                        
                
                        
                        NSArray * objectsSorted = [objectsSortedB sortedArrayUsingComparator:^NSComparisonResult(PFObject *buzz1, PFObject *buzz2) {
                            
                            
                            PFGeoPoint *center1 = [[buzz1 objectForKey:kBuzzCountry] objectForKey:kCountryCenter];
                            PFGeoPoint *center2 = [[buzz2 objectForKey:kBuzzCountry] objectForKey:kCountryCenter];
                            
                        
                            
                            double d1 = [[[Position sharedInstance]currentPosition] distanceInKilometersTo:center1];
                            double d2 = [[[Position sharedInstance]currentPosition] distanceInKilometersTo:center2];
                            
                            

                            if (d2 < d1) {
                                
                                return (NSComparisonResult)NSOrderedDescending;

                            }else{
                                
                                
                                return (NSComparisonResult)NSOrderedSame;

                            }
                        }];
                        
                        
                        
                        
                        int valueCountry = 0;
                        NSMutableArray *objectsSorted2 = [[NSMutableArray alloc]init];
                        
                        
                        if([[Position sharedInstance]currentCountry] != NULL){

                        
                            
                                    for (int i = 0; i<objectsSorted.count; i++) {
                                        
                                        PFObject *king = [objectsSorted objectAtIndex:i];
                                        
                                        if (king[kBuzzCountry] ) {
                                        
                                            PFObject*country = king[kBuzzCountry];
                                            
                                            
                                            if ([country.objectId isEqualToString:[[Position sharedInstance]currentCountry].objectId]) {
                                                
                                                [objectsSorted2 insertObject:king atIndex:valueCountry];
                                                valueCountry = valueCountry +1;
                                                
                                            }else{
                                                
                                                [objectsSorted2 addObject:king];
                                                
                                            }

                                            
                                        }else{
                                            
                                            [objectsSorted2 addObject:king];

                                            
                                        }
                                     }
                            
                        }else{
                            
                            objectsSorted2 = [[NSMutableArray alloc]initWithArray:objectsSorted];

                        }
                        
                        
                        
                        
                        int valueCity = 1;
                        NSMutableArray *buzzs = [[NSMutableArray alloc]init];

                        if([[Position sharedInstance]currentCity] != NULL){

                        
                                        for (int i = 0; i<objectsSorted2.count; i++) {
                                            

                                            PFObject *king = [objectsSorted2 objectAtIndex:i];
                                            
                                            if (king[kBuzzCity] ) {
                                            
                                                PFObject*city = king[kBuzzCity];
                                                
                                                
                                                if ([city.objectId isEqualToString:[[Position sharedInstance]currentCity].objectId] && ![king[@"type"] isEqualToString:@"Country"]) {
                                                    
                                                    NSLog(@"bbb %@",buzzs);

                                                    NSLog(@"xo %d",valueCity);
                                                    
                                                    [buzzs insertObject:king atIndex:valueCity];
                                                    valueCity = valueCity +1;
                                                    
                                                }else{
                                                    
                                                    [buzzs addObject:king];
                                                    
                                                }
                                                
                                                
                                            }else{
                                                
                                                [buzzs addObject:king];
                                                
                                                
                                            }
                                        }
                                        

                        }else{
                            
                            buzzs = [[NSMutableArray alloc]initWithArray:objectsSorted2];

                            
                        }
                        
                        
                        
                        
                        [self.indicator stopAnimating];
                        
                        if (buzzs != NULL && buzzs.count > 0) {
                            
                            
                            self.btnPlay.hidden = NO;
                            
                            self.buzzs = [[NSMutableArray alloc]initWithArray:buzzs];
                            [self.tableView scrollsToTop];
                            [self.tableView reloadData];
                            
                            
                        }else{
                            
                            self.btnPlay.hidden = YES;
                            
                            self.buzzs = [[NSMutableArray alloc]init];
                            [self.tableView scrollsToTop];

                            [self.tableView reloadData];
                            
                            self.logoEmpty.hidden = NO;
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
                
                
                
                
            }];
            
            
            
            
        }];
        
        
//        
//        
//    }else{
//        
//        self.btnPlay.hidden = YES;
//        
//        self.buzzs = [[NSMutableArray alloc]init];
//        [self.tableView reloadData];
//        
//        self.logoEmpty.hidden = NO;
//        
//        
//    }
    
    
    
}
-(void)hide{
    
    
//    [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] animator] setDragable:YES];

    self.alpha = 1;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        
    }];
    
    
}


@end
