//
//  CommentView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-07-17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "CommentView.h"
#import "AppDelegate.h"

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
             
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.87];
        self.userInteractionEnabled=YES;
        self.hidden = YES;
        
              
        self.indicator = [[UIActivityIndicatorView alloc]init];
        self.indicator.center = self.center;
        self.indicator.hidesWhenStopped=YES;
        [self addSubview:self.indicator];
        
        self.logoEmpty =[[UIImageView alloc]initWithFrame:CGRectMake((largeurIphone-57)/2, (hauteurIphone-77)/2, 57, 77)];
        self.logoEmpty.image =[UIImage imageNamed:@"logoEmpty"];
        self.logoEmpty.hidden = YES;
        [self addSubview:self.logoEmpty];
        
        
        self.containerTableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        [self addSubview:self.containerTableView];
//        
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.containerTableView.bounds;
//        gradient.colors = @[(id)[UIColor clearColor].CGColor,
//                            (id)[UIColor blackColor].CGColor,
//                            (id)[UIColor blackColor].CGColor,
//                            (id)[UIColor clearColor].CGColor];
//        gradient.locations = @[@0.0, @0.15, @0.80, @1.0];
//        self.containerTableView.layer.mask = gradient;
//        
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 80)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;

        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 90)];
        [self.containerTableView addSubview:self.tableView];
        

        if (IS_IPHONEX) {
            
            self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 75+25)];
            
        }else{
            
            self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 75)];
            
        }        self.navBar.backgroundColor =[UIColor blackColor];
        [self addSubview:self.navBar];
        self.btnClose = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-50-14, 14, 50, 50)];
        [self.btnClose setBackgroundImage:[UIImage imageNamed:@"btnCancel"] forState:UIControlStateNormal];
        [self.btnClose addTarget:self action:@selector(actionBtnClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnClose];
        
        

        if (IS_IPHONEX) {
            
            self.titlePage = [[UILabel alloc]initWithFrame:CGRectMake(0, 25+30, largeurIphone, 23)];
            
        }else{
            
            self.titlePage = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, largeurIphone, 23)];
            
        }        self.titlePage.textAlignment = NSTextAlignmentCenter;
        self.titlePage.font = [UIFont HelveticaNeue:20];
        self.titlePage.textColor = [UIColor whiteColor];
        self.titlePage.text = NSLocalizedString(@"Comments", nil);
        [self addSubview:self.titlePage];
        
        
        
        if (IS_IPHONEX) {
            
            self.chatTextViewBackground = [[UIView alloc]initWithFrame:CGRectMake(0, hauteurIphone-67-20, largeurIphone, 67)];

        }else{
            
            self.chatTextViewBackground = [[UIView alloc]initWithFrame:CGRectMake(0, hauteurIphone-67, largeurIphone, 67)];

        }
        self.chatTextViewBackground.backgroundColor=[UIColor clearColor];
        [self addSubview:self.chatTextViewBackground];
        
        self.borderView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, largeurIphone-30, 50)];
        self.borderView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.borderView.layer.borderWidth = 2;
        self.borderView.layer.cornerRadius = 10;
        self.borderView.layer.borderColor =[UIColor colorForHex:@"4D4D4D"].CGColor;
        [self.chatTextViewBackground addSubview:self.borderView];
        
        
        self.chatTextView=[[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(25, 0, largeurIphone-15-16-70-18, 50)];
        self.chatTextView.delegate=self;
        self.chatTextView.backgroundColor=[UIColor clearColor];
        [self.chatTextView setContentInset:UIEdgeInsetsMake(7, -4, 0, 0)];
        self.chatTextView.textAlignment = NSTextAlignmentLeft;
        self.chatTextView.font =[UIFont HelveticaNeue:16];
        self.chatTextView.textColor =[UIColor whiteColor];
        self.chatTextView.keyboardAppearance = UIKeyboardAppearanceLight;
        
        
    
//        
//        self.bottomLineTextView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, 1)];
//        self.bottomLineTextView.backgroundColor =[UIColor whiteColor];
//        self.bottomLineTextView.alpha = 0.3;
//        [self.chatTextViewBackground addSubview:self.bottomLineTextView];
//
        
        
        self.chatTextView.placeholderColor = [UIColor whiteColor];
        self.chatTextView.placeholder= NSLocalizedString(@"Send a comment...", nil);
        [self.chatTextViewBackground addSubview:self.chatTextView];
        
        
        if ([Utils languageFr]) {
            self.buttonChatTextView =[[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-110, self.chatTextViewBackground.frame.size.height-67, 85, 50)];

        }else{
            self.buttonChatTextView =[[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-100, self.chatTextViewBackground.frame.size.height-67, 85, 50)];

        }
        [self.buttonChatTextView.titleLabel setFont:[UIFont HelveticaNeueBold:17]];
        self.buttonChatTextView.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.buttonChatTextView setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
        [self.buttonChatTextView setTitleColor:[UIColor yellowBuzzy] forState:UIControlStateNormal];
        self.buttonChatTextView.hidden=YES;
        [self.buttonChatTextView addTarget:self action:@selector(sendMessageToChat) forControlEvents:UIControlEventTouchUpInside];
        [self.chatTextViewBackground addSubview:self.buttonChatTextView];
    
        
        

        
    }
    return self;
}

