//
//  CommentView.h
//  Buzzy
//
//  Created by Julien Levallois on 17-07-17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
#import "UIPlaceHolderTextView.h"

#import "CommentTableViewCell.h"

@interface CommentView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic)NSMutableArray *comments;

@property(nonatomic)UIButton *btnClose;
@property(nonatomic)UIView *navBar;


@property(nonatomic)UILabel *titlePage;

@property(nonatomic)UIActivityIndicatorView *indicator;


@property(nonatomic)UITableView *tableView;

@property(nonatomic)UIView *containerTableView;


-(void)showCommentsWithBuzz:(PFObject *)buzz;

@property(nonatomic) PFObject *buzz;


//Input

@property (nonatomic) UIView *chatTextViewBackground;
@property (nonatomic) UIPlaceHolderTextView *chatTextView;
@property (nonatomic) UIButton *buttonChatTextView;;

@property(nonatomic)int KeyboardHeight;

@property(nonatomic)BOOL keyboardIsShowing;

@property(nonatomic)UIImageView *bottomLineTextView;

@property(nonatomic)UIView *borderView;


@property(nonatomic)BOOL messageIsSending;

@property(nonatomic)UIImageView *logoEmpty;


@end
