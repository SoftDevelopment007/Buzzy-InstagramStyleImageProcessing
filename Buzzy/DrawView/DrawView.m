//
//  DrawView.m
//  Buzzy
//
//  Created by Chandan Makhija on 02/11/17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "DrawView.h"
#import "Base.h"

@implementation DrawView


- (id)initWithFrame:(CGRect)frame imageArr:(NSMutableArray*)images{
    if (self = [super initWithFrame:frame]) {
        [self setClearsContextBeforeDrawing:YES];
        
        red = 0.0/255.0;
        green = 0.0/255.0;
        blue = 0.0/255.0;
        brush = 5.0;
        opacity = 1.0;
        isErasing = false;
            
        self.userInteractionEnabled = YES;
        
        self.tempDrawImage = [[UIImageView alloc] initWithFrame:frame];
        self.mainImage = [[UIImageView alloc] initWithFrame:frame];

		drawLayerArr = images ? images : [[NSMutableArray alloc]init];
		
        self.tempDrawImage.userInteractionEnabled = YES;
        
        _mainImage.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
        
        _tempDrawImage.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
        
        [self addSubview:self.mainImage];
        [self addSubview:self.tempDrawImage];
        
        [self addDoneBtn];
        [self addUndoDrawBtn];
        [self showNewLayers];
    //    [self addEraseDrawBtn];
        
        [self initTextColor];
        [self initCollectionView];
    }
    return self;
}

- (void)addDoneBtn {
    if (IS_IPHONEX) {
        
        self.doneDrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-90, 14+10, 65, 65)];
        
    }else{
        
        self.doneDrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone-70, 14-10, 65, 65)];
    }
    [self.doneDrawBtn setBackgroundImage:[UIImage imageNamed:@"btnSavedPhoto"] forState:UIControlStateNormal];
    
    [self.doneDrawBtn addTarget:self action:@selector(actionDoneDraw) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.doneDrawBtn];
}

- (void)addUndoDrawBtn {
    
    if (IS_IPHONEX) {
        
        self.undoDrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 14+35, 30, 30)];
        
    }else{
        
        self.undoDrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 14 + 5, 30, 30)];
    }
    [self.undoDrawBtn.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.undoDrawBtn setBackgroundImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    
    [self.undoDrawBtn addTarget:self action:@selector(actionUndoDraw) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.undoDrawBtn];
}

- (void)addEraseDrawBtn {
    if (IS_IPHONEX) {
        
        self.eraseDrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2 - 50/2, 14+30, 50, 50)];
        
    }else{
        
        self.eraseDrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(largeurIphone/2 - 50/2, 14 + 5, 50, 50)];
    }
    [self.eraseDrawBtn setBackgroundImage:[UIImage imageNamed:@"btnSavedPhoto"] forState:UIControlStateNormal];
    
    [self.eraseDrawBtn addTarget:self action:@selector(actionEraseDraw) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.eraseDrawBtn];
}

- (void)actionEraseDraw {
    isErasing = true;
}

- (void)actionUndoDraw {
    [drawLayerArr removeLastObject];
    [self removeAllLayers];
    [self showNewLayers];
}

- (void)removeAllLayers {
    self.mainImage.image = nil;
}

- (void)showNewLayers {
    for (UIImage* layer in drawLayerArr) {
        UIGraphicsBeginImageContext(self.mainImage.frame.size);
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [layer drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (void)actionDoneDraw {
    self.tempDrawImage = nil;
    self.cancelDrawBtn = nil;
    self.doneDrawBtn = nil;
    self.eraseDrawBtn = nil;
    
    if (_drawDone != nil) {
        _drawDone(self.mainImage.layer, drawLayerArr);
    }
    self.mainImage = nil;
    [self removeFromSuperview];
}

- (void)setNeedsDisplay{
    [self setNeedsDisplayInRect:self.frame];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self];
    
    if (isErasing) {
        self.tempDrawImage.image = self.mainImage.image;
        self.mainImage.image = nil;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    
    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    
    if (isErasing) {
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    } else {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    }
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        
        if (isErasing) {
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        } else {
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        }
        
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        [drawLayerArr addObject:self.tempDrawImage.image];
        UIGraphicsEndImageContext();
    }

    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [drawLayerArr addObject:self.mainImage.image];
    UIGraphicsEndImageContext();
    self.tempDrawImage.image = nil;
}

#pragma mark -

- (void)initTextColor {
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"color" ofType:@"plist"]];
    colorArr = [dictionary objectForKey:@"color"];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _colorView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 50) collectionViewLayout:layout];
    [_colorView setDataSource:self];
    [_colorView setDelegate:self];
    
    [_colorView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_colorView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:_colorView];
    
}

#pragma mark - CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return colorArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
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
    [cell.backgroundColor getRed:&red green:&green blue:&blue alpha:&opacity];
    isErasing = false;
    cell.layer.borderWidth = 4.0f;
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
