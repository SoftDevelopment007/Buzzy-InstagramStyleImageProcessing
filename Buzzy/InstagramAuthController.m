//
//  InstagramAuthController.m
//  Instagram-Auth-iOS
//
//  Created by buza on 9/27/12.
//  Copyright (c) 2012 BuzaMoto. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "InstagramAuthController.h"
#import "InstagramAuthenticatorView.h"

#import "AppDelegate.h"


@interface InstagramAuthController () <InstagramAuthenticatorViewDelegate>

@property (nonatomic) InstagramAuthenticatorView *instaView;

@end

@implementation InstagramAuthController

@synthesize completionBlock;
@synthesize authDelegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        
        self.authDelegate = nil;
        
        self.view.backgroundColor =[UIColor colorForHex:@"F6F6F8"];
        

        self.instaView = [[InstagramAuthenticatorView alloc] initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        self.instaView.authDelegate = self;
        self.instaView.viewDelegate = self;
        [self.view addSubview:self.instaView];

        
        self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake((largeurIphone-80)/2, hauteurIphone-100, 80, 100)];
        self.cancelBtn.titleLabel.font = [UIFont HelveticaNeue:18];
        self.cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.cancelBtn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBtn setTitleColor:[UIColor colorForHex:@"ACB0B0"] forState:UIControlStateNormal];

        [self.view addSubview:self.cancelBtn];

        [self loadInstaView];

        
    }
    return self;
}



-(void)loadInstaView{
    
    [self.instaView authorize];

}
-(void) dealloc
{
}

-(void)cancelLogin{
        
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        

        
        [self loadInstaView];

        
    }];
    
    
    
}
-(void) didAuthWithToken:(NSString*)token andObjectId:(NSString *)objectId
{
    [self.authDelegate didAuthWithToken:token andObjectId:objectId ];
    self.completionBlock();
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
