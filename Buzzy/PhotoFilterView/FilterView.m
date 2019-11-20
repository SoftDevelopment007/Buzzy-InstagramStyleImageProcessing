//
//  FilterView.m
//  Buzzy
//
//  Created by Chandan Makhija on 04/11/17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView

NSArray<NSString*> *_pictureFilters;
NSNumber* _pictureFilterIterator;
UIImage* _originalImage;
UIImage* _currentImage;
UIImage* _filterImage;
UIImageView* _uiImageViewCurrentImage;
UIImageView* _uiImageViewNewlyFilteredImage;
CGPoint _startLocation;
BOOL _directionAssigned = NO;
enum direction {LEFT,RIGHT};
enum direction _direction;
BOOL _reassignIncomingImage = YES;
UIPanGestureRecognizer* pan;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initializeFiltering];
    }
    return self;
}

//set it up for video feed
-(void)initializeVideoFeed
{
    
}

- (void)setUpImage:(UIImage*)image {
    _originalImage = image;
    _currentImage = image;
}

-(void)initializeFiltering
{
    
    // @"CISepiaTone",
    //create filters
    _pictureFilters = @[@"CINone",@"CIWhiteFilter",@"CIColorControls",@"CIFalseColor",@"CIPhotoEffectNoir"];
    _pictureFilterIterator = [NSNumber numberWithInt:0];

    
    //create the UIImageViews for the current and filter object
    _uiImageViewCurrentImage = [[UIImageView alloc] initWithImage:_currentImage]; //creates a UIImageView with the UIImage
    _uiImageViewNewlyFilteredImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];//need to set its size to full since it doesn't have a filter yet
    _uiImageViewCurrentImage.frame = _uiImageViewNewlyFilteredImage.frame;
    _uiImageViewNewlyFilteredImage.center = _uiImageViewCurrentImage.center;
    _uiImageViewNewlyFilteredImage.contentMode = UIViewContentModeScaleAspectFill;
    _uiImageViewCurrentImage.contentMode = UIViewContentModeScaleAspectFill;
    
    //add UIImageViews to view
    [self addSubview:_uiImageViewCurrentImage]; //adds the UIImageView to view;
    [self addSubview:_uiImageViewNewlyFilteredImage];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    [self addGestureRecognizer:pan];
}

- (void)enablePanGesture:(BOOL)state {
    pan.enabled = state;
}

- (void)removeImagesFromFilter {
    _uiImageViewCurrentImage.image = nil;
    _uiImageViewNewlyFilteredImage.image = nil;
    _originalImage = nil;
    _currentImage = nil;
}


-(void)swipeRecognized:(UIPanGestureRecognizer *)swipe
{
    CGFloat distance = 0;
    CGPoint stopLocation;
    
    if (swipe.state == UIGestureRecognizerStateBegan)
    {
        _directionAssigned = NO;
        _startLocation = [swipe locationInView:self];
    }else
    {
        stopLocation = [swipe locationInView:self];
        CGFloat dx = stopLocation.x - _startLocation.x;
        CGFloat dy = stopLocation.y - _startLocation.y;
        distance = sqrt(dx*dx + dy*dy);
    }
       
    if(swipe.state == UIGestureRecognizerStateEnded)
    {
        if(_direction == LEFT && (([UIScreen mainScreen].bounds.size.width - _startLocation.x) + distance) > [UIScreen mainScreen].bounds.size.width/2)
        {
            [self reassignCurrentImage];
        }else if(_direction == RIGHT && _startLocation.x + distance > [UIScreen mainScreen].bounds.size.width/2)
        {
            [self reassignCurrentImage];
        }else
        {
            //since no filter applied roll it back
            if(_direction == LEFT)
            {
                _pictureFilterIterator = [NSNumber numberWithInt:[_pictureFilterIterator intValue]-1];
            }else
            {
                _pictureFilterIterator = [NSNumber numberWithInt:[_pictureFilterIterator intValue]+1];
            }
        }
        [self clearIncomingImage];
        _reassignIncomingImage = YES;
        return;
    }
    
    CGPoint velocity = [swipe velocityInView:self];
    
    if(velocity.x > 0)//right
    {
        if(!_directionAssigned)
        {
            _directionAssigned = YES;
            _direction  = RIGHT;
        }
        if(_reassignIncomingImage && !_filterImage)
        {
            _reassignIncomingImage = false;
            [self reassignIncomingImageLeft:NO];
        }
    }
    else//left
    {
        if(!_directionAssigned)
        {
            _directionAssigned = YES;
            _direction  = LEFT;
        }
        if(_reassignIncomingImage && !_filterImage)
        {
            _reassignIncomingImage = false;
            [self reassignIncomingImageLeft:YES];
        }
    }
    
    if(_direction == LEFT)
    {
        if(stopLocation.x > _startLocation.x -5) //adjust to avoid snapping
        {
            distance = -distance;
        }
    }else
    {
        if(stopLocation.x < _startLocation.x +5) //adjust to avoid snapping
        {
            distance = -distance;
        }
    }
    
    [self slideIncomingImageDistance:distance];
}

