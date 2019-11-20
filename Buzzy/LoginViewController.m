//
//  LoginViewController.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-18.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "LoginViewController.h"
#import "InstagramAuthController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor =[UIColor redBuzzy];
    

    self.instagramVC = [[InstagramAuthController alloc]init];
    self.instagramVC.authDelegate = self;
    
    __weak InstagramAuthController *weakAuthController = self.instagramVC;
    
    
    self.instagramVC.completionBlock = ^(void) {
        [weakAuthController dismissViewControllerAnimated:NO completion:nil];
        
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [weakAuthController loadInstaView];

    };
    
    if (IS_IPHONEX) {
        self.btnLogin =[[UIButton alloc]initWithFrame:CGRectMake((largeurIphone-300)/2, hauteurIphone-155-20, 300, 60)];

    }else{
        self.btnLogin =[[UIButton alloc]initWithFrame:CGRectMake((largeurIphone-300)/2, hauteurIphone-155, 300, 60)];

    }
    [self.btnLogin setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"btnLogin", nil)] forState:UIControlStateNormal];
    [self.btnLogin addTarget:self action:@selector(checkInstagramAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLogin];
    
    
    if (IS_IPHONE_4) {
        
        self.imgLogo =[[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone-120)/2, 120, 120, 160)];

        
    }else if( IS_IPHONE_5) {
        
        self.imgLogo =[[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone-173)/2, 130, 173, 233)];

    }else{
        
        self.imgLogo =[[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone-173)/2, 175, 173, 233)];

    }
    
    self.imgLogo.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:self.imgLogo];
    
    
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imgLogo.frame.origin.y-85, largeurIphone, 60)];
    self.name.font =[UIFont BerkshireSwash:40];
    self.name.textAlignment = NSTextAlignmentCenter;
    self.name.textColor = [UIColor whiteColor];
    self.name.text = NSLocalizedString(@"Buzzy", nil);
    [self.view addSubview:self.name];
    
    
    if (IS_IPHONEX) {
        self.line =[[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone-110)/2, hauteurIphone-65-20, 110, 1)];

    }else{
        
        self.line =[[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone-110)/2, hauteurIphone-65, 110, 1)];

    }
    self.line.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.line];
    
    
    
    if (IS_IPHONEX) {
        
        if ([Utils languageFr]) {
            self.terms = [[UIButton alloc]initWithFrame:CGRectMake(0, hauteurIphone-65-20, largeurIphone, 65)];
            self.terms.titleLabel.numberOfLines =2;
            
        }else{
            
            self.terms = [[UIButton alloc]initWithFrame:CGRectMake(0, hauteurIphone-65-20, largeurIphone, 65)];
            
        }
    }else{
        
        if ([Utils languageFr]) {
            self.terms = [[UIButton alloc]initWithFrame:CGRectMake(0, hauteurIphone-65, largeurIphone, 65)];
            self.terms.titleLabel.numberOfLines =2;
            
        }else{
            
            self.terms = [[UIButton alloc]initWithFrame:CGRectMake(0, hauteurIphone-65, largeurIphone, 65)];
            
        }
    }
   
    
    self.terms.titleLabel.font =[UIFont HelveticaNeueLight:14];
    self.terms.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.terms setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.terms setTitle:NSLocalizedString(@"By signing up, you agree to our Terms", nil) forState:UIControlStateNormal];
    [self.terms addTarget:self action:@selector(openTerms) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.terms];

    self.genderLabel =[[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, (hauteurIphone-120)/2-40, largeurIphone, 120)];
    self.genderLabel.font =[UIFont BerkshireSwash:24];
    self.genderLabel.textColor = [UIColor whiteColor];
    self.genderLabel.textAlignment = NSTextAlignmentCenter;
    self.genderLabel.hidden = YES;
    self.genderLabel.numberOfLines = 3;
    [self.view addSubview:self.genderLabel];
    
    self.couronne =[[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone-62)/2, self.genderLabel.frame.origin.y-70, 62, 55)];
    self.couronne.image =[UIImage imageNamed:@"couronneLogin"];
    self.couronne.hidden = YES;
    
    [self.view addSubview:self.couronne];
    
    
    
    self.queen =[[UIButton alloc]initWithFrame:CGRectMake((largeurIphone-80-45-45)/2, hauteurIphone-80-100, 45, 102)];
    [self.queen setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"QueenEn", nil)] forState:UIControlStateNormal];
    self.queen.hidden = YES;
    [self.queen addTarget:self action:@selector(chooseQueen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.queen];
    
    
    self.king =[[UIButton alloc]initWithFrame:CGRectMake((largeurIphone-80-45-45)/2+80+45, hauteurIphone-80-100, 45, 102)];
    [self.king setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"KingEn", nil)] forState:UIControlStateNormal];
    self.king.hidden = YES;
    [self.king addTarget:self action:@selector(chooseKing) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.king];
    
    
    
    

}


