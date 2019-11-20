//
//  BNavigationController.m
//
//  Created by Julien Levallois on 16-12-20.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import "BNavigationController.h"

@interface BNavigationController ()

@end

@implementation BNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    NSArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"_targets"];
//    if ([targets isKindOfClass:[NSArray class]]) {
//        @try {
//            id interactivePanTarget = [[targets firstObject] valueForKey:@"target"];
//            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:interactivePanTarget action:NSSelectorFromString(@"handleNavigationTransition:")];
//            [self.view addGestureRecognizer:panRecognizer];
//            
//            self.interactivePopGestureRecognizer.enabled = NO;
//        }
//        @catch (NSException *exception) {
//            NSLog(@"%@", exception);
//        }
//    }
//
//    
}

-(BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIPanGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // disable interactivePopGestureRecognizer in the rootViewController of navigationController
        if ([[navigationController.viewControllers firstObject] isEqual:viewController]) {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            // enable interactivePopGestureRecognizer
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
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
