//
//  TWRSliderStackedView.m
//  TWRPickerSlider
//
//  Created by Michelangelo Chasseur on 28/08/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import "TWRSliderStackedView.h"
#import "TWRSliderContainerView.h"

#define PICKER_CUSTOM_HEIGHT 200
#define PICKER_DATE_HEIGHT 250
#define PICKER_INVISIBLE_HEIGHT 156

@interface TWRSliderStackedView ()

@property (strong, nonatomic) NSMutableArray *containers;
@property (assign, nonatomic) NSUInteger stackHeight;
@property (assign, nonatomic) NSUInteger bottomPadding;
@property (assign, nonatomic) NSUInteger topPadding;
@property (assign, nonatomic) TWRPickerSliderPosition position;

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

- (instancetype)initWithPosition:(TWRPickerSliderPosition)position bottomPadding:(NSUInteger)padding {
    self = [self initWithPosition:position];
    if (self) {
        self.bottomPadding = padding;
    }
    return self;
}

- (instancetype)initWithPosition:(TWRPickerSliderPosition)position topPadding:(NSUInteger)padding {
    self = [self initWithPosition:position];
    if (self) {
        self.topPadding = padding;
    }
    return self;
}

- (instancetype)initWithTabBar {
    self = [self initWithPosition:TWRPickerSliderPositionBottom];
    if (self) {
        self.bottomPadding = 49;
    }
    return self;
}

- (instancetype)initWithPosition:(TWRPickerSliderPosition)position {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.position = position;
    }
    return self;
}

- (void)commonInit {
    self.containers = [NSMutableArray new];
}

- (void)setSliders:(NSArray *)sliders {
    NSMutableArray *mutableSliders = [NSMutableArray new];
    [sliders enumerateObjectsUsingBlock:^(TWRPickerSlider *slider, NSUInteger idx, BOOL *stop) {
        slider.position = self.position;
        slider.type = self.type;
        [mutableSliders addObject:slider];
    }];
    _sliders = [NSArray arrayWithArray:mutableSliders.copy];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        return;
    }
    
    NSUInteger verticalSpacing = [self verticalSpacing];
    
    switch (self.position) {
        case TWRPickerSliderPositionBottom: {
            self.frame = CGRectMake(CGRectGetMinX(newSuperview.frame), CGRectGetMaxY(newSuperview.frame) - PICKER_INVISIBLE_HEIGHT - PICKER_DEFAULT_VISIBLE_HEIGHT * self.sliders.count - self.bottomPadding, CGRectGetWidth(newSuperview.frame), PICKER_INVISIBLE_HEIGHT + PICKER_DEFAULT_VISIBLE_HEIGHT * self.sliders.count);
            
            [_sliders enumerateObjectsUsingBlock:^(TWRPickerSlider *slider, NSUInteger idx, BOOL *stop) {
                TWRSliderContainerView *container = [[TWRSliderContainerView alloc] initWithFrame:CGRectMake(0, PICKER_DEFAULT_VISIBLE_HEIGHT * idx, CGRectGetWidth(newSuperview.frame), verticalSpacing)];
                [self.containers insertObject:container atIndex:0];
                [self addSubview:container];
            }];
            
            [self.containers enumerateObjectsUsingBlock:^(UIView *container, NSUInteger idx, BOOL *stop) {
                [container addSubview:self.sliders[idx]];
            }];
        }
            break;
            
        case TWRPickerSliderPositionTop: {
            self.frame = CGRectMake(CGRectGetMinX(newSuperview.frame), self.topPadding, CGRectGetWidth(newSuperview.frame), PICKER_INVISIBLE_HEIGHT + PICKER_DEFAULT_VISIBLE_HEIGHT * self.sliders.count + self.topPadding);
            
            [_sliders enumerateObjectsUsingBlock:^(TWRPickerSlider *slider, NSUInteger idx, BOOL *stop) {
                CGRect containerFrame = CGRectMake(0, PICKER_DEFAULT_VISIBLE_HEIGHT * idx, CGRectGetWidth(newSuperview.frame), verticalSpacing);
                TWRSliderContainerView *container = [[TWRSliderContainerView alloc] initWithFrame:containerFrame];
                [self.containers insertObject:container atIndex:0];
            }];
            
            [self.containers enumerateObjectsUsingBlock:^(UIView *container, NSUInteger idx, BOOL *stop) {
                [container addSubview:self.sliders[idx]];
                [self addSubview:container];
            }];
        }
            
            break;
            
        default:
            break;
    }
}

- (NSUInteger)verticalSpacing {
    switch (self.type) {
        case TWRPickerSliderTypeCustomObjects:
            return PICKER_CUSTOM_HEIGHT;
            break;
        case TWRPickerSliderTypeDatePicker:
            return PICKER_DATE_HEIGHT;
            break;
            
        default:
            break;
    }
}

@end
