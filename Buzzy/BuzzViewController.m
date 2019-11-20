//
//  PretentViewController.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-14.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "BuzzViewController.h"
#import "AppDelegate.h"


@interface BuzzViewController ()

@end

@implementation BuzzViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    
}


-(instancetype)initWithBuzzs:(NSArray *)buzzs andPretendant:(BOOL)pretendant fromLiked:(BOOL)liked{

self = [super init];
if(self)
{
    
    self.pretendant = pretendant;
    self.fromLiked = liked;
    
    self.buzzs = [[NSMutableArray alloc]initWithArray:buzzs];
    
    for (int i = 0; i<self.buzzs.count; i++) {
        
        
        PFObject *buzz = self.buzzs[i];
        
        
        if (buzz[kBuzzPhoto]) {
            
            PFFile *photo = buzz[kBuzzPhoto];
            [photo getDataInBackground];
        }
        
        if (buzz[kBuzzVideo]) {
            
            PFFile *video = buzz[kBuzzVideo];
            [video getDataInBackground];
            
        }

        
        
        if ([[buzz objectForKey:kBuzzCountry] objectForKey:kCountryFlag]) {
            
            
            PFImageView *flag;
            
            
            flag.file = [[buzz objectForKey:kBuzzCountry] objectForKey:kCountryFlag];
            
            [flag loadInBackground];
            
        }
        
    }
    
    
    
    
    
}
return self;


}



-(instancetype)initWithBuzzs:(NSArray *)buzzs andPretendant:(BOOL)pretendant{
    
    
    self = [super init];
    if(self)
    {
        
        self.pretendant = pretendant;
        
        self.buzzs = [[NSMutableArray alloc]initWithArray:buzzs];
        
        for (int i = 0; i<self.buzzs.count; i++) {
            
            
            PFObject *buzz = self.buzzs[i];
           
            
            if (buzz[kBuzzPhoto]) {
                
                PFFile *photo = buzz[kBuzzPhoto];
                [photo getDataInBackground];
            }
            
            if (buzz[kBuzzVideo]) {
                
                PFFile *video = buzz[kBuzzVideo];
                [video getDataInBackground];
                
            }

            
            
            
            if ([[buzz objectForKey:kBuzzCountry] objectForKey:kCountryFlag]) {
                
                
                PFImageView *flag;
                
                
                flag.file = [[buzz objectForKey:kBuzzCountry] objectForKey:kCountryFlag];
                
                [flag loadInBackground];
                
            }

        }
        
        

        
        
    }
    return self;
    
    
}

