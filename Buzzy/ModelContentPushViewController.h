//
//  ModelContentPushViewController.h
//  BottleBond
//
//  Created by Julien Levallois on 16-12-25.
//  Copyright © 2016 Julien Levallois. All rights reserved.
//

#import "ModelPushViewController.h"

typedef enum TypeBB : NSUInteger {
    kTypeImage,
    kTypeText,
} TypeBB;


@interface ModelContentPushViewController : ModelPushViewController

@property(nonatomic)BOOL bondType;


@property(nonatomic) enum TypeBB type;

@property(nonatomic) NSString *titleBB;
@property(nonatomic) UILabel *titleLabel;

-(instancetype)initWithStyle:(enum StyleBB)style type:(enum TypeBB)type;

@end
