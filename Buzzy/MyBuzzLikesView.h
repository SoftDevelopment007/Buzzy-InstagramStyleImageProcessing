//
//  MyBuzzLikesView.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-30.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Base.h"

#import "CommentTableViewCell.h"

@interface MyBuzzLikesView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)NSMutableArray *users;

@property(nonatomic)UIButton *btnClose;

@property(nonatomic)UIView *navBar;

@property(nonatomic)UILabel *titlePage;

@property(nonatomic)UIActivityIndicatorView *indicator;


@property(nonatomic)UITableView *tableView;

@property(nonatomic)UIView *containerTableView;


-(void)showLikesWithBuzz:(PFObject *)buzz;

@property(nonatomic) PFObject *buzz;


//Input



@end