-(void)touch{
    
    //empty
}
-(void)actionBtnClose{
    
    
   
    [self hide];
    
}





-(void)sendMessageToChat{
    
    
    if (self.chatTextView.text.length>0) {
        
        self.messageIsSending = YES;
        
        
        PFObject *msg = [PFObject objectWithClassName:kCommentClasseName];
        msg[kCommentMessage]= self.chatTextView.text;
        msg[kCommentUser] = [PFUser currentUser];
        msg[kCommentBuzz] = self.buzz;
        
        
        
        
        
        [msg saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            self.messageIsSending = NO;
            
            [self.buzz fetchInBackgroundWithBlock:^(PFObject * _Nullable buzz, NSError * _Nullable error) {
               
                int nbMess = [buzz[kBuzzMessageNumber] intValue];
                
                buzz[kBuzzMessageNumber] = @(nbMess + 1);
                [buzz saveInBackground];
                
                PFUser *user = buzz[kBuzzUser];
                
                
                if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@(nbMess+1) forKey:[NSString stringWithFormat:@"nbMess-%@",buzz.objectId]];

                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] refreshNotifs];

                }
                
            }];
            
            
        }];
        
        
        
        [self.chatTextView setText:@""];
        
        
        if (self.chatTextView.text.length >0) {
            
            self.buttonChatTextView.hidden=NO;
            
        }else{
            
            self.buttonChatTextView.hidden=YES;
        }
        
        [self _updateInputViewFrameWithKeyboardFrame];
        
        
        
        
        //        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
        
        
        self.logoEmpty.hidden = YES;

        [self.tableView beginUpdates];
        
        NSIndexPath *row1 = [NSIndexPath indexPathForRow:self.comments.count inSection:0];
        
        [self.comments insertObject:msg atIndex:self.comments.count];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
        
        [self.tableView endUpdates];
        
        
        //Always scroll the chat table when the user sends the message
        if([self.tableView numberOfRowsInSection:0]!=0)
        {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0]-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:UITableViewRowAnimationLeft];
        }
        
    }
    
    
}

