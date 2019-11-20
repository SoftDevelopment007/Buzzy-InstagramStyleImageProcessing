//
//  ModelPushViewController.m
//  BottleBond
//
//  Created by Julien Levallois on 16-12-25.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import "ModelPushViewController.h"

@interface ModelPushViewController ()

@end

@implementation ModelPushViewController

-(instancetype)initWithStyle:(enum StyleBB )style  {
    
    self = [super init];
    if(self)
    {
        self.style = style;
        
               
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.view.clipsToBounds = YES;

    if (self.style == kStyleWhite) {
        
        [self.view.layer insertSublayer:[Utils gradientBBWhitewithFrame:self.view.frame] atIndex:0];

    }
    
    

    if (IS_IPHONEX) {
        
        self.navigationBarBB =[[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 70+25)];

    }else{
        
        self.navigationBarBB =[[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 70)];

    }
    self.navigationBarBB.clipsToBounds =YES;
    self.navigationBarBB.layer.zPosition = MAXFLOAT-10;

    [self.view addSubview:self.navigationBarBB];
    
    
    if (IS_IPHONEX) {
        
        self.bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 94, largeurIphone, 1)];

    }else{
        
        self.bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 69, largeurIphone, 1)];

    }
    [self.navigationBarBB addSubview:self.bottomLine];
    
    
    if (IS_IPHONEX) {
        
        self.buttonPrec = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 70, 70)];

    }else{
        
        self.buttonPrec = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];

    }
    [self.buttonPrec setBackgroundImage:[[UIImage imageNamed:@"buttonLeftB"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.buttonPrec addTarget:self action:@selector(popBBViewController) forControlEvents:UIControlEventTouchUpInside];
    self.buttonPrec.layer.zPosition = MAXFLOAT;
    [self.navigationBarBB addSubview:self.buttonPrec];
    
    
    
    self.buttonMore = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-70, 0, 70, 70)];
    [self.buttonMore setBackgroundImage:[[UIImage imageNamed:@"buttonMore"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.buttonMore addTarget:self action:@selector(buttonMoreAction) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationBarBB addSubview:self.buttonMore];
    


    
        self.navigationBarBB.backgroundColor=[UIColor colorForHex:@"FDFDFD"];
        self.bottomLine.backgroundColor =[UIColor colorForHex:@"F5F5F5"];
        self.buttonPrec.tintColor = [UIColor blackColor];
        self.buttonMore.tintColor = [UIColor blackColor];
        
       
    
    

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}


-(void)popBBViewController{
    
}

-(void)buttonMoreAction{
    
    
    
      
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
