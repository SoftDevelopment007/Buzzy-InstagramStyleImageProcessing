//
//  DrawView.h
//  Buzzy
//
//  Created by Chandan Makhija on 02/11/17.
//  Copyright © 2017 Julien Levallois. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    BOOL isErasing;
    
        UICollectionView* _colorView;
        UICollectionViewCell* prevCell;
        NSArray* colorArr;
        NSMutableArray<UIImage*>* drawLayerArr;

}
@property(nonatomic)UIButton *eraseDrawBtn;
@property(nonatomic)UIButton *cancelDrawBtn;
@property(nonatomic)UIButton *doneDrawBtn;
@property(nonatomic)UIButton *undoDrawBtn;

@property(nonatomic) UIImageView* tempDrawImage;
@property(nonatomic) UIImageView* mainImage;

@property (strong, nonatomic) void(^drawDone)(CALayer* imageLayer, NSMutableArray* imageArr);

- (id)initWithFrame:(CGRect)frame imageArr:(NSMutableArray*)images;

@end
