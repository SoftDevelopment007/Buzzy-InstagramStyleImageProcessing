//
//  LegendViewController.m
//  Buzzy
//
//  Created by Julien Levallois on 17-09-11.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "LegendViewController.h"

@interface LegendViewController ()

@end

@implementation LegendViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"Dealloc Webview");
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationBarBB.backgroundColor =[UIColor blackColor];
    self.titleLabel.text = NSLocalizedString(@"Legend", nil);
    
    self.buttonMore.hidden = YES;
    
    if (self.style == kStyleWhite) {
        
        
        self.titleLabel.textColor=[UIColor blackColor];
        
        
    }else{
        
        self.titleLabel.textColor=[UIColor whiteColor];
        
        
    }
    
    
    self.bottomLine.backgroundColor =[UIColor colorWithWhite:0.7 alpha:0.1];
    self.buttonPrec.tintColor = [UIColor whiteColor];

    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 25)];

    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, largeurIphone, hauteurIphone-80)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor =[UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.tableHeaderView = self.headerView;
////    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 80)];
//    self.tableView.tableHeaderView = self.headerView;
    
    [self.view addSubview:self.tableView];
    
    if ([PFConfig currentConfig][@"hideFriends"]) {
        
        if ([Utils languageFr]) {
            
            self.content = [[NSMutableArray alloc]initWithObjects:
                            @[NSLocalizedString(@"Liked", nil),@"l2"],
                           // @[NSLocalizedString(@"King's/Queen's friend", nil),@"l8"],
                            @[NSLocalizedString(@"Camera", nil),@"l4"],
                            @[NSLocalizedString(@"Chat", nil),@"l5"],
                            @[NSLocalizedString(@"Kingdom's border", nil),@"l7"],
                            @[NSLocalizedString(@"Kingdoms' list", nil),@"l1"],
                            @[NSLocalizedString(@"My BUZZs", nil),@"l3"],
                            @[NSLocalizedString(@"King's/Queen's pretenders", nil),@"l6"],
                            nil];
            
        }else{
            
            self.content = [[NSMutableArray alloc]initWithObjects:
                            @[NSLocalizedString(@"Camera", nil),@"l4"],
                            @[NSLocalizedString(@"Chat", nil),@"l5"],
                            @[NSLocalizedString(@"Kingdoms' list", nil),@"l1"],
                            @[NSLocalizedString(@"King's/Queen's pretenders", nil),@"l6"],
                            @[NSLocalizedString(@"Kingdom's border", nil),@"l7"],
                         //   @[NSLocalizedString(@"King's/Queen's friend", nil),@"l8"],
                            @[NSLocalizedString(@"Liked", nil),@"l2"],
                            @[NSLocalizedString(@"My BUZZs", nil),@"l3"],
                            nil];
        }

        
    }else{
        
        if ([Utils languageFr]) {
            
            self.content = [[NSMutableArray alloc]initWithObjects:
                            @[NSLocalizedString(@"Liked", nil),@"l2"],
//                            @[NSLocalizedString(@"King's/Queen's friend", nil),@"l8"],
                            @[NSLocalizedString(@"Buzzy's friend", nil),@"l8"],
                            @[NSLocalizedString(@"Camera", nil),@"l4"],
                            @[NSLocalizedString(@"Chat", nil),@"l5"],
                            @[NSLocalizedString(@"Kingdom's border", nil),@"l7"],
                            @[NSLocalizedString(@"Kingdoms' list", nil),@"l1"],
                            @[NSLocalizedString(@"My BUZZs", nil),@"l3"],
                            @[NSLocalizedString(@"King's/Queen's pretenders", nil),@"l6"],
                            nil];
            
        }else{
            
            self.content = [[NSMutableArray alloc]initWithObjects:
                            @[NSLocalizedString(@"Camera", nil),@"l4"],
                            @[NSLocalizedString(@"Chat", nil),@"l5"],
                            @[NSLocalizedString(@"Kingdoms' list", nil),@"l1"],
                            @[NSLocalizedString(@"King's/Queen's pretenders", nil),@"l6"],
                            @[NSLocalizedString(@"Kingdom's border", nil),@"l7"],
//                            @[NSLocalizedString(@"King's/Queen's friend", nil),@"l8"],
                            @[NSLocalizedString(@"Liked", nil),@"l2"],
                            @[NSLocalizedString(@"My BUZZs", nil),@"l3"],
                            nil];
        }

    }
    
    
  
    

    [self.tableView reloadData];
    
    
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
    LegendTableViewCell *cell = (LegendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    cell.name.text = [self.content objectAtIndex:indexPath.row][0];
    
    cell.image.image = [UIImage imageNamed:[self.content objectAtIndex:indexPath.row][1]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 68;
    
    
}




-(void)popBBViewController{
    
    
    NSLog(@"pop");
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
    if (self.style == kStyleWhite) {
        
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
    }else if(self.style == kStyleBlack){
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }
    
    

}


-(void)viewDidDisappear:(BOOL)animated{
    
    if ([self isMovingFromParentViewController])
    {
        
        
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    if ([self isMovingFromParentViewController])
    {
        
        
        
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
        
    }
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
