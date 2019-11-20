//
//  WebViewViewController.h
//  BottleBond
//
//  Created by Julien Levallois on 17-01-28.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "ModelContentPushViewController.h"

@interface WebViewViewController : ModelContentPushViewController <UIWebViewDelegate>

-(instancetype)initWithStyle:(enum StyleBB)style type:(enum TypeBB)type title:(NSString *)title url:(NSURL *)url;


@property(nonatomic) UIWebView *webView;

@property(nonatomic)NSURL *url;


@property(nonatomic)UIActivityIndicatorView *indicator;



@end
