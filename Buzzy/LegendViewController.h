//
//  LegendViewController.h
//  Buzzy
//
//  Created by Julien Levallois on 17-09-11.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
#import "ModelContentPushViewController.h"


#import "LegendTableViewCell.h"

@interface LegendViewController : ModelContentPushViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSMutableArray *content;
@property(nonatomic)UIView *headerView;

@end
