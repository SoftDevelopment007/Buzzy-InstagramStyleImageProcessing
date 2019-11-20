//
//  JotViewController.m
//  jot
//
//  Created by Laura Skelton on 4/30/15.
//
//

#import "JotView.h"
#import "JotDrawView.h"
#import "JotTextView.h"
#import "JotTextEditView.h"
#import <Masonry/Masonry.h>
#import "UIImage+Jot.h"
#import "JotDrawingContainer.h"

@interface JotView () <UIGestureRecognizerDelegate, JotTextEditViewDelegate, JotDrawingContainerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong, readwrite) JotDrawingContainer *drawingContainer;
@property (nonatomic, strong) JotDrawView *drawView;
@property (nonatomic, strong) JotTextEditView *textEditView;
@property (nonatomic, strong) JotTextView *textView;

@end

@implementation JotView

- (instancetype)init
{
    if ((self = [super init])) {
        
        
        _drawView = [JotDrawView new];
        _textEditView = [JotTextEditView new];
        _textEditView.delegate = self;
        [self.textEditView setTextColor:[UIColor blackColor]];
        [self.textEditView setFont:[UIFont BerkshireSwash:18]];

        _textView = [JotTextView new];
        _drawingContainer = [JotDrawingContainer new];
        self.drawingContainer.delegate = self;
        
        _font = self.textView.font;
        self.textEditView.font = self.font;
        _fontSize = self.textView.fontSize;
        self.textEditView.fontSize = self.fontSize;
        _textAlignment = self.textView.textAlignment;
        self.textEditView.textAlignment = NSTextAlignmentCenter;;
        _textColor = self.textView.textColor;
        self.textEditView.textColor = self.textColor;
        _textString = @"";
        _drawingColor = self.drawView.strokeColor;
        _drawingStrokeWidth = self.drawView.strokeWidth;
        _textEditingInsets = self.textEditView.textEditingInsets;
        _initialTextInsets = self.textView.initialTextInsets;
        _state = JotViewStateDefault;
        
        _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchOrRotateGesture:)];
        self.pinchRecognizer.delegate = self;
        
        _rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchOrRotateGesture:)];
        self.rotationRecognizer.delegate = self;
        
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panRecognizer.delegate = self;
        
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        self.tapRecognizer.delegate = self;
        
        
        self.backgroundColor = [UIColor clearColor];
        self.drawingContainer.clipsToBounds = YES;
        
        [self addSubview:self.drawingContainer];
        [self.drawingContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.drawingContainer addSubview:self.drawView];
        [self.drawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.drawingContainer);
        }];
        
        [self.drawingContainer addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.drawingContainer);
        }];
        
        [self addSubview:self.textEditView];
        [self.textEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.drawingContainer addGestureRecognizer:self.tapRecognizer];
        [self.drawingContainer addGestureRecognizer:self.panRecognizer];
        [self.drawingContainer addGestureRecognizer:self.rotationRecognizer];
        [self.drawingContainer addGestureRecognizer:self.pinchRecognizer];
        
        
    }
    
    return self;
}

- (void)dealloc
{
    self.textEditView.delegate = nil;
    self.drawingContainer.delegate = nil;
}



#pragma mark - Properties

- (void)setState:(JotViewState)state
{
    if (_state != state) {
        _state = state;
        
        self.textView.hidden =
        self.textEditView.isEditing = (state == JotViewStateEditingText);
        
        if (state == JotViewStateEditingText
            && [self.delegate respondsToSelector:@selector(jotView:isEditingText:)]) {
            [self.delegate jotView:self isEditingText:YES];
        }
        
        self.drawingContainer.multipleTouchEnabled =
        self.tapRecognizer.enabled =
        self.panRecognizer.enabled =
        self.pinchRecognizer.enabled =
        self.rotationRecognizer.enabled = (state == JotViewStateText);
    }
}

- (void)setTextString:(NSString *)textString
{
    if (![_textString isEqualToString:textString]) {
        _textString = textString;
        if (![self.textView.textString isEqualToString:textString]) {
            self.textView.textString = textString;
        }
        if (![self.textEditView.textString isEqualToString:textString]) {
            self.textEditView.textString = textString;
        }
    }
}

- (void)setFont:(UIFont *)font
{
    if (_font != font) {
        _font = font;
        self.textView.font =
        self.textEditView.font = font;
    }
}

- (void)setFontSize:(CGFloat)fontSize
{
    if (_fontSize != fontSize) {
        _fontSize = fontSize;
        self.textView.fontSize =
        self.textEditView.fontSize = fontSize;
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    if (_textAlignment != textAlignment) {
        _textAlignment = textAlignment;
        self.textView.textAlignment =
        self.textEditView.textAlignment = textAlignment;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (_textColor != textColor) {
        _textColor = textColor;
        self.textView.textColor =
        self.textEditView.textColor = textColor;
    }
}

- (void)setInitialTextInsets:(UIEdgeInsets)initialTextInsets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_initialTextInsets, initialTextInsets)) {
        _initialTextInsets = initialTextInsets;
        self.textView.initialTextInsets = initialTextInsets;
    }
}

- (void)setTextEditingInsets:(UIEdgeInsets)textEditingInsets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_textEditingInsets, textEditingInsets)) {
        _textEditingInsets = textEditingInsets;
        self.textEditView.textEditingInsets = textEditingInsets;
    }
}