-(instancetype)initWithBuzzs:(NSArray *)buzzs andimage:(UIImage *)image andPretendant:(BOOL)pretendant{
    
    
    self = [super init];
    if(self)
    {
        
        self.pretendant = pretendant;

        
        self.buzzs = [[NSMutableArray alloc]initWithArray:buzzs];
        
        for (int i = 0; i<self.buzzs.count; i++) {
            
            
            self.myImage = image;
            
            PFObject *buzz = self.buzzs[i];
            
            if (buzz[kBuzzPhoto]) {
                
                PFFile *photo = buzz[kBuzzPhoto];
                [photo getDataInBackground];
            }
            
            if (buzz[kBuzzVideo]) {
                
                PFFile *video = buzz[kBuzzVideo];
                [video getDataInBackground];
                
            }

            
            
            
            if ([[buzz objectForKey:kBuzzCountry] objectForKey:kCountryFlag]) {
                
                
                PFImageView *flag;
                
                
                flag.file = [[buzz objectForKey:kBuzzCountry] objectForKey:kCountryFlag];
                
                [flag loadInBackground];
                
            }
            
        }
        
        
        
        
        
    }
    return self;
    
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        
    self.backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    [self.view addSubview:self.backgroundImage];
    self.backgroundImage.image =  self.myImage;

    self.swipeView = [[SwipeView alloc]initWithFrame:CGRectMake( -5, -5, largeurIphone+10, hauteurIphone+10)];
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    self.swipeView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:self.swipeView];

    
    self.commentView = [[CommentView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    [self.view addSubview:self.commentView];
    
    self.mybuzzlikesview = [[MyBuzzLikesView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    [self.view addSubview:self.mybuzzlikesview];
    
    
    self.kingsView = [[KingsView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
    self.kingsView.delegate=self;
    [self.view addSubview:self.kingsView];

    

    
}

#pragma mark - KingsView Delegate
-(void)launchBuzz:(PFObject *)buzz pretendantType:(BOOL)pretendant{
    
    NSArray *buzzs = [[NSArray alloc]initWithObjects:buzz, nil];
    
    [self openBuzzWithArray:buzzs andPretendant:pretendant];
    
    
}


//////
//////
//////


-(void)buzzOpenKing:(PFObject *)buzz{
    
    

    [self.kingsView showWithBuzz:buzz];
    
}
-(void)buzzOpenComment:(PFObject *)buzz{
    
    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshNotifs];

    [self.commentView showCommentsWithBuzz:buzz];
 
}


-(void)buzzOpenLikes:(PFObject *)buzz{
    
    
    [self.mybuzzlikesview showLikesWithBuzz:buzz];
    
}

-(void)preloadPretenders:(PFObject *)buzz{
    
    if ([buzz[@"tutoriel"] isEqual:@YES]) {
        
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:@"tutoriel" equalTo:@YES];
        [query1 whereKey:@"fakeKing" notEqualTo:@YES];
        
        [query1 includeKey:kBuzzUser];
        [query1 includeKey:kBuzzCity];
        [query1 includeKey:kBuzzCountry];
        [query1 includeKey:kBuzzUniversity];
        [query1 includeKey:@"fakeCountry"];
        
        [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzsA, NSError * _Nullable error) {
            
            
            
            
            if (buzzsA != NULL && buzzsA.count > 0) {
                
                for (int i = 0; i<buzzsA.count; i++) {
                    
                    
                    PFObject *buzz = buzzsA[i];
                    
                    if (buzz[kBuzzPhoto]) {
                        
                        PFFile *photo = buzz[kBuzzPhoto];
                        [photo getDataInBackground];
                    }
                    
                    if (buzz[kBuzzVideo]) {
                        
                        PFFile *video = buzz[kBuzzVideo];
                        [video getDataInBackground];
                        
                    }
                    
                    
                    
                }

                
            }else{
                
                
            }
            
            
            
            
            
        }];
        
        
        
        return;
        
    }
    
    if ([buzz[kBuzzKingCountry] isEqual:@YES]) {
        
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
        
        //        PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
        //        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
        
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        
        
        [query whereKey:kBuzzCountry equalTo:buzz[kBuzzCountry]];
        [query whereKey:@"objectId" notEqualTo:buzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];
        
        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzsA, NSError * _Nullable error) {
            //
            //            if (self.swipeView.visibleCardsCount > 0) {
            //
            //                DraggableCardView *card = self.swipeView.visibleCardsViewArray[0];
            //                [card.contentView.btnSword.layer removeAllAnimations];
            //            }
            //
            
            
            
            if (buzzsA != NULL && buzzsA.count > 0) {
                
                for (int i = 0; i<buzzsA.count; i++) {
                    
                    
                    PFObject *buzz = buzzsA[i];
                    
                    if (buzz[kBuzzPhoto]) {
                        
                        PFFile *photo = buzz[kBuzzPhoto];
                        [photo getDataInBackground];
                    }
                    
                    if (buzz[kBuzzVideo]) {
                        
                        PFFile *video = buzz[kBuzzVideo];
                        [video getDataInBackground];
                        
                    }
                    
                    
                    
                }

                
            }else{
                
                
            }
            
            
            
            
            
        }];
        
        
    }else if([buzz[kBuzzKingCity] isEqual:@YES]){
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
        //
        //        PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
        //        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
        //
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        
        
        [query whereKey:kBuzzCity equalTo:buzz[kBuzzCity]];
        [query whereKey:@"objectId" notEqualTo:buzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];
        
        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzsA, NSError * _Nullable error) {
            
            
            if (buzzsA != NULL && buzzsA.count > 0) {
             
                for (int i = 0; i<buzzsA.count; i++) {
                    
                    
                    PFObject *buzz = buzzsA[i];
                    
                    if (buzz[kBuzzPhoto]) {
                        
                        PFFile *photo = buzz[kBuzzPhoto];
                        [photo getDataInBackground];
                    }
                    
                    if (buzz[kBuzzVideo]) {
                        
                        PFFile *video = buzz[kBuzzVideo];
                        [video getDataInBackground];
                        
                    }
                    
                    
                    
                }

            }else{
                
                
            }
            
            
            
            
        }];
        
        
        
        
    }else if([buzz[kBuzzKingUniversity] isEqual:@YES]){
        
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
        //
        //        PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
        //        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
        
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        
        //        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
        
        [query whereKey:kBuzzUniversity equalTo:buzz[kBuzzUniversity]];
        [query whereKey:@"objectId" notEqualTo:buzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];
        
        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzsA, NSError * _Nullable error) {
            
            
            //            if (self.swipeView.visibleCardsCount > 0) {
            //
            //                DraggableCardView *card = self.swipeView.visibleCardsViewArray[0];
            //                [card.contentView.btnSword.layer removeAllAnimations];
            //            }
            
            if (buzzsA != NULL && buzzsA.count > 0) {
                
                
                for (int i = 0; i<buzzsA.count; i++) {
                    
                    
                    PFObject *buzz = buzzsA[i];
                    
                    if (buzz[kBuzzPhoto]) {
                        
                        PFFile *photo = buzz[kBuzzPhoto];
                        [photo getDataInBackground];
                    }
                    
                    if (buzz[kBuzzVideo]) {
                        
                        PFFile *video = buzz[kBuzzVideo];
                        [video getDataInBackground];
                        
                    }
                    
                    
                    
                }

                
                
            }else{
                
                
            }
            
            
            
        }];
        
        
        
        
    }else{
        
        
    
    }
    
    
}
-(void)buzzOpenPretendant:(PFObject *)buzz{

    
    
    if ([buzz[@"tutoriel"] isEqual:@YES]) {
        
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:@"tutoriel" equalTo:@YES];
        [query1 whereKey:@"fakeKing" notEqualTo:@YES];
        
        [query1 includeKey:kBuzzUser];
        [query1 includeKey:kBuzzCity];
        [query1 includeKey:kBuzzCountry];
        [query1 includeKey:kBuzzUniversity];
        [query1 includeKey:@"fakeCountry"];
        
        [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzsA, NSError * _Nullable error) {
            
            
            
            
            if (buzzsA != NULL && buzzsA.count > 0) {
                
                
                int newIndexNumber = 0;
                
                NSMutableArray *buzzs = [[NSMutableArray alloc]init];
                
                for (int i = 0; i<buzzsA.count; i++) {
                    
                    
                    PFObject *buzz = [buzzsA objectAtIndex:i];
                    
                    if ([[[Following sharedInstance]following] containsObject:buzz[kBuzzInstaUsername]]){
                        
                        [buzzs insertObject:buzz atIndex:newIndexNumber];
                        newIndexNumber = newIndexNumber+1;
                        
                    }else{
                        
                        [buzzs addObject:buzz];
                        
                    }
                    
                    
                }
                
                
                [self dismissViewControllerAnimated:NO completion:^{
                    
                }];
                
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] openBuzzWithArray:buzzs andPretendant:YES];
                
                
               
                
            }else{
                
                
            }
            
            
            

            
        }];
        

        
        return;
        
    }
    
    if ([buzz[kBuzzKingCountry] isEqual:@YES]) {
        
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
        
//        PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
//        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
        
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];

        
        [query whereKey:kBuzzCountry equalTo:buzz[kBuzzCountry]];
        [query whereKey:@"objectId" notEqualTo:buzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];

        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzsB, NSError * _Nullable error) {
//            
//            if (self.swipeView.visibleCardsCount > 0) {
//                
//                DraggableCardView *card = self.swipeView.visibleCardsViewArray[0];
//                [card.contentView.btnSword.layer removeAllAnimations];
//            }
//            

            

            if (buzzsB != NULL && buzzsB.count > 0) {
                
                
                    
                    NSArray *objectsSorted = [buzzsB sortedArrayUsingComparator:^NSComparisonResult(PFObject *buzz1, PFObject *buzz2) {
                        
                        
                        if([buzz1[kBuzzLikeNumber] intValue] == [buzz2[kBuzzLikeNumber] intValue]){
                            
                            if (!buzz2[kBuzzKingCity] && buzz1[kBuzzKingCity]) {
                                
                                return (NSComparisonResult)NSOrderedAscending;
                                
                            }else{
                                
                                return (NSComparisonResult)NSOrderedSame;
                                
                            }
                            
                        }else{
                            return (NSComparisonResult)NSOrderedSame;
                            
                        }
                        
                        
                    }];
                    
                    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"likeNumber" ascending:NO];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
                    
                    NSArray * buzzsA = [objectsSorted sortedArrayUsingDescriptors:sortDescriptors];

                    
                    
                int newIndexNumber = 0;
                
                NSMutableArray *buzzs = [[NSMutableArray alloc]init];
                
                for (int i = 0; i<buzzsA.count; i++) {
                    
                    
                    PFObject *buzz = [buzzsA objectAtIndex:i];
                    
                   if ([[[Following sharedInstance]following] containsObject:buzz[kBuzzInstaUsername]]){
                       
                       [buzzs insertObject:buzz atIndex:newIndexNumber];
                       newIndexNumber = newIndexNumber+1;
                       
                   }else{
                       
                       [buzzs addObject:buzz];
                       
                   }

        
                }
                
                
                
                [self dismissViewControllerAnimated:NO completion:^{
                    
                }];
                
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] openBuzzWithArray:buzzs andPretendant:YES];
                
                

            }else{
                
                
            }
            
            
            
            
            
        }];
        
        
    }else if([buzz[kBuzzKingCity] isEqual:@YES]){
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
//        
//        PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
//        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
//        
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];

        
        [query whereKey:kBuzzCity equalTo:buzz[kBuzzCity]];
        [query whereKey:@"objectId" notEqualTo:buzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];

        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzsB, NSError * _Nullable error) {
            
            
            if (buzzsB != NULL && buzzsB.count > 0) {
                
                NSArray *objectsSorted = [buzzsB sortedArrayUsingComparator:^NSComparisonResult(PFObject *buzz1, PFObject *buzz2) {
                    
                    
                    if([buzz1[kBuzzLikeNumber] intValue] == [buzz2[kBuzzLikeNumber] intValue]){
                        
                        if (!buzz2[kBuzzKingUniversity] && buzz1[kBuzzKingUniversity]) {
                            
                            return (NSComparisonResult)NSOrderedDescending;
                            
                        }else{
                            
                            return (NSComparisonResult)NSOrderedSame;
                            
                        }
                        
                    }else{
                        return (NSComparisonResult)NSOrderedSame;
                        
                    }
                    
                    
                }];
                
                NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"likeNumber" ascending:NO];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
                
                NSArray * buzzsA = [objectsSorted sortedArrayUsingDescriptors:sortDescriptors];

                
                int newIndexNumber = 0;
                
                NSMutableArray *buzzs = [[NSMutableArray alloc]init];
                
                for (int i = 0; i<buzzsA.count; i++) {
                    
                    
                    PFObject *buzz = [buzzsA objectAtIndex:i];
                    
                    if ([[[Following sharedInstance]following] containsObject:buzz[kBuzzInstaUsername]]){
                        
                        [buzzs insertObject:buzz atIndex:newIndexNumber];
                        newIndexNumber = newIndexNumber+1;
                        
                    }else{
                        
                        [buzzs addObject:buzz];
                        
                    }
                    
                    
                }

                
                [self dismissViewControllerAnimated:NO completion:^{
                    
                }];
                
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] openBuzzWithArray:buzzs andPretendant:YES];
                
                

            }else{
                
                
            }
            
            
            
            
        }];
        
        
        
        
    }else if([buzz[kBuzzKingUniversity] isEqual:@YES]){
        
        
        PFQuery *query1 = [PFQuery queryWithClassName:kBuzzClasseName];
        [query1 whereKey:kBuzzLike notEqualTo:[PFUser currentUser].objectId];
        [query1 whereKey:kBuzzView notEqualTo:[PFUser currentUser].objectId];
        
        
//        
//        PFQuery *query2 = [PFQuery queryWithClassName:kBuzzClasseName];
//        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];
        
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1]];
        
        
        NSDate *date = [NSDate date];
        NSDate *yesterday = [date dateByAddingTimeInterval:-1*24*60*60];
        
        [query whereKey:kBuzzWhen greaterThan:yesterday];
        [query whereKey:kBuzzDeleted notEqualTo:@YES];
        
        //        [query2 whereKey:kBuzzLike equalTo:[PFUser currentUser].objectId];

        [query whereKey:kBuzzUniversity equalTo:buzz[kBuzzUniversity]];
        [query whereKey:@"objectId" notEqualTo:buzz.objectId];
        [query whereKey:kBuzzUser notEqualTo:[PFUser currentUser]];

        [query includeKey:kBuzzUser];
        [query includeKey:kBuzzCity];
        [query includeKey:kBuzzCountry];
        [query includeKey:kBuzzUniversity];
        
        [query orderByDescending:kBuzzKingCountry];
        [query addDescendingOrder:kBuzzKingCity];
        [query addDescendingOrder:kBuzzKingUniversity];
        [query addDescendingOrder:kBuzzLikeNumber];
        
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable buzzsA, NSError * _Nullable error) {
            
            
//            if (self.swipeView.visibleCardsCount > 0) {
//                
//                DraggableCardView *card = self.swipeView.visibleCardsViewArray[0];
//                [card.contentView.btnSword.layer removeAllAnimations];
//            }

            if (buzzsA != NULL && buzzsA.count > 0) {
                
                
                int newIndexNumber = 0;
                
                NSMutableArray *buzzs = [[NSMutableArray alloc]init];
                
                for (int i = 0; i<buzzsA.count; i++) {
                    
                    
                    PFObject *buzz = [buzzsA objectAtIndex:i];
                    
                    if ([[[Following sharedInstance]following] containsObject:buzz[kBuzzInstaUsername]]){
                        
                        [buzzs insertObject:buzz atIndex:newIndexNumber];
                        newIndexNumber = newIndexNumber+1;
                        
                    }else{
                        
                        [buzzs addObject:buzz];
                        
                    }
                    
                    
                }

                
                [self dismissViewControllerAnimated:NO completion:^{
                    
                }];
                
                [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] openBuzzWithArray:buzzs andPretendant:YES];
                
                

                
            }else{
                
                
            }
            
            
            
        }];
        
        
        
        
    }else{
        
        
//        if (self.swipeView.visibleCardsCount > 0) {
//            
//            DraggableCardView *card = self.swipeView.visibleCardsViewArray[0];
//            [card.contentView.btnSword.layer removeAllAnimations];
//        }

    }
    
}



