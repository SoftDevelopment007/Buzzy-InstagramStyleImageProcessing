//
//  FriendsView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-09-27.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "FriendsView.h"


#import "AppDelegate.h"

@implementation FriendsView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        ///// 58 234
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.90];
        self.hidden = YES;
        
        
        
        
        self.indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(19, 19, 40, 40)];
        self.indicator.hidesWhenStopped=YES;
        [self addSubview:self.indicator];
        
        
      
        
        self.containerTableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        [self addSubview:self.containerTableView];
        
        self.addButton2 =[[UIButton alloc]initWithFrame:CGRectMake((largeurIphone-150)/2, (hauteurIphone-150)/2, 150, 150)];
        [self.addButton2 addTarget:self action:@selector(actionAddFriend) forControlEvents:UIControlEventTouchUpInside];
        [self.addButton2 setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"btnAddFriends2", nil)] forState:UIControlStateNormal];
                self.addButton2.hidden = YES;
        [self addSubview:self.addButton2];
        
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
        
        self.btnAdd = [[UIButton alloc]initWithFrame:CGRectMake(14, 14, 50, 50)];
        [self.btnAdd setBackgroundImage:[UIImage imageNamed:@"btnAddFriend"] forState:UIControlStateNormal];
        [self.btnAdd addTarget:self action:@selector(actionAddFriend) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnAdd];
        self.btnAdd.hidden = YES;

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
        self.titlePage.text = NSLocalizedString(@"My Friends", nil);
        [self addSubview:self.titlePage];
        
        
        
        
        
    }
    return self;
}


-(void)actionAddFriend{
    
    
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        NSLog(@"animation complete");
    };
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithInputTitle:NSLocalizedString(@"Add Friends", nil) detail:NSLocalizedString(@"Add friends by their Instagram username", nil) placeholder:NSLocalizedString(@"Instagram username", nil) handler:^(NSString *text) {
        
        if (text.length <1) {
            
            return;
            
        }
        appPlayLoading;
        
        
        NSLog(@"A");
        
        PFQuery *searchUser = [PFUser query];
        [searchUser whereKey:kUserInstaUsername equalTo:[Utils capitalizedFirstLetterInString:text]];
        
        [searchUser getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable user, NSError * _Nullable error) {
           
            if (error) {
                
                appStopLoading;
                
                MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
                    NSLog(@"animation complete");
                };
                
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:NSLocalizedString(@"Username unknown", nil) detail:NSLocalizedString(@"Sorry, this username is unknown in Buzzy", nil)];
                alertView.attachedView = self;
                alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
                alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
                [alertView showWithBlock:completeBlock];
                return;
            }
            if (user) {
                
                NSLog(@"B");

                PFQuery *queryCheck = [PFQuery queryWithClassName:kFollowersClasseName];
                [queryCheck whereKey:kFollowersFrom equalTo:[PFUser currentUser]];
                [queryCheck whereKey:kFollowersTo equalTo:user];
                [queryCheck findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    
                    if ( error || objects.count > 0) {
                        
                        appStopLoading;

                    }else{
                        
                        NSLog(@"C");

                        
                        PFObject *friendsObject = [PFObject objectWithClassName:kFollowersClasseName];
                        friendsObject[kFollowersFrom]= [PFUser currentUser];
                        friendsObject[kFollowersTo] = user;
                        [friendsObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            
                            NSLog(@"D");


                            [self refreshDataAndTableView:YES];
                            
                        }];
                    }
                }];
               
                
            }else{
                
                appStopLoading;

                MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
                    NSLog(@"animation complete");
                };
                
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:NSLocalizedString(@"Username unknown", nil) detail:NSLocalizedString(@"Sorry, this username is unknown in Buzzy", nil)];
                alertView.attachedView = self;
                alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
                alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
                [alertView showWithBlock:completeBlock];
            }
            
        }];

        
    }];
    alertView.attachedView = self;
    alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
    alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
    [alertView showWithBlock:completeBlock];
    
    
    
    
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
    return self.friends.count;
}

