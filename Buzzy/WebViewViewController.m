//
//  WebViewViewController.m
//  BottleBond
//
//  Created by Julien Levallois on 17-01-28.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"Dealloc Webview");
    
}

-(instancetype)initWithStyle:(enum StyleBB)style type:(enum TypeBB)type title:(NSString *)title url:(NSURL*)url{
    
    
    self = [super initWithStyle:style type:type];
    if(self)
    {
        
        
        self.style = style;
        self.type = type;
        self.titleBB = title;
        self.url = url;
        
        
    }
    return self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.titleLabel.text = self.titleBB;
    self.buttonMore.hidden = YES;
    
    if (self.style == kStyleWhite) {
        
        
        self.titleLabel.textColor=[UIColor blackColor];
        
        
    }else{
        
        self.titleLabel.textColor=[UIColor whiteColor];
        
        
    }
    
    

    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.center = CGPointMake(largeurIphone/2, (hauteurIphone-70)/2 );
    [self.indicator startAnimating];
    [self.view addSubview:self.indicator];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 70, largeurIphone, hauteurIphone-70)];
    self.webView.delegate = self;
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];

    
    
}


-(void)popBBViewController{
    
    
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
    
    
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:requestObj];

    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.webView.hidden = NO;

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