-(void)openBuzzWithArray:(NSArray *)buzzs andPretendant:(BOOL)pretendant{
    
    
    BuzzViewController *buzzVC = [[BuzzViewController alloc]initWithBuzzs:buzzs andimage:[self makeImage] andPretendant:pretendant];
    
//    buzzVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:buzzVC];
//    self.animator.dragable = YES;
//    self.animator.bounces = NO;
//    self.animator.behindViewAlpha = 1.0f;
//    self.animator.behindViewScale = 1.0f;
//    self.animator.transitionDuration = 0.7f;
//    buzzVC.transitioningDelegate = self.animator;
//    [self presentViewController:buzzVC animated:YES completion:nil];
    
//
    buzzVC.modalPresentationStyle = UIModalPresentationFullScreen;
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:buzzVC];
    //    self.animator.dragable = YES;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 1.0f;
    self.animator.behindViewScale = 1.0f;
    self.animator.transitionDuration = 0.7f;
    
        buzzVC.transitioningDelegate = self.animator;
        [self presentViewController:buzzVC animated:YES completion:nil];

    
    
}

-(void)setback:(UIImage *)image{

    
    [self.backgroundImage setImage:image];
    
}
-(UIImage*) makeImage {
    
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    
    return viewImage;
}



#pragma mark - SWIPE