-(void)openTerms{
    
    
    [self.navigationController pushViewController:[[WebViewViewController alloc]initWithStyle:kStyleWhite type:kTypeText title:NSLocalizedString(@"Terms & Conditions", nil)
                                                                                          url:[NSURL URLWithString:[PFConfig currentConfig][kConfigTerms]]] animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//This is our authentication delegate. When the user logs in, and
// Instagram sends us our auth token, we receive that here.
-(void) didAuthWithToken:(NSString*)token andObjectId:(NSString *)objectId
{
    
    
    if (!token || !objectId) {
        
        appStopLoading;
        NSLog(@"error token null");
        return;
        
    }
    
    
    appPlayLoading;

    [PFInstagramUtils logInInBackgroundWithAccessToken:token instaId:objectId block:^(PFUser * _Nullable user, NSError * _Nullable error) {


        appPlayLoading;

            [[IntercomControl sharedInstance] loginIntercomWithId:[PFUser currentUser].objectId];

        
            [PFCloud callFunctionInBackground:@"getUserInstagram" withParameters:@{@"accessToken":token, @"userId":objectId  } block:^(NSDictionary *dic2, NSError * _Nullable error){
                
                appPlayLoading;


                NSLog(@"Voici le content que l'on recoit de insta : %@",dic2);
                
                if (error) {
                    
                    NSLog(@"error getUserInsta %@",error);
                    
                    
                    
                }else{
                    
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:dic2];
                    
                 
                    
                    if ([dic  objectForKey:@"full_name"] ) {
                        
                        if ([[dic  objectForKey:@"full_name"] isEqualToString:@""]) {
                            
                            [dic removeObjectForKey:@"full_name"];
                        
                        }
                    }
                    
                    if ([dic  objectForKey:@"full_name"] ) {
                        
                        [PFUser currentUser][kUserFirstName]= [Utils capitalizedFirstLetterInString:[dic objectForKey:@"full_name"]];
                        [PFUser currentUser][kUserInstaUsername]= [Utils capitalizedFirstLetterInString:[dic objectForKey:@"username"]];
                        [PFUser currentUser][kUserIdInsta]= [dic objectForKey:@"id"];
                        [PFUser currentUser][@"firstName"]= [Utils capitalizedFirstLetterInString:[dic  objectForKey:@"full_name"]];
                        
                        
                        
                        
                        ICMUserAttributes *attrs = [[ICMUserAttributes alloc] init];
                        attrs.name = [Utils capitalizedFirstLetterInString:[dic  objectForKey:@"full_name"]];
                        attrs.customAttributes =@{ @"idInsta" : [dic  objectForKey:@"id"]};
                        
                        [Intercom updateUser:attrs];

                        
                    }else{
                        
                        [PFUser currentUser][kUserFirstName]= [Utils capitalizedFirstLetterInString:[dic objectForKey:@"username"]];
                        [PFUser currentUser][kUserInstaUsername]= [Utils capitalizedFirstLetterInString:[dic objectForKey:@"username"]];
                        [PFUser currentUser][kUserIdInsta]= [dic objectForKey:@"id"];
                        [PFUser currentUser][@"firstName"]= [Utils capitalizedFirstLetterInString:[dic  objectForKey:@"username"]];
                        
                        
                        ICMUserAttributes *attrs = [[ICMUserAttributes alloc] init];
                        attrs.name =  [Utils capitalizedFirstLetterInString:[dic  objectForKey:@"username"]];
                        attrs.customAttributes =@{ @"idInsta" : [dic  objectForKey:@"id"]};
                        
                        [Intercom updateUser:attrs];
                    }
                    
                    if ([dic  objectForKey:@"profile_picture"]) {
                        
                        appPlayLoading;

                        dispatch_async(dispatch_get_global_queue(0,0), ^{
                            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[dic  objectForKey:@"profile_picture"]]];
                            if ( data == nil )
                                return;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                PFFile *profilePicture = [PFFile fileWithName:@"profilePicture.png" data:data];
                                [profilePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                    
                                    [PFUser currentUser][kUserProfilePicture] = profilePicture;
                                    
                                    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                                    
                                    [PFUser currentUser][kUserLanguage] = language;
                                    
                                    
                                    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                        
                                        
                                        
                                        
                                        
                                        ///// On save un object installation pour le user
                                        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                        [currentInstallation addUniqueObject:@"Global" forKey:@"channels"];
                                        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                                        [currentInstallation setObject:language forKey:@"language"];
                                        [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
                                        
                                        
                                        if ([PFUser currentUser][kUserFirstName]) {
                                            
                                            [currentInstallation setObject:[PFUser currentUser][kUserFirstName] forKey:kUserFirstName];
                                            
                                        }
                                        
                                        
                                        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                            
                                            
                                            
                                            
                                            
                                            if ([PFUser currentUser][kUserGender]) {
                                                
                                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                [appDelegate loginVCCustomer];
                                                
                                                
                                            }else{
                                                
                                                
                                                [self addGender];
                                                
                                                
                                            }
                                            
                                            
                                            
                                            
                                        }];
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                    }];
                                    
                                }];
                                
                                
                            });
                        });
                        

                        
                    }else{
                        
                        
                        
                       
                                    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                                    
                                    [PFUser currentUser][kUserLanguage] = language;
                                    
                                    
                                    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                        
                                        
                                        
                                        
                                        
                                        ///// On save un object installation pour le user
                                        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                        [currentInstallation addUniqueObject:@"Global" forKey:@"channels"];
                                        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                                        [currentInstallation setObject:language forKey:@"language"];
                                        [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
                                        
                                        
                                        if ([PFUser currentUser][kUserFirstName]) {
                                            
                                            [currentInstallation setObject:[PFUser currentUser][kUserFirstName] forKey:kUserFirstName];
                                            
                                        }
                                        
                                        
                                        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                            
                                            
                                            
                                            
                                            
                                            if ([PFUser currentUser][kUserGender]) {
                                                
                                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                [appDelegate loginVCCustomer];
                                                
                                                
                                            }else{
                                                
                                                
                                                [self addGender];
                                                
                                                
                                            }
                                            
                                            
                                            
                                            
                                        }];
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                    }];
                                    
                        
                    

                        
                    }
                    
                    

                    
                    
                }
                
                                                                               
                                                                               
                
              
                                                                    
                                                                               
                                                                               
                                                                               
            }];

        
        

    }];
    
    
    

    

