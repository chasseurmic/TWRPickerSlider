//
//  TWRSliderStackedView.m
//  TWRPickerSlider
//
//  Created by Michelangelo Chasseur on 28/08/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import "TWRSliderStackedView.h"
#import "TWRPickerSlider.h"
#import "TWRSliderContainerView.h"

@interface TWRSliderStackedView ()

@property (strong, nonatomic) NSMutableArray *containers;
@property (assign, nonatomic) NSUInteger stackHeight;
@property (assign, nonatomic) NSUInteger bottomPadding;

@end

@implementation TWRSliderStackedView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithBottomPadding:(NSUInteger)padding {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.bottomPadding = padding;
    }
    return self;
}

- (instancetype)initWithTabBar {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.bottomPadding = 49;
    }
    return self;
}

- (void)commonInit {
    self.containers = [NSMutableArray new];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [_sliders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TWRSliderContainerView *container = [[TWRSliderContainerView alloc] initWithFrame:CGRectMake(0, PICKER_DEFAULT_VISIBLE_HEIGHT * idx, CGRectGetWidth(newSuperview.frame), 200)];
        [self.containers insertObject:container atIndex:0];
        [self addSubview:container];
    }];
    
    self.frame = CGRectMake(CGRectGetMinX(newSuperview.frame), CGRectGetMaxY(newSuperview.frame) - 156 - PICKER_DEFAULT_VISIBLE_HEIGHT * self.sliders.count - self.bottomPadding, CGRectGetWidth(newSuperview.frame), 156 + PICKER_DEFAULT_VISIBLE_HEIGHT * self.sliders.count);
    
    [self.containers enumerateObjectsUsingBlock:^(UIView *container, NSUInteger idx, BOOL *stop) {
        [container addSubview:self.sliders[idx]];
    }];
}

@end