-(void)slideIncomingImageDistance:(float)distance
{
    CGRect incomingImageCrop;
    if(_direction == LEFT) //start on the right side
    {
        incomingImageCrop = CGRectMake(_startLocation.x - distance,0, [UIScreen mainScreen].bounds.size.width - _startLocation.x + distance, [UIScreen mainScreen].bounds.size.height);
    }else//start on the left side
    {
        incomingImageCrop = CGRectMake(0,0, _startLocation.x + distance, [UIScreen mainScreen].bounds.size.height);
    }
    
    [self applyMask:incomingImageCrop];
}

-(void)reassignCurrentImage
{
    if(!_filterImage)//if you go fast this is null sometimes
    {
        [self reassignIncomingImageLeft:YES];
    }
    _uiImageViewCurrentImage.image = _filterImage;
    self.frame = [[UIScreen mainScreen] bounds];
}

//left is forward right is back
-(void)reassignIncomingImageLeft:(BOOL)left
{
    if(left == YES)
    {
        _pictureFilterIterator = [NSNumber numberWithInt:[_pictureFilterIterator intValue]+1];
    }else
    {
        _pictureFilterIterator = [NSNumber numberWithInt:[_pictureFilterIterator intValue]-1];
    }
    
    NSNumber* arrayCount = [NSNumber numberWithInt:(int)_pictureFilters.count];
    
    if([_pictureFilterIterator integerValue]>=[arrayCount integerValue])
    {
        _pictureFilterIterator = 0;
    }
    if([_pictureFilterIterator integerValue]< 0)
    {
        _pictureFilterIterator = [NSNumber numberWithInt:(int)_pictureFilters.count-1];
    }
    
    CIImage* ciImage = [CIImage imageWithCGImage:_originalImage.CGImage];
    
    if([_pictureFilters[[_pictureFilterIterator integerValue]]  isEqualToString:@"CIWhiteFilter" ]) {
        CIFilter *filter63 = [CIFilter filterWithName:@"CIColorControls"];
        [filter63 setDefaults];
        [filter63 setValue:ciImage forKey:kCIInputImageKey];
        [filter63 setValue:[NSNumber numberWithFloat:0.03] forKey:@"inputBrightness"];
        
        _filterImage = [UIImage imageWithCIImage:[filter63 outputImage]];
    }
    
    else if(![_pictureFilters[[_pictureFilterIterator integerValue]]  isEqualToString:@"CINone" ]) {
        CIFilter* filter = [CIFilter filterWithName:_pictureFilters[[_pictureFilterIterator integerValue]] keysAndValues:kCIInputImageKey,ciImage, nil];
        if([[filter name] isEqualToString:@"CIColorControls"]) {
            
            [filter setValue:ciImage forKey:@"inputImage"];
            [filter setValue:[NSNumber numberWithFloat:1.5] forKey:@"inputSaturation"];
            
        }
        _filterImage = [UIImage imageWithCIImage:[filter outputImage]];
    } else {
        _filterImage = _originalImage;
    }
    
    _uiImageViewNewlyFilteredImage.image = _filterImage;
    CGRect maskRect = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    [self applyMask:maskRect];
}

//apply mask to filter UIImageView
-(void)applyMask:(CGRect)maskRect
{
    // Create a mask layer and the frame to determine what will be visible in the view.
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    // Create a path with the rectangle in it.
    CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
    
    // Set the path to the mask layer.
    maskLayer.path = path;
    
    // Release the path since it's not covered by ARC.
    CGPathRelease(path);
    
    // Set the mask of the view.
    _uiImageViewNewlyFilteredImage.layer.mask = maskLayer;
}


-(void)clearIncomingImage
{
    _filterImage = nil;
    _uiImageViewNewlyFilteredImage.image = nil;
    //mask current image view fully again
    [self applyMask:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
}


@end