- (IBAction)revertAction:(id)sender {
    [self.swipeView revertAction];
}
- (void)likeAction {
    [self.swipeView swipeDirection:SwipeDirectionRight];
}
- (void)ignoreAction {
    [self.swipeView swipeDirection:SwipeDirectionLeft];
}

- (NSUInteger)swipeViewNumberOfCards:(SwipeView *)swipeView
{
    return self.buzzs.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView
          cardAtIndex:(NSUInteger)index {
    
    
    BbCardView *card = [[BbCardView alloc]initWithFrame:CGRectMake(0, 0, self.swipeView.frame.size.width, self.swipeView.frame.size.height)];
    card.delegate = self;
    [card launchBuzz:self.buzzs[index] pretendantType:self.pretendant fromLiked:self.fromLiked];

    if (index == 0) {
        
        [card launchTimer];

    }
    
    return card;
    
}

-(void)cardPassed{
    
    
    
    
//    if (self.swipeView.visibleCardsViewArray.count == 1) {
    
    self.view.alpha = 0;
    
        [self performSelector:@selector(popVC) withObject:self afterDelay:0];

        
//    }else{
//       
//        
//        
//        [self.swipeView swipeDirection:SwipeDirectionLeft];
//
//        
//    }
    
}

- (OverlayView *)swipeView:(SwipeView *)swipeView
        cardOverlayAtIndex:(NSUInteger)index
{
    CustomOverlayView *overlay = [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil][0];
    return overlay;
}

- (void)swipeView:(SwipeView *)swipeView didSwipeCardAtIndex:(NSUInteger)index inDirection:(SwipeDirection)direction
{
    
   
    
    if (swipeView.visibleCardsViewArray.count > 0) {
        
        DraggableCardView *draggable = (DraggableCardView *)swipeView.visibleCardsViewArray[0];
        [draggable.contentView launchTimer];
    }
    
    
}

- (void)swipeViewDidRunOutOfCards:(SwipeView *)swipeView
{
    
    
    [self performSelector:@selector(popVC) withObject:self afterDelay:0.33];

    
}

-(void)popVC{
    
    NSLog(@"pop!");
//    
//    [self dismissViewControllerAnimated:NO completion:^{
//    
//    }];
//
    
    
    if ([self.presentationController.presentingViewController isKindOfClass:[BuzzViewController class]]) {

//        [self.presentingViewController.presentingViewController
//         dismissViewControllerAnimated:NO completion:nil];
        [self
         dismissViewControllerAnimated:NO completion:nil];

        
    }else{
        
        [self
         dismissViewControllerAnimated:NO completion:nil];

    }
    
    if (self.pretendant == YES && ![[NSUserDefaults standardUserDefaults] objectForKey:@"Tuto10"]) {
        
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] showTutoStep:10];

    }
    
    
    
}