//    if(!token)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                            message:@"Failed to request token."
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        return;
//    }
//    
//    //As a test, we'll request a list of popular Instagram photos.
//    NSString *instagramBase = @"https://api.instagram.com/v1";
//    NSString *popularURLString = [NSString stringWithFormat:@"%@/users/self/media/recent/?access_token=%@", instagramBase, token];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:popularURLString]];
//    
//    NSOperationQueue *theQ = [NSOperationQueue new];
//    [NSURLConnection sendAsynchronousRequest:request queue:theQ
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               
//                               NSError *err;
//                               id val = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
//                               
//                               if(!err && !error && val && [NSJSONSerialization isValidJSONObject:val])
//                               {
//                                   NSArray *data = [val objectForKey:@"data"];
//                                   
//                                   dispatch_sync(dispatch_get_main_queue(), ^{
//                                       
//                                       if(!data)
//                                       {
//                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                                                               message:@"Failed to request perform request."
//                                                                                              delegate:nil
//                                                                                     cancelButtonTitle:@"OK"
//                                                                                     otherButtonTitles:nil];
//                                           [alertView show];
//                                       } else
//                                       {
//                                           
//                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
//                                                                                               message:@"Successfully retrieved popular photos!"
//                                                                                              delegate:nil
//                                                                                     cancelButtonTitle:@"OK"
//                                                                                     otherButtonTitles:nil];
//                                           [alertView show];
//                                           
//                                           
//                                           NSLog(@"dataaa %@",data);
//                                           
//                                       }
//                                   });
//                               }
//                           }];
    
    

 
  
    
    
}