- (void)setFitOriginalFontSizeToViewWidth:(BOOL)fitOriginalFontSizeToViewWidth
{
    if (_fitOriginalFontSizeToViewWidth != fitOriginalFontSizeToViewWidth) {
        _fitOriginalFontSizeToViewWidth = fitOriginalFontSizeToViewWidth;
        self.textView.fitOriginalFontSizeToViewWidth = fitOriginalFontSizeToViewWidth;
        if (fitOriginalFontSizeToViewWidth) {
            self.textEditView.textAlignment = self.textAlignment;
        } else {
            self.textEditView.textAlignment = NSTextAlignmentLeft;
        }
    }
}

- (void)setClipBoundsToEditingInsets:(BOOL)clipBoundsToEditingInsets
{
    if (_clipBoundsToEditingInsets != clipBoundsToEditingInsets) {
        _clipBoundsToEditingInsets = clipBoundsToEditingInsets;
        self.textEditView.clipBoundsToEditingInsets = clipBoundsToEditingInsets;
    }
}

- (void)setDrawingColor:(UIColor *)drawingColor
{
    if (_drawingColor != drawingColor) {
        _drawingColor = drawingColor;
        self.drawView.strokeColor = drawingColor;
    }
}

- (void)setDrawingStrokeWidth:(CGFloat)drawingStrokeWidth
{
    if (_drawingStrokeWidth != drawingStrokeWidth) {
        _drawingStrokeWidth = drawingStrokeWidth;
        self.drawView.strokeWidth = drawingStrokeWidth;
    }
}

- (void)setDrawingConstantStrokeWidth:(BOOL)drawingConstantStrokeWidth
{
    if (_drawingConstantStrokeWidth != drawingConstantStrokeWidth) {
        _drawingConstantStrokeWidth = drawingConstantStrokeWidth;
        self.drawView.constantStrokeWidth = drawingConstantStrokeWidth;
    }
}

#pragma mark - Undo

- (void)clearAll
{
    [self clearDrawing];
    [self clearText];
}

- (void)clearDrawing
{
    [self.drawView clearDrawing];
}

- (void)clearText
{
    self.textString = @"";
    [self.textView clearText];
}

#pragma mark - Output UIImage

- (UIImage *)drawOnImage:(UIImage *)image
{
    UIImage *drawImage = [self.drawView drawOnImage:image];
    
    return [self.textView drawTextOnImage:drawImage];
}

- (UIImage *)renderImage
{
    return [self renderImageWithScale:1.f];
}

- (UIImage *)renderImageOnColor:(UIColor *)color
{
    return [self renderImageWithScale:1.f onColor:color];
}

- (UIImage *)renderImageWithScale:(CGFloat)scale
{
    return [self renderImageWithSize:CGSizeMake(CGRectGetWidth(self.drawingContainer.frame) * scale,
                                           CGRectGetHeight(self.drawingContainer.frame) * scale)];
}

- (UIImage *)renderImageWithScale:(CGFloat)scale onColor:(UIColor *)color
{
    return [self renderImageWithSize:CGSizeMake(CGRectGetWidth(self.drawingContainer.frame) * scale,
                                                CGRectGetHeight(self.drawingContainer.frame) * scale)
                             onColor:color];
}

- (UIImage *)renderImageWithSize:(CGSize)size
{
    UIImage *renderDrawingImage = [self.drawView renderDrawingWithSize:size];
    
    return [self.textView drawTextOnImage:renderDrawingImage];
}

- (UIImage *)renderImageWithSize:(CGSize)size onColor:(UIColor *)color
{
    UIImage *colorImage = [UIImage jotImageWithColor:color size:size];
    
    UIImage *renderDrawingImage = [self.drawView drawOnImage:colorImage];
    
    return [self.textView drawTextOnImage:renderDrawingImage];
}

#pragma mark - Gestures

- (void)handleTapGesture:(UIGestureRecognizer *)recognizer
{
    if (!(self.state == JotViewStateEditingText)) {
        self.state = JotViewStateEditingText;
    }
}

- (void)handlePanGesture:(UIGestureRecognizer *)recognizer
{
    [self.textView handlePanGesture:recognizer];
}

- (void)handlePinchOrRotateGesture:(UIGestureRecognizer *)recognizer
{
    [self.textView handlePinchOrRotateGesture:recognizer];
}

#pragma mark - JotDrawingContainer Delegate

- (void)jotDrawingContainerTouchBeganAtPoint:(CGPoint)touchPoint
{
    if (self.state == JotViewStateDrawing) {
        [self.drawView drawTouchBeganAtPoint:touchPoint];
    }
}

- (void)jotDrawingContainerTouchMovedToPoint:(CGPoint)touchPoint
{
    if (self.state == JotViewStateDrawing) {
        [self.drawView drawTouchMovedToPoint:touchPoint];
    }
}

- (void)jotDrawingContainerTouchEnded
{
    if (self.state == JotViewStateDrawing) {
        [self.drawView drawTouchEnded];
    }
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - JotTextEditView Delegate

- (void)jotTextEditViewFinishedEditingWithNewTextString:(NSString *)textString
{
    if (self.state == JotViewStateEditingText) {
        self.state = JotViewStateText;
    }
    
    self.textString = textString;
    
    if ([self.delegate respondsToSelector:@selector(jotView:isEditingText:)]) {
        [self.delegate jotView:self isEditingText:NO];
    }
}

@end