#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Comment";
    
    // Similar to UITableViewCell, but
    CommentTableViewCell *cell = (CommentTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    cell.profilePicture.file = [[[self.comments objectAtIndex:indexPath.row] objectForKey:kCommentUser] objectForKey:kUserProfilePicture];
    [cell.profilePicture loadInBackground];
    
    
    
    [cell adjustBubbleWithText:[[self.comments objectAtIndex:indexPath.row] objectForKey:kCommentMessage]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *text = [[self.comments objectAtIndex:indexPath.row] objectForKey:kCommentMessage];
    
    CGSize sizeOfText = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont HelveticaNeue:15]} context:nil].size;
    
    CGFloat width = MIN((largeurIphone-84)-16, sizeOfText.width);
    width = MAX(width, 30);
    
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(84, 10, (largeurIphone-84)-16, 20)];
    content.font = [UIFont HelveticaNeue:15];
    content.numberOfLines=0;// This will make the label multiline
    content.lineBreakMode = NSLineBreakByWordWrapping;
    
    content.text =text;
    content.frame = CGRectMake(84, 10, width, 17);
    [content sizeToFit];
    
   
    
    return MAX(content.frame.size.height+20, 60);
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
//    [self.chatTextView resignFirstResponder];

    
    // Fades out top and bottom cells in table view as they leave the screen
    NSArray *visibleCells = [self.tableView visibleCells];
    
    CGPoint offset = self.tableView.contentOffset;
    CGRect bounds = self.tableView.bounds;
    CGSize size = self.tableView.contentSize;
    UIEdgeInsets inset = self.tableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    
    if (y > h) {
        for (UITableViewCell *cell in visibleCells) {
            cell.contentView.alpha = 1 - (y/h - 1)*4;
        }
    } else {
        for (UITableViewCell *cell in visibleCells) {
            cell.contentView.alpha = 1;
        }
    }
}




- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@",[[self.comments objectAtIndex:indexPath.row ] objectForKey:kCommentUser] [kUserInstaUsername]]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
    
    
    
}

-(void)showCommentsWithBuzz:(PFObject *)buzz{
    

//    [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] animator] setDragable:NO];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    self.buzz = buzz;
    

    [self.chatTextView resignFirstResponder];
    self.chatTextView.text = @"";
    [self _updateInputViewFrameWithKeyboardFrame];

    if (IS_IPHONEX) {
        
        self.chatTextViewBackground.frame = CGRectMake(0, hauteurIphone-67-20, largeurIphone, 67);

    }else{
        self.chatTextViewBackground.frame = CGRectMake(0, hauteurIphone-67, largeurIphone, 67);

        
    }

    
    if (self.comments.count == 0) {
        
        [self.indicator startAnimating];
        
    }
    
    [self refreshData];
    
    
    
    self.hidden = NO;
    self.alpha = 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
    
}

-(void)refreshData{
    
    self.comments = [[NSMutableArray alloc]init];
    [self.tableView reloadData];
    [self.tableView scrollsToTop];

    self.logoEmpty.hidden = YES;

    PFQuery *queryMess = [PFQuery queryWithClassName:kCommentClasseName];
    
    [queryMess whereKey:kCommentBuzz equalTo:self.buzz];
    [queryMess orderByAscending:@"createdAt"];
    [queryMess includeKey:kCommentUser];

    [queryMess findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
       
        [self.indicator stopAnimating];
        if (objects != false) {
            
            
                        self.comments = [[NSMutableArray alloc]initWithArray:objects];
                        [self.tableView reloadData];
            
            if (objects.count == 0) {
                
                self.logoEmpty.hidden = NO;

            }
            
        }else{
            
            self.logoEmpty.hidden = NO;

        }
        
    }];
    
}
-(void)hide{
    
//    [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] homeViewController] animator] setDragable:YES];

    
    [self.chatTextView resignFirstResponder];
    self.chatTextView.text = @"";
    [self _updateInputViewFrameWithKeyboardFrame];

    

    self.alpha = 1;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        
        if (IS_IPHONEX) {
            
            self.chatTextViewBackground.frame = CGRectMake(0, hauteurIphone-67-20, largeurIphone, 67);

        }else{
            self.chatTextViewBackground.frame = CGRectMake(0, hauteurIphone-67, largeurIphone, 67);

            
        }

    }];
    
    
}



#pragma mark - Chat Messaging & Keyboard