// the cell will be returned to the tableView
- (FriendsTableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FriendCell";

    // Similar to UITableViewCell, but
    FriendsTableViewCell *cell = (FriendsTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[FriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.picture.image = nil;
    
    if ([[self.friends objectAtIndex:indexPath.row] objectForKey:kFollowersTo]) {
        cell.picture.file = [[[self.friends objectAtIndex:indexPath.row] objectForKey:kFollowersTo] objectForKey:kUserProfilePicture];
        [cell.picture loadInBackground];

    }

    if ([[self.friends objectAtIndex:indexPath.row] objectForKey:kFollowersTo]) {

    cell.instaId.text = [[[self.friends objectAtIndex:indexPath.row] objectForKey:kFollowersTo] objectForKey:kUserInstaUsername];
    
        if ([[[self.friends objectAtIndex:indexPath.row] objectForKey:kFollowersTo] objectForKey:@"firstName"]) {
            
                cell.name.text = [[[self.friends objectAtIndex:indexPath.row] objectForKey:kFollowersTo] objectForKey:@"firstName"];

        }
    }


    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete; //if you don't want to show delete button
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set NSString for button display text here.
    NSString *newTitle = NSLocalizedString(@"Remove", nil);
    return newTitle;
    
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
            
            
            
            PFObject *followers = [self.friends objectAtIndex:indexPath.row];
            
            
            [self.friends removeObjectAtIndex:indexPath.row];
            [self.tableView scrollsToTop];
            
            if (self.friends.count == 0) {
                
                self.addButton2.hidden=NO;
                self.btnAdd.hidden = YES;

            }
            
            [self.tableView reloadData];
           
            
            [followers deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
                [self refreshDataAndTableView:NO];
                
            }];
            
            
        };
        
        
        NSArray *items = @[MMItemMake(NSLocalizedString(@"NO", nil), MMItemTypeNormal, blockNO),MMItemMake(NSLocalizedString(@"YES", nil), MMItemTypeNormal, blockYES)];
        
        NSString *message = NSLocalizedString(@"Are you sure you want to remove this Friend?",nil);
        
        
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:NSLocalizedString(@"Remove Friend", nil) detail:message items:items];
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




//#pragma mark - UITableViewDelegate
//// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@",[self.friends objectAtIndex:indexPath.row][kFollowersTo][kUserInstaUsername]]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
        
    }else{
        
        
    }

}




-(void)actionBtnClose{
    
    [self hide];
    
}






-(void)show{
    
    
    
    
        [self.indicator startAnimating];
        
    
    [self refreshDataAndTableView:YES];
    
    
    
    self.hidden = NO;
    self.alpha = 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
    
}

-(void)refreshDataAndTableView:(BOOL)refreshTable{
    
    
    [[Following sharedInstance]updateFollowingCompletion:^(BOOL succeeded) {
        
        
        
        if (![PFUser currentUser]) {
            
            return;
            
        }
        
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshMapAction];
        
    }];
    
    
    if (refreshTable == true) {

        if (self.friends.count != 0) {
            
            self.addButton2.hidden=YES;
            self.btnAdd.hidden = NO;

        }
        [self.indicator startAnimating];

        [self.tableView setContentOffset:CGPointZero];
        
    }
    PFQuery *followers = [PFQuery queryWithClassName:kFollowersClasseName];
    [followers whereKey:kFollowersFrom equalTo:[PFUser currentUser]];
    
    followers.limit=10000;
    followers.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [followers includeKey:kFollowersTo];
    
    
    [followers findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
       
        [self.indicator stopAnimating];

      
        
        appStopLoading;
        
        if (objects) {
            
            if (objects.count ==0) {
             
                if (refreshTable == true) {

                self.friends = [[NSMutableArray alloc]init];

                
                    self.addButton2.hidden=NO;
                    self.btnAdd.hidden = YES;

                    [self.tableView reloadData];

                }

            }else{
                
                if (refreshTable == true) {

                NSSortDescriptor *name = [[NSSortDescriptor alloc] initWithKey:@"to.instaUsername" ascending:YES];
                NSMutableArray *objectsSortedB = [[NSMutableArray alloc]initWithArray:[objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects: name, nil]]];
                
                
                self.friends = [[NSMutableArray alloc]initWithArray:objectsSortedB];
                self.addButton2.hidden=YES;
                self.btnAdd.hidden = NO;

                
                    
                    [self.tableView reloadData];
                    
                }
                
                
            }
        }else{
            
            if (refreshTable == true) {

            self.friends = [[NSMutableArray alloc]init];

            self.btnAdd.hidden = YES;

            self.addButton2.hidden=NO;
            
                
                [self.tableView reloadData];
                
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
