//
//  scrollFilter.m
//  Buzzy
//
//  Created by Julien Levallois on 17-09-06.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "scrollFilter.h"

#define nbFilter 3


@implementation scrollFilter



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor clearColor];
        
        
        
        self.scroll = [[GBInfiniteScrollView alloc] initWithFrame:self.bounds];
        
        self.scroll.infiniteScrollViewDataSource = self;
        self.scroll.infiniteScrollViewDelegate = self;
        
        self.scroll.pageIndex = 0;
        
        [self addSubview:self.scroll];
       
        
        self.v1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        self.v1.backgroundColor = [UIColor clearColor];
        
        
        self.v2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        self.v2.backgroundColor = [UIColor colorWithRed:95.0/225.0 green:65.0/255.0 blue:17.0/255.0 alpha:0.26];
        
        
        self.v3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
//        self.v3.backgroundColor = [UIColor blueColor];
        self.v3.backgroundColor = [UIColor colorWithRed:253.0/225.0 green:254.0/255.0 blue:225.0/255.0 alpha:0.16];
//        self.v3.image = [self ipMaskedImageNamed:@"filterWhite" ];

        
        self.data = [[NSMutableArray alloc]init];
        [self.data addObject:self.v1];
        [self.data addObject:self.v2];
        [self.data addObject:self.v3];
        
        
        
        [self.scroll reloadData];
        
        

        

        
        
    }
    
    return self;

}


- (UIImage *)ipMaskedImageNamed:(NSString *)name {

    UIImage *image = [UIImage imageNamed:name];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetBlendMode(c, kCGBlendModeLighten);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}


- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView
{    NSLog(@"Next page");

}

- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{    NSLog(@"Previous page");

}

- (BOOL)infiniteScrollViewShouldScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView
{
    return YES;
}

- (BOOL)infiniteScrollViewShouldScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{
    return YES;
}

- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView
{
    return self.data.count;
}

- (GBInfiniteScrollViewPage *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView pageAtIndex:(NSUInteger)index;
{
    
    return [self.data objectAtIndex:index];
}





@end
