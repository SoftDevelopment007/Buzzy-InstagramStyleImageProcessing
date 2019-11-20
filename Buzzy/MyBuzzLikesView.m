//
//  MyBuzzLikesView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-30.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "MyBuzzLikesView.h"
#import "AppDelegate.h"


@implementation MyBuzzLikesView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.87];
        self.userInteractionEnabled=YES;
        self.hidden = YES;
        
    
        
        self.indicator = [[UIActivityIndicatorView alloc]init];
        self.indicator.center = self.center;
        self.indicator.hidesWhenStopped=YES;
        [self addSubview:self.indicator];
        
        
        
        
        self.containerTableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        [self addSubview:self.containerTableView];
        
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.containerTableView.bounds;
//        gradient.colors = @[(id)[UIColor clearColor].CGColor,
//                            (id)[UIColor blackColor].CGColor,
//                            (id)[UIColor blackColor].CGColor,
//                            (id)[UIColor clearColor].CGColor];
//        gradient.locations = @[@0.0, @0.15, @0.80, @1.0];
//        self.containerTableView.layer.mask = gradient;
        
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 80)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        

        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 90)];
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
            
        }
        
        self.titlePage.textAlignment = NSTextAlignmentCenter;
        self.titlePage.font = [UIFont HelveticaNeue:20];
        self.titlePage.textColor = [UIColor whiteColor];
        self.titlePage.text = NSLocalizedString(@"Likes", nil);
        [self addSubview:self.titlePage];
        
        
        
     
        
        
    }
    return self;
}

-(void)touch{
    
    //empty
}
-(void)actionBtnClose{
    
    [self hide];
    
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
    return self.users.count;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Comment";
    
    // Similar to UITableViewCell, but
    CommentTableViewCell *cell = (CommentTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    cell.profilePicture.file = [[self.users objectAtIndex:indexPath.row]objectForKey:kUserProfilePicture];
    [cell.profilePicture loadInBackground];
    
    
    
    [cell adjustBubbleWithText:[[self.users objectAtIndex:indexPath.row] objectForKey:kUserInstaUsername]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   
    return 60;
    
    
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@",[self.users objectAtIndex:indexPath.row ] [kUserInstaUsername]]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
    
    
    
}


-(void)showLikesWithBuzz:(PFObject *)buzz{
    
    
//    [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] animator] setDragable:NO];
    
    
    self.buzz = buzz;
    
    
    if (self.users.count == 0) {
        
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
    
    self.users = [[NSMutableArray alloc]init];
    [self.tableView reloadData];
    [self.tableView scrollsToTop];
    
    NSLog(@"xx %@",self.buzz[kBuzzLike]);
    
    PFQuery *queryMess = [PFQuery queryWithClassName:kUserClasseName];
    [queryMess whereKey:@"objectId" containedIn:self.buzz[kBuzzLike]];
    
    [queryMess findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        NSLog(@"oooo %@",objects);
        
        [self.indicator stopAnimating];
        if (objects != false) {
            
            
            self.users = [[NSMutableArray alloc]initWithArray:objects];
            [self.tableView reloadData];
            
            
        }else{
            
            
        }
        
    }];
    
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