- (BOOL)swipeViewShouldApplyAppearAnimation:(SwipeView *)swipeView
{
    return YES;
}

- (BOOL)swipeViewShouldMoveBackgroundCard:(SwipeView *)swipeView
{
    return YES;
}

- (BOOL)swipeViewShouldTransparentizeNextCard:(SwipeView *)swipeView
{
    return YES;
}

- (POPPropertyAnimation *)swipeViewBackgroundCardAnimation:(SwipeView *)swipeView
{
    return nil;
}





-(void)popBBViewController{
    
    
    [self popVC];
    
}



-(void)viewWillAppear:(BOOL)animated{
    



}


-(void)viewDidDisappear:(BOOL)animated{
   
    

}
-(void)viewWillDisappear:(BOOL)animated{
    
    

    
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}



-(void)reportBuzz:(PFObject *)buzz liked:(BOOL)liked{
    
    
//    if (liked == TRUE) {
//
//        NSString *firstName=@"";
//
//        if (buzz[kBuzzUser][kUserInstaUsername]) {
//
//            firstName = buzz[kBuzzUser][kUserInstaUsername];
//
//        }
//
//        UIActionSheet *sheet = [UIActionSheet presentOnView:self.view
//                                                  withTitle:Nil
//                                               cancelButton:NSLocalizedString(@"Cancel", nil)
//                                          destructiveButton:nil
//                                               otherButtons:@[NSLocalizedString(@"Add Friend", nil),[NSString stringWithFormat:NSLocalizedString(@"Report %@", nil),firstName],[NSString stringWithFormat:NSLocalizedString(@"Report BUZZ", nil)]]
//                                                   onCancel:^(UIActionSheet *actionSheet) {
//
//                                                   }
//                                              onDestructive:^(UIActionSheet *actionSheet) {
//                                                  NSLog(@"Touched destructive button");
//
//
//
//                                              }
//                                            onClickedButton:^(UIActionSheet *actionSheet, NSUInteger index) {
//                                                //
//                                                //                                            if (index == 0) {
//                                                //
//                                                //                                            }else{
//                                                //
//                                                //
//                                                //                                            }
//                                                //
//
//                                                if (index == 0) {
//
//
//                                                    PFQuery *searchUser = [PFUser query];
//                                                    [searchUser whereKey:kUserInstaUsername equalTo:firstName];
//
//                                                    [searchUser getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable user, NSError * _Nullable error) {
//
//                                                        if (error) {
//
//
//                                                            return;
//                                                        }
//                                                        if (user) {
//
//                                                            NSLog(@"B");
//
//                                                            if([user.objectId isEqualToString:[PFUser currentUser].objectId]){
//
//                                                                return;
//
//                                                            }
//
//                                                            PFQuery *queryCheck = [PFQuery queryWithClassName:kFollowersClasseName];
//                                                            [queryCheck whereKey:kFollowersFrom equalTo:[PFUser currentUser]];
//                                                            [queryCheck whereKey:kFollowersTo equalTo:user];
//                                                            [queryCheck findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//
//                                                                if ( error || objects.count > 0) {
//
//
//                                                                }else{
//
//                                                                    NSLog(@"C");
//
//
//                                                                    PFObject *friendsObject = [PFObject objectWithClassName:kFollowersClasseName];
//                                                                    friendsObject[kFollowersFrom]= [PFUser currentUser];
//                                                                    friendsObject[kFollowersTo] = user;
//                                                                    [friendsObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//
//                                                                        [[Following sharedInstance]updateFollowingCompletion:^(BOOL succeeded) {
//
//
//
//                                                                            if (![PFUser currentUser]) {
//
//                                                                                return;
//
//                                                                            }
//
//                                                                            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshMapAction];
//
//                                                                        }];
//
//                                                                    }];
//                                                                }
//                                                            }];
//
//
//                                                        }else{
//
//                                                        }
//
//                                                    }];
//
//
//                                                }else{
//
//                                                    PFObject *report = [PFObject objectWithClassName:@"Report"];
//                                                    report[@"buzz"]=buzz;
//                                                    report[@"user"]=[PFUser currentUser];
//
//                                                    [report saveInBackground];
//                                                }
//
//
//
//                                            }];
//
//        [sheet showInView:self.view];
//    }else{
//
    
    if ([[PFConfig currentConfig][@"blockUserFeature"] isEqual:@YES]) {
        
        NSString *firstName=@"";
        
        if (buzz[kBuzzUser][kUserInstaUsername]) {
            
            firstName = buzz[kBuzzUser][kUserInstaUsername];
            
        }
        
        UIActionSheet *sheet = [UIActionSheet presentOnView:self.view
                                                  withTitle:Nil
                                               cancelButton:NSLocalizedString(@"Cancel", nil)
                                          destructiveButton:nil
                                               otherButtons:@[[NSString stringWithFormat:NSLocalizedString(@"Block %@", nil),firstName],[NSString stringWithFormat:NSLocalizedString(@"Report %@", nil),firstName],[NSString stringWithFormat:NSLocalizedString(@"Report BUZZ", nil)]]
                                                   onCancel:^(UIActionSheet *actionSheet) {
                                                       
                                                   }
                                              onDestructive:^(UIActionSheet *actionSheet) {
                                                  NSLog(@"Touched destructive button");
                                                  
                                                  
                                                  
                                              }
                                            onClickedButton:^(UIActionSheet *actionSheet, NSUInteger index) {
    
                                                if (index == 0) {
    
                                                    
                                                }else{
    
                                                    PFObject *report = [PFObject objectWithClassName:@"Report"];
                                                    report[@"buzz"]=buzz;
                                                    report[@"user"]=[PFUser currentUser];
                                                    
                                                    [report saveInBackground];
                                                }
    
                                                
                                         
                                                
                                                
                                            }];
        
        [sheet showInView:self.view];
    }else{
        
        NSString *firstName=@"";
        
        if (buzz[kBuzzUser][kUserInstaUsername]) {
            
            firstName = buzz[kBuzzUser][kUserInstaUsername];
            
        }
        
        UIActionSheet *sheet = [UIActionSheet presentOnView:self.view
                                                  withTitle:Nil
                                               cancelButton:NSLocalizedString(@"Cancel", nil)
                                          destructiveButton:nil
                                               otherButtons:@[[NSString stringWithFormat:NSLocalizedString(@"Report %@", nil),firstName],[NSString stringWithFormat:NSLocalizedString(@"Report BUZZ", nil)]]
                                                   onCancel:^(UIActionSheet *actionSheet) {
                                                       
                                                   }
                                              onDestructive:^(UIActionSheet *actionSheet) {
                                                  NSLog(@"Touched destructive button");
                                                  
                                                  
                                                  
                                              }
                                            onClickedButton:^(UIActionSheet *actionSheet, NSUInteger index) {
                                                //
                                                //                                            if (index == 0) {
                                                //
                                                //                                            }else{
                                                //
                                                //
                                                //                                            }
                                                //
                                                
                                                PFObject *report = [PFObject objectWithClassName:@"Report"];
                                                report[@"buzz"]=buzz;
                                                report[@"user"]=[PFUser currentUser];
                                                
                                                [report saveInBackground];
                                                
                                                
                                            }];
        
        [sheet showInView:self.view];
    }
    
//    }
  
    
}



@end
