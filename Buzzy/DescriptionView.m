//
//  DescriptionView.m
//  Buzzy
//
//  Created by Julien Levallois on 17-06-24.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "DescriptionView.h"

@implementation DescriptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {        
        
        self.backgroundColor = [UIColor clearColor];
        
        self.background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, largeurIphone, hauteurIphone)];
        self.background.image = [UIImage imageNamed:@"blackBackground"];
        [self addSubview:self.background];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(hideDescription)];
        [self addGestureRecognizer:singleFingerTap];
		[self prepareTitleTextField:frame];
        
        [self initTextColor];
        [self initCollectionView];
    }
    return self;
}

- (void)initTextColor {
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"color" ofType:@"plist"]];
    colorArr = [dictionary objectForKey:@"color"];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _colorView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) collectionViewLayout:layout];
    [_colorView setDataSource:self];
    [_colorView setDelegate:self];
    
    [_colorView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_colorView setBackgroundColor:[UIColor clearColor]];
    
    self.titleTextField.inputAccessoryView = _colorView;
}

- (void)prepareTitleTextField:(CGRect)superViewFrame {
	
	CGRect rect = CGRectMake(0, 0, superViewFrame.size.width - 40, 60);
	self.titleTextField = [[UITextView alloc] initWithFrame:rect];
	self.titleTextField.center = CGPointMake(superViewFrame.size.width/2, 60);
    self.titleTextField.translatesAutoresizingMaskIntoConstraints = true;
	self.titleTextField.font=[UIFont Avenir:30];
	self.titleTextField.textColor = [UIColor whiteColor];
	self.titleTextField.returnKeyType= UIReturnKeyDone;
	self.titleTextField.userInteractionEnabled = YES;
	self.titleTextField.delegate=self;
	self.titleTextField.scrollEnabled = false;
	self.titleTextField.backgroundColor = [UIColor clearColor];
	self.titleTextField.textAlignment = NSTextAlignmentCenter;
	[self addSubview:self.titleTextField];
	[self.titleTextField setReturnKeyType:UIReturnKeyDone];
	[self.titleTextField setTintColor:[UIColor whiteColor]];
}

-(void)hideDescription{

    self.hidden = YES;
    [self.titleTextField resignFirstResponder];
	
	if (_descriptionDone != nil)
		_descriptionDone(_titleTextField.text, _titleTextField.textColor);
}

#pragma mark - TextField Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;  
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if([text isEqualToString:@"\n"]) {
		
		[self hideDescription];
		return NO;
    }
	return YES;
}

#pragma mark - CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return colorArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.layer.cornerRadius = cell.frame.size.width/2;
    cell.layer.borderWidth = 2.0f;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.masksToBounds = YES;
    
    NSDictionary* colorDict = colorArr[indexPath.row];
    NSString* hexString = [colorDict objectForKey:@"hex"];
    
    cell.backgroundColor= [self colorFromHexString:hexString] ;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (prevCell) {
        prevCell.layer.borderWidth = 2.0;
    }
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 4.0f;
    self.titleTextField.textColor = cell.backgroundColor;
    prevCell = cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(25, 25);
}


#pragma mark = Utility method

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