- (void)keyboardWillShow:(NSNotification *)notification{
    
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect finalKeyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.KeyboardHeight = finalKeyboardFrame.size.height;
    
    float inputViewFinalYPosition =  hauteurIphone-  self.chatTextViewBackground.frame.size.height - finalKeyboardFrame.size.height;
    CGRect inputViewFrame = self.chatTextViewBackground.bounds;
    inputViewFrame.origin.y = inputViewFinalYPosition;
    
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.chatTextViewBackground.frame = inputViewFrame;
    }];
    
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    
    if (self.keyboardIsShowing == NO) {
        
        
        if (self.tableView.contentSize.height>self.tableView.frame.size.height) {
            
            
            
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+keyboardSize.height)];
            
            
            
        }else if(self.tableView.frame.size.height-self.tableView.contentSize.height<keyboardSize.height){
            
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+keyboardSize.height-(self.tableView.frame.size.height-self.tableView.contentSize.height))];
            
            
        }
        
    }else{
        
        if (self.tableView.contentSize.height>self.tableView.frame.size.height-keyboardSize.height) {
            
            CGSize keyboardSizeBefore = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
            
            if (keyboardSize.height-keyboardSizeBefore.height>0) {
                
                
                [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+(keyboardSize.height-keyboardSizeBefore.height))];
                
            }
            
            
        }
    }
    
    self.keyboardIsShowing = YES;
    
    
}




- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardIsShowing = NO;
    
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect inputViewFrame = self.chatTextViewBackground.bounds;
    inputViewFrame.origin.y = hauteurIphone-inputViewFrame.size.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.chatTextViewBackground.frame = inputViewFrame;
    }];
    
    
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}



- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView == self.chatTextView) {
        
        if (textView.text.length >0) {
            
            self.buttonChatTextView.hidden=NO;
            
        }else{
            
            self.buttonChatTextView.hidden=YES;
        }
        
        [self _updateInputViewFrameWithKeyboardFrame];
        
    }
    
    
}

- (void)_updateInputViewFrameWithKeyboardFrame
{
    // Calculate the height the input view ideally
    // has based on its textview's content
    UITextView *textView = self.chatTextView;
    
    CGFloat newInputViewHeight;
    if ([NSURLSession class])
    {
        newInputViewHeight = textViewHeight(textView);
    } else {
        newInputViewHeight = self.chatTextView.contentSize.height;
    }
    
    //10 is the border of the uitoolbar top and bottom
    newInputViewHeight += 7;
    newInputViewHeight = ceilf(newInputViewHeight);
    //newInputViewHeight = MIN(maxInputViewHeight, newInputViewHeight);
    
    // If the new input view height equals the current,
    // nothing has to be changed
    if (self.chatTextView.bounds.size.height == newInputViewHeight) {
        return;
    }
    
    // If the new input view height is bigger than the view available, do nothing
    if ((self.tableView.bounds.size.height - self.KeyboardHeight < newInputViewHeight)) {
        return;
    }
    
    CGRect inputViewFrame = self.chatTextView.frame;
    inputViewFrame.size.height = newInputViewHeight;
    self.chatTextView.frame = inputViewFrame;
    
    CGRect toolBarFrame = self.chatTextViewBackground.frame;
    toolBarFrame.size.height = newInputViewHeight + 17;
    
    toolBarFrame.origin.y = self.tableView.frame.size.height-self.KeyboardHeight - (toolBarFrame.size.height);
    
    self.chatTextViewBackground.frame = toolBarFrame;
    
    if ([Utils languageFr]) {
        self.buttonChatTextView.frame = CGRectMake(largeurIphone-110, self.chatTextViewBackground.frame.size.height-67, 85, 50);

    }else{
        
        self.buttonChatTextView.frame = CGRectMake(largeurIphone-100, self.chatTextViewBackground.frame.size.height-67, 85, 50);

    }
    
    
    self.borderView.frame = CGRectMake(15, 0, largeurIphone-30, self.chatTextView.frame.size.height);

}

static inline CGFloat textViewHeight(UITextView *textView) {
    NSTextContainer *textContainer = textView.textContainer;
    CGRect textRect =
    [textView.layoutManager usedRectForTextContainer:textContainer];
    
    CGFloat textViewHeight = textRect.size.height +
    textView.textContainerInset.top + textView.textContainerInset.bottom;
    
    return textViewHeight+6;
    
    
}






@end
