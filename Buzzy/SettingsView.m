//
//  SettingsView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-11.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        ///// 58 234
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.95];
        self.hidden = YES;
        
        
        
        
        self.indicator = [[UIActivityIndicatorView alloc]init];
        self.indicator.center = self.center;
        self.indicator.hidesWhenStopped=YES;
        [self addSubview:self.indicator];
        
        
        
        self.containerTableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        [self addSubview:self.containerTableView];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.containerTableView.bounds;
        gradient.colors = @[(id)[UIColor blackColor].CGColor,
                            (id)[UIColor blackColor].CGColor,
                            (id)[UIColor blackColor].CGColor,
                            (id)[UIColor clearColor].CGColor];
        gradient.locations = @[@0.0, @0.20, @0.70, @1.0];
        self.containerTableView.layer.mask = gradient;
        
//
//        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
//        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 80)];
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self;
//        self.tableView.backgroundColor = [UIColor clearColor];
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self.containerTableView addSubview:self.tableView];
        
            
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 110)];
        
        
        
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.showsVerticalScrollIndicator=NO;
        self.tableView.backgroundColor =[UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //    self.tableView.tableHeaderView = self.headerTableView;
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 100)];
        self.tableView.tableHeaderView = self.headerView;

        [self.containerTableView addSubview:self.tableView];
        
        
        self.content = [[NSMutableArray alloc]initWithObjects:
                        @[NSLocalizedString(@"Invite Friends", nil),@"iconInviteFriends"],
                        @[NSLocalizedString(@"Rate us", nil),@"iconRateUs"],
                        @[NSLocalizedString(@"Help & Support", nil),@"iconHelp"],
                        @[NSLocalizedString(@"Tutorial", nil),@"iconTutorial"],
                        @[NSLocalizedString(@"Legend", nil),@"iconLegend"],
                        @[NSLocalizedString(@"Privacy Policy", nil),@"iconPrivacy"],
                        @[NSLocalizedString(@"Terms & Conditions", nil),@"iconTerms"],
                        @[NSLocalizedString(@"Log Out", nil),@"iconLogout"],
                        nil];

        
        
        self.profilePicture = [[PFImageView alloc]initWithFrame:CGRectMake(40, 40, 60, 60)];
        self.profilePicture.layer.cornerRadius = 30;
        self.profilePicture.layer.borderColor =[UIColor whiteColor].CGColor;
        self.profilePicture.layer.borderWidth = 2;
        self.profilePicture.layer.masksToBounds = YES;

        [self.headerView addSubview:self.profilePicture];
        
        
        self.profilePicture.file = [PFUser currentUser][kUserProfilePicture];
        [self.profilePicture loadInBackground];

        
        self.firstName = [[UILabel alloc]initWithFrame:CGRectMake(120, 41, largeurIphone-120, 40)];
        self.firstName.font =[UIFont HelveticaNeue:19];
        self.firstName.textColor =[UIColor whiteColor];
        self.firstName.text = [PFUser currentUser][kUserFirstName];
        [self.headerView addSubview:self.firstName];
        
        
        self.username = [[UILabel alloc]initWithFrame:CGRectMake(120, 63, largeurIphone-120, 40)];
        self.username.font =[UIFont HelveticaNeue:14];
        self.username.textColor =[UIColor colorForHex:@"8D8D8D"];
        self.username.text = [NSString stringWithFormat:@"@%@",[PFUser currentUser][kUserInstaUsername]];
        [self.headerView addSubview:self.username];

        
        self.btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-80, 40, 50, 50)];
        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"btnCancel"] forState:UIControlStateNormal];
        [self.btnCancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:self.btnCancel];
        
    }
    return self;
}




#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    ///Payments
    /// Invite friends
    /// Help & Support
    /// Privacy Policy
    /// Terms & conditions
    /// SIgn out
    
    
    return self.content.count;
    
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Settings";
    
    // Similar to UITableViewCell, but
    SettingsTableViewCell *cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.line.hidden = NO;
    
    cell.name.text = [self.content objectAtIndex:indexPath.row][0];
    
    cell.image.image = [[UIImage imageNamed:[self.content objectAtIndex:indexPath.row][1]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.image.tintColor = [UIColor whiteColor];
    
    
    if (indexPath.row == self.content.count-1) {
        
        cell.line.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 75;
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *value = [self.content objectAtIndex:indexPath.row][0];
    
    
   if ([value isEqualToString:NSLocalizedString(@"Invite Friends", nil)]){
        
        
       [self.delegate openInviteFriends];
       
       
    }else if ([value isEqualToString:NSLocalizedString(@"Rate us", nil)]){
        
        
        [self.delegate openRateUs];

        
    }else if ([value isEqualToString:NSLocalizedString(@"Help & Support", nil)]){
        
        
        [self.delegate openHelpSupport];

    }else if ([value isEqualToString:NSLocalizedString(@"Tutorial", nil)]){
        
        [self hide];
        [self.delegate openTutorial];
        
    }else if ([value isEqualToString:NSLocalizedString(@"Legend", nil)]){
        
        [self.delegate openLegend];
        
    }
    else if ([value isEqualToString:NSLocalizedString(@"Privacy Policy", nil)]){
        
        
        
        [self.delegate openPrivacy];
        
        
    }else if ([value isEqualToString:NSLocalizedString(@"Terms & Conditions", nil)]){
        
        [self.delegate openTerms];

        
        
        
    }else if ([value isEqualToString:NSLocalizedString(@"Log Out", nil)]){
        
        
        [self.delegate openLogout];

    }
    
}

-(void)show{
    
 
    self.profilePicture.file = [PFUser currentUser][kUserProfilePicture];
    [self.profilePicture loadInBackground];
    
    self.firstName.text = [PFUser currentUser][kUserFirstName];
    self.username.text = [NSString stringWithFormat:@"@%@",[PFUser currentUser][kUserInstaUsername]];

    
    self.hidden = NO;
    self.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
    
}

-(void)hide{
    
    self.alpha = 1;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        
    }];
    
    
}




@end