-(void)addGender{
    
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint * _Nullable geoPoint, NSError * _Nullable error) {
        
    }];
    
    
    [self.genderLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Hi %@,\nare you a Queen\nor a King ?", nil),[PFUser currentUser][kUserFirstName]] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
       
        NSRange range = [[mutableAttributedString string] rangeOfString:@"Queen" options:NSCaseInsensitiveSearch];
        NSRange range2 = [[mutableAttributedString string] rangeOfString:@"King" options:NSCaseInsensitiveSearch];
        NSRange range3 = [[mutableAttributedString string] rangeOfString:[PFUser currentUser][kUserFirstName] options:NSCaseInsensitiveSearch];

        UIFont *customSize = [UIFont BerkshireSwash:30];
        
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)customSize.fontName, customSize.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range2];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range3];

            CFRelease(font);
        }
        
        return mutableAttributedString;
    }];
    
    
    
    self.genderLabel.alpha = 0;
    self.genderLabel.hidden = NO;
    
    
    self.couronne.hidden = NO;
    self.couronne.alpha = 0;

    self.king.hidden = NO;
    self.king.alpha = 0;

    self.queen.hidden = NO;
    self.queen.alpha = 0;

    appStopLoading;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.imgLogo.alpha = 0;
                         self.btnLogin.alpha = 0;
                         self.line.alpha = 0;
                         self.terms.alpha = 0;
                         self.name.alpha = 0;

                     }
                     completion:^(BOOL finished){

                         [UIView animateWithDuration:0.5
                                               delay:0
                                             options: UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                           
                                              
                                              self.genderLabel.alpha = 1;
                                              self.couronne.alpha = 1;
                                              self.queen.alpha = 1;
                                              self.king.alpha = 1;

                                              
                                          }
                                          completion:^(BOOL finished){

                                          
                                          
                                          }];

                         
                         
                     }];
    
    
}



-(void) checkInstagramAuth
{
    
       
    self.instagramVC.modalPresentationStyle = UIModalPresentationFormSheet;
    self.instagramVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:self.instagramVC animated:YES completion:^{
    
        
        
    
    } ];
    
    
}

-(void)chooseKing{
    
    appPlayLoading;
    
    [PFUser currentUser][kUserGender]= @"male";
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
       
        
        ICMUserAttributes *attrs = [[ICMUserAttributes alloc] init];
        attrs.customAttributes =@{ @"gender" : @"male"};
        
        [Intercom updateUser:attrs];
        
        

        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loginVCCustomer];

    }];
}


-(void)chooseQueen{
    
    appPlayLoading;
    
    [PFUser currentUser][kUserGender]= @"female";
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        ICMUserAttributes *attrs = [[ICMUserAttributes alloc] init];
        attrs.customAttributes =@{ @"gender" : @"female"};
        
        [Intercom updateUser:attrs];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loginVCCustomer];
        
    }];
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
