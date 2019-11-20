//
//  ModelContentPushViewController.m
//  BottleBond
//
//  Created by Julien Levallois on 16-12-25.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import "ModelContentPushViewController.h"

@interface ModelContentPushViewController ()

@end

@implementation ModelContentPushViewController


-(instancetype)initWithStyle:(enum StyleBB)style type:(enum TypeBB)type{
    
    self = [super initWithStyle:style];
    if(self)
    {
        
        
     
        self.type = type;

        
    }
    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
        
        if (IS_IPHONE_5) {
            
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 20, largeurIphone-140, 44)];

        }else if (IS_IPHONEX){
    
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 20+20, largeurIphone-110, 44)];

        }else{
            
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 20, largeurIphone-110, 44)];

        }
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font =[UIFont HelveticaNeueLight:19];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = self.titleBB;
        [self.navigationBarBB addSubview:self.titleLabel];
    
  
    
    // Do any additional setup after loading the view.
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
